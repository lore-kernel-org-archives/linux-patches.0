Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0723413C3F2;
	Tue, 26 Aug 2025 14:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219102; cv=none; b=O9z6OIeBteFjt8OYEFPuC9p5avebwR/Ck2VTQiTFCJLgjFj/crC03NxnPBc+4J6dH6t01KFHDN9DQK+2BOwIuH8JHM/8CG2s/ipGG8XZWGOdO4k2MpPeEhOqTJafktNvWO85D4bB8nTdhRG4cIJb/ZP5jYNOpeomJ6iQH32rW0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219102; c=relaxed/simple;
	bh=Dv5IGcnS7pE5c5+MmOSfOsTkmioXEv9AGn0tmpJre2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDC+1A8iQOl6T1WcP574wzsMwVAuOWy2ICAL2hFHZ2734tZ5BtHBiV1+N8mlCOUXP0cJxN38mcs+Ir9J75vGDhTJpA1KnXIFMsyxPwJ25WhWcnyxnTHwLyZQA+5PnR7xUhBC7ufW/BCLl7EzmDyCxaPO+b6VDbhAzG/0I5gvEAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMnqTyyq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMnqTyyq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56EDEC4CEF1;
	Tue, 26 Aug 2025 14:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219099;
	bh=Dv5IGcnS7pE5c5+MmOSfOsTkmioXEv9AGn0tmpJre2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMnqTyyqEAdLcNF+jt9P9STU+6fhBWkUxv3wAsSrn1g7dKVBEMqbJBUxYzkbumpzZ
	 EizydKSNBE87db7dy40ylztz/+ftHKKRu0Ui9HG/zz9JvhFRAgTbuy08W7fmKuRJto
	 S5hFBVBUAijU/j+NeOw1e9+yGTHGbI7yKAishLpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 221/403] wifi: iwlwifi: fw: Fix possible memory leak in iwl_fw_dbg_collect
Date: Tue, 26 Aug 2025 13:09:07 +0200
Message-ID: <20250826110912.937295051@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

[ Upstream commit cc8d9cbf269dab363c768bfa9312265bc807fca5 ]

Ensure descriptor is freed on error to avoid memory leak.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250611222325.8158d15ec866.Ifa3e422c302397111f20a16da7509e6574bc19e3@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 286b5ca3b167..14f96bd41377 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2130,6 +2130,7 @@ int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
 	struct iwl_fw_dump_desc *desc;
 	unsigned int delay = 0;
 	bool monitor_only = false;
+	int ret;
 
 	if (trigger) {
 		u16 occurrences = le16_to_cpu(trigger->occurrences) - 1;
@@ -2160,7 +2161,11 @@ int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
 	desc->trig_desc.type = cpu_to_le32(trig);
 	memcpy(desc->trig_desc.data, str, len);
 
-	return iwl_fw_dbg_collect_desc(fwrt, desc, monitor_only, delay);
+	ret = iwl_fw_dbg_collect_desc(fwrt, desc, monitor_only, delay);
+	if (ret)
+		kfree(desc);
+
+	return ret;
 }
 IWL_EXPORT_SYMBOL(iwl_fw_dbg_collect);
 
-- 
2.39.5



