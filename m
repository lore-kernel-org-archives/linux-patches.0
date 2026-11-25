Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619701;
	b=uGva3hRQNoflNJUUcciKpfch9areUeM1a4zEdZhBg4/uVMk/B0Hln36svhcdqFdrsTxd
	 17P7qEDsFjFYip7kbWdGolaTPrJ4X/WGvTx41NAXWrCf4dC7oGkPePLp31EHeRHtgq0+z
	 zfFs7oN5CjOuHVEeAtLuczgpn8Hh/NZyg88iVm/Wjtja6+ko87dPrumsRi4p9r5dk217K
	 OK0eAdFOSW0CMnEKMlqhnoZq36/MYGiPwjccuLHpZwI/OnaWmWYSVj5UzHQB1PXH3Xbbr
	 JJ1Ut6gjrzgeoYE9pVvNenUAOnigFGWqu246XLeKXNlsy/BI+lMBXT3JuAQycKC8PTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619701;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sNKRUoFhh9txT53v/zlb/25ByWB+RsbqBrtBk6weyaQ=;
	b=htTtPLyYhZKnpRX72PCyHp4mtkFghp+PiKAUY1M6iUv1Njob/2k1EXSUBwZpihaXggSz
	 6JWwri4XE4tGkbr3+PozEa7M6mbvoZE9nZ613GQyyUPEs8W4jI1xQeifEqfFW0KbsjJTQ
	 Y46y/fAUp4gg4J5WzSnvMjbk5sFzxoPn5QVEgpMiTwGuDUTDdv9Pu0HhfCLv2KxAOY7pt
	 TDl7eq3xjwkPUHKdPCHzqDQluqLBmPHq6/Rq/nf0zaoyVhGZkOeo1hiK2sjaHofDiqXGH
	 gJeES0BRZlPE7VDd2fH4wOHk/Dr3Yn8PzZBEo7jhvXHPnMNkFrrCIfa/r1fue4s6j7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oofhSp5B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F95606A327;
	Wed, 25 Nov 2026 15:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oofhSp5B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED08A1F00A03;
	Wed, 25 Nov 2026 15:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619700;
	bh=sNKRUoFhh9txT53v/zlb/25ByWB+RsbqBrtBk6weyaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oofhSp5BWLKgR4MShHTsby/nPIz7aqlDRCg0Lpnx9sJeP3x9Bvc0sa+Ip8tBn2HiL
	 FcBhpC18ZNxACV669P1B/XWwwh4p0h2Q2dkyqHc5rJRHZ22Gy8/r8sx7JzWQyr/GFt
	 5XTm+pz6YiYS4b+EjmxmSv5qARHMDQ7gKJX3xFQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.3 0680/1005] power: sequencing: pcie-m2: fix use-after-free in pwrseq_pcie_m2_vregs_enable()
Date: Wed, 25 Nov 2026 15:33:38 +0100
Message-ID: <20261125143837.684081062@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit cd5f26ed96604b18e4235052525abe6b4ba505d6 upstream.

During device teardown or on the probe error path, a concurrent consumer
access triggers a use-after-free in pwrseq_pcie_m2_vregs_enable() or
pwrseq_pcie_m2_vregs_disable() due to a lifetime inversion between
devm-managed device registration and manual resource cleanup.

The driver exposes the power sequencer using devm_pwrseq_device_register(),
meaning the device remains fully registered and accessible on the
pwrseq_bus until the driver core schedules devm_pwrseq_device_unregister()
to run after pwrseq_pcie_m2_remove() returns. However, the driver performs
manual resource teardown within pwrseq_pcie_m2_remove() and the
pwrseq_pcie_m2_probe() error path, prematurely destroying the backing
regulator array.

This creates a narrow vulnerability window where the globally visible power
sequencer is backed by freed memory. If a concurrent consumer invokes
pwrseq_enable() during this window, execution is routed to the sequencer
callback and dereferences the destroyed ctx->regs array, resulting in a
direct use-after-free and a kernel crash.

Schedule a devres action for freeing the memory used for the regulator
array to ensure it runs *after* the pwrseq provider was unregistered.

Cc: stable@vger.kernel.org
Fixes: 3f736aecbdc8 ("power: sequencing: pcie-m2: Create serdev device for WCN7850 bluetooth")
Closes: https://sashiko.dev/#/bug/linux-bd17e5b1-a000-4717-b392-0ff0c2a9c376
Link: https://patch.msgid.link/20261105-pwrseq-pcie-m2-uaf-v2-1-3e1dd415af9a@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/sequencing/pwrseq-pcie-m2.c |   36 +++++++++++++++---------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/drivers/power/sequencing/pwrseq-pcie-m2.c
+++ b/drivers/power/sequencing/pwrseq-pcie-m2.c
@@ -492,6 +492,14 @@ err_remove_serdev:
 	return ret;
 }
 
+static void pwrseq_pcie_m2_free_regulators(void *data)
+{
+	struct pwrseq_pcie_m2_ctx *ctx = data;
+
+	regulator_bulk_free(ctx->num_vregs, ctx->regs);
+	kfree(ctx->regs);
+}
+
 static int pwrseq_pcie_m2_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -522,19 +530,19 @@ static int pwrseq_pcie_m2_probe(struct p
 
 	ctx->num_vregs = ret;
 
+	ret = devm_add_action_or_reset(dev, pwrseq_pcie_m2_free_regulators, ctx);
+	if (ret)
+		return ret;
+
 	ctx->w_disable1_gpio = devm_gpiod_get_optional(dev, "w-disable1", GPIOD_OUT_HIGH);
-	if (IS_ERR(ctx->w_disable1_gpio)) {
-		ret = dev_err_probe(dev, PTR_ERR(ctx->w_disable1_gpio),
+	if (IS_ERR(ctx->w_disable1_gpio))
+		return dev_err_probe(dev, PTR_ERR(ctx->w_disable1_gpio),
 				     "Failed to get the W_DISABLE_1# GPIO\n");
-		goto err_free_regulators;
-	}
 
 	ctx->w_disable2_gpio = devm_gpiod_get_optional(dev, "w-disable2", GPIOD_OUT_HIGH);
-	if (IS_ERR(ctx->w_disable2_gpio)) {
-		ret = dev_err_probe(dev, PTR_ERR(ctx->w_disable2_gpio),
+	if (IS_ERR(ctx->w_disable2_gpio))
+		return dev_err_probe(dev, PTR_ERR(ctx->w_disable2_gpio),
 				     "Failed to get the W_DISABLE_2# GPIO\n");
-		goto err_free_regulators;
-	}
 
 	config.parent = dev;
 	config.owner = THIS_MODULE;
@@ -543,11 +551,9 @@ static int pwrseq_pcie_m2_probe(struct p
 	config.targets = ctx->pdata->targets;
 
 	ctx->pwrseq = devm_pwrseq_device_register(dev, &config);
-	if (IS_ERR(ctx->pwrseq)) {
-		ret = dev_err_probe(dev, PTR_ERR(ctx->pwrseq),
+	if (IS_ERR(ctx->pwrseq))
+		return dev_err_probe(dev, PTR_ERR(ctx->pwrseq),
 				     "Failed to register the power sequencer\n");
-		goto err_free_regulators;
-	}
 
 	mutex_init(&ctx->list_lock);
 	INIT_LIST_HEAD(&ctx->pci_devices);
@@ -572,9 +578,6 @@ err_remove_serdev:
 	pwrseq_pcie_m2_remove_serdev(ctx, NULL);
 err_destroy_mutex:
 	mutex_destroy(&ctx->list_lock);
-err_free_regulators:
-	regulator_bulk_free(ctx->num_vregs, ctx->regs);
-	kfree(ctx->regs);
 
 	return ret;
 }
@@ -586,9 +589,6 @@ static void pwrseq_pcie_m2_remove(struct
 	bus_unregister_notifier(&pci_bus_type, &ctx->nb);
 	pwrseq_pcie_m2_remove_serdev(ctx, NULL);
 	mutex_destroy(&ctx->list_lock);
-
-	regulator_bulk_free(ctx->num_vregs, ctx->regs);
-	kfree(ctx->regs);
 }
 
 static const struct of_device_id pwrseq_pcie_m2_of_match[] = {


