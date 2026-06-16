Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73050318EDA;
	Tue, 16 Jun 2026 19:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636599; cv=none; b=QSZPZyzCvQD4XM59GtRKHOM+T+iqb3iVwThQSv30pxda3Pk9/0rUWh0PIHMpnsa37kHDCmEc/w9cJf5h89LXzY5p0sO53CGXnwC13noR9Tnhg0rypTameM9s0wwz+JdRj8d0V0UqWNsLNG2MT4/RU55lnktF5hFFDH1X46TBsJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636599; c=relaxed/simple;
	bh=xH9q9tKHCkp71pPfdXJ+SslGoFxmVy2GtU7RcoAGPyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rk+s9jZo4yRMXBMyZpM1gU0OB7IG5mxJNF+LYmJWcZT5PWhEAJFh1p0P5xXNXmRJlyqdeCQc40bfTERr32rgpfuPbPE971ftAF1k+YRN9VV6+ksLqWTiqwvpomFH8UrtbDjHBg8DgRyQBQzP5yw6gnVLovMN3jQ9O2/6MGZ/o3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xL0V2DBx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xL0V2DBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1F51F000E9;
	Tue, 16 Jun 2026 19:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636598;
	bh=tfd0XBTbnGh0UcmGA0PCYb6AgJVPwf6Rhx7o2xPjaLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xL0V2DBxB3OIaVONzpVE2q5Zab67l7+NGixQhNVlmP+E/U0w+c+QUaHrcN7A0t7uI
	 tYwhnhV1tvJN+D8vxi9+jVYaEpvANkwkr1yQTTMHtYoBOdb0pYVL9eftaaerd79etb
	 iGY77ElaWLpmpL4cyEndcp3qKz3Z3cKI3yyiLguU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 269/342] pmdomain: core: Fix detach procedure for virtual devices in genpd
Date: Tue, 16 Jun 2026 20:29:25 +0530
Message-ID: <20260616145100.845963441@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 26735dfdd8930d9ef1fa92e590a9bf77726efdf6 ]

If a device is attached to a PM domain through genpd_dev_pm_attach_by_id(),
genpd calls pm_runtime_enable() for the corresponding virtual device that
it registers. While this avoids boilerplate code in drivers, there is no
corresponding call to pm_runtime_disable() in genpd_dev_pm_detach().

This means these virtual devices are typically detached from its genpd,
while runtime PM remains enabled for them, which is not how things are
designed to work. In worst cases it may lead to critical errors, like a
NULL pointer dereference bug in genpd_runtime_suspend(), which was recently
reported. For another case, we may end up keeping an unnecessary vote for a
performance state for the device.

To fix these problems, let's add this missing call to pm_runtime_disable()
in genpd_dev_pm_detach().

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Closes: https://lore.kernel.org/all/CAMuHMdWapT40hV3c+CSBqFOW05aWcV1a6v_NiJYgoYi0i9_PDQ@mail.gmail.com/
Fixes: 3c095f32a92b ("PM / Domains: Add support for multi PM domains per device to genpd")
Cc: stable@vger.kernel.org
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
[ dropped upstream context block referencing nonexistent `default_pstate` field ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/domain.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -2525,6 +2525,7 @@ static struct bus_type genpd_bus_type =
 static void genpd_dev_pm_detach(struct device *dev, bool power_off)
 {
 	struct generic_pm_domain *pd;
+	bool is_virt_dev;
 	unsigned int i;
 	int ret = 0;
 
@@ -2534,6 +2535,13 @@ static void genpd_dev_pm_detach(struct d
 
 	dev_dbg(dev, "removing from PM domain %s\n", pd->name);
 
+	/* Check if the device was created by genpd at attach. */
+	is_virt_dev = dev->bus == &genpd_bus_type;
+
+	/* Disable runtime PM if we enabled it at attach. */
+	if (is_virt_dev)
+		pm_runtime_disable(dev);
+
 	for (i = 1; i < GENPD_RETRY_MAX_MS; i <<= 1) {
 		ret = genpd_remove_device(pd, dev);
 		if (ret != -EAGAIN)
@@ -2553,7 +2561,7 @@ static void genpd_dev_pm_detach(struct d
 	genpd_queue_power_off_work(pd);
 
 	/* Unregister the device if it was created by genpd. */
-	if (dev->bus == &genpd_bus_type)
+	if (is_virt_dev)
 		device_unregister(dev);
 }
 


