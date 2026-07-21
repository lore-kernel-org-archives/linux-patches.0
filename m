Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAAD46AA9C;
	Tue, 21 Jul 2026 15:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649149; cv=none; b=gHMOTimEfeDj0KYNbj2fQRS8QmcojkID99ckqxR1SxYrLBVZZ4eS5oi6/asywQUCkCwfuo+MCncYQ0rCI6bO6PgGrsi4RdSt5Uhz+nSahuZFX57lkvtsqANSxvxZ5jW3QfwhJ/NIZFKGUSwummiFNCHZkTmXl0B4DERrxTxQXaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649149; c=relaxed/simple;
	bh=AgJ7yUFigNyV/WjWRT0gYR0RJwDQQsL7ml3mqNdK6D4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUNmDek/68y+ZejlryfN0LeuVDDb1L3Ya7nBUCeYU5/UXTR9j4sQxGDUG2+6iYdfCyKQDNy77HR8f70C3qScak2i/ydJLbr8Bj3s/KddvJ1SLy9W+CmGJcN6Xt56qcRBgE1p3JjgYb0+5UYPAvzPjm5nYQBSLHcWQ19qpvC5ung=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ufBUfTR7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ufBUfTR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38B31F000E9;
	Tue, 21 Jul 2026 15:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649147;
	bh=UWcpev6jd/gNhRpmNiDbdza6Mg2uvAw3SVPPSeSpfe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ufBUfTR7h6sh6flyaO271NktGvBxPuBuCLEoVQEuDBWTXa9xCEIljyPTuZ4oG4DDI
	 zR865r7gymd6PfFY7NjHbMDMR67/ZnF75xXRHcfwzd+vV39eeMwA7DePOEcX4jymSd
	 c0VyAiL/C68Wt6Owkm5jsFkCddrEWn+/ZIp01me8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0469/2077] cxl/fwctl: Fix __fortify_panic
Date: Tue, 21 Jul 2026 17:02:22 +0200
Message-ID: <20260721152603.855269044@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3435db9ea6b116..85185af46b72d8 100644
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



