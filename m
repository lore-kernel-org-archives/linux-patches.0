Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC222214425;
	Tue, 12 Nov 2024 10:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407678; cv=none; b=FVldJ8zEj125pp/lzXxt4TPLDHuSxWVkG8OOXArRQM5jdvumXHK0GT529POCV7yxeSiKSCE+SsUN0DGes+kfk9fRVJMue1Hr1WIkxT85ikIk5+Xgb7UbeHjaLrrFrChC+J6fgRDhl4qPPD3Q1hPhgCTly5ygmLO8/c2bMhFqj9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407678; c=relaxed/simple;
	bh=K8lmpxVD64S82eXnru0wUaiBwpW47azgPEYczTJkRXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8rbIf/6rAoKYFLP3vs83nfkas+yAsCmwL86I2Ao7iIlehcz5mV8y/QMoRMuf0B5RcWNOtZww7X+rgvQsWFOOArVCHYRHwNEuYrmfnhl4g+p2LaYM97dDltRGLm0VBAmISGKbq3maDKOjgdKY4yrAUx86cBpLEhzGGqxJ8rvRHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zoZRl93h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zoZRl93h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42347C4CECD;
	Tue, 12 Nov 2024 10:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407678;
	bh=K8lmpxVD64S82eXnru0wUaiBwpW47azgPEYczTJkRXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zoZRl93hhUCBF+yJdMcHN/FDCYcWVrUJO4+jze2xXr2TNYU5q+/C7Xhq2+0h+tFqV
	 RyTyCPEsOJfQOP/ygRDcWC+kSkeKIIsnWyjUJ4zqcSwrEQqJ72H7nfJhheMiDF8Kxt
	 2MDCZceZT6Wy7EJlM1jtkTQ9KO9Jt1H2bNSZYSBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <Wentao_liang_g@163.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/119] drivers: net: ionic: add missed debugfs cleanup to ionic_probe() error path
Date: Tue, 12 Nov 2024 11:20:57 +0100
Message-ID: <20241112101850.589728219@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <Wentao_liang_g@163.com>

[ Upstream commit 71712cf519faeed529549a79559c06c7fc250a15 ]

The ionic_setup_one() creates a debugfs entry for ionic upon
successful execution. However, the ionic_probe() does not
release the dentry before returning, resulting in a memory
leak.

To fix this bug, we add the ionic_debugfs_del_dev() to release
the resources in a timely manner before returning.

Fixes: 0de38d9f1dba ("ionic: extract common bits from ionic_probe")
Signed-off-by: Wentao Liang <Wentao_liang_g@163.com>
Acked-by: Shannon Nelson <shannon.nelson@amd.com>
Link: https://patch.msgid.link/20241107021756.1677-1-liangwentao@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 35099ad5eccc8..f49b697ab00f8 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -385,6 +385,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_out_pci:
 	ionic_dev_teardown(ionic);
 	ionic_clear_pci(ionic);
+	ionic_debugfs_del_dev(ionic);
 err_out:
 	mutex_destroy(&ionic->dev_cmd_lock);
 	ionic_devlink_free(ionic);
-- 
2.43.0



