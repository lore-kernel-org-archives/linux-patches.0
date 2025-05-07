Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29EC29A0;
	Wed,  7 May 2025 19:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644660; cv=none; b=jkCjNoHUDSLzgZXQqQmN1tQBMUmCfI5/yC3ifrSaLjzffo5jGGz16HlHHBueTNeKnYyCclo+zcJAo0oRBYQoQyJzseEcaW6e4pdaG2vmSofOfVFjWOEhN+FGZOWhXyCyb/67JLMSochAFRLQA6q1WRsu16zML8vnl5srYVv3UsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644660; c=relaxed/simple;
	bh=PiGNITFrU9rMS0Qk84O/gN1xmtX61gzfGi/Nww/RDrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JhysDUg21RBoWJ4+tPRmm+TcTx7GAXnl67I45nlQVaG3k0Z5TuSn28Kw/QEpuuYzLZnRq+9wIQxyX7PELfrHkYbIEzDLmwNmIYZ0C78yKu7zTzp1CYQ6LMRWz0Zj1VEQFsYzfTUqaM/MDZkN7puQVeZEXXZegYP85GY8Ey59C38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qCD/3tfs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qCD/3tfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60367C4CEE2;
	Wed,  7 May 2025 19:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644659;
	bh=PiGNITFrU9rMS0Qk84O/gN1xmtX61gzfGi/Nww/RDrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qCD/3tfsI1Dg5eHzFTh5Yyx5s+C6PDBQkZdAZx8a01cE9O64W5KrBpLUUDVJcWtwU
	 2+rqrlprYoUnyFtldRIds4J1NEe3BEhhclmDHBRmbC1feiI9PMUv5uwHmToqa99KCy
	 evtKLo94xUzzYfMlUDh9XRZAE6Qrow7cMRrcspxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 114/164] bnxt_en: call pci_alloc_irq_vectors() after bnxt_reserve_rings()
Date: Wed,  7 May 2025 20:39:59 +0200
Message-ID: <20250507183825.590048994@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kashyap Desai <kashyap.desai@broadcom.com>

[ Upstream commit 1ae04e489dd757e1e61999362f33e7c554c3b9e3 ]

On some architectures (e.g. ARM), calling pci_alloc_irq_vectors()
will immediately cause the MSIX table to be written.  This will not
work if we haven't called bnxt_reserve_rings() to properly map
the MSIX table to the MSIX vectors reserved by FW.

Fix the FW error recovery path to delay the bnxt_init_int_mode() ->
pci_alloc_irq_vectors() call by removing it from bnxt_hwrm_if_change().
bnxt_request_irq() later in the code path will call it and by then the
MSIX table is properly mapped.

Fixes: 4343838ca5eb ("bnxt_en: Replace deprecated PCI MSIX APIs")
Suggested-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 74be0dd6f7a53..e4d5bd30cf319 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11851,13 +11851,8 @@ static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
 				set_bit(BNXT_STATE_ABORT_ERR, &bp->state);
 				return rc;
 			}
+			/* IRQ will be initialized later in bnxt_request_irq()*/
 			bnxt_clear_int_mode(bp);
-			rc = bnxt_init_int_mode(bp);
-			if (rc) {
-				clear_bit(BNXT_STATE_FW_RESET_DET, &bp->state);
-				netdev_err(bp->dev, "init int mode failed\n");
-				return rc;
-			}
 		}
 		rc = bnxt_cancel_reservations(bp, fw_reset);
 	}
-- 
2.39.5



