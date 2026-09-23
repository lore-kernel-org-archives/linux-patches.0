Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5C653B34B;
	Wed, 23 Sep 2026 14:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174927; cv=none; b=T7ON7spcMAepV7gBrxAt/rqcg/Ic7FyYXeHQq+KPwKSzeS2F6PieyQjPLLHrx73Q/nVJ3g8gEVhFRQS97ckZsBsN+Ugfzvx9yCYPxV30cUpWMHDr3abTfU0WFKzUXjlD+R53ZD+wOBHEFDZ1zJTckMVXRmUHCGkzhvakIIYG67A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174927; c=relaxed/simple;
	bh=taB1HKr3hQxz3V9x2fNaQ8HKCeC1SsecnmdjQa7aXE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SluS0hiPOUSMWWCirWfW0mlOv4fugJspRRRi2V3iAZtjlEDNLjP5ZEdwZcrEeeQV6S5NCd45BzzlyhRJFItEYMCp67fmR9A8kUolthVlhD+T7NCxuq24yU4uumCPI46yq2KWVv9gTAMS67spezGw5SHY8++30g+6NMmrawKFhn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yKR/eziu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yKR/eziu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6C31F000FF;
	Wed, 23 Sep 2026 14:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174926;
	bh=iiX+5Bby2LO5Tcb8cj6BsnSWfm86qqlEa09LTbw4Dgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yKR/eziuahZeBJYQgG+LU7JF468GDlf7quKn8RFl+9solmEA6gM95oiTYT1EEmaST
	 Mum3zx6VDrPkTIIP0FSYkxwb+xNSmQpARP56UYMSFVnljHJpaarLKRKlyXDq02JGOK
	 GJZ6S8sY9CpxHHh6Zz7ZuG5JGEowbuibLLFgxGng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Liu Zhenlong <dragonliu2018@gmail.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 268/398] i2c: qcom-cci: fix device_node refcount leak in cci_probe()/cci_remove()
Date: Wed, 23 Sep 2026 16:05:42 +0200
Message-ID: <20260923140650.361879078@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -499,10 +499,14 @@ static const struct dev_pm_ops qcom_cci_
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
@@ -518,7 +522,7 @@ static int cci_probe(struct platform_dev
 	if (!cci->data)
 		return -ENOENT;
 
-	for_each_available_child_of_node(dev->of_node, child) {
+	for_each_available_child_of_node_scoped(dev->of_node, child) {
 		struct cci_master *master;
 		u32 idx;
 
@@ -539,6 +543,9 @@ static int cci_probe(struct platform_dev
 		master->adap.algo = &cci_algo;
 		master->adap.dev.parent = dev;
 		master->adap.dev.of_node = of_node_get(child);
+		ret = devm_add_action_or_reset(dev, cci_put_of_node, child);
+		if (ret)
+			return ret;
 		master->master = idx;
 		master->cci = cci;
 
@@ -610,10 +617,8 @@ static int cci_probe(struct platform_dev
 			continue;
 
 		ret = i2c_add_adapter(&cci->master[i].adap);
-		if (ret < 0) {
-			of_node_put(cci->master[i].adap.dev.of_node);
+		if (ret < 0)
 			goto error_i2c;
-		}
 	}
 
 	return 0;
@@ -621,10 +626,8 @@ static int cci_probe(struct platform_dev
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
@@ -640,7 +643,6 @@ static void cci_remove(struct platform_d
 	for (i = 0; i < cci->data->num_masters; i++) {
 		if (cci->master[i].cci) {
 			i2c_del_adapter(&cci->master[i].adap);
-			of_node_put(cci->master[i].adap.dev.of_node);
 			cci_halt(cci, i);
 		}
 	}


