Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A131D416E;
	Wed,  6 Nov 2024 12:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895172; cv=none; b=Sqoo8oaQsQpsyki2B3tzf3ihI3erV+TUd2+7MOKBc1Ogxc9k/q7c8msFHkMTaD6yEDuTbo9PjHE9M0cOSpeboBb5AJ4nwuRFqOZYQYHHKKXRev9CN4FQVBtP/zoF3QSgevOriv+HshtJIGhOIQnlsMYLNuwMqc87E2ssdFR1yGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895172; c=relaxed/simple;
	bh=L51DN+DoH6NbrlczINLX/GtZkIVYxBbxtR4tAuAAWsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6qSU/bDkSNInYBJkXry4kQImaPtgYUDRJDshS9OnZu/Qus+s1qGj3/Fzh8osNzQQmh7fYwuodut+Ujb+Gohcv4oudqjQdCu7eqt5+HGKdEi7nZdP/AW+GjhZi56S8zMJQ4uDR9f5G3k5EnsYbxC9oNUEb3qdVfVhQVJDNvxhXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sncTDjLz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sncTDjLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B09CC4CECD;
	Wed,  6 Nov 2024 12:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895172;
	bh=L51DN+DoH6NbrlczINLX/GtZkIVYxBbxtR4tAuAAWsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sncTDjLzuIh57qMNKTIOg7n+jwImzHr0y7OrdF57ChekyG3QmL30IOw8BZ8iheiyz
	 Gsg/Z41VlS5baVEYczMJI8cizpelfOnkzY0DAOlp6HQGqaZPDH8lLwJ0hPmDH67ggW
	 8N1SBK1M5BytEInQX8yKZEkemeeDo34iKOCbKvFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 092/350] ntb: intel: Fix the NULL vs IS_ERR() bug for debugfs_create_dir()
Date: Wed,  6 Nov 2024 13:00:20 +0100
Message-ID: <20241106120323.172958059@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit e229897d373a87ee09ec5cc4ecd4bb2f895fc16b ]

The debugfs_create_dir() function returns error pointers.
It never returns NULL. So use IS_ERR() to check it.

Fixes: e26a5843f7f5 ("NTB: Split ntb_hw_intel and ntb_transport drivers")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/intel/ntb_hw_gen1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ntb/hw/intel/ntb_hw_gen1.c b/drivers/ntb/hw/intel/ntb_hw_gen1.c
index 084bd1d1ac1dc..0e913fd6b592e 100644
--- a/drivers/ntb/hw/intel/ntb_hw_gen1.c
+++ b/drivers/ntb/hw/intel/ntb_hw_gen1.c
@@ -777,7 +777,7 @@ static void ndev_init_debugfs(struct intel_ntb_dev *ndev)
 		ndev->debugfs_dir =
 			debugfs_create_dir(pci_name(ndev->ntb.pdev),
 					   debugfs_dir);
-		if (!ndev->debugfs_dir)
+		if (IS_ERR(ndev->debugfs_dir))
 			ndev->debugfs_info = NULL;
 		else
 			ndev->debugfs_info =
-- 
2.43.0



