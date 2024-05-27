Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B5C17727;
	Mon, 27 May 2024 19:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838223; cv=none; b=OS+IM8T/bK+VOqMssILU6aQAPWB5CjRt00cI7V1XlrkNcCWl08p6XSxd9ICLqLpLsNF1bdR39ZjzYd8hqw52CqVlgDvA/71PTzSzdz+odk+ZGWRL4nlwVYVrgvLxv6YnAqNjjo9vGpLChuwCHLdkH+L3mW6kAcQVJs/r1eVhYZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838223; c=relaxed/simple;
	bh=OoHJZV9zICArvuZVPgSku1h9WE82nLST84U6ZFXbh6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qY9g/v033OuRE0OLeeJUaWMvC0uxsSK4DFMXchK6uQmJxDJhXI/gNjHLTIZ4kOZImkYs7a5MZeMjFeK4SSOib3HA8gVBhahqK0vP+cv43RY1a1lYYV2FnCXwiLQmCxUkSwad/ZCtPAwyGOBAkVWH/DEJCMz2azrSyjhKNoGxfXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xb5yzM98; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xb5yzM98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337E6C2BBFC;
	Mon, 27 May 2024 19:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838223;
	bh=OoHJZV9zICArvuZVPgSku1h9WE82nLST84U6ZFXbh6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xb5yzM98p8HFotOB78a/7fWA04CJJjKS43MTCZmr6VEvEO+ARVoJDnRzcbruqTFhC
	 0OJp8EW6Qckz2Cn8/M2r6e28tEuxVjknQrDygAnVhLxS5ZxXLRVIaQB9nay4PaIqDd
	 xch6ZABX5MJaFZ5D6n56nF5N2XzaGMzoB3OzAdAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 261/493] pwm: Provide an inline function to get the parent device of a given chip
Date: Mon, 27 May 2024 20:54:23 +0200
Message-ID: <20240527185638.825586838@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 4e59267c7a20eb1c1ad9106e682cb6a0d8eb3111 ]

Currently a pwm_chip stores in its struct device *dev member a pointer
to the parent device. Preparing a change that embeds a full struct
device in struct pwm_chip, this accessor function should be used in all
drivers directly accessing chip->dev now. This way struct pwm_chip and
this new function can be changed without having to touch all drivers in
the same change set.

Make use of this function in the framework's core sources.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/cc30090d2f9762bed9854a55612144bccc910781.1707900770.git.u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Stable-dep-of: 3e551115aee0 ("pwm: meson: Add check for error from clk_round_rate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/core.c  | 42 +++++++++++++++++++++---------------------
 drivers/pwm/sysfs.c |  4 ++--
 include/linux/pwm.h |  5 +++++
 3 files changed, 28 insertions(+), 23 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 1b4c3d0caa824..830a697826af5 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -71,18 +71,18 @@ static void pwm_apply_debug(struct pwm_device *pwm,
 
 	if (s2.polarity != state->polarity &&
 	    state->duty_cycle < state->period)
-		dev_warn(chip->dev, ".apply ignored .polarity\n");
+		dev_warn(pwmchip_parent(chip), ".apply ignored .polarity\n");
 
 	if (state->enabled &&
 	    last->polarity == state->polarity &&
 	    last->period > s2.period &&
 	    last->period <= state->period)
-		dev_warn(chip->dev,
+		dev_warn(pwmchip_parent(chip),
 			 ".apply didn't pick the best available period (requested: %llu, applied: %llu, possible: %llu)\n",
 			 state->period, s2.period, last->period);
 
 	if (state->enabled && state->period < s2.period)
-		dev_warn(chip->dev,
+		dev_warn(pwmchip_parent(chip),
 			 ".apply is supposed to round down period (requested: %llu, applied: %llu)\n",
 			 state->period, s2.period);
 
@@ -91,20 +91,20 @@ static void pwm_apply_debug(struct pwm_device *pwm,
 	    last->period == s2.period &&
 	    last->duty_cycle > s2.duty_cycle &&
 	    last->duty_cycle <= state->duty_cycle)
-		dev_warn(chip->dev,
+		dev_warn(pwmchip_parent(chip),
 			 ".apply didn't pick the best available duty cycle (requested: %llu/%llu, applied: %llu/%llu, possible: %llu/%llu)\n",
 			 state->duty_cycle, state->period,
 			 s2.duty_cycle, s2.period,
 			 last->duty_cycle, last->period);
 
 	if (state->enabled && state->duty_cycle < s2.duty_cycle)
-		dev_warn(chip->dev,
+		dev_warn(pwmchip_parent(chip),
 			 ".apply is supposed to round down duty_cycle (requested: %llu/%llu, applied: %llu/%llu)\n",
 			 state->duty_cycle, state->period,
 			 s2.duty_cycle, s2.period);
 
 	if (!state->enabled && s2.enabled && s2.duty_cycle > 0)
-		dev_warn(chip->dev,
+		dev_warn(pwmchip_parent(chip),
 			 "requested disabled, but yielded enabled with duty > 0\n");
 
 	/* reapply the state that the driver reported being configured. */
@@ -112,7 +112,7 @@ static void pwm_apply_debug(struct pwm_device *pwm,
 	trace_pwm_apply(pwm, &s1, err);
 	if (err) {
 		*last = s1;
-		dev_err(chip->dev, "failed to reapply current setting\n");
+		dev_err(pwmchip_parent(chip), "failed to reapply current setting\n");
 		return;
 	}
 
@@ -127,7 +127,7 @@ static void pwm_apply_debug(struct pwm_device *pwm,
 	    s1.polarity != last->polarity ||
 	    (s1.enabled && s1.period != last->period) ||
 	    (s1.enabled && s1.duty_cycle != last->duty_cycle)) {
-		dev_err(chip->dev,
+		dev_err(pwmchip_parent(chip),
 			".apply is not idempotent (ena=%d pol=%d %llu/%llu) -> (ena=%d pol=%d %llu/%llu)\n",
 			s1.enabled, s1.polarity, s1.duty_cycle, s1.period,
 			last->enabled, last->polarity, last->duty_cycle,
@@ -318,7 +318,7 @@ static struct pwm_chip *pwmchip_find_by_name(const char *name)
 	mutex_lock(&pwm_lock);
 
 	idr_for_each_entry_ul(&pwm_chips, chip, tmp, id) {
-		const char *chip_name = dev_name(chip->dev);
+		const char *chip_name = dev_name(pwmchip_parent(chip));
 
 		if (chip_name && strcmp(chip_name, name) == 0) {
 			mutex_unlock(&pwm_lock);
@@ -456,19 +456,19 @@ EXPORT_SYMBOL_GPL(of_pwm_single_xlate);
 
 static void of_pwmchip_add(struct pwm_chip *chip)
 {
-	if (!chip->dev || !chip->dev->of_node)
+	if (!pwmchip_parent(chip) || !pwmchip_parent(chip)->of_node)
 		return;
 
 	if (!chip->of_xlate)
 		chip->of_xlate = of_pwm_xlate_with_flags;
 
-	of_node_get(chip->dev->of_node);
+	of_node_get(pwmchip_parent(chip)->of_node);
 }
 
 static void of_pwmchip_remove(struct pwm_chip *chip)
 {
-	if (chip->dev)
-		of_node_put(chip->dev->of_node);
+	if (pwmchip_parent(chip))
+		of_node_put(pwmchip_parent(chip)->of_node);
 }
 
 static bool pwm_ops_check(const struct pwm_chip *chip)
@@ -479,7 +479,7 @@ static bool pwm_ops_check(const struct pwm_chip *chip)
 		return false;
 
 	if (IS_ENABLED(CONFIG_PWM_DEBUG) && !ops->get_state)
-		dev_warn(chip->dev,
+		dev_warn(pwmchip_parent(chip),
 			 "Please implement the .get_state() callback\n");
 
 	return true;
@@ -500,7 +500,7 @@ int __pwmchip_add(struct pwm_chip *chip, struct module *owner)
 	unsigned int i;
 	int ret;
 
-	if (!chip || !chip->dev || !chip->ops || !chip->npwm)
+	if (!chip || !pwmchip_parent(chip) || !chip->ops || !chip->npwm)
 		return -EINVAL;
 
 	if (!pwm_ops_check(chip))
@@ -594,15 +594,15 @@ static struct device_link *pwm_device_link_add(struct device *dev,
 		 * impact the PM sequence ordering: the PWM supplier may get
 		 * suspended before the consumer.
 		 */
-		dev_warn(pwm->chip->dev,
+		dev_warn(pwmchip_parent(pwm->chip),
 			 "No consumer device specified to create a link to\n");
 		return NULL;
 	}
 
-	dl = device_link_add(dev, pwm->chip->dev, DL_FLAG_AUTOREMOVE_CONSUMER);
+	dl = device_link_add(dev, pwmchip_parent(pwm->chip), DL_FLAG_AUTOREMOVE_CONSUMER);
 	if (!dl) {
 		dev_err(dev, "failed to create device link to %s\n",
-			dev_name(pwm->chip->dev));
+			dev_name(pwmchip_parent(pwm->chip)));
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -617,7 +617,7 @@ static struct pwm_chip *fwnode_to_pwmchip(struct fwnode_handle *fwnode)
 	mutex_lock(&pwm_lock);
 
 	idr_for_each_entry_ul(&pwm_chips, chip, tmp, id)
-		if (chip->dev && device_match_fwnode(chip->dev, fwnode)) {
+		if (pwmchip_parent(chip) && device_match_fwnode(pwmchip_parent(chip), fwnode)) {
 			mutex_unlock(&pwm_lock);
 			return chip;
 		}
@@ -1085,8 +1085,8 @@ static int pwm_seq_show(struct seq_file *s, void *v)
 
 	seq_printf(s, "%s%d: %s/%s, %d PWM device%s\n",
 		   (char *)s->private, chip->id,
-		   chip->dev->bus ? chip->dev->bus->name : "no-bus",
-		   dev_name(chip->dev), chip->npwm,
+		   pwmchip_parent(chip)->bus ? pwmchip_parent(chip)->bus->name : "no-bus",
+		   dev_name(pwmchip_parent(chip)), chip->npwm,
 		   (chip->npwm != 1) ? "s" : "");
 
 	pwm_dbg_show(chip, s);
diff --git a/drivers/pwm/sysfs.c b/drivers/pwm/sysfs.c
index 1698609d91c8a..3f434a771fb52 100644
--- a/drivers/pwm/sysfs.c
+++ b/drivers/pwm/sysfs.c
@@ -509,10 +509,10 @@ void pwmchip_sysfs_export(struct pwm_chip *chip)
 	 * If device_create() fails the pwm_chip is still usable by
 	 * the kernel it's just not exported.
 	 */
-	parent = device_create(&pwm_class, chip->dev, MKDEV(0, 0), chip,
+	parent = device_create(&pwm_class, pwmchip_parent(chip), MKDEV(0, 0), chip,
 			       "pwmchip%d", chip->id);
 	if (IS_ERR(parent)) {
-		dev_warn(chip->dev,
+		dev_warn(pwmchip_parent(chip),
 			 "device_create failed for pwm_chip sysfs export\n");
 	}
 }
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index 8ffe9ae7a23a9..07af6910bdced 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -289,6 +289,11 @@ struct pwm_chip {
 	struct pwm_device *pwms;
 };
 
+static inline struct device *pwmchip_parent(const struct pwm_chip *chip)
+{
+	return chip->dev;
+}
+
 #if IS_ENABLED(CONFIG_PWM)
 /* PWM user APIs */
 int pwm_apply_might_sleep(struct pwm_device *pwm, const struct pwm_state *state);
-- 
2.43.0



