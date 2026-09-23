Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8EF5383E2;
	Wed, 23 Sep 2026 14:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173741; cv=none; b=cTm42DVKG2NHQEyRSEEZBSgU8ecvs66BK0JHmw1J6u8ipLDTLQwJqj70dCVIbokLfqjKhITgPgHZdvg0V7Mo6TyI6Bl73An+Py0lHZX+aZTpbxhPrjhDwpSbwE4KhS13dWc4OVjCldD5W98EWihoxTQ6EASBL53YMTiyPsP+Mcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173741; c=relaxed/simple;
	bh=/4YmbLqCjzRPTsdYTI68mnwb0xkoA9jByxn8skjDFIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuDy14Buw/CQC9BDkTezlt7DujSDxSkx+0FS3Mc5KtltdZ+3WNPSCwyEVEO+qptI5tWDa+Xx02mRUO26v7U72iljEEjbX66cGgOxyhTct311FSs+zeh8gtAq82Tf691bVqQCqXIsPXJoNlMyhMpVA2yuFREQBbSuj3pGzLKHE/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBmoLVXJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBmoLVXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6491F000FF;
	Wed, 23 Sep 2026 14:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173740;
	bh=HULhbuyxlWb1O94cPIlyGY5Tj7dmnuAEBRCv4aEBg2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NBmoLVXJLVVE2dr2NvtP6kKWFcmk9kNt7RBokx10Sh8xNW1djCbgoZdT3m212x3Qx
	 OvM+Rbg70lrrv3HoYghbT0I/noOxRaZoyWTsc2ciNvgNIhAirx4AUytr7MD2xSQpzf
	 GkKZMfEXg+NFGfDyM2T52jhGsNRFmUoyT/z/34Gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Liu Zhenlong <dragonliu2018@gmail.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.2 327/438] i2c: qcom-cci: fix device_node refcount leak in cci_probe()/cci_remove()
Date: Wed, 23 Sep 2026 16:05:48 +0200
Message-ID: <20260923140653.280109814@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Zhenlong <dragonliu2018@gmail.com>

commit 7362a1553eb09a8cdf8be7e509bd5309a8342486 upstream.

The of_node_put() matching of_node_get() runs after i2c_del_adapter(),
whose trailing memset() zeroes adap->dev and thus adap->dev.of_node,
making the put a no-op and leaking the node on every adapter removal
and error cleanup.

Use a devm action: the pointer is captured at registration, out of
reach of that memset(), and devres runs the put once on probe failure
and detach, replacing the three manual of_node_put() calls.  The
setup loop uses the scoped iterator form so the child node is released
automatically if devm_add_action_or_reset() fails mid-loop.

Suggested-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Fixes: 02a4a69667a2 ("i2c: qcom-cci: don't put a device tree node before i2c_add_adapter()")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Liu Zhenlong <dragonliu2018@gmail.com>
Cc: <stable@vger.kernel.org> # v5.17+
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260818175750.4205-1-dragonliu2018@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-qcom-cci.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/drivers/i2c/busses/i2c-qcom-cci.c
+++ b/drivers/i2c/busses/i2c-qcom-cci.c
@@ -497,10 +497,14 @@ static const struct dev_pm_ops qcom_cci_
 	SET_RUNTIME_PM_OPS(cci_suspend_runtime, cci_resume_runtime, NULL)
 };
 
+static void cci_put_of_node(void *data)
+{
+	of_node_put(data);
+}
+
 static int cci_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct device_node *child;
 	struct resource *r;
 	struct cci *cci;
 	int ret, i;
@@ -516,7 +520,7 @@ static int cci_probe(struct platform_dev
 	if (!cci->data)
 		return -ENOENT;
 
-	for_each_available_child_of_node(dev->of_node, child) {
+	for_each_available_child_of_node_scoped(dev->of_node, child) {
 		struct cci_master *master;
 		u32 idx;
 
@@ -537,6 +541,9 @@ static int cci_probe(struct platform_dev
 		master->adap.algo = &cci_algo;
 		master->adap.dev.parent = dev;
 		master->adap.dev.of_node = of_node_get(child);
+		ret = devm_add_action_or_reset(dev, cci_put_of_node, child);
+		if (ret)
+			return ret;
 		master->master = idx;
 		master->cci = cci;
 
@@ -606,10 +613,8 @@ static int cci_probe(struct platform_dev
 			continue;
 
 		ret = i2c_add_adapter(&cci->master[i].adap);
-		if (ret < 0) {
-			of_node_put(cci->master[i].adap.dev.of_node);
+		if (ret < 0)
 			goto error_i2c;
-		}
 	}
 
 	return 0;
@@ -617,10 +622,8 @@ static int cci_probe(struct platform_dev
 error_i2c:
 
 	for (--i ; i >= 0; i--) {
-		if (cci->master[i].cci) {
+		if (cci->master[i].cci)
 			i2c_del_adapter(&cci->master[i].adap);
-			of_node_put(cci->master[i].adap.dev.of_node);
-		}
 	}
 disable_clocks:
 	cci_disable_clocks(cci);
@@ -636,7 +639,6 @@ static void cci_remove(struct platform_d
 	for (i = 0; i < cci->data->num_masters; i++) {
 		if (cci->master[i].cci) {
 			i2c_del_adapter(&cci->master[i].adap);
-			of_node_put(cci->master[i].adap.dev.of_node);
 			cci_halt(cci, i);
 		}
 	}


