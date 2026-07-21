Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C463543C06B;
	Tue, 21 Jul 2026 20:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667442; cv=none; b=QjodMI21K12sqGR9DK8iMpTnaLXCVqvfsJSH0hloB0IBgyo4KsinCSDzoPagCsaJQUm13NjAyfLGABhne0cDgb94kE2J4sztW1/l/klxMUc4DzC9nxVHYO9suTMKILi3PL4Q/hAaFkicA7SRA6kLc3sVTXB/MjeCe/r1zYI4jw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667442; c=relaxed/simple;
	bh=RbjhoN4ovPfop+C7X604mnpV0h1Ja3GS4a81KxItC/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TxQz8dupe3Y5uOIOkNtAS5zFET9610Pe647GhHhkpZ3duaNZBSdx3FxS9/Sn4CvSAqUQOXDbuv8MqvWinkH4cH9wy2VHHK61ZsW4j3YtPjn++xYTrH9noQjRmhReooZV3bR+WNS+w2e9AKJgB+o+ZLTR1zd0lPKVjl9WYds1iKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2AghBBdZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2AghBBdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E861F00A3E;
	Tue, 21 Jul 2026 20:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667440;
	bh=bxY2KtPqCkTeWo6JmDcc0dH7p3JBdHFP6J7d2CcVEE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2AghBBdZIX62lLqcRmArVlKJMa0+vozeNCGNobAYPdNIVuaAMl5gNx0LhwLNsse3S
	 P+xvY4Do2MFGqkoc+Rqq0M2juVk8yhFp4XQ5HLkrHBqNjrcktnzrBwfFalNlFDvNuB
	 JCwv6ArwcWhaLctyr9aqzaEUFFzMtj+WGzeN0gf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sindre Henriksen <sindrehenriksen93@gmail.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Daniel Gibson <daniel@gibson.sh>
Subject: [PATCH 6.6 1019/1266] platform/x86/amd/pmc: Delay suspend for some Lenovo Laptops
Date: Tue, 21 Jul 2026 17:24:16 +0200
Message-ID: <20260721152504.630096376@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Gibson <daniel@gibson.sh>

commit 9b9e60dd31da054a37d601e9fcabdfd8a2bff354 upstream.

Some IdeaPad Slim 3 devices and similar with AMD CPUs have a
nonfunctional keyboard and lid switch after s2idle.

It helps to delay suspend by 2.5 seconds so the EC has some time
to do whatever it needs to get done before suspend - unfortunately
at least on my 16ABR8 waking it with a timer (wakealarm) still
triggers the issue, but at least normal resume via keypress or
lid works fine. On the 14ARP10 wakealarm has been reported to also
work fine with this patch.

This issue has been reported for many different devices, this patch
has been tested with the Zen3-based IdeaPad Slim 3 16ABR8 (82XR)
and the Zen3+-based IdeaPad Slim 3 14ARP10 (83K6) and IdeaPad Slim 3
15ARP10 (83MM).

Reported-by: Sindre Henriksen <sindrehenriksen93@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221383
Tested-by: Sindre Henriksen <sindrehenriksen93@gmail.com>
Suggested-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Daniel Gibson <daniel@gibson.sh>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260611150426.3683372-3-daniel@gibson.sh
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmc/pmc-quirks.c |   39 ++++++++++++++++++++++++++++++
 drivers/platform/x86/amd/pmc/pmc.c        |   24 +++++++++++++++++-
 drivers/platform/x86/amd/pmc/pmc.h        |    1 
 3 files changed, 63 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -17,6 +17,7 @@
 struct quirk_entry {
 	u32 s2idle_bug_mmio;
 	bool spurious_8042;
+	bool need_suspend_delay;
 };
 
 static struct quirk_entry quirk_s2idle_bug = {
@@ -27,6 +28,10 @@ static struct quirk_entry quirk_spurious
 	.spurious_8042 = true,
 };
 
+static struct quirk_entry quirk_s2idle_need_suspend_delay = {
+	.need_suspend_delay = true,
+};
+
 static const struct dmi_system_id fwbug_list[] = {
 	{
 		.ident = "L14 Gen2 AMD",
@@ -197,6 +202,35 @@ static const struct dmi_system_id fwbug_
 			DMI_MATCH(DMI_PRODUCT_NAME, "82XQ"),
 		}
 	},
+	/* https://bugzilla.kernel.org/show_bug.cgi?id=221383 */
+	{
+		.ident = "Zen3-based IdeaPad Slim and similar",
+		.driver_data = &quirk_s2idle_need_suspend_delay,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			/*
+			 * Note: there are also some Zen2-based 82X* devices that
+			 * need different quirks, they're already handled above
+			 */
+			DMI_MATCH(DMI_PRODUCT_NAME, "82X"),
+		}
+	},
+	{
+		.ident = "Zen3+-based IdeaPad Slim and similar",
+		.driver_data = &quirk_s2idle_need_suspend_delay,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83K"),
+		}
+	},
+	{
+		.ident = "IdeaPad Slim 3 15ARP10 (83MM)",
+		.driver_data = &quirk_s2idle_need_suspend_delay,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83MM"),
+		}
+	},
 	/* https://bugzilla.kernel.org/show_bug.cgi?id=221273 */
 	{
 		.ident = "Thinkpad L14 Gen3",
@@ -350,6 +384,11 @@ void amd_pmc_process_restore_quirks(stru
 		amd_pmc_skip_nvme_smi_handler(dev->quirks->s2idle_bug_mmio);
 }
 
+bool amd_pmc_quirk_need_suspend_delay(struct amd_pmc_dev *dev)
+{
+	return dev->quirks && dev->quirks->need_suspend_delay;
+}
+
 void amd_pmc_quirks_init(struct amd_pmc_dev *dev)
 {
 	const struct dmi_system_id *dmi_id;
--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -803,6 +803,27 @@ static bool amd_pmc_intermediate_wakeup_
 	return get_metrics_table(pdev, &table) == 0 && table.s0i3_last_entry_status;
 }
 
+static bool amd_pmc_want_suspend_delay(struct amd_pmc_dev *pdev)
+{
+	/*
+	 * Some Lenovo Laptops (like different IdeaPad 3 Slims) need some
+	 * me-time before sleeping or they get uncooperative after waking
+	 * up and don't send events for keyboard and lid switch anymore.
+	 *
+	 * Unfortunately this doesn't entirely fix the problem: It can still
+	 * happen when resuming with a timer (wakealarm), but at least the
+	 * more common usecases (wakeup by opening lid or pressing a key)
+	 * work fine with this workaround.
+	 *
+	 * See https://bugzilla.kernel.org/show_bug.cgi?id=221383
+	 */
+	if (!disable_workarounds && amd_pmc_quirk_need_suspend_delay(pdev)) {
+		dev_info(pdev->dev, "Delaying suspend by 2.5s to avoid platform bug\n");
+		return true;
+	}
+	return false;
+}
+
 static void amd_pmc_s2idle_prepare(void)
 {
 	struct amd_pmc_dev *pdev = &pmc;
@@ -839,7 +860,8 @@ static void amd_pmc_s2idle_check(void)
 	struct amd_pmc_dev *pdev = &pmc;
 	int rc;
 
-	if (amd_pmc_intermediate_wakeup_need_delay(pdev))
+	if (amd_pmc_intermediate_wakeup_need_delay(pdev) ||
+	    amd_pmc_want_suspend_delay(pdev))
 		msleep(2500);
 
 	/* Dump the IdleMask before we add to the STB */
--- a/drivers/platform/x86/amd/pmc/pmc.h
+++ b/drivers/platform/x86/amd/pmc/pmc.h
@@ -40,6 +40,7 @@ struct amd_pmc_dev {
 };
 
 void amd_pmc_process_restore_quirks(struct amd_pmc_dev *dev);
+bool amd_pmc_quirk_need_suspend_delay(struct amd_pmc_dev *dev);
 void amd_pmc_quirks_init(struct amd_pmc_dev *dev);
 
 /* List of supported CPU ids */


