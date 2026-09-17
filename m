Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DB04FDA76;
	Thu, 17 Sep 2026 17:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664934; cv=none; b=KUZ03Vgh0n7h43V3RGLC5wCe84wjoNCR1lZYn4MPOzSkizUAoFFbl2U0ZYxxudhsw9JPDJPZsQL298/PaBxSRXiPESuO/L1QWLVZC3RH6kOBvPwfswkGKGORla+v3s3iwOwQ8ZbPHOjP2BfAT55DxSYwp4m2bOtvRdcbX1iLOsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664934; c=relaxed/simple;
	bh=K9x3HwhvFTAsPYJ38YKDCFfiwxVupSQgCS2EJSr5LRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OvdI8rciEDQ2b8MqD2xYux1pfcx8juH64YDir0XEi76YWqOWtwaxdjjsIg9e2sxUeDReChMvn3kcJYb9pUCwatPly/5Ek8Qh64p8UFqim3dWrv4HL9Sp7+GPMxSN9rZ+BP+B1T8lfkMMFjBSkjPpVsmPhAxw6iWDZyi7mgOZi9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0UwILGUS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0UwILGUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6441F000FF;
	Thu, 17 Sep 2026 17:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664933;
	bh=1UcGZHis3kYhpBpAE2Duc2UMcO4SRZL9Xz/UBgPTGRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0UwILGUSwx5Dve75XG7Q0qZ0armSYjwNLORrYZnXrRp+IRuB5K+rbgnrXTGw0pS53
	 D8p4t5/dpwwJDnCzLOnG+dSuxlBD+Kbfbu1RFyJyE7jc0SLZai+GU2lf+Y6YLfCqrn
	 GJeGmuFupXwFAe1Bv4oehHgvsr2c+jnBOzHFUMSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0537/1250] wifi: iwlwifi: acpi: validate WGDS table revision index
Date: Thu, 17 Sep 2026 16:05:32 +0100
Message-ID: <20260917151606.491928314@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 52edc19d8cdd5..852c5ac36c221 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -761,6 +761,11 @@ int iwl_acpi_get_wgds_table(struct iwl_fw_runtime *fwrt)
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



