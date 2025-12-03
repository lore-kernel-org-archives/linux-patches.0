Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604DD306D3D;
	Wed,  3 Dec 2025 15:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776186; cv=none; b=Qo4zUku2Z22Ktkr8+1cRLhj8vWXTBc034ekAle99cOvLgYHHGUVUrCiGdWRKkbeExa3lLiOSqSvhhAkzMkBeGV24EnmeBQH5iwqfxmDKD/9yUioV1iizMLdOWX+yea0qAKybImGSH3WAout+/bBRHEA3dOViU3K2CLX0+W3yMZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776186; c=relaxed/simple;
	bh=+TmqS4yQsEcRMvZrf86ooHWy631Roft9HRVfjb++FxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a13/l78a1d7eIy9u6sgEKXJekVsVxum0SSs7SghfC2zKS9fVMo4nlUqOReC3QF4NbenKKfBclCe9lss7DrZUEg392Jin7BQWcYpWWUf0d0aYrvShRobR2bjlqFUGEXqbYbgOBengFSkNnGiw8WPtV8d7SfmXG4JJtRlfTm+dyFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BO15ppkL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BO15ppkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BCCC4CEF5;
	Wed,  3 Dec 2025 15:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776186;
	bh=+TmqS4yQsEcRMvZrf86ooHWy631Roft9HRVfjb++FxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BO15ppkLe1ZPT21nVzkhNz69Sn6jV2lemdOpTY5XNQ5fXSEUVOxWMyvbquJOgQIba
	 CN3Qya+WePE5VVSqcQIUICBpw0cA2+UZEwDF7snReS7cmbQk/xb2GOmrPPEy50xQSc
	 LhIuj5D3tffB1NiCsKOl3otT0gNM71EOgowa1+pU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Sairaj Kodilkar <sarunkod@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/300] iommu/amd: Skip enabling command/event buffers for kdump
Date: Wed,  3 Dec 2025 16:25:11 +0100
Message-ID: <20251203152404.587364809@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashish Kalra <ashish.kalra@amd.com>

[ Upstream commit 9be15fbfc6c5c89c22cf6e209f66ea43ee0e58bb ]

After a panic if SNP is enabled in the previous kernel then the kdump
kernel boots with IOMMU SNP enforcement still enabled.

IOMMU command buffers and event buffer registers remain locked and
exclusive to the previous kernel. Attempts to enable command and event
buffers in the kdump kernel will fail, as hardware ignores writes to
the locked MMIO registers as per AMD IOMMU spec Section 2.12.2.1.

Skip enabling command buffers and event buffers for kdump boot as they
are already enabled in the previous kernel.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Link: https://lore.kernel.org/r/576445eb4f168b467b0fc789079b650ca7c5b037.1756157913.git.ashish.kalra@amd.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 1ba6adb5b9124..8ac0ac915efd3 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -697,11 +697,16 @@ static void iommu_enable_command_buffer(struct amd_iommu *iommu)
 
 	BUG_ON(iommu->cmd_buf == NULL);
 
-	entry = iommu_virt_to_phys(iommu->cmd_buf);
-	entry |= MMIO_CMD_SIZE_512;
-
-	memcpy_toio(iommu->mmio_base + MMIO_CMD_BUF_OFFSET,
-		    &entry, sizeof(entry));
+	if (!is_kdump_kernel()) {
+		/*
+		 * Command buffer is re-used for kdump kernel and setting
+		 * of MMIO register is not required.
+		 */
+		entry = iommu_virt_to_phys(iommu->cmd_buf);
+		entry |= MMIO_CMD_SIZE_512;
+		memcpy_toio(iommu->mmio_base + MMIO_CMD_BUF_OFFSET,
+			    &entry, sizeof(entry));
+	}
 
 	amd_iommu_reset_cmd_buffer(iommu);
 }
@@ -750,10 +755,15 @@ static void iommu_enable_event_buffer(struct amd_iommu *iommu)
 
 	BUG_ON(iommu->evt_buf == NULL);
 
-	entry = iommu_virt_to_phys(iommu->evt_buf) | EVT_LEN_MASK;
-
-	memcpy_toio(iommu->mmio_base + MMIO_EVT_BUF_OFFSET,
-		    &entry, sizeof(entry));
+	if (!is_kdump_kernel()) {
+		/*
+		 * Event buffer is re-used for kdump kernel and setting
+		 * of MMIO register is not required.
+		 */
+		entry = iommu_virt_to_phys(iommu->evt_buf) | EVT_LEN_MASK;
+		memcpy_toio(iommu->mmio_base + MMIO_EVT_BUF_OFFSET,
+			    &entry, sizeof(entry));
+	}
 
 	/* set head and tail to zero manually */
 	writel(0x00, iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);
-- 
2.51.0



