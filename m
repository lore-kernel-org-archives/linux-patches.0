Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E422B4071E3;
	Sun,  7 Jun 2026 10:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828157; cv=none; b=L16IKjjAHqUWnBYGC3E909KCMDUTGV3hNXEvy7ATl7eRHm9/re1Ma1zNqKM4hxesX4Y3iEEJDM2+eX2x4eNBCf+iPHHP5JmZnLMq5yAs5NRVyNMn8Y6ePLrbdHM53xqembMSfsXrKRUV9ribHi7ZFY11eiuq5kCqyQaYsF+lshg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828157; c=relaxed/simple;
	bh=FcyKWVG7lVcCDiWbHx+dbp55zDQFYxdiHH0eyLWQy3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JZJPVObT1DnD4QM9P0ThZpx2zoNqJGVlUeXzmFUl/TyJ7Usd4aBhKTVa1ThF5Yy5piYViJz3muq+pvA8LTfq7ZfmN8/XgEp17dvVuetMgTok6KMkxcLaydeUGwE8WBHlQiJyoVynFlG4d1A66Ax4z2N8HizLvNb+rSXJMga1mnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CnBqyrkw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CnBqyrkw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BE71F0089F;
	Sun,  7 Jun 2026 10:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828156;
	bh=9tnQv36PEFNbCvYQAMPbo+Gq/DKmj7RLWkPKWvxVoJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CnBqyrkwXp2ZZFrWG1Y2wSj3pLUZ8gOFhc0SqTtjHRyIpRoxT6IE1zwmj9Y45g9Fz
	 8vqgqfOZ2Po5IxTi4rzWCLr0u8SPmvyjyV0v9xDPC4UC0G33nhbszsD3GaAc9foyYD
	 YpkdzLnmJcw12aELBCgSby0aCjG2A+X7zh7KW3iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenghang Xiao <kipreyyy@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 092/307] sctp: fix race between sctp_wait_for_connect and peeloff
Date: Sun,  7 Jun 2026 11:58:09 +0200
Message-ID: <20260607095731.156749290@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6b562dd1aae110..3e80cf4e63ff00 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9377,6 +9377,8 @@ static int sctp_wait_for_connect(struct sctp_association *asoc, long *timeo_p)
 		release_sock(sk);
 		current_timeo = schedule_timeout(current_timeo);
 		lock_sock(sk);
+		if (sk != asoc->base.sk)
+			goto do_error;
 
 		*timeo_p = current_timeo;
 	}
-- 
2.53.0



