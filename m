Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604F651DE18;
	Wed, 30 Sep 2026 16:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784780; cv=none; b=t6X4DevEKdptrhm1WbDiEU4PHMAU81Ouc4f3j0U9YYrt+dDmWUgnNqpGWmr9BkXyiqP1O+zFsf9C70E5ny/JoGe/1L+pKXf34f+gtKfgNyHoCQSanGlLViXPuv2FY65JS6dSNS+OrB6KsTCwmL8u5f5rM9nNiMxlbkRXrcGy3Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784780; c=relaxed/simple;
	bh=zA02Dk8VBinvdxW+XspoZcMVlCiWjnp0RUJM4ZBVibg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUvAz54yAihWPHVsMu8bW0w/4yLV5pP4dzYc24XWOwaKNZCSewDGgiChWF2qGncyYHYer4/82FmlfnY0Rk15YF+o1PL+xtQA++houHpmz/+qxG4s1EC1mb0K1Lc56TXImfNg3yDnK3GQn+JiT4OFW+LgQ0BPEFBTq9loFgX2QpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IjxOw66N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IjxOw66N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675AD1F00898;
	Wed, 30 Sep 2026 16:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784773;
	bh=HGF9wclvhiFsZNahvHi0MZ/ke65zkdcYVYYRnvE9q5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IjxOw66NDwem+WHbvgUBcz9qaepTQJ3WLM8cRAAnbYJlAURlnj3MdVYhGfQVB1sSs
	 VSCtD00QiVdT5YYJphuQs4QSReDiid3cT7Y9+yglSLIJ86fTRS3B1YzLkFmMfN72Ym
	 Yga0k70WhlTOKLJe6lU8P88yxXwNOKBOhoBGk2u0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 274/982] wifi: iwlwifi: acpi: validate WGDS table revision index
Date: Wed, 30 Sep 2026 17:16:50 +0200
Message-ID: <20260930152422.686279282@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 84980f6a0d603..99f6e5138c01e 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -815,6 +815,11 @@ int iwl_sar_get_wgds_table(struct iwl_fw_runtime *fwrt)
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



