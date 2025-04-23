Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C14827FD7A;
	Wed, 23 Apr 2025 14:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419684; cv=none; b=ncOHdibtP7c3g3HWW/Tmxk16RyfTQKH7tT8kFVddk4JGeBsuyXmIzIQa4zcDCLAeSr+iRJMtbsXrY3SdKmoKG2UwljS+GlOFpq35GxyH1fcf4pxzmmoybBzMTRnZ1cTIYGTGqjul77rQQGYFHzPp1M23fSCFY04vV97aHE+dj4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419684; c=relaxed/simple;
	bh=4fRTpV2Sl2XsDPQTuqdC0ecrqCQFRlFDXTiTHDtl9+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNS7pxb4GLUwMvNrTdkNiVSX2bTnVxpEnMUbotjT0kiiwyH0ekIQiTZKKBkxm4G6LWjTTm3zF8ygsH1QejJ1zKg+Qili9BTASyGYxU6tgTyHcsaPivOq8WsaW3hxQzXivku89tIBxTwjCiepNY+CoKhAQR5rcQcJ7yqvd8Tq2qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eeakNRbm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eeakNRbm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F06C4CEE2;
	Wed, 23 Apr 2025 14:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419684;
	bh=4fRTpV2Sl2XsDPQTuqdC0ecrqCQFRlFDXTiTHDtl9+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eeakNRbmb69/gFH7dIS+dazWMtiSzSdXzE/hDev75TCOgSMv0hMbgrYqPA4QhN/rk
	 XOmLTagHBZUG0tSzvdh9PpH3EAp9+74oaa8utdW9f0lx+VXqUqEy9EEa5Bxry6EWUp
	 CIIjQrgGdLfsEl9gPElVGmK7bfQWH26WpqyeeoGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/223] pds_core: fix memory leak in pdsc_debugfs_add_qcq()
Date: Wed, 23 Apr 2025 16:41:54 +0200
Message-ID: <20250423142618.841147872@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



