Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31C012FB31;
	Wed, 19 Jun 2024 13:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802365; cv=none; b=K7DUmeemmk0k5HrUZFVME11sV2ZgGTtO/xnyck+czn25hHy6wff3TBvU6Oi1SQIQ+S2EVfQneFVVWo2eRLzMQ0Uni20dXyJIgRbiJvoatQ/BXl+mqtKo+aIDELBh7NMcOOfbUEvk67tGFDcB9sVYn2uPQu/s7XNjebHNo1kDEWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802365; c=relaxed/simple;
	bh=Z/YFbcRJB6D6BEqgwz7aarHvOrlmGo64SCGSjlNIhFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJayQ0jfopi1aj0MsVOwGrRv0pteCwwx1RT3Wua9H4CeINlw55RHpWdJIv69CehSgyIOfwBB6v0ryBy4RQeB3Fr8cVyTHo5XkCNPGbxpRrqZt8z2e3j+uFNINKWtLM9aDIF1/Z1xTKBJzuu/Lf8bM6pRWE59YOtqK5tLDL1p3mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AtI3dUFT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AtI3dUFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D2CC2BBFC;
	Wed, 19 Jun 2024 13:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802364;
	bh=Z/YFbcRJB6D6BEqgwz7aarHvOrlmGo64SCGSjlNIhFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AtI3dUFTlhEVZleqX17jjAGO/c3iytpNPK2m5AdUA4ywHZRUMWF+vb25kMty5ZDYy
	 7i1A55ZjJDSSWDISnQFer/4pY82V5aBI1TFieFhC42SXfQNYq5Cc/H73J6I7EHMhar
	 uzHG8YmoVez4vX66dsciJwCact2ubx8kaRj/6D3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 171/267] bnxt_en: Adjust logging of firmware messages in case of released token in __hwrm_send()
Date: Wed, 19 Jun 2024 14:55:22 +0200
Message-ID: <20240619125612.905147632@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit a9b9741854a9fe9df948af49ca5514e0ed0429df ]

In case of token is released due to token->state == BNXT_HWRM_DEFERRED,
released token (set to NULL) is used in log messages. This issue is
expected to be prevented by HWRM_ERR_CODE_PF_UNAVAILABLE error code. But
this error code is returned by recent firmware. So some firmware may not
return it. This may lead to NULL pointer dereference.
Adjust this issue by adding token pointer check.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 8fa4219dba8e ("bnxt_en: add dynamic debug support for HWRM messages")
Suggested-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/20240611082547.12178-1-amishin@t-argos.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
index 132442f16fe67..7a4e08b5a8c1b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
@@ -678,7 +678,7 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 			    req_type);
 	else if (rc && rc != HWRM_ERR_CODE_PF_UNAVAILABLE)
 		hwrm_err(bp, ctx, "hwrm req_type 0x%x seq id 0x%x error 0x%x\n",
-			 req_type, token->seq_id, rc);
+			 req_type, le16_to_cpu(ctx->req->seq_id), rc);
 	rc = __hwrm_to_stderr(rc);
 exit:
 	if (token)
-- 
2.43.0



