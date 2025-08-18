Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D933203B5;
	Mon, 18 Aug 2025 13:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522492; cv=none; b=JdWuL+3ETdCa3g8HTUke2YeD5d6YxOAlPPHyas4nWp7SbeDBLgJSMsKF+yT8maCbuUbngR2pwt2UO9yvU/d7aM2R4rWslMXviMdumMj1tgzCQJBefrMX8uTsyHUBPSLOXHDTyGOM5p4x4shAUjL25vIF9UzVX5AvS3n+pUSWTKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522492; c=relaxed/simple;
	bh=9lXw057TEcv0HTTVpW+mPAMH48TTbscU6J5bngoF3RM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4RT0U6OWDfP76qcSdKL5XXZ9LgvSKDgT7ueIcf5EAp57oKgdBuoYC5OdJgoeSVkHiSglSxlN9CJF7PlL0YT1oTk4NcpWBMZoaKwAOwt4AelD7QGxYx+6V6QCcR890622joGV+cNDTFX0SOaRxrit2kM6buGzczJMDjYlhgDP7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ONUNAlCT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ONUNAlCT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94D0C4CEEB;
	Mon, 18 Aug 2025 13:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522492;
	bh=9lXw057TEcv0HTTVpW+mPAMH48TTbscU6J5bngoF3RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ONUNAlCTGtBpPYgYRuaLenMnmuxktfvxNG1YhEf4yxpaMBVETygtWPbt4EMqxS3or
	 eH6zWpBA380GX8K+0BmcssuJEqWek7FhAVC/wksPlzPUaZtZxreGLdH0o9PkJ3wdfv
	 VDMVw5vrAmk2lRhlL8MRLu+02iwC0X9B5RbqKmIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 325/444] soundwire: amd: cancel pending slave status handling workqueue during remove sequence
Date: Mon, 18 Aug 2025 14:45:51 +0200
Message-ID: <20250818124501.125610435@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit f93b697ed98e3c85d1973ea170d4f4e7a6b2b45d ]

During remove sequence, cancel the pending slave status update workqueue.

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://lore.kernel.org/r/20250530054447.1645807-4-Vijendar.Mukunda@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/amd_manager.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soundwire/amd_manager.c b/drivers/soundwire/amd_manager.c
index dc7d54cb1740..a325ce52c396 100644
--- a/drivers/soundwire/amd_manager.c
+++ b/drivers/soundwire/amd_manager.c
@@ -972,6 +972,7 @@ static void amd_sdw_manager_remove(struct platform_device *pdev)
 	int ret;
 
 	pm_runtime_disable(&pdev->dev);
+	cancel_work_sync(&amd_manager->amd_sdw_work);
 	amd_disable_sdw_interrupts(amd_manager);
 	sdw_bus_master_delete(&amd_manager->bus);
 	ret = amd_disable_sdw_manager(amd_manager);
-- 
2.39.5



