Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05482116
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 11:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E8BC433EF;
	Tue,  7 Feb 2023 11:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675768245;
	bh=CTwk00tUwPcA4xd58vPRNcKygDw2cn2AUmwSE5jR3mQ=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=a5nes4s0XwwrXKc2NvMKtwfZxAXXDe3lIOUg8JeAIURn4YNi9P7cYoBrKAHy4Ffst
	 RTnTDbwYdvkK3+qgFDB9gAi5qY59FThIbnO9ZseSYH3i3gvckKRiOyV8nSuQytp1RV
	 laKjAQ6wXyiDZEu4yYbI0YkG3jn01FgG9FLvF4d0=
Subject: Patch "phy: qcom-qmp-usb: fix memleak on probe deferral" has been added to the 5.15-stable tree
To: gregkh@linuxfoundation.org,johan+linaro@kernel.org,patches@lists.linux.dev,swboyd@chromium.org,vkoul@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 07 Feb 2023 12:10:30 +0100
In-Reply-To: <20230203222616.2935268-4-swboyd@chromium.org>
Message-ID: <1675768230231242@kroah.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    phy: qcom-qmp-usb: fix memleak on probe deferral

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     phy-qcom-qmp-usb-fix-memleak-on-probe-deferral.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable-owner@vger.kernel.org Fri Feb  3 23:27:26 2023
From: Stephen Boyd <swboyd@chromium.org>
Date: Fri,  3 Feb 2023 14:26:14 -0800
Subject: phy: qcom-qmp-usb: fix memleak on probe deferral
To: stable@vger.kernel.org
Cc: Johan Hovold <johan+linaro@kernel.org>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Vinod Koul <vkoul@kernel.org>
Message-ID: <20230203222616.2935268-4-swboyd@chromium.org>

From: Johan Hovold <johan+linaro@kernel.org>

commit a5d6b1ac56cbd6b5850a3a54e35f1cb71e8e8cdd upstream.

Switch to using the device-managed of_iomap helper to avoid leaking
memory on probe deferral and driver unbind.

Note that this helper checks for already reserved regions and may fail
if there are multiple devices claiming the same memory.

Two bindings currently rely on overlapping mappings for the PCS region
so fallback to non-exclusive mappings for those for now.

Fixes: e78f3d15e115 ("phy: qcom-qmp: new qmp phy driver for qcom-chipsets")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20220916102340.11520-7-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
[swboyd@chromium.org: Backport to pre-split driver]
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp.c |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -5387,6 +5387,21 @@ static void qcom_qmp_reset_control_put(v
 	reset_control_put(data);
 }
 
+static void __iomem *qmp_usb_iomap(struct device *dev, struct device_node *np,
+		int index, bool exclusive)
+{
+	struct resource res;
+
+	if (!exclusive) {
+		if (of_address_to_resource(np, index, &res))
+			return IOMEM_ERR_PTR(-EINVAL);
+
+		return devm_ioremap(dev, res.start, resource_size(&res));
+	}
+
+	return devm_of_iomap(dev, np, index, NULL);
+}
+
 static
 int qcom_qmp_phy_create(struct device *dev, struct device_node *np, int id,
 			void __iomem *serdes, const struct qmp_phy_cfg *cfg)
@@ -5396,8 +5411,18 @@ int qcom_qmp_phy_create(struct device *d
 	struct qmp_phy *qphy;
 	const struct phy_ops *ops;
 	char prop_name[MAX_PROP_NAME];
+	bool exclusive = true;
 	int ret;
 
+	/*
+	 * FIXME: These bindings should be fixed to not rely on overlapping
+	 *        mappings for PCS.
+	 */
+	if (of_device_is_compatible(dev->of_node, "qcom,sdx65-qmp-usb3-uni-phy"))
+		exclusive = false;
+	if (of_device_is_compatible(dev->of_node, "qcom,sm8350-qmp-usb3-uni-phy"))
+		exclusive = false;
+
 	qphy = devm_kzalloc(dev, sizeof(*qphy), GFP_KERNEL);
 	if (!qphy)
 		return -ENOMEM;
@@ -5418,7 +5443,7 @@ int qcom_qmp_phy_create(struct device *d
 	if (IS_ERR(qphy->rx))
 		return PTR_ERR(qphy->rx);
 
-	qphy->pcs = devm_of_iomap(dev, np, 2, NULL);
+	qphy->pcs = qmp_usb_iomap(dev, np, 2, exclusive);
 	if (IS_ERR(qphy->pcs))
 		return PTR_ERR(qphy->pcs);
 


Patches currently in stable-queue which might be from stable-owner@vger.kernel.org are

queue-5.15/phy-qcom-qmp-combo-fix-broken-power-on.patch
queue-5.15/phy-qcom-qmp-combo-fix-runtime-suspend.patch
queue-5.15/phy-qcom-qmp-combo-disable-runtime-pm-on-unbind.patch
queue-5.15/phy-qcom-qmp-usb-fix-memleak-on-probe-deferral.patch
queue-5.15/phy-qcom-qmp-combo-fix-memleak-on-probe-deferral.patch
