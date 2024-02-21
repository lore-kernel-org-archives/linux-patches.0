Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EACC3D981;
	Wed, 21 Feb 2024 14:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525127; cv=none; b=ElFn3F/VoCNrAMiNpkl1iu7KLjGbsIe2XbkdzU+Km7hntOQYNSfHvu5FGgk9q8gMXwv47HESLJgcmW8aHE0b91DGqcHMQUrWglQUrW2SEV7T3hzyeFPMPG6bNKqHmCvt47nFb8Dp/UEo2WONJk0hds/aNpiSS0j+mA+/4uKGCkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525127; c=relaxed/simple;
	bh=VGAFU8JxoCRoiFh94SbuKJfihLoqaokvjaJCijmmjxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWv/lMT83DOh57aU81mXb3xoaG2BBBDd1IIkPCCODu1pWYVO0mSjYCJH/hku8xX7RMasFIteu+toEbzRzBhvw/zam5RCWB2x/iUtY+/nQ9qnUX5dCDgZXAkut7bf0OjAWC1bLYNAq8laAKa2Isr1713NRpMgbEjELY4Mc4vLb0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KtWLSHy3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KtWLSHy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01ABC433F1;
	Wed, 21 Feb 2024 14:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525127;
	bh=VGAFU8JxoCRoiFh94SbuKJfihLoqaokvjaJCijmmjxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KtWLSHy33/6R4Sk22GfLJjJhsTBth/t3hOvY2ynwFYLL59CyRw5LnvWe/6Ei+6GOE
	 lcYR7KINhGdbr0c3SCF06TtVT+PSv/On0yrKNE+HsDrSM8voq9jMofsA7NLUbjt+WX
	 5zLnmw9MZQUOomvCfIFpzY91gvQeWIvyIGpsDWyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 067/267] perf/core: Fix narrow startup race when creating the perf nr_addr_filters sysfs file
Date: Wed, 21 Feb 2024 14:06:48 +0100
Message-ID: <20240221125942.095104021@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg KH <gregkh@linuxfoundation.org>

[ Upstream commit 652ffc2104ec1f69dd4a46313888c33527145ccf ]

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/2023061204-decal-flyable-6090@gregkh
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1e62a567b0d7..3ec29a27d877 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10080,9 +10080,32 @@ static DEVICE_ATTR_RW(perf_event_mux_interval_ms);
 static struct attribute *pmu_dev_attrs[] = {
 	&dev_attr_type.attr,
 	&dev_attr_perf_event_mux_interval_ms.attr,
+	&dev_attr_nr_addr_filters.attr,
+	NULL,
+};
+
+static umode_t pmu_dev_is_visible(struct kobject *kobj, struct attribute *a, int n)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct pmu *pmu = dev_get_drvdata(dev);
+
+	if (!pmu->nr_addr_filters)
+		return 0;
+
+	return a->mode;
+
+	return 0;
+}
+
+static struct attribute_group pmu_dev_attr_group = {
+	.is_visible = pmu_dev_is_visible,
+	.attrs = pmu_dev_attrs,
+};
+
+static const struct attribute_group *pmu_dev_groups[] = {
+	&pmu_dev_attr_group,
 	NULL,
 };
-ATTRIBUTE_GROUPS(pmu_dev);
 
 static int pmu_bus_running;
 static struct bus_type pmu_bus = {
@@ -10118,18 +10141,11 @@ static int pmu_dev_alloc(struct pmu *pmu)
 	if (ret)
 		goto free_dev;
 
-	/* For PMUs with address filters, throw in an extra attribute: */
-	if (pmu->nr_addr_filters)
-		ret = device_create_file(pmu->dev, &dev_attr_nr_addr_filters);
-
-	if (ret)
-		goto del_dev;
-
-	if (pmu->attr_update)
+	if (pmu->attr_update) {
 		ret = sysfs_update_groups(&pmu->dev->kobj, pmu->attr_update);
-
-	if (ret)
-		goto del_dev;
+		if (ret)
+			goto del_dev;
+	}
 
 out:
 	return ret;
-- 
2.43.0



