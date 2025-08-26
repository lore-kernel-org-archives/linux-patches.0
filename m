Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF2335E4CE;
	Tue, 26 Aug 2025 14:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219334; cv=none; b=d+H3U0UrlAEOn54eVAJcPt3px6xuS5ng9CmoozEuZ47A86v+UCjyLc1xFipJA4NOZcH4v5M7JbFJ7Xsxmd0kIxMC4neko8rU9Dn591BTybD//QIOjQ445f2CedutcVMzA4URuHQ6eKuVWZDlrLxtBp4yeBElp65sKOKjgnGJXyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219334; c=relaxed/simple;
	bh=t/H+P/jlFO6/1yK+LmmXQYDB4K9ipTVvyV9XEt/0I0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bi9+Nb6XD754UXEmcq0Kz0MBUcwplFcFbRHvtn6Lq1jIApCWRZi3Qx4uMbTeN448xjcJMb8PiYPXSOQrLHN0KWkgYtG4ecH4EIBtxvxYof6KM3Pox/f48rp7hrtzIUT8ALBtoNA9/lLjdNHMaWL6uIzChLrnrty98uae2GG29JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DzEyd103; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DzEyd103"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9D8C4CEF1;
	Tue, 26 Aug 2025 14:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219333;
	bh=t/H+P/jlFO6/1yK+LmmXQYDB4K9ipTVvyV9XEt/0I0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DzEyd1030d59Do1pLlQ3ocwayLID66jLb9N+NeyeAZ7JsuoSfsLAS5z+TQUPo2Z3O
	 11H9sShhOEjhnmgjn1JT6wcmCcL2B8rnyLuOLNXN6G+gOidUZebSeCmnBnIuESsbDr
	 Fmvp4kUtWW90u4GMMvvPUcWhPZw+n4v4DgrPtMf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 341/403] x86/mce/amd: Add default names for MCA banks and blocks
Date: Tue, 26 Aug 2025 13:11:07 +0200
Message-ID: <20250826110916.278570524@linuxfoundation.org>
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

From: Yazen Ghannam <yazen.ghannam@amd.com>

[ Upstream commit d66e1e90b16055d2f0ee76e5384e3f119c3c2773 ]

Ensure that sysfs init doesn't fail for new/unrecognized bank types or if
a bank has additional blocks available.

Most MCA banks have a single thresholding block, so the block takes the same
name as the bank.

Unified Memory Controllers (UMCs) are a special case where there are two
blocks and each has a unique name.

However, the microarchitecture allows for five blocks. Any new MCA bank types
with more than one block will be missing names for the extra blocks. The MCE
sysfs will fail to initialize in this case.

Fixes: 87a6d4091bd7 ("x86/mce/AMD: Update sysfs bank names for SMCA systems")
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/20250624-wip-mca-updates-v4-3-236dd74f645f@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/amd.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -1180,13 +1180,20 @@ static const char *get_name(unsigned int
 	}
 
 	bank_type = smca_get_bank_type(bank);
-	if (bank_type >= N_SMCA_BANK_TYPES)
-		return NULL;
 
 	if (b && bank_type == SMCA_UMC) {
 		if (b->block < ARRAY_SIZE(smca_umc_block_names))
 			return smca_umc_block_names[b->block];
-		return NULL;
+	}
+
+	if (b && b->block) {
+		snprintf(buf_mcatype, MAX_MCATYPE_NAME_LEN, "th_block_%u", b->block);
+		return buf_mcatype;
+	}
+
+	if (bank_type >= N_SMCA_BANK_TYPES) {
+		snprintf(buf_mcatype, MAX_MCATYPE_NAME_LEN, "th_bank_%u", bank);
+		return buf_mcatype;
 	}
 
 	if (smca_banks[bank].hwid->count == 1)


