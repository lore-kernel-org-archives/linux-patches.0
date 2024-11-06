Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF551DE4EA;
	Wed,  6 Nov 2024 12:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896086; cv=none; b=BxSonCA+fb47xcUl8lqJWHDfSa3gZUypbHbbFNYBnlppMoqyvwfsYgoU7xsTs2toqqcTq40unF1BPVFtiN7CFbLXEIRaIth9vhC92+MsZhKW+nEGLSon4cAAtoMMG1+/n58fVfoBSCylVbq1q5bBkKY5fU3r5ECYqA0Qi/SEtXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896086; c=relaxed/simple;
	bh=aaRRHUaCIns7h7Kihf4fNwcC+0PTMnxhmuTsObfJmbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTzl8FEylARQWX4JTqXprLxrsJXmnXzA8V0Lz1uQUHNMPyczxWdbABiQxxFjCe/KxQPO26m58M9l33WRXou1jITzyF/vXfFh7GRc4NlojdTbpHZey01gIas0RavHMbNuyuQwcPGQpJoqRb8xT61Fs1/nxZL1jhdcEXohk9jVbi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWW5Wux3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWW5Wux3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16D1C4CED3;
	Wed,  6 Nov 2024 12:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896086;
	bh=aaRRHUaCIns7h7Kihf4fNwcC+0PTMnxhmuTsObfJmbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pWW5Wux3lt+tHbqTlEmt516Y5YWkse5RcCXQec2IWm2/RlD2TZzs4Bx6Mk22+EDgm
	 a/q6cTRElc2tm2VEAymoKYqOaoSL5C8oEJ1ZaABMcppi4O0pl2ucifdxjkhygZWtLg
	 LwM2RpQLVCh+zFqCg31WjV4KQu4JKSiUfRPrt0to=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wei <dw@davidwei.uk>,
	Christoph Hellwig <hch@lst.de>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 078/245] nvme: module parameter to disable pi with offsets
Date: Wed,  6 Nov 2024 13:02:11 +0100
Message-ID: <20241106120321.126249125@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 42ab37eaad17aee458489c553a367621ee04e0bc ]

A recent commit enables integrity checks for formats the previous kernel
versions registered with the "nop" integrity profile. This means
namespaces using that format become unreadable when upgrading the kernel
past that commit.

Introduce a module parameter to restore the "nop" integrity profile so
that storage can be readable once again. This could be a boot device, so
the setting needs to happen at module load time.

Fixes: 921e81db524d17 ("nvme: allow integrity when PI is not in first bytes")
Reported-by: David Wei <dw@davidwei.uk>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index a6fb1359a7e14..89ad4217f8606 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -90,6 +90,17 @@ module_param(apst_secondary_latency_tol_us, ulong, 0644);
 MODULE_PARM_DESC(apst_secondary_latency_tol_us,
 	"secondary APST latency tolerance in us");
 
+/*
+ * Older kernels didn't enable protection information if it was at an offset.
+ * Newer kernels do, so it breaks reads on the upgrade if such formats were
+ * used in prior kernels since the metadata written did not contain a valid
+ * checksum.
+ */
+static bool disable_pi_offsets = false;
+module_param(disable_pi_offsets, bool, 0444);
+MODULE_PARM_DESC(disable_pi_offsets,
+	"disable protection information if it has an offset");
+
 /*
  * nvme_wq - hosts nvme related works that are not reset or delete
  * nvme_reset_wq - hosts nvme reset works
@@ -1921,8 +1932,12 @@ static void nvme_configure_metadata(struct nvme_ctrl *ctrl,
 
 	if (head->pi_size && head->ms >= head->pi_size)
 		head->pi_type = id->dps & NVME_NS_DPS_PI_MASK;
-	if (!(id->dps & NVME_NS_DPS_PI_FIRST))
-		info->pi_offset = head->ms - head->pi_size;
+	if (!(id->dps & NVME_NS_DPS_PI_FIRST)) {
+		if (disable_pi_offsets)
+			head->pi_type = 0;
+		else
+			info->pi_offset = head->ms - head->pi_size;
+	}
 
 	if (ctrl->ops->flags & NVME_F_FABRICS) {
 		/*
-- 
2.43.0



