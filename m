Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0121ACEDA;
	Tue, 26 Aug 2025 13:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214464; cv=none; b=PBrh2F3PRxGgl+aedqQz48ynmYKiXP6f7Zs5uR+UANGWtnyBgeYT+0kbFtclMrCg9tq3bxVtUVbsZTlcCXlD1xUvJMREERkucd/Nb2g2HApGN0kM8ypQaa0beg99G8NAmlawDMCXPlkh95BttEJg0HEJLwXNsHRR/9tVqEzqOck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214464; c=relaxed/simple;
	bh=LFp2b1NsVGXHJgrjeaQuPgGEvOxGYWqQzJtJanCgFuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SdC6qOoTUiNNi/zN36gIOfqD43jYtzVRs+SGfWzxMM4Z3+4YEBoYeBXjLzqjM6H78UmUbYQXmF+CLWMc8V//qI/g64YyyoLLJmQdeB8D+iEIYYDUOo98IidzsUvIYE1gmypKc5+UpOnke2mRUDakPl/XmwbNsygPwHAfROoyKNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJxxyITo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJxxyITo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF987C4CEF1;
	Tue, 26 Aug 2025 13:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214464;
	bh=LFp2b1NsVGXHJgrjeaQuPgGEvOxGYWqQzJtJanCgFuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oJxxyIToctUtQj6/iEp4dEVsrVIvok7SBg3lzq7HkzrzCb9p2ytuKMt0gMaH0AZcw
	 wWXe/PqUtNkHHBDbavJNVDMNWZeooP+ag/oSACemYeg7YsdIZDxjYb5DC3wkt9lnmQ
	 rrHIetxRJU63LqxfkjlofRe9q+YGR7ysfaMpbpm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 146/482] wifi: iwlwifi: fw: Fix possible memory leak in iwl_fw_dbg_collect
Date: Tue, 26 Aug 2025 13:06:39 +0200
Message-ID: <20250826110934.425287825@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4c5dbd8248e7..20db79f34163 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2786,6 +2786,7 @@ int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
 	struct iwl_fw_dump_desc *desc;
 	unsigned int delay = 0;
 	bool monitor_only = false;
+	int ret;
 
 	if (trigger) {
 		u16 occurrences = le16_to_cpu(trigger->occurrences) - 1;
@@ -2816,7 +2817,11 @@ int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
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



