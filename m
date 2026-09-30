Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2526E30566A;
	Wed, 30 Sep 2026 18:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794755; cv=none; b=TQHBVpWzP82BF/6MYPSwJY3DIBsIWq5rRyHZEqmjtnE1/fjkSeTyRPYfTl4+bf9rJ7V8E4D5GtD63eTIfIZf6n21ZekTaKf04bVhJL705b+5KcFdFWCPIeCkiZDIX6ydL28LXSD2hH36qtr7s3hR2K9WF7jxIJVgQNmOTODr4Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794755; c=relaxed/simple;
	bh=IryMveq2Xki9VKE+lu5LefAmCn4ZfYji9ScZd6CxDoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wj/9EsFQ1yGPgXrf4rYm+qjOEE8tJApd2aeRsBy05gRiwsHBZSnJq5grWO6uIC6GLlQA4n/Z3+N0GgiSa7RJdyqdbB5CyGNrI274hbqtV+OTwbZ67sk1b231y+elzRiU3yhcF0/ojdVd1KBPJeDf0ETmfFmxJUJQBv0Sqtm+Uzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mVWOF/zX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mVWOF/zX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501341F000FF;
	Wed, 30 Sep 2026 18:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794753;
	bh=wGvRaBnwQejpWp5UGkgPOtMgkFIMmP32NWK4CimmkU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mVWOF/zXkbyu4RAKykj+/Bp1MfZZdPNd0x7bnI04rVc1E7vSI7cmn9M2HWeh/Il2A
	 RClaG47ulb+Qj0CvB07ot8TacMK0KeChsuQlwpRYb3Vbm/CqDp5P0a4aslUd0KTA+4
	 qqQGVWzFImdgOBdW+0Gnwh1N7Lf82M8WBRaLcVWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0320/1193] wifi: iwlwifi: acpi: validate WGDS table revision index
Date: Wed, 30 Sep 2026 17:16:44 +0200
Message-ID: <20260930152441.247393108@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 954e821f42aaca56073ca830c5fd4bcf1a89048c ]

Check tbl_rev bounds before BIT(tbl_rev) to avoid undefined shifts when
firmware reports an invalid revision value.

Assisted-by: GitHubCopilot:GPT-5.3-Codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260717173215.52a01f841f2a.Ic0131eaac31d9ff71b169138d9b0865cb39b44a9@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index e72f238ff7b23..68ae4414844e9 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -857,6 +857,11 @@ int iwl_sar_get_wgds_table(struct iwl_fw_runtime *fwrt)
 						       min_size, max_size,
 						       &tbl_rev);
 		if (!IS_ERR(wifi_pkg)) {
+			if (tbl_rev < 0 ||
+			    tbl_rev >= BITS_PER_BYTE *
+			    sizeof(rev_data[idx].revisions))
+				continue;
+
 			if (!(BIT(tbl_rev) & rev_data[idx].revisions))
 				continue;
 
-- 
2.53.0



