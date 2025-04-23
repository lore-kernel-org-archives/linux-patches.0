Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C21C296155;
	Wed, 23 Apr 2025 15:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422034; cv=none; b=AZu4Z6bksnFBZVJVvNuahauJ7Pjog3QkIIs2wWAEIcQHGr+wxdF3oMoG8s/hXJixLa3S37ld6ZS/MZVqLaIAq38fwA2K6X5kgF/NsMhD55hfauRqJka1dI1iB7+PjDq4yM4kZVk8bxMawPAskHfeYcVDH15iux9xwF43ahIItWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422034; c=relaxed/simple;
	bh=CgUlGqVIjm69OLbmZhpU8Qk2dYxVgQK6jL0yKIaOb+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUGS5cEcmfxPWAKlkEnKQ3zBnOJg5n9IB7GWAtcjg3UeJOvicDahM5Lm1DXDqMl0/1aD1ixOaxOI9n7IkhKnEX9sSUofm3EI8dKt/fQwJ7tqv1KKN8hff6ptmVK/E/W8UvZfgerUU8p1cAaSgC0+l1Wm6jL8xy6oGiNUrbI2JGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IJNs6DBK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IJNs6DBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C572EC4CEE2;
	Wed, 23 Apr 2025 15:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422034;
	bh=CgUlGqVIjm69OLbmZhpU8Qk2dYxVgQK6jL0yKIaOb+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJNs6DBKEsoKi2lKqoEQ4HAzB5cc17rb0HcdDZb6SkvrYEldjahv08MqTSDmPjZZA
	 2f52uU/2vguK/cIbNG1hKJ8d7HSoNqbj3on03LIXbZ6t8qaivlNZiQyoxhZEU5Z/45
	 HNWpVWf4Iiv+5251RzqgD3UgB1dKBEMXyzS6gN2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 266/393] pds_core: fix memory leak in pdsc_debugfs_add_qcq()
Date: Wed, 23 Apr 2025 16:42:42 +0200
Message-ID: <20250423142654.352164590@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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
index 4e8579ca1c8c7..51f3f73a839a9 100644
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



