Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11ED213777E;
	Tue, 16 Jun 2026 18:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635332; cv=none; b=YLkiPwNNzDoOzJkzl4h2k3FZ5XCRN3DHBwcR1+5Zkxd81w2CLAbTFLRAIFdnDbQMYP5j2v2YV9ebnOpASh8NC/kEui7y+Z1V6ZVo3MWkALUXsgVOH8VV2Wj4ktz7UCD/2HMDwxAhoF8GQh9l9RlsGXknS2lSZv4jznC4HSFNmQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635332; c=relaxed/simple;
	bh=6tFLVvnjX/mjLyTl6gDpYzP5q1Q36G7HQONwcpfYYrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=If7AglRzPRT0EhzreLU0Q5voqF68QRwtgZ0/9a5p5IPF+jkG9X2MfNij+Lg/ndcgCxKR+lFiJX6mPCtNKqRkwNUWDmdDzdgx40pFHhT1WlKYWdrZICf/s3TTiJquxm9hrLLqeEP/2fDCsqbphQxjoto4VHnOXtxNt8KFQ8m4KxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h+N6C/BW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h+N6C/BW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC431F000E9;
	Tue, 16 Jun 2026 18:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635330;
	bh=oZt9o1Jjxn8slingVgrjEsc94/h1sFe0fXLm7pg4Bxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h+N6C/BWKhznFfwltPOOB7Pl1G3HRknB8h94hIjaSsu4kOMpshq1WT6h2x/hcURUt
	 mppXmMmSCXNUUJN+Lfxob5TGe3vno9+vb0ybDuirWZtkydIPnoVSixpV5dKAmTQdc5
	 fR8Pi9e9fu6I3vzj3EF1+a8gjbpQKP0+Xr/VSq0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenghang Xiao <kipreyyy@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 029/342] sctp: fix race between sctp_wait_for_connect and peeloff
Date: Tue, 16 Jun 2026 20:25:25 +0530
Message-ID: <20260616145049.615551755@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhenghang Xiao <kipreyyy@gmail.com>

[ Upstream commit f14fe6395a8b3d961a61e138ad7b36ba3626dd4e ]

sctp_wait_for_connect() drops and re-acquires the socket lock while
waiting for the association to reach ESTABLISHED state. During this
window, another thread can peeloff the association to a new socket via
getsockopt(SCTP_SOCKOPT_PEELOFF), changing asoc->base.sk. After
re-acquiring the old socket lock, sctp_wait_for_connect() returns
success without noticing the migration — the caller then accesses
the association under the wrong lock in sctp_datamsg_from_user().

Add the same sk != asoc->base.sk check that sctp_wait_for_sndbuf()
already has, returning an error if the association was migrated while
we slept.

Fixes: 668c9beb9020 ("sctp: implement assign_number for sctp_stream_interleave")
Signed-off-by: Zhenghang Xiao <kipreyyy@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260527032411.60959-1-kipreyyy@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/socket.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 8c7bdf01e32a17..150235d861411d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9133,6 +9133,8 @@ static int sctp_wait_for_connect(struct sctp_association *asoc, long *timeo_p)
 		release_sock(sk);
 		current_timeo = schedule_timeout(current_timeo);
 		lock_sock(sk);
+		if (sk != asoc->base.sk)
+			goto do_error;
 
 		*timeo_p = current_timeo;
 	}
-- 
2.53.0



