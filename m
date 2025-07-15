Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4B92E719B;
	Tue, 15 Jul 2025 13:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585857; cv=none; b=Th1YP/gVIUQbk32iHRpPO2wf06RWaPdNsqTmJQdq+QGi/HTU4/xcFka85SPQu/kijQNSuSjhZPvHjLOL+LRcDWzz4Qdm88aRGmYv51X2945ZFokNc8s0kX2VUTbcGpltvXuClHDVvA5Ssjp1YCpOE+PD4gtQ3aiEIBES+LI2Hz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585857; c=relaxed/simple;
	bh=w/VZsHOY3ANV6VmvxTyncQ6W7jkBP6i4c3UYXU5oUrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzrguPkJ56q7XmT5nAcH+l1d9iX1u9tNkU9Q+Zh1oDZ485ENe94sDM+0V+2Soog/ZFhKRXuWgFkJs8aQHlztEUUUpMMZFo6HIr2vHoPQeG4dkSMyzFcWVftQ6nxk6PfG5aVybQmUNzpN59jseGOy5j7Jt8Qi01kqVo+1EZlnOpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BE4CmWHY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BE4CmWHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E24DC4CEF1;
	Tue, 15 Jul 2025 13:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585857;
	bh=w/VZsHOY3ANV6VmvxTyncQ6W7jkBP6i4c3UYXU5oUrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BE4CmWHYvj/UPKhYlktMQO4t8y/M9Otlo82167Mz0KB8qqwghHYz8Z812/QvCRE7e
	 9uxpefniQ5E78B0bOHur3di1gAufIczjel2xpQbVFz+2rzVuhTKtCJp9BiAyRMTpBk
	 pHuNWiSvLAezxbFti1YOLpjBmgBew6ZD/3NeqP6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 033/109] x86/mce/amd: Add default names for MCA banks and blocks
Date: Tue, 15 Jul 2025 15:12:49 +0200
Message-ID: <20250715130800.210903685@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yazen Ghannam <yazen.ghannam@amd.com>

commit d66e1e90b16055d2f0ee76e5384e3f119c3c2773 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/amd.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -1049,13 +1049,20 @@ static const char *get_name(unsigned int
 	}
 
 	bank_type = smca_get_bank_type(cpu, bank);
-	if (bank_type >= N_SMCA_BANK_TYPES)
-		return NULL;
 
 	if (b && (bank_type == SMCA_UMC || bank_type == SMCA_UMC_V2)) {
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
 
 	if (per_cpu(smca_bank_counts, cpu)[bank_type] == 1)


