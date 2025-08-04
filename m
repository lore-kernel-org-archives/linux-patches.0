Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B396215A8;
	Mon,  4 Aug 2025 00:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267519; cv=none; b=fKCVJqLxumDxix8nOFzSbOm/Okqjn1vkVh/4v5lCI/jln70zh2RsjX3earMg14kR46S0U7Mf7XBn7Xc1kGFz31J4KZLKcupmVK+eyH27y2j3glBKCFoK+DrGxEoT31Z3oMMtRleZaNg8fhiyk2TmQ2vDElMYd4h8n/bqqxeRIMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267519; c=relaxed/simple;
	bh=N5C90kP997xdiI2NjRwXCsSFjrsArUe09K7rB+aKgac=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M3IJp6hE0+DBNE4d0GUbZD/sVle1bY8Ud3TjIOxxi1NbpRyFmraZHX130xFClIo1pL5sF/HwXagcOvP918ogs6v/UsabraL9gdtVLnvgAGDi2kuuxQ+4KbsioMPVFVIl46BPRnJ7vxkKO8lJWxqcRJFmdfzi1/P9YZG3Q9nePT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FyShjCbh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FyShjCbh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A90C4CEEB;
	Mon,  4 Aug 2025 00:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267519;
	bh=N5C90kP997xdiI2NjRwXCsSFjrsArUe09K7rB+aKgac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FyShjCbhWTfD6Adl7XiCOOU9ZRhhmctmTd/Sc5Yj3wirKLjcaGX2ZGmrFQPSyms2g
	 LodB1SEXMBt2zZKjb3xTQ0Uja9532ajX/OQA3w8E3IAYdODezicio4gsjx7jBpLyUl
	 LERD69mS0VRW4jVLcOdqbO7TsbTYrOa+CJbJRu0YrjbEHSlw1/ySrGOTQ1IpwY75/Y
	 kGlm3ekcX6cwwawV8YfumxMUNtbP+AOtmcKdyS9ihhvfyG20n5GJdUl2FI/cDSFxvE
	 EluEDUBQlD6LCTeJJbRlF68+Q6mqhQSW+ATYUo/VTiMJ6ZvPrJuiqLbtooJWQ+hLfn
	 wId9rQ4XIuLIw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	heikki.krogerus@linux.intel.com,
	krzysztof.kozlowski@linaro.org,
	amitsd@google.com
Subject: [PATCH AUTOSEL 6.12 14/69] usb: typec: tcpm/tcpci_maxim: fix irq wake usage
Date: Sun,  3 Aug 2025 20:30:24 -0400
Message-Id: <20250804003119.3620476-14-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003119.3620476-1-sashal@kernel.org>
References: <20250804003119.3620476-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.41
Content-Transfer-Encoding: 8bit

From: André Draszik <andre.draszik@linaro.org>

[ Upstream commit 31611223fb34a3e9320cdfc4f4395072a13ea78e ]

This driver calls enable_irq_wake() during probe() unconditionally, and
never issues the required corresponding disable_irq_wake() to disable
hardware interrupt wakeup signals.

Additionally, whether or not a device should wake-up the system is
meant to be a policy decision based on sysfs (.../power/wakeup) in the
first place.

Update the driver to use the standard approach to enable/disable IRQ
wake during the suspend/resume callbacks. This solves both issues
described above.

Signed-off-by: André Draszik <andre.draszik@linaro.org>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Link: https://lore.kernel.org/r/20250707-max77759-irq-wake-v1-1-d367f633e4bc@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Clear Bug Fix**: The commit fixes a resource management bug where
   `enable_irq_wake()` is called during probe without a corresponding
   `disable_irq_wake()`. This violates the kernel's IRQ wake API usage
   requirements, leading to:
   - Resource leak in the IRQ subsystem
   - Incorrect wake behavior that cannot be controlled via sysfs
   - Potential system power management issues

2. **Small and Contained Change**: The fix is minimal and well-
   contained:
   - Removes the problematic `max_tcpci_init_alert()` function
   - Moves IRQ request directly into probe
   - Adds proper suspend/resume callbacks with correct
     `enable_irq_wake()`/`disable_irq_wake()` pairing
   - Total change is about 40 lines of straightforward code

3. **Low Risk of Regression**:
   - The change follows established kernel patterns for IRQ wake
     handling in PM callbacks
   - Similar patterns exist in other USB Type-C drivers (e.g., fusb302.c
     uses suspend/resume for IRQ wake)
   - The fix only affects power management behavior, not core
     functionality
   - Uses `device_may_wakeup()` to properly check policy before enabling
     wake

4. **Clear Impact on Users**:
   - Without this fix, devices cannot properly control wake-on-USB-C
     events through sysfs
   - The unconditional `enable_irq_wake()` means the device will always
     wake the system on USB-C events, regardless of user preference
   - This affects power consumption and battery life on systems with USB
     Type-C

5. **No Architectural Changes**: The commit:
   - Doesn't introduce new features
   - Doesn't change any APIs or interfaces
   - Simply fixes incorrect usage of existing kernel APIs
   - Maintains backward compatibility

The commit message clearly explains the problem and solution, the code
changes are minimal and correct, and it fixes a real bug that affects
system power management behavior. This is exactly the type of fix that
stable kernels should receive.

 drivers/usb/typec/tcpm/tcpci_maxim_core.c | 46 +++++++++++++++--------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpci_maxim_core.c b/drivers/usb/typec/tcpm/tcpci_maxim_core.c
index 648311f5e3cf..eeaf79e97261 100644
--- a/drivers/usb/typec/tcpm/tcpci_maxim_core.c
+++ b/drivers/usb/typec/tcpm/tcpci_maxim_core.c
@@ -421,21 +421,6 @@ static irqreturn_t max_tcpci_isr(int irq, void *dev_id)
 	return IRQ_WAKE_THREAD;
 }
 
-static int max_tcpci_init_alert(struct max_tcpci_chip *chip, struct i2c_client *client)
-{
-	int ret;
-
-	ret = devm_request_threaded_irq(chip->dev, client->irq, max_tcpci_isr, max_tcpci_irq,
-					(IRQF_TRIGGER_LOW | IRQF_ONESHOT), dev_name(chip->dev),
-					chip);
-
-	if (ret < 0)
-		return ret;
-
-	enable_irq_wake(client->irq);
-	return 0;
-}
-
 static int max_tcpci_start_toggling(struct tcpci *tcpci, struct tcpci_data *tdata,
 				    enum typec_cc_status cc)
 {
@@ -532,7 +517,9 @@ static int max_tcpci_probe(struct i2c_client *client)
 
 	chip->port = tcpci_get_tcpm_port(chip->tcpci);
 
-	ret = max_tcpci_init_alert(chip, client);
+	ret = devm_request_threaded_irq(&client->dev, client->irq, max_tcpci_isr, max_tcpci_irq,
+					(IRQF_TRIGGER_LOW | IRQF_ONESHOT), dev_name(chip->dev),
+					chip);
 	if (ret < 0)
 		return dev_err_probe(&client->dev, ret,
 				     "IRQ initialization failed\n");
@@ -541,6 +528,32 @@ static int max_tcpci_probe(struct i2c_client *client)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int max_tcpci_resume(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	int ret = 0;
+
+	if (client->irq && device_may_wakeup(dev))
+		ret = disable_irq_wake(client->irq);
+
+	return ret;
+}
+
+static int max_tcpci_suspend(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	int ret = 0;
+
+	if (client->irq && device_may_wakeup(dev))
+		ret = enable_irq_wake(client->irq);
+
+	return ret;
+}
+#endif /* CONFIG_PM_SLEEP */
+
+static SIMPLE_DEV_PM_OPS(max_tcpci_pm_ops, max_tcpci_suspend, max_tcpci_resume);
+
 static const struct i2c_device_id max_tcpci_id[] = {
 	{ "maxtcpc" },
 	{ }
@@ -559,6 +572,7 @@ static struct i2c_driver max_tcpci_i2c_driver = {
 	.driver = {
 		.name = "maxtcpc",
 		.of_match_table = of_match_ptr(max_tcpci_of_match),
+		.pm = &max_tcpci_pm_ops,
 	},
 	.probe = max_tcpci_probe,
 	.id_table = max_tcpci_id,
-- 
2.39.5

