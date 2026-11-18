Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058632;
	b=LJk4736qyPVf7lv4QVNLCA5ViUtgh9LDPVmj42QfdYVCUcYecSzl7p4/zTgVc2wBsPAU
	 CoqjLqu/eW9GtBCaIhk6k0UQ+ZPPxnYEGgvBSuWVzdkTxl6iMcX4zMaAiXd6yeAfFEZPJ
	 bUv8pOAThfgRRPvfu/nQjTlm79+B8kG7qwswSRzooQXCnO+hfBLb/PxQ0DmTelWODCpJH
	 VaUMFFNJNkJvfOuXt+2l5sOw0JZsF1Kyp7oanO2b1XbcB29xZIgenZadniQDL+jVjMDD/
	 r4ixu+Uchm6RQEUbDKumVF1KkYmAnck5hpvJtt6ukgZq7tiZAINTHlKXGqkTKjm4fxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZURypWif1d+XoE6eckG7wD1uoicdh9r+LyWrBc49Jas=;
	b=PLmb/kaQhsVFjcGM+Zdfsq281LjYHaPsz4yF5tPL9Ct37/R915aPKrnfGo65nFcjKkvv
	 w+tFQX72MQE3vUOt1xe9gAqqXFJ6QS8+D9JJRAIqeiZ84YZSbSkpnCYiu1vep7g3G/v/+
	 cW9MdX3M37x3bcVDjrWp5W0udPPu22OuHIc2w4RieA75SQifZ4qb7pkziXRrMTxSE3tlY
	 IbHhxL24PBcGsCFjU7Jf+Tq6OoiYKrl42Mqsf1e/3m4o3DEyk/uWvJd/U7OQiRLqlT/mv
	 vCGdG5DoszojBjrVuZmoyHeKWHniJtzZGKkqLupLitiLBkK5Jc1zLHjYWeawO8WMUFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cR1L1FiV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7690B606A31C;
	Thu, 19 Nov 2026 03:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cR1L1FiV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB51B1F000C4;
	Thu, 19 Nov 2026 03:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058632;
	bh=ZURypWif1d+XoE6eckG7wD1uoicdh9r+LyWrBc49Jas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cR1L1FiVDEb3abrMJBetgldGh6WMYpfsLjjNTdQbYuxKEuBWk36u1lbB8NOGfceIQ
	 k5l23OI3H9TJxjG72wvODlqLzhhAMI62X2SgAZtzbBVSGwy1u3U/6E/K+l5LI3OVWS
	 Y5cFytFFsxPEkT9XVdK4RohKUa4zW3LrpJaeq0cI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0555/1848] net/smc: queue the copied chunk when smc_tx_sendmsg() faults
Date: Wed, 18 Nov 2026 15:43:13 +0100
Message-ID: <20261118145938.144795053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3a2748bc4beaf..899a9060874a9 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -193,6 +193,13 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
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



