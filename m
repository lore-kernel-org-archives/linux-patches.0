Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9144595B;
	Mon, 14 Oct 2024 14:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916519; cv=none; b=eGNfPZ7ITvFz3VH8MVkDGzAHrERBgBlK0z1H37py4JlrLiRW6kIaHVxZeFukD4iU/rUSNIbBeeeeK32CgE03dBogtmHejVbWoRIaBD4CvJEtIHfZlL9qt2F3+c0J1GOQRo05rjxaeFhNSbk9K/Y5CPZo9xHJRlNapUEx6vMsMtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916519; c=relaxed/simple;
	bh=ua23tWhqj+xE83m/RXzAl/11Hv9LGGS7gCTCuooiVXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dS511DEg6HpOWvSk8ZfEX/3weXsdqWS3Da2sjENrBeJmIHIV+k8b+VnDfYGuDE3LkHTDFckNvvMON2i5LWastAQhQZ/L+4ul/djWmU5sIjUtejmzZburEUnDg1BVLvJLhaxZ66/BA+E0fLR6YzCfjirYRLkpaxFnwRjzlth0A9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FgRb+URO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FgRb+URO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3330AC4CEC3;
	Mon, 14 Oct 2024 14:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916519;
	bh=ua23tWhqj+xE83m/RXzAl/11Hv9LGGS7gCTCuooiVXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FgRb+UROaczyh4cDfBEmiolkgNECSc/Qay93GGNeUCsjouE9LMueFlHUrqxXrUkqU
	 +gFEP8zNZxoxmJSKRDxSoZOmDW7BW89mC/YyTp85N/u7nOLrUjWu925yvpwKPUEJok
	 VgKNzA6hWmdtMiWkLbEu3NVm/V6huDO2RSHYpf8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.11 208/214] PM: domains: Fix alloc/free in dev_pm_domain_attach|detach_list()
Date: Mon, 14 Oct 2024 16:21:11 +0200
Message-ID: <20241014141053.094901868@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

From: Ulf Hansson <ulf.hansson@linaro.org>

commit 7738568885f2eaecfc10a3f530a2693e5f0ae3d0 upstream.

The dev_pm_domain_attach|detach_list() functions are not resource managed,
hence they should not use devm_* helpers to manage allocation/freeing of
data. Let's fix this by converting to the traditional alloc/free functions.

Fixes: 161e16a5e50a ("PM: domains: Add helper functions to attach/detach multiple PM domains")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://lore.kernel.org/r/20241002122232.194245-3-ulf.hansson@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/common.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/drivers/base/power/common.c
+++ b/drivers/base/power/common.c
@@ -195,6 +195,7 @@ int dev_pm_domain_attach_list(struct dev
 	struct device *pd_dev = NULL;
 	int ret, i, num_pds = 0;
 	bool by_id = true;
+	size_t size;
 	u32 pd_flags = data ? data->pd_flags : 0;
 	u32 link_flags = pd_flags & PD_FLAG_NO_DEV_LINK ? 0 :
 			DL_FLAG_STATELESS | DL_FLAG_PM_RUNTIME;
@@ -217,19 +218,17 @@ int dev_pm_domain_attach_list(struct dev
 	if (num_pds <= 0)
 		return 0;
 
-	pds = devm_kzalloc(dev, sizeof(*pds), GFP_KERNEL);
+	pds = kzalloc(sizeof(*pds), GFP_KERNEL);
 	if (!pds)
 		return -ENOMEM;
 
-	pds->pd_devs = devm_kcalloc(dev, num_pds, sizeof(*pds->pd_devs),
-				    GFP_KERNEL);
-	if (!pds->pd_devs)
-		return -ENOMEM;
-
-	pds->pd_links = devm_kcalloc(dev, num_pds, sizeof(*pds->pd_links),
-				     GFP_KERNEL);
-	if (!pds->pd_links)
-		return -ENOMEM;
+	size = sizeof(*pds->pd_devs) + sizeof(*pds->pd_links);
+	pds->pd_devs = kcalloc(num_pds, size, GFP_KERNEL);
+	if (!pds->pd_devs) {
+		ret = -ENOMEM;
+		goto free_pds;
+	}
+	pds->pd_links = (void *)(pds->pd_devs + num_pds);
 
 	if (link_flags && pd_flags & PD_FLAG_DEV_LINK_ON)
 		link_flags |= DL_FLAG_RPM_ACTIVE;
@@ -272,6 +271,9 @@ err_attach:
 			device_link_del(pds->pd_links[i]);
 		dev_pm_domain_detach(pds->pd_devs[i], true);
 	}
+	kfree(pds->pd_devs);
+free_pds:
+	kfree(pds);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(dev_pm_domain_attach_list);
@@ -318,6 +320,9 @@ void dev_pm_domain_detach_list(struct de
 			device_link_del(list->pd_links[i]);
 		dev_pm_domain_detach(list->pd_devs[i], true);
 	}
+
+	kfree(list->pd_devs);
+	kfree(list);
 }
 EXPORT_SYMBOL_GPL(dev_pm_domain_detach_list);
 


