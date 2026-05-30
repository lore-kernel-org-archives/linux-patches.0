Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4014D261B9E;
	Sat, 30 May 2026 17:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163637; cv=none; b=QhzVFuMwRLFrJv9sQG6J4FRcg5YdKMxIfSYas1MYCsN3zKrvSPqRG7ENl1ceVQtuNqXkSQgyjO0LhRN6U0OwURr7gE/cz+feY81UjJ4odbTz6Mr1iEs846f3gfELSgLFSPComy6G7wG6kjwv9+wCF8CBQskZ7LzfiIpNGzJ/eOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163637; c=relaxed/simple;
	bh=72s0oXtUkz+nt6kf20vhDsj0hHyluEz2sMdGXkWY/1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtCvTZfj0vFFMwXY+DNRUayhh/LrdnFX5tmD8GSFy2hbEZcPMOeLOhiQsBDs4lMmbvtM/HzNKSn7sbNHr4siuRqFhica6EE5OUkR6GdCc2heNxBHXCdPTK171EWt6zFk3EjTki9TNXD5cqF0stTlZZ+Lh48Uzj+VI1W+6C0iMXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MpMOkjFL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MpMOkjFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849491F00893;
	Sat, 30 May 2026 17:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163636;
	bh=KZi8yiv3/XZP/ypVH9hOdJe2mgb2hK9rA7srICnXWRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MpMOkjFL2hxLsCmWEugpqs+WvHsxJKO/+eNQrjCD36/gF6R3AO3/JVRXk8AiB7m7z
	 zW3fK2N5gHc677b9opzAzkj8Bi4H3TJm4IzNRac6zB1o4NcJETKR/qYaAGu6l3jeFv
	 Q0cGly8gk/ZStxabdwbkc7lNH4qkv54g5I7ldv3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 5.15 317/776] extcon: ptn5150: handle pending IRQ events during system resume
Date: Sat, 30 May 2026 18:00:31 +0200
Message-ID: <20260530160248.761363791@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit 4652fefcda3c604c83d1ae28ede94544e2142f06 upstream.

When the system is suspended and ptn5150 wakeup interrupt is disabled,
any changes on ptn5150 will only be record in interrupt status
registers and won't fire an IRQ since its trigger type is falling
edge. So the HW interrupt line will keep at low state and any further
changes won't trigger IRQ anymore. To fix it, this will schedule a
work to check whether any IRQ are pending and handle it accordingly.

Fixes: 4ed754de2d66 ("extcon: Add support for ptn5150 extcon driver")
Cc: stable@vger.kernel.org
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Link: https://lore.kernel.org/lkml/20251115025905.1395347-1-xu.yang_2@nxp.com/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/extcon/extcon-ptn5150.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/extcon/extcon-ptn5150.c
+++ b/drivers/extcon/extcon-ptn5150.c
@@ -306,6 +306,19 @@ static int ptn5150_i2c_probe(struct i2c_
 	return 0;
 }
 
+static int ptn5150_resume(struct device *dev)
+{
+	struct i2c_client *i2c = to_i2c_client(dev);
+	struct ptn5150_info *info = i2c_get_clientdata(i2c);
+
+	/* Need to check possible pending interrupt events */
+	schedule_work(&info->irq_work);
+
+	return 0;
+}
+
+static DEFINE_SIMPLE_DEV_PM_OPS(ptn5150_pm_ops, NULL, ptn5150_resume);
+
 static const struct of_device_id ptn5150_dt_match[] = {
 	{ .compatible = "nxp,ptn5150" },
 	{ },
@@ -321,6 +334,7 @@ MODULE_DEVICE_TABLE(i2c, ptn5150_i2c_id)
 static struct i2c_driver ptn5150_i2c_driver = {
 	.driver		= {
 		.name	= "ptn5150",
+		.pm = pm_sleep_ptr(&ptn5150_pm_ops),
 		.of_match_table = ptn5150_dt_match,
 	},
 	.probe_new	= ptn5150_i2c_probe,


