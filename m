Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CE939C00E;
	Thu, 30 Jul 2026 15:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423877; cv=none; b=kmk+Gr3YDR2NYDNbYVumfPBCJ87YLUiZdsnqKGpxoZtwsx6/jMZVhvSSZXr/HsPUDCG1sHIxOWXzex7lhCHohM/d7ydXPCs8Jw4JH19GHTprd19OzReHgbP7TzdXQ9RmubZ+7YrXKa/bvURzbb2YMw8amAgxRGzIZ1ho3st929o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423877; c=relaxed/simple;
	bh=828C7WYAQIvXSjrLHMUr7hDdedAoAcOGuk6hyYTV/Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AbC1wF+rWaAg0BxV6dPLEtg+otAK2TiXd6B31w0pH5j6D+Pb5SoC72H3wD293K39wmwmg4VsXwNHaGz5SfK4QZapvl4zNDaAEt77GPzWgWr2FuJSESqHfMRySOq6YEzXa6v08RkB7xqd4Rr5urBiBKw6d1Mz1BmXAKH+Qg3JOwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GTyumZ2S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GTyumZ2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7077F1F000E9;
	Thu, 30 Jul 2026 15:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423876;
	bh=K6wnJAfi3hvLmBSlW/pp2zd6GnguXOTZxDoOlbK7B9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GTyumZ2SIjH1iuHTUeJAV/+nDKpHarHMgwrF+1aChSh8POP70DC4M5yG9z2JNtN22
	 DVpbDrrOcTHEWXxQDahAHtyGLZX9JshUChi+KRKHh3e0hgAgGwNkEE/jw/b1KqF2lW
	 DtPX5WUBXSIcHlNvARtJPjXWMV5+vL/LzqneMlx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 197/675] wifi: iwlwifi: validate payload length in iwl_pnvm_complete_fn
Date: Thu, 30 Jul 2026 16:08:47 +0200
Message-ID: <20260730141449.330649073@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit daec24a5ed5da77a108e246ad77aa8b889911f93 ]

iwl_pnvm_complete_fn() casts pkt->data directly to
struct iwl_pnvm_init_complete_ntfy and reads the status field
without first verifying that the firmware notification payload
is large enough to contain that structure.

Add a WARN_ON_ONCE check against sizeof(*pnvm_ntf) and return
early without reading uninitialised memory if the payload is too
short.

Fixes: b3e4c0f34c17 ("iwlwifi: move PNVM implementation to common code")
Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715215523.7f2a669e5c75.I00465dcfcbccb250ae9af2d9bb305e24de1ba394@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
index f297e82d63d234..5de3a9c0b3ef09 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright(c) 2020-2025 Intel Corporation
+ * Copyright(c) 2020-2026 Intel Corporation
  */
 
 #include "iwl-drv.h"
@@ -12,6 +12,7 @@
 #include "fw/api/alive.h"
 #include "fw/uefi.h"
 #include "fw/img.h"
+#include "fw/dbg.h"
 
 #define IWL_PNVM_REDUCED_CAP_BIT BIT(25)
 
@@ -26,6 +27,12 @@ static bool iwl_pnvm_complete_fn(struct iwl_notif_wait_data *notif_wait,
 	struct iwl_trans *trans = (struct iwl_trans *)data;
 	struct iwl_pnvm_init_complete_ntfy *pnvm_ntf = (void *)pkt->data;
 
+	if (IWL_FW_CHECK(trans,
+			 iwl_rx_packet_payload_len(pkt) < sizeof(*pnvm_ntf),
+			 "Bad notif len: %d\n",
+			 iwl_rx_packet_payload_len(pkt)))
+		return true;
+
 	IWL_DEBUG_FW(trans,
 		     "PNVM complete notification received with status 0x%0x\n",
 		     le32_to_cpu(pnvm_ntf->status));
-- 
2.53.0



