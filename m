Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036783;
	b=j5+OXsp6mMasCtpzn0fmWJG2l2mJSUIhY9MxhFYJXWT7hNk85uxIm9+InGew1qE2vC17
	 jzjgpplR15kVJzjV+RBndUc457lWPiCf66Gt/B9ko3xJSoQbu/7mW/2LNib0ivcteEsNE
	 MTw8bt1Wbp+hhq9VhWcenL1muEPFh5Kidrcz7cU12M2ZiuYLI99jzsPmRDMNr1DifK8PJ
	 mnYVjR6k7AnALZeptRG7i64DvoCb+BgQdUc781uDmL3Ko4KX2zsSSBONY1QvpzMhePqVq
	 5l148OC+WaMzQXG7vVnd75HvHjiOwIHm4ZUXB/Sljkhd6Lolenl7u/f9U1SYr0hMGsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U01D8bgDVvtcLv5XcBHB+3KlQonVHTlFJoJVfz46H8E=;
	b=ZmL2+1EUq5/SZGLBadBDBSyahUDRAc6Pep+c7b1Y+uRwMAtbETGJ/eLtMlV63aB7YYfS
	 Uk4Zimkx3F3NuY4cHNgP/YjpYldjIvQCXrUe9vDdbXcLbWCjiEToOzvUKiUCJFjrqV/iG
	 tqLia3GO8zesPFIFsUGfxgzwZcTcAK9ooB89rdh8D5UzDH15V2i3xk1LESU4YeTNYaAQp
	 phyYbGpkUPMqJq4H+beZumR9fSt5ker7aZGRUbSsJzPoOfSbOpKWdT5+qiNAU+lVENkPl
	 KmSeWA1RViPiEPe6PazlSdjNQ6Lxy/lK2Rd3UTXIRp9kG0ifZ5ICGbvAGUJb0Xqsr9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EWoIrSuV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279F3606A320;
	Wed, 18 Nov 2026 21:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EWoIrSuV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7958B1F000C4;
	Wed, 18 Nov 2026 21:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036783;
	bh=U01D8bgDVvtcLv5XcBHB+3KlQonVHTlFJoJVfz46H8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EWoIrSuV32fV7KGpOJHXy3r2actssnpxRQ/kBDJPtjAX94Y+k7tFc7UUM/ki7oWnw
	 nsjCc+NUxA1rOrmEVPYC7QQ/sZvqWImWDfUXt5Vfl7ZM2fnjd1+fZ0uY9B5H8rLRAh
	 W5lpbxlh2rc+jnICt65GsrgTEDc8B8G135YYjK2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1182/3318] net/smc: queue the copied chunk when smc_tx_sendmsg() faults
Date: Wed, 18 Nov 2026 15:30:04 +0100
Message-ID: <20261118150355.604938113@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit c0703534b223a5c6993e0f000fd1c3abe621fb65 ]

When a send wraps the end of the send buffer, smc_tx_sendmsg() copies
the data in two chunks. If memcpy_from_msg() faults on the second one,
smc_tx_sendmsg() returns send_done, which already counts the first
chunk, but leaves tx_curs_prep and sndbuf_space as they were. send()
reports bytes the peer never receives, and the next send() overwrites
them. Any caller can hit this on its own stream with a buffer whose
tail is unreadable.

On a fault in the second chunk, queue the first one. The next pass
retries the rest and returns send_done if it faults again, so send()
reports only what it queued, as TCP does.

Fixes: e6727f39004b ("smc: send data (through RDMA)")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Link: https://patch.msgid.link/20261013-b4-disp-872a3689-v1-1-2a4c63b04761@proton.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_tx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 3b0ff3b589c70..ee6e345db0072 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -249,6 +249,13 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
 			rc = memcpy_from_msg(sndbuf_base + chunk_off,
 					     msg, chunk_len);
 			if (rc) {
+				if (chunk) {
+					/* send_done counts the first chunk:
+					 * queue it and retry the rest
+					 */
+					copylen -= chunk_len;
+					break;
+				}
 				smc_sndbuf_sync_sg_for_device(conn);
 				if (send_done)
 					return send_done;
-- 
2.53.0



