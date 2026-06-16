Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021911A6803;
	Tue, 16 Jun 2026 16:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628350; cv=none; b=U23964owDUcgE+itXqnjSxxyujxEzVZLCEzG6Ejj4jxqZK40tH3znNwyWErK/d/A6lCoE1mJjMU0A3AZ7fRu6LNHAhnyUqJTi6NyWUShDHGWGRDFYtscfyxCz1y7EJXy7iGzfMlns+pQUM6h7hcmH1NZZgBvo+zC/3/LrxMGkXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628350; c=relaxed/simple;
	bh=jHOmaBOoBWbiQfMxX+W4CiOnKtau+DNO3/9Hdw0jiA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gKmacKZ7GDydaeK+BXgmGmgXFHfyS4J66F3Ixo0ZYy/+/uKInKSLuQyFaJ2LhqNKw6PuNpREpbFPFfy7PX8vlQgpX24jGPPJeAjnudim3Ni8M8McZXIr9EEWuL0qu5nX4/NA+v2P4aeyxSMJ1gZJDy5vPujxAzzdR2U6QKfewLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ct9vLaCs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ct9vLaCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B0C1F000E9;
	Tue, 16 Jun 2026 16:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628348;
	bh=0IJwPwDgRjZcjKsqpJoJMpKe9Wo/bUbVG0bqIJ8yFeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ct9vLaCs27U5M7f4/O5NHgHSnoTwyf2tm5znDcoxf/dHorQE4lexYWzo8VyRU1xCz
	 bybxbX+Tp7sespEl6qrlvOG/s0MoMSkqtGaiqLSDA+L/4DZHhwX9S8IYpK/5z/qN7J
	 v0PfDkgBvBn+xIXGIJ43hM4yxWdz4rCHTsCSZcys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenghang Xiao <kipreyyy@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/452] sctp: fix race between sctp_wait_for_connect and peeloff
Date: Tue, 16 Jun 2026 20:24:32 +0530
Message-ID: <20260616145120.305346195@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 98586bcf83cebe..a6a53b0c4ea324 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9371,6 +9371,8 @@ static int sctp_wait_for_connect(struct sctp_association *asoc, long *timeo_p)
 		release_sock(sk);
 		current_timeo = schedule_timeout(current_timeo);
 		lock_sock(sk);
+		if (sk != asoc->base.sk)
+			goto do_error;
 
 		*timeo_p = current_timeo;
 	}
-- 
2.53.0



