Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F218E32AAB5;
	Fri,  9 Jan 2026 11:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959079; cv=none; b=hCV0cmyEHR3Q6MnUcDfIXiRz/ssSoaij2BlnKetiJLKFyPZLf1zlL/7h7Tv56m6KFVlCc4wqFXWyvR3VLSnKjRbmXauzUifQcN+gIyBD+mCcKvBQas9yfMwLDk+6UULZOJu9eWetwcQM+arDW9kFGadQYg/rqk5Mn3Gs0dSakms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959079; c=relaxed/simple;
	bh=N1G52x+4xittAMqEFoDVCiv9h+KpwgGiDKmRNwSscM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwAFANMrd57GsVNSEP423ImShRzDIS68hE7A9tL7B2wgCXxtMZGo7vCrxp1JO373qGSkUU+jFEzWcYWMxW/uJbIlFbQO9lwfMA//NduI3ywp1OWJg06cHQjXdzQ9nrJSPq8C/7s2ux2O503ncykmFmlxBy80Xhyqy+6MY90dhV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KGsqu2ks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KGsqu2ks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457A4C4CEF1;
	Fri,  9 Jan 2026 11:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959078;
	bh=N1G52x+4xittAMqEFoDVCiv9h+KpwgGiDKmRNwSscM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KGsqu2ksH5Lit2VCIEAj5UFAGFguJgb7aOS8KUha1H65eS+RKAwV7nf+KCeS0VD9/
	 Yinlmgki88FpwoAh6HXNRBWFFklsmPnv4qPxzVKMdziFj/W4UQS8cEsGkbJKk4OR8i
	 p+uJ49PkNlMJTufY1dFPDvh/VNibebmu+A+jvjqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashish Kalra <ashish.kalra@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Sairaj Kodilkar <sarunkod@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 16/16] Revert "iommu/amd: Skip enabling command/event buffers for kdump"
Date: Fri,  9 Jan 2026 12:43:57 +0100
Message-ID: <20260109111952.032873905@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109111951.415522519@linuxfoundation.org>
References: <20260109111951.415522519@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 3344716ddee01d7caa35b470d30fd87781c661b1 which is
commit 9be15fbfc6c5c89c22cf6e209f66ea43ee0e58bb upstream.

This causes problems in older kernel trees as SNP host kdump is not
supported in them, so drop it from the stable branches.

Reported-by: Ashish Kalra <ashish.kalra@amd.com>
Link: https://lore.kernel.org/r/dacdff7f-0606-4ed5-b056-2de564404d51@amd.com
Cc: Vasant Hegde <vasant.hegde@amd.com>
Cc: Sairaj Kodilkar <sarunkod@amd.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/init.c |   28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -816,16 +816,11 @@ static void iommu_enable_command_buffer(
 
 	BUG_ON(iommu->cmd_buf == NULL);
 
-	if (!is_kdump_kernel()) {
-		/*
-		 * Command buffer is re-used for kdump kernel and setting
-		 * of MMIO register is not required.
-		 */
-		entry = iommu_virt_to_phys(iommu->cmd_buf);
-		entry |= MMIO_CMD_SIZE_512;
-		memcpy_toio(iommu->mmio_base + MMIO_CMD_BUF_OFFSET,
-			    &entry, sizeof(entry));
-	}
+	entry = iommu_virt_to_phys(iommu->cmd_buf);
+	entry |= MMIO_CMD_SIZE_512;
+
+	memcpy_toio(iommu->mmio_base + MMIO_CMD_BUF_OFFSET,
+		    &entry, sizeof(entry));
 
 	amd_iommu_reset_cmd_buffer(iommu);
 }
@@ -874,15 +869,10 @@ static void iommu_enable_event_buffer(st
 
 	BUG_ON(iommu->evt_buf == NULL);
 
-	if (!is_kdump_kernel()) {
-		/*
-		 * Event buffer is re-used for kdump kernel and setting
-		 * of MMIO register is not required.
-		 */
-		entry = iommu_virt_to_phys(iommu->evt_buf) | EVT_LEN_MASK;
-		memcpy_toio(iommu->mmio_base + MMIO_EVT_BUF_OFFSET,
-			    &entry, sizeof(entry));
-	}
+	entry = iommu_virt_to_phys(iommu->evt_buf) | EVT_LEN_MASK;
+
+	memcpy_toio(iommu->mmio_base + MMIO_EVT_BUF_OFFSET,
+		    &entry, sizeof(entry));
 
 	/* set head and tail to zero manually */
 	writel(0x00, iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);


