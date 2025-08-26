Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D52350D46;
	Tue, 26 Aug 2025 13:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216308; cv=none; b=IdUWFFgMoBmldNCVGzbWdtblXuVeakAfo+XE9tXwGfT6u2eEb8MbrRyyPWEagBAN/8L4eOWtd25TngiJ0EO6cg0vX7aMPnQ4L4+K3P1qa6qysA/z2m+acYU3zuXHqIiiXQv6pY/MyiCTXtroDAqnShITo1ncOFwa4hX8x2+o7rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216308; c=relaxed/simple;
	bh=Z86WqDwcXjrWl9EZiIFvKk5ijFSj2zumM64EDbhvJAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZ/zacBksUc6PhnQd9H+Uh237NHmvttKNwAPYCNBprP2FsnPox+0/BBLsozUYMkE9XlP5RvnFJ6r6yGe5bH/Mg7S+2X7T5LfSPqw9r19++7cgYqcF/waoAII8ToNhoc/Vh9yQ1ExoIiO8e0FyiCvSWrIEZA7nqdCOqU3xbq0wIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WKyXJRT7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WKyXJRT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EED7C4CEF1;
	Tue, 26 Aug 2025 13:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216307;
	bh=Z86WqDwcXjrWl9EZiIFvKk5ijFSj2zumM64EDbhvJAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKyXJRT73KK/suxnlwyfoEBxfohmsa+wdjQyelKbDm5idA0RaZ8c7UZyEd0pmNhs5
	 QAYp4T7xkpHAU67O+n8HkKfw1eHoK90HGUoKwrKYc9IEK4FN7tsqeRsqnt1ZDNAYiu
	 KQ41ZkmR7Hv8sgXFCiYXEnVNcMzA8mqhU3wFdFE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 363/644] wifi: iwlwifi: fw: Fix possible memory leak in iwl_fw_dbg_collect
Date: Tue, 26 Aug 2025 13:07:34 +0200
Message-ID: <20250826110955.409525329@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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
index f1d07ddb3f83..2c5358fc05b1 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2561,6 +2561,7 @@ int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
 	struct iwl_fw_dump_desc *desc;
 	unsigned int delay = 0;
 	bool monitor_only = false;
+	int ret;
 
 	if (trigger) {
 		u16 occurrences = le16_to_cpu(trigger->occurrences) - 1;
@@ -2591,7 +2592,11 @@ int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
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



