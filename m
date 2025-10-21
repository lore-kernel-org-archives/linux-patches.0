Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BB0350A07;
	Tue, 21 Oct 2025 20:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076852; cv=none; b=QUgaBybJjQZwCTkm13OuHADTReI1FAg5TgymBe9mcAARcKaXZ941hwHR4nkdDNHSCfe+oVmDvpEX18iAm5A3uWJANc3PqhLp1EJe3nNYO1eN7AyUl4qqcruv+a/RWkgtVT5GKp521OT6cXKZPZKdnq+RDllJ6AVMuLG+SSfCfTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076852; c=relaxed/simple;
	bh=4Tdd5lf/uPUVV2ez89JeYhgnIjLSgBZQ7ZuXvmEIgaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chc3hZ1WGgLXtKcKDQvgI0kKletUzCmJqZhh+r1bPWtw/8rPWnofEDPUTcgFVTXZjCbEICxeEWajx9T8uvIBs8Y8OwX+dj2Aer/H1148dMAwO0RgmGQGA8POEuIUzdHlNeg50guj0KTYNHqjiGKvlYy7pGiDghN3IuQwNv+heF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UDxPP3RK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UDxPP3RK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BE6C4CEF1;
	Tue, 21 Oct 2025 20:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076852;
	bh=4Tdd5lf/uPUVV2ez89JeYhgnIjLSgBZQ7ZuXvmEIgaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UDxPP3RKep+MuDbJNHC4+WpKQ6EAd8bfsPEML3c8uVSJZeN4vBQX63fu5LdTiU2s5
	 3YWXGgy+FC7SKf2MTl6O/mmOSgyM4CwJggT4xm/I4SxmItrCWSTuPnMvcUcDr/rdNb
	 cZV5PL4aP/CyXVaBq0CNflUFvAmOkCT2a+K/sibo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/136] tls: trim encrypted message to match the plaintext on short splice
Date: Tue, 21 Oct 2025 21:50:47 +0200
Message-ID: <20251021195037.399435126@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit ce5af41e3234425a40974696682163edfd21128c ]

During tls_sw_sendmsg_locked, we pre-allocate the encrypted message
for the size we're expecting to send during the current iteration, but
we may end up sending less, for example when splicing: if we're
getting the data from small fragments of memory, we may fill up all
the slots in the skmsg with less data than expected.

In this case, we need to trim the encrypted message to only the length
we actually need, to avoid pushing uninitialized bytes down the
underlying TCP socket.

Fixes: fe1e81d4f73b ("tls/sw: Support MSG_SPLICE_PAGES")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/66a0ae99c9efc15f88e9e56c1f58f902f442ce86.1760432043.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index f46550b96061e..aac685daf66c4 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1112,8 +1112,11 @@ static int tls_sw_sendmsg_locked(struct sock *sk, struct msghdr *msg,
 				goto send_end;
 			tls_ctx->pending_open_record_frags = true;
 
-			if (sk_msg_full(msg_pl))
+			if (sk_msg_full(msg_pl)) {
 				full_record = true;
+				sk_msg_trim(sk, msg_en,
+					    msg_pl->sg.size + prot->overhead_size);
+			}
 
 			if (full_record || eor)
 				goto copied;
-- 
2.51.0



