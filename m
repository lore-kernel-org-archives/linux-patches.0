Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4694F392C;
	Thu, 17 Sep 2026 18:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668465; cv=none; b=qcNdRcCSg1aS+CON5figNN/DlDrn84yOaXSQUh+7B8rk3USEItaIHutWBGLq4VE+nstCviVNj6pgds9L+I/t3BZk30Zz4sGPh55DtJrwr/eIQ7hCYNbLbjmMBZ+OZqh/zspH8pN6q91wJ7brjCjtNnAJa+7YMzdHtXK2XHCRx/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668465; c=relaxed/simple;
	bh=12WkGId+l14rqlVaRLLmImYT97DoEf5hJCkVPencYRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDohKg/i5V+KPYYts56DJFoizA7o6OW1hcvIMGlb8I/Qrb1B0cHX2G/kx8qHPSHap+95GlJV8MjZprxCpZPk6RU+BB4cazFV4OXuyv0r3MAEOIg4zwrFjj5ZF/exRtPGMC9XQJkgF7NY7qvBbeaZ3puvqUxMMUbiuQ2WLmGnuFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dhtTNaET; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dhtTNaET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51421F000FF;
	Thu, 17 Sep 2026 18:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668464;
	bh=qPGV/SIyOroo4rbZGQkvnsV2+UNXvUxfA7UiUdtUSsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dhtTNaET6PGdcgBO2GSPtZaJZKwkk+nE8XU7ZFwgXEHRErrEwLO1QzI4P/Bughl+L
	 2W06IE3LgSdpdaB29JS63dHYvrUdtGdmBnnJZRwru2dhFAipcIxBCl5ki7UDzHm6rU
	 OvFVIa761mlJy9434xG63lbFYB61e543HZivf6xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0434/1102] wifi: iwlwifi: acpi: validate WGDS table revision index
Date: Thu, 17 Sep 2026 16:06:17 +0100
Message-ID: <20260917151550.570255534@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a26c5573d2091..380f33e1db953 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -740,6 +740,11 @@ int iwl_acpi_get_wgds_table(struct iwl_fw_runtime *fwrt)
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



