Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF981225413;
	Mon, 18 Aug 2025 14:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525641; cv=none; b=MB48uhW6iw0uy9yrJKC5qlUq95nof4gvqkOdJAI+x2OxaJOluCrFRKxZBal/z7lmpk0L+xhiB2vYUlqmPxbdyVBbLcZO+3IU3c6tUoMmhcsgg4fXYVRJ63NJ3Mg278j56hkxsH5dN4TrDkzgGvg3OkxxoEtECovHhA3LGaVUi+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525641; c=relaxed/simple;
	bh=yjiQmoJuv6gG4YDUnxLyWj7sEZbvusKoDr49Zu2Tb8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXlFuxZVQrkT6vz0TTdgpfe2ORkkQPP51Xl+aQzUXeiaG35ryCIY0R3vYkhhMOSOG3Ra/+3lrOmMOWKndLHmChJOhcfm31dUHAA1mAkOXTkm12f6MOmI7xa6O1siyT8O9fbgTDs5Ko2OvMPFkrCXRy9Gg0D06E7luwWiaW9Cna0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r8nffxhM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r8nffxhM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2428C4CEEB;
	Mon, 18 Aug 2025 14:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525641;
	bh=yjiQmoJuv6gG4YDUnxLyWj7sEZbvusKoDr49Zu2Tb8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r8nffxhMa/4fRXXGgoCbMIqIjbrX+z6D22Yad4CP0+994mQZn6CyHb/RRgAXXtsty
	 mDE+Ikcpnn3O9WZD8jCLz6NEPEE3JLckXIvduvEHpxWwZ6KgNvzyJp3k2e5miKMvSR
	 6eCS2znCdqRJ8sdJiN7GNyZad7868YiCjx0UNqg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 306/570] wifi: iwlwifi: fw: Fix possible memory leak in iwl_fw_dbg_collect
Date: Mon, 18 Aug 2025 14:44:53 +0200
Message-ID: <20250818124517.664577835@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index ea739ebe7cb0..95a732efce45 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -3008,6 +3008,7 @@ int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
 	struct iwl_fw_dump_desc *desc;
 	unsigned int delay = 0;
 	bool monitor_only = false;
+	int ret;
 
 	if (trigger) {
 		u16 occurrences = le16_to_cpu(trigger->occurrences) - 1;
@@ -3038,7 +3039,11 @@ int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
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



