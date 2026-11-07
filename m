Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065191;
	b=Sguhutsukv6wbHyOLOtaXpAgwkCJl0gW6tEKgOYdiNpHIEq10zhUDk+Q6WLpOLw5CEN+
	 bv2X4bRJlXbnH2lAPxrsugJeWzqpjwYEF/yrizxV+2zcLoFPMgFSchhSPfsFXgfhnKJWi
	 IjT6uS8xOgryV6jKH0YW1UKlv36pZBzzyM2sdPqj1KAfVIQtg9nQlfm/m+xn2Te7NWHbI
	 NtRZmQNSsfd3gH9Cl2JiexSWkM4eG4iPqXeN0izDxiOl5LWN1AjUiC5Pak7ooKJEWE2JO
	 LtvIWTlye6nAfCFXD7Io9Zft8HFu4+denmfs/0EqHovKAJyITxeGvKJ+8o1BfEBcTeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ztfNtwYd9TwKQDdZVtiEnEZO/iEwLjcLyCC3TT1dIGI=;
	b=Cq7/k6c7s2uuk8CERr9YLamLt9fBl9qj1nh9lcaV9p4gs8e1pmbLRyIyBE9jRgLId3z3
	 2PoUrVgkAj9jw70UWzBiho+oU0sKfUn/m0IAzMRg7mcj5SARaZtbFFOitcYdqGqpfs2LG
	 MCTjDIXv0y67RfShV6qhJsTcYI6XtPoJdA9210gmoFcfrEg5VQepoCOTg1B7DkmOCiO56
	 yqEFUpUwpi1/wMLTFix+Wc5oqP3xdfuk9C7TEyEaudxwKEMUCRLINkeb4pDpoyoQihPc6
	 /2hA9F9lmJ7l8aWww06oheUD+kBXg3UwQRWjVWzNal9n0Jzv4iy/FQ+Lps92vX691UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oTUA1vSn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA6C606A339;
	Sat,  7 Nov 2026 15:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oTUA1vSn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7341F0089F;
	Sat,  7 Nov 2026 15:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065190;
	bh=ztfNtwYd9TwKQDdZVtiEnEZO/iEwLjcLyCC3TT1dIGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oTUA1vSnjzdDGhVTly6l3T14FW5L/3s3bfnqoBjY7bKQV3Ovmq94BVeGYbi/trsTu
	 w+YmhNG5LlW14bpRKEzfn2xEgKtdxLX1c+ccFzZ7LZJzH1q7fn+G+cBERwAkly5/X1
	 vvvUqPfNpWqwup66vImwWCT7G7JzIMdGNLNFyCxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0993/1257] net/smc: queue the copied chunk when smc_tx_sendmsg() faults
Date: Sat,  7 Nov 2026 08:54:49 -0500
Message-ID: <20261107135006.791058553@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 3144b4b1fe290..495fb1354728c 100644
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



