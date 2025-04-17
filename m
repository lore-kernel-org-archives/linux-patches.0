Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A977A2571AE;
	Thu, 17 Apr 2025 18:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914027; cv=none; b=ZdQJJcxEkf2PvuznzWpCN7gtUkXeMyArDAl8K4Xf6fTcicvJYvNcmAYHJa2YGZgCL2dGVFUr3qaB1bWiucJHFFDBXHL46nOqQBOfPytkJqxRi44Ih2pLnUcp4vpQvYGfe4nlvye4TGKswzz5m8zNZMKvxXWwXgdbC8vK/4W632c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914027; c=relaxed/simple;
	bh=Gp0OPBs5jmxOHXoiu8rMjipHDq3u4dex7CPw3olmUvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mm4msAySBZckmvRgsB2HDCiliRZzg6w9lYc2McwbPKrhog2Hl+BMz2NOgvGqCfrNFczbpCNfrbEfVlJeUiqXiWm9dWoXFhw0zwP7Pom7RVEMAAdtPkV2/Cp6PFWEyqeyQ+ZaGN3sJJut6mAPu5begnXJlzuzjUucq8SK67qOt1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wxhVne20; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxhVne20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE364C4CEE4;
	Thu, 17 Apr 2025 18:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914027;
	bh=Gp0OPBs5jmxOHXoiu8rMjipHDq3u4dex7CPw3olmUvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wxhVne20ahijjkW8CTJZwMuepQCvA0Ypn/NIoVIpyiiVlF6depqzPCgNvss4VMRXI
	 QYCn4SXAJ9pe6RwJdaR8vENe/4EbnM+p4+cZ0hATVJeIBMKz+qRBNI66Hd1cqK8uZp
	 uEJRD0voouhVrhxLAM8KecWVcJE57NyC5kB0K1tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 052/414] perf/dwc_pcie: fix some unreleased resources
Date: Thu, 17 Apr 2025 19:46:50 +0200
Message-ID: <20250417175113.504949921@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunhui Cui <cuiyunhui@bytedance.com>

[ Upstream commit 6eb1e8ef586ac4a3dcdc20248f9cb45e4ceb141f ]

Release leaked resources, such as plat_dev and dev_info.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250220121716.50324-2-cuiyunhui@bytedance.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/dwc_pcie_pmu.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/perf/dwc_pcie_pmu.c b/drivers/perf/dwc_pcie_pmu.c
index 9cbea9675e21a..a7e7864e73a8e 100644
--- a/drivers/perf/dwc_pcie_pmu.c
+++ b/drivers/perf/dwc_pcie_pmu.c
@@ -567,8 +567,10 @@ static int dwc_pcie_register_dev(struct pci_dev *pdev)
 		return PTR_ERR(plat_dev);
 
 	dev_info = kzalloc(sizeof(*dev_info), GFP_KERNEL);
-	if (!dev_info)
+	if (!dev_info) {
+		platform_device_unregister(plat_dev);
 		return -ENOMEM;
+	}
 
 	/* Cache platform device to handle pci device hotplug */
 	dev_info->plat_dev = plat_dev;
@@ -724,6 +726,15 @@ static struct platform_driver dwc_pcie_pmu_driver = {
 	.driver = {.name = "dwc_pcie_pmu",},
 };
 
+static void dwc_pcie_cleanup_devices(void)
+{
+	struct dwc_pcie_dev_info *dev_info, *tmp;
+
+	list_for_each_entry_safe(dev_info, tmp, &dwc_pcie_dev_info_head, dev_node) {
+		dwc_pcie_unregister_dev(dev_info);
+	}
+}
+
 static int __init dwc_pcie_pmu_init(void)
 {
 	struct pci_dev *pdev = NULL;
@@ -736,7 +747,7 @@ static int __init dwc_pcie_pmu_init(void)
 		ret = dwc_pcie_register_dev(pdev);
 		if (ret) {
 			pci_dev_put(pdev);
-			return ret;
+			goto err_cleanup;
 		}
 	}
 
@@ -745,35 +756,35 @@ static int __init dwc_pcie_pmu_init(void)
 				      dwc_pcie_pmu_online_cpu,
 				      dwc_pcie_pmu_offline_cpu);
 	if (ret < 0)
-		return ret;
+		goto err_cleanup;
 
 	dwc_pcie_pmu_hp_state = ret;
 
 	ret = platform_driver_register(&dwc_pcie_pmu_driver);
 	if (ret)
-		goto platform_driver_register_err;
+		goto err_remove_cpuhp;
 
 	ret = bus_register_notifier(&pci_bus_type, &dwc_pcie_pmu_nb);
 	if (ret)
-		goto platform_driver_register_err;
+		goto err_unregister_driver;
 	notify = true;
 
 	return 0;
 
-platform_driver_register_err:
+err_unregister_driver:
+	platform_driver_unregister(&dwc_pcie_pmu_driver);
+err_remove_cpuhp:
 	cpuhp_remove_multi_state(dwc_pcie_pmu_hp_state);
-
+err_cleanup:
+	dwc_pcie_cleanup_devices();
 	return ret;
 }
 
 static void __exit dwc_pcie_pmu_exit(void)
 {
-	struct dwc_pcie_dev_info *dev_info, *tmp;
-
 	if (notify)
 		bus_unregister_notifier(&pci_bus_type, &dwc_pcie_pmu_nb);
-	list_for_each_entry_safe(dev_info, tmp, &dwc_pcie_dev_info_head, dev_node)
-		dwc_pcie_unregister_dev(dev_info);
+	dwc_pcie_cleanup_devices();
 	platform_driver_unregister(&dwc_pcie_pmu_driver);
 	cpuhp_remove_multi_state(dwc_pcie_pmu_hp_state);
 }
-- 
2.39.5



