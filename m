Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AC9129E6E;
	Mon,  4 Aug 2025 00:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267088; cv=none; b=etze1EodJU4n4kPi/ZJpXH9poboq0w96nqcpz/tadXhxKwKkDhrNf9BGL1rmM2nduyoifT84/E4atRp8Xs60mr976AmR2JDk5Q92UcBYUcYuOyJyWgz96P5mOfYZwdvwxLNiEIlqZCrAffHpO9CueUN8wU6d+5y7CNOot/3/wHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267088; c=relaxed/simple;
	bh=D+TJ0Ii3gg2DTkEdRbTGjABXCzpS1PjS1fT2tmTi2RI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OuG28gKvwmOi3M7nwIt6H9YbE14rA3U95S5Kkw5ar4C+lXmwXxEY36Jnb8eljw6qNJyDvgNlNcQaOiP43DL0wIxoaZ3omf+oJIe6EpuEza3Pj0hwczJ71u3JEhDRhWKzPoL2IVpacYmcizKGO80/Aszi8wL0NYvVHEqyI5sjSyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TsktKUNT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TsktKUNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCA4C4CEEB;
	Mon,  4 Aug 2025 00:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267088;
	bh=D+TJ0Ii3gg2DTkEdRbTGjABXCzpS1PjS1fT2tmTi2RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TsktKUNTtkslSxP0OoGg5GDMlDjGICFmrPQmUznoYqF7ytBTz3/IbBHyO0Lo60YmZ
	 PHBGAJIWl3HCRr5GG1bwe6BJp/GjKF5InSHF7x5+o87lIesMvFbAvIXDbhLgTA8H8O
	 f04L9lCEb6GYCahmbTYjYgO4vwDDImWb0V+QenA/PGkUjmjhV5U9OxlISygkqmejfx
	 0egjCe974e8o5EoW0YTARhfELxZMaH6R36qsf956p7XQm50akdFZ8mJaV8weMlchyH
	 Enuc1Q0cHsxWF42S/oRQgdcIaeeQReozSuaXOfKH1jGUe66tH+hYP8LskztuZFEFLK
	 TPgHhq9MX4VPw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	heikki.krogerus@linux.intel.com,
	kyletso@google.com,
	amitsd@google.com,
	krzysztof.kozlowski@linaro.org
Subject: [PATCH AUTOSEL 6.16 21/85] usb: typec: tcpm/tcpci_maxim: fix irq wake usage
Date: Sun,  3 Aug 2025 20:22:30 -0400
Message-Id: <20250804002335.3613254-21-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002335.3613254-1-sashal@kernel.org>
References: <20250804002335.3613254-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
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
index b5a5ed40faea..ff3604be79da 100644
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
@@ -544,6 +531,32 @@ static int max_tcpci_probe(struct i2c_client *client)
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
@@ -562,6 +575,7 @@ static struct i2c_driver max_tcpci_i2c_driver = {
 	.driver = {
 		.name = "maxtcpc",
 		.of_match_table = of_match_ptr(max_tcpci_of_match),
+		.pm = &max_tcpci_pm_ops,
 	},
 	.probe = max_tcpci_probe,
 	.id_table = max_tcpci_id,
-- 
2.39.5

