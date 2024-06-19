Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7768F1E492;
	Wed, 19 Jun 2024 13:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803950; cv=none; b=bhF074bQvxu8/f54YeoRL1vV9owzuPkxN1ejGRlA2O6MvaZKEpKqBa2ydsqIe2R3aeujAgqjQzqqhB50l8/nkNfh0oa75745j0uI6+8S7XlCBpvL4xD8rDN5dExexaIXq18WYEvtQzrpInafn+1EATQO0QA+eUuKKWthfrx2NLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803950; c=relaxed/simple;
	bh=4CAiRxuWtJmp7UKy3ne1Tr0x1j6WyrOymxVIAebeX08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0dtYPPX1w9RPcDAQdrdgtMDGoE1lkUjCWU9axfVzp8rfcOs07nbomqV2lNCSfG5JmTs8bnZX0W/zWaryhsRY/6zUTrd5coCPztT6HCSL8ZQhH4qvx8RlTgM0+XHVOfpKLMsTopYA16p5LsH4UAUmHZzEMi8f09i9XuCr6qB7BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g7jFnyEA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g7jFnyEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE97CC2BBFC;
	Wed, 19 Jun 2024 13:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803950;
	bh=4CAiRxuWtJmp7UKy3ne1Tr0x1j6WyrOymxVIAebeX08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g7jFnyEAPQBeAPhC02YWTYW8PSe7hz+azj7oD9MOCiM24yVxwKzW7pYfjsB/RsCPB
	 xt01fWBVsIOVN3AROpgOr2/30zeK1UuOIPULqHolrT/Hg0LJbW/zN5mf5mnTiHPyZ4
	 Zy5qjkaFcdwVR7P9XK4UZEN+CqVxXh00WYy7hMbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 158/217] bnxt_en: Adjust logging of firmware messages in case of released token in __hwrm_send()
Date: Wed, 19 Jun 2024 14:56:41 +0200
Message-ID: <20240619125602.788641855@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



