Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C498F70831;
	Tue, 15 Jul 2025 13:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586263; cv=none; b=XeC3zxKDaEJ4DTW2cuCSKKGmjG2AbJmsD5KbpEDT5/zM02tSCfxtMSlh7q3zamC/8RpjvoBQ0kf4jN7/8biu7KNStlukeaEMf/Ljo1+n8SLaOcqGIrr6iWrzI0Re4Kh9ml+jxtDf2nvUoeo5sw2yfCR2bqpXwQtxah+uA0TarZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586263; c=relaxed/simple;
	bh=Tk1X99FDD/yWIz12o1Pp2VqnfWUJ+BGNFjBgekO9e6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=le6b+sVblWfOZPpquF5qzGCQXNMZVP/M/plL4bWRzmT0eCU4DvRYQBvCFwbuHJ3c/D/JxuaEwlY6U5D9RIqoUMQWfWQDMKe1POKSQTctYCyxn7omX7ezdAkpR9jYEFseu2aa6lamANjYK/rtJ9vgH+eVoh1AHrrrfEqx/3I2u74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qwr5o3Fe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qwr5o3Fe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5969AC4CEE3;
	Tue, 15 Jul 2025 13:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586263;
	bh=Tk1X99FDD/yWIz12o1Pp2VqnfWUJ+BGNFjBgekO9e6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qwr5o3Fe8w8ivfI4YVSSp+R9DTk9RepjKcep86mHHs2/NbEHdyeJxebbka8Pnph5l
	 7yxa9aJw0NDsIfoxaDNKFTTlPRQfbtuZIuana1tZUTQBFljFhS9SdXoAi19VYl2Aw3
	 2PISVYqwfFHh7441bWJSJPdw8IzLrMDPr+CGk8wE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 66/77] bnxt_en: Set DMA unmap len correctly for XDP_REDIRECT
Date: Tue, 15 Jul 2025 15:14:05 +0200
Message-ID: <20250715130754.376733352@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Somnath Kotur <somnath.kotur@broadcom.com>

[ Upstream commit 3cdf199d4755d477972ee87110b2aebc88b3cfad ]

When transmitting an XDP_REDIRECT packet, call dma_unmap_len_set()
with the proper length instead of 0.  This bug triggers this warning
on a system with IOMMU enabled:

WARNING: CPU: 36 PID: 0 at drivers/iommu/dma-iommu.c:842 __iommu_dma_unmap+0x159/0x170
RIP: 0010:__iommu_dma_unmap+0x159/0x170
Code: a8 00 00 00 00 48 c7 45 b0 00 00 00 00 48 c7 45 c8 00 00 00 00 48 c7 45 a0 ff ff ff ff 4c 89 45
b8 4c 89 45 c0 e9 77 ff ff ff <0f> 0b e9 60 ff ff ff e8 8b bf 6a 00 66 66 2e 0f 1f 84 00 00 00 00
RSP: 0018:ff22d31181150c88 EFLAGS: 00010206
RAX: 0000000000002000 RBX: 00000000e13a0000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ff22d31181150cf0 R08: ff22d31181150ca8 R09: 0000000000000000
R10: 0000000000000000 R11: ff22d311d36c9d80 R12: 0000000000001000
R13: ff13544d10645010 R14: ff22d31181150c90 R15: ff13544d0b2bac00
FS: 0000000000000000(0000) GS:ff13550908a00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005be909dacff8 CR3: 0008000173408003 CR4: 0000000000f71ef0
PKRU: 55555554
Call Trace:
<IRQ>
? show_regs+0x6d/0x80
? __warn+0x89/0x160
? __iommu_dma_unmap+0x159/0x170
? report_bug+0x17e/0x1b0
? handle_bug+0x46/0x90
? exc_invalid_op+0x18/0x80
? asm_exc_invalid_op+0x1b/0x20
? __iommu_dma_unmap+0x159/0x170
? __iommu_dma_unmap+0xb3/0x170
iommu_dma_unmap_page+0x4f/0x100
dma_unmap_page_attrs+0x52/0x220
? srso_alias_return_thunk+0x5/0xfbef5
? xdp_return_frame+0x2e/0xd0
bnxt_tx_int_xdp+0xdf/0x440 [bnxt_en]
__bnxt_poll_work_done+0x81/0x1e0 [bnxt_en]
bnxt_poll+0xd3/0x1e0 [bnxt_en]

Fixes: f18c2b77b2e4 ("bnxt_en: optimized XDP_REDIRECT support")
Signed-off-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20250710213938.1959625-4-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 148b58f3468b3..8a5009e66a134 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -67,7 +67,7 @@ static void __bnxt_xmit_xdp_redirect(struct bnxt *bp,
 	tx_buf->action = XDP_REDIRECT;
 	tx_buf->xdpf = xdpf;
 	dma_unmap_addr_set(tx_buf, mapping, mapping);
-	dma_unmap_len_set(tx_buf, len, 0);
+	dma_unmap_len_set(tx_buf, len, len);
 }
 
 void bnxt_tx_int_xdp(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
-- 
2.39.5



