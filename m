Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070634071DA;
	Sun,  7 Jun 2026 10:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827595; cv=none; b=tRFbomuZIA5T1tC0qY7sY2ZSHYzaxWhSdP0sCZtcjgNPPPI6MZSU9FJ/4QO3mOBNgFQ74i6rPloVYFOUPjDiycCZE4l3xkl37RabEI/TwdsyF7y/XrQtIv1OhvJSuvliEKyU4KIQR5g6JvzkdDCElKAdFEaMiYQqfkxIEFCjpXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827595; c=relaxed/simple;
	bh=s+Sb5gWKXO+n2XnKini7s6F9tOop5xLs6Sk0BhOqsLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f1l5C70WLezdBhOWYxJVLc0Z0sQpJowae16aBKEWht6Q7hzdTLW58ObwLz7XKeyX/vBUd6uvX3yBVyNxMnaNk/P5zLv6CKF7JS1Hl+p3ZfzBzMUinhKRt5CtaQJLyS/RtbanQ772HSG+P7a90xqbPSM1kCQa6F1gDVXSEziH0Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ltJcaxo8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ltJcaxo8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BB01F00893;
	Sun,  7 Jun 2026 10:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827593;
	bh=4fGBBcUQ3Qf/3abGddxTqrzBdHnlJVUqz/vN7b1S/Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ltJcaxo8IOvxDtG38CoCb7oIZhtVz+dSWds1/3FH5k2uJSdVBrmbXx9Hw4krdXrfZ
	 1nsXOzahTB+LqGyvnXBjM5N4ohjQawRO8l6EOdNrdk5qauEQlLZlYe77ZjePqfcCs9
	 7DZt9vBL/zeOoR/6S+CpQaNTtgm9xydnQEHNPzKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenghang Xiao <kipreyyy@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 107/332] sctp: fix race between sctp_wait_for_connect and peeloff
Date: Sun,  7 Jun 2026 11:57:56 +0200
Message-ID: <20260607095732.052638502@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index aeffa10ff2d34a..59e04788e1c760 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9403,6 +9403,8 @@ static int sctp_wait_for_connect(struct sctp_association *asoc, long *timeo_p)
 		release_sock(sk);
 		current_timeo = schedule_timeout(current_timeo);
 		lock_sock(sk);
+		if (sk != asoc->base.sk)
+			goto do_error;
 
 		*timeo_p = current_timeo;
 	}
-- 
2.53.0



