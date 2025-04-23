Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1398818DB17;
	Wed, 23 Apr 2025 14:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419932; cv=none; b=i942foPwkm6i/tJvynK0aLX0s18vLGo09pPqj84hyedN+7LLaiI6W4PRIQFAJp3k7VAtaLfp79msnQko93r4yz/ZSLDkHUimWx9yS/gauyP4qfugyKVEVaQNp2BrFQ8zK1taTTJKPvk7iMRI5SIf+3M9oB21/hDAgeVzvqCmtG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419932; c=relaxed/simple;
	bh=gSt79VuvKpu3tH7hcCV9tw77ardnRb2vAqxIhDkdH/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLmxMmC0Ix6JAf6xA+4pMCHnOpS3E9lwXCkWQv+2Z1Uz8oJ+0Pd+bokD5yTpmSLFhDPlmX39iE4EZ5+yQqwx2ojmqIdPfNur6+bwgxLWe1ZTPI6TDsR+kFsURLcXQeWvkYJMV6DDkT/xPWAB8kqaWxkVjAbKsMWJddEP5H9umjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4ztDeUB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4ztDeUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9883DC4CEE2;
	Wed, 23 Apr 2025 14:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419931;
	bh=gSt79VuvKpu3tH7hcCV9tw77ardnRb2vAqxIhDkdH/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4ztDeUBhXblcEMq9ldZzdYjgiOfxhnMmdP9xhmtQOU1+YYh3WK6TvmXwuwWdXHe2
	 91ziGCpYsQQJAaqEup3Kn5Z1+BxhuhuhgQsV9joBo+ZLdpDk6OjW1f0ACcsENLQ0sw
	 nACrbSKEKZsEm93kCW8B9C9A/j+wpQoaShvfUonY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 044/241] pds_core: fix memory leak in pdsc_debugfs_add_qcq()
Date: Wed, 23 Apr 2025 16:41:48 +0200
Message-ID: <20250423142622.307871993@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <abdun.nihaal@gmail.com>

[ Upstream commit 8b82f656826c741d032490b089a5638c33f2c91d ]

The memory allocated for intr_ctrl_regset, which is passed to
debugfs_create_regset32() may not be cleaned up when the driver is
removed. Fix that by using device managed allocation for it.

Fixes: 45d76f492938 ("pds_core: set up device and adminq")
Signed-off-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Link: https://patch.msgid.link/20250409054450.48606-1-abdun.nihaal@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/debugfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/debugfs.c b/drivers/net/ethernet/amd/pds_core/debugfs.c
index ac37a4e738ae7..04c5e3abd8d70 100644
--- a/drivers/net/ethernet/amd/pds_core/debugfs.c
+++ b/drivers/net/ethernet/amd/pds_core/debugfs.c
@@ -154,8 +154,9 @@ void pdsc_debugfs_add_qcq(struct pdsc *pdsc, struct pdsc_qcq *qcq)
 		debugfs_create_u32("index", 0400, intr_dentry, &intr->index);
 		debugfs_create_u32("vector", 0400, intr_dentry, &intr->vector);
 
-		intr_ctrl_regset = kzalloc(sizeof(*intr_ctrl_regset),
-					   GFP_KERNEL);
+		intr_ctrl_regset = devm_kzalloc(pdsc->dev,
+						sizeof(*intr_ctrl_regset),
+						GFP_KERNEL);
 		if (!intr_ctrl_regset)
 			return;
 		intr_ctrl_regset->regs = intr_ctrl_regs;
-- 
2.39.5



