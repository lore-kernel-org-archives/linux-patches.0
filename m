Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DF0309DC0;
	Sat, 25 Oct 2025 16:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409146; cv=none; b=YKw6AqmVc1rpapDm+mQHceP1OULdwEjU+Q6VQvVLGrMpriEmjCUDsS50r7hP+uEmLEsFtAhqf6uQF+Gaei6gkCILyflSPiUtQpV3/cLRMLblmeCPalhlHubQKhEbPHnnHbBN+eOrRI9OTIjo8kZPuDPyINlrEyMKTr9qQ/o0wy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409146; c=relaxed/simple;
	bh=cz8b1t42iBNufAebYvA72Jtw3O9wtHDlLCui6XlV7G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WU71jecn6KMgrfQpjYW9lmlBWSMLberP/h9SL8LgZmMLKVUW0egnScVFhv0qlSSSjN68UWP9NIyZHFRcAnZRKiK/RP0Rv/UgCTdxdPs4Mszg4no5fG6jqXjj82xY3tbXODZAqCYlPV8u0xoQyFq7wofbQNCdlkSMpl/BlnsVB2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oYd8GyLq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oYd8GyLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D852C4CEF5;
	Sat, 25 Oct 2025 16:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409146;
	bh=cz8b1t42iBNufAebYvA72Jtw3O9wtHDlLCui6XlV7G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYd8GyLqcGzRRLp7TIPgg2vW1v8fMlunsQX8UoJfjgMjZewqHJmwj4qXxV8NVc0aB
	 ck8Xzywoe3unQ2NB/F9CzDK+GltB/hqsLhXb10GT5VUYhRleRBPJnKJQ/jZIMotHWF
	 IgXNmeF/JFA6c6KtmQQZ6WCBsMemfXtdUDIjfivz+TWg2HqcPOtvYBoLJ3eJfFdK6R
	 y7JWrWif9AR+cM2IqCNd6dU6P+n0R0gjaWJEWBlIqh22XFkqhA5HAcwx0B0VzoU0FW
	 zmpEJsWwyfsvNSYetW0C6HhKJnQChK1LZqxzjGhNCaV8gWlh12waQRKsJZQ++qKcf1
	 +ZqJp/GGfzTpw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ashish Kalra <ashish.kalra@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Sairaj Kodilkar <sarunkod@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	joro@8bytes.org,
	iommu@lists.linux.dev
Subject: [PATCH AUTOSEL 6.17-5.10] iommu/amd: Skip enabling command/event buffers for kdump
Date: Sat, 25 Oct 2025 11:57:27 -0400
Message-ID: <20251025160905.3857885-216-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Kdump boot after a panic with AMD SNP: IOMMU command/event buffer
    base registers remain locked to the previous kernel, so programming
    them in the crash kernel is ignored (per AMD IOMMU spec 2.12.2.1).
    This prevents enabling command/event buffers and breaks IOMMU
    operation in the crash kernel.

- Key changes
  - Skips writing command buffer base in kdump:
    `drivers/iommu/amd/init.c:824-833`. The write to
    `MMIO_CMD_BUF_OFFSET` is now gated by `if (!is_kdump_kernel())`,
    while still resetting and enabling the ring via
    `amd_iommu_reset_cmd_buffer()` (`drivers/iommu/amd/init.c:835`).
  - Skips writing event buffer base in kdump:
    `drivers/iommu/amd/init.c:884-892`. Similarly, the write to
    `MMIO_EVT_BUF_OFFSET` is skipped in kdump; head/tail registers are
    cleared and logging enabled (`drivers/iommu/amd/init.c:894-899`).

- Why it’s correct and low risk
  - The driver already reuses/remaps the previous kernel’s buffers in
    kdump:
    - Event buffer remap from existing MMIO base:
      `drivers/iommu/amd/init.c:987-996`.
    - Command buffer remap from existing MMIO base:
      `drivers/iommu/amd/init.c:998-1006`.
    - Kdump buffer provisioning path:
      `drivers/iommu/amd/init.c:1039-1050`.
  - With those remaps, `iommu->cmd_buf` and `iommu->evt_buf` point to
    the same memory the hardware is locked to, so skipping the base
    register writes is necessary and safe; the driver still resets
    head/tail and enables the features so operation resumes as expected.
  - This matches existing kdump policy to avoid touching locked
    registers, e.g. device table programming is skipped in kdump:
    `drivers/iommu/amd/init.c:409`.
  - Scope is small, localized to AMD IOMMU init paths, and guarded by
    `is_kdump_kernel()`, so normal boots are unaffected.

- User impact and stability criteria
  - Fixes a real reliability bug in crash dump scenarios on SNP-enabled
    systems; improves kdump robustness without adding features or
    architectural changes.
  - Changes are minimal and well-contained; only affect the kdump path.
  - No ABI or interface changes; limited to initialization register
    programming avoidance in kdump.

- Dependencies/considerations for backport
  - Ensure the kdump remap paths for command/event/CWB buffers are
    present so that `iommu->cmd_buf` and `iommu->evt_buf` reference the
    pre-existing hardware buffer addresses (see
    `drivers/iommu/amd/init.c:987-996`, `998-1006`, `1039-1050`). This
    commit relies on those existing mechanisms; backport alongside those
    if they’re not already in the target stable tree.

Given the above, this is a good stable backport candidate: important
bugfix, minimal risk, and confined to the kdump path for AMD IOMMU.

 drivers/iommu/amd/init.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 309951e57f301..d0cd40ee0dec6 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -815,11 +815,16 @@ static void iommu_enable_command_buffer(struct amd_iommu *iommu)
 
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
@@ -870,10 +875,15 @@ static void iommu_enable_event_buffer(struct amd_iommu *iommu)
 
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

