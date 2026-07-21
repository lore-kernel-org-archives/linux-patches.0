Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519E5476069;
	Tue, 21 Jul 2026 17:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656404; cv=none; b=ofVDRL/iffg9MBECol4jlI5LSr1UOkOd0BnRR552ChgEshmvCLHLsxtgoqYuC/42avE1rNW6cH6n9Li1DpoosULwfOUNdGzYNvYqm5IegOqq1BAut4jzoE9hzBVZmJYXMqG5SLkRvscdBVGKkHbkLJN3gi1iIA/bYMlfFUGmrRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656404; c=relaxed/simple;
	bh=aE7c5SgnuSHJtPggQK2Y1hEfhHwbkXAQUU4RkGf+Wh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h8G7wq12FxeUTFbGcvNCpADJNhziCIbl+7uRz8i93vRp7KX3KZ/IDzhyP2EeNOpLt02DvnxzsZvbmkANZBJF55fYu7FOYSG8ud5msPscvSANUl4jr3D/8lBtfPPgttQTqVZcNcO0PfuzLuLS7cG0mcHhFlLw9tgeuQUfSut4p+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wi5Ofu7/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wi5Ofu7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6963F1F00A3A;
	Tue, 21 Jul 2026 17:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656402;
	bh=jtVPcbuV7+V6x2715S8gZpY6LaqTNztDUZ8Z9ebPjc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wi5Ofu7/WnCc3zPLrTiCAun0PH0t76nEnp9V1e/JWZEE4+3oTDP35hjWkY3I9VjbY
	 FLTxk9Ps/evxKCzmvqLMLU4+h/0+L7GtVh1TCrq8IoEC3WKTYScdFure7TEkEPMRbs
	 6Bwi22U12CSPCkR4rxdZyOLE28kKCZdgLutGlEsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0331/1611] cxl/fwctl: Fix __fortify_panic
Date: Tue, 21 Jul 2026 17:07:27 +0200
Message-ID: <20260721152522.541236179@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <djbw@kernel.org>

[ Upstream commit 6c9d2e87df40d606f1c85143e9acb1ecff463d5e ]

Fix a runtime assertion in cxlctl_get_supported_features(). Fortify
complains that it is potentially overflowing the entries array per
__counted_by_le(num_entries). Quiet the false positive by initializing
@num_entries earlier.

 memcpy: detected buffer overflow: 48 byte write of buffer size 0
 WARNING: lib/string_helpers.c:1036 at __fortify_report+0x4d/0xa0, CPU#7: fwctl/1398
 RIP: 0010:__fortify_report+0x50/0xa0
 Call Trace:
  __fortify_panic+0xd/0xf
  cxlctl_get_supported_features.cold+0x23/0x35 [cxl_core]

Fixes: 4d1c09cef2c2 ("cxl: Add support for fwctl RPC command to enable CXL feature commands")
Signed-off-by: Dan Williams <djbw@kernel.org>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260519221204.1517773-2-djbw@kernel.org
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/features.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/core/features.c b/drivers/cxl/core/features.c
index 4bc484b46f439f..c3cb2060bbeac8 100644
--- a/drivers/cxl/core/features.c
+++ b/drivers/cxl/core/features.c
@@ -423,6 +423,7 @@ static void *cxlctl_get_supported_features(struct cxl_features_state *cxlfs,
 
 	rpc_out->size = struct_size(feat_out, ents, requested);
 	feat_out = &rpc_out->get_sup_feats_out;
+	feat_out->num_entries = cpu_to_le16(requested);
 
 	for (i = start, pos = &feat_out->ents[0];
 	     i < cxlfs->entries->num_features; i++, pos++) {
@@ -444,7 +445,6 @@ static void *cxlctl_get_supported_features(struct cxl_features_state *cxlfs,
 		}
 	}
 
-	feat_out->num_entries = cpu_to_le16(requested);
 	feat_out->supported_feats = cpu_to_le16(cxlfs->entries->num_features);
 	rpc_out->retval = CXL_MBOX_CMD_RC_SUCCESS;
 	*out_len = out_size;
-- 
2.53.0



