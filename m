Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BA12EE97A;
	Thu,  3 Jul 2025 15:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555598; cv=none; b=UBF4Bb5A4riLDl6XJ/bguwY5OKUcwU+7hlPFRN4V/+Yu87PKayedcA6bVerQd5mIIHqNAEZUXogS6q8ZYmAmqPq8Xm7BKV2K62O2+BoAX+VrYoyd6IJJncqNJwRcC3j0i10si5WjV637zxWlHMxPj6E1tklloapyr6EftCasxEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555598; c=relaxed/simple;
	bh=Sb/mvuPivGY/unYhybt+7fb9TSzV2PL7sp0+x1fHm3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=As0yDTK4L9k+odvlcVazRxf4kjTBptGcP8jRcNWdyOvr085hieXsRuX2H5GWdbgu0u1PAMUyI3kG4jSOsANpczBOvZ2pZHrYvby3WBXjdzjiZc6C8+a0rybuJiz850EcxzfD2RJ6RR1xy2Szr1RBDTNKL8uTFHJuJu8Ao7x8aWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eN51xFTG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eN51xFTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65428C4CEE3;
	Thu,  3 Jul 2025 15:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555597;
	bh=Sb/mvuPivGY/unYhybt+7fb9TSzV2PL7sp0+x1fHm3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eN51xFTGBbz2Qcw6rc0vvZFJ47TJdUnqDTBTwsISfVhicTdEhUn/UMMZE2XirkTfa
	 +PouJCTVtO2kBHGZmTV1LYJyVSh23z3CHAEPuJF11I0rhLw+MqYX0qEOmoA/WUPQ9Y
	 TTWIiMN86S6pt/pi06IBCKZfwogH2pxv+NHfl+3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/139] platform/x86: ideapad-laptop: introduce a generic notification chain
Date: Thu,  3 Jul 2025 16:42:05 +0200
Message-ID: <20250703143943.593695575@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Gergo Koteles <soyer@irl.hu>

[ Upstream commit 613e3900c24bb1379d994f44d75d31c3223cc263 ]

There are several cases where a notification chain can simplify Lenovo
WMI drivers.

Add a generic notification chain into ideapad-laptop.

Signed-off-by: Gergo Koteles <soyer@irl.hu>
Link: https://lore.kernel.org/r/c5a43efae8a32bd034c3d19c0a686941347575a7.1721898747.git.soyer@irl.hu
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 5808c3421695 ("platform/x86: ideapad-laptop: use usleep_range() for EC polling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/ideapad-laptop.c | 37 +++++++++++++++++++++++++++
 drivers/platform/x86/ideapad-laptop.h |  5 ++++
 2 files changed, 42 insertions(+)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 50013af0537c3..e21b4dcfe1ddd 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -1501,6 +1501,39 @@ static void ideapad_sync_touchpad_state(struct ideapad_private *priv, bool send_
 	priv->r_touchpad_val = value;
 }
 
+static int ideapad_laptop_nb_notify(struct notifier_block *nb,
+				    unsigned long action, void *data)
+{
+	switch (action) {
+	}
+
+	return 0;
+}
+
+static struct notifier_block ideapad_laptop_notifier = {
+	.notifier_call = ideapad_laptop_nb_notify,
+};
+
+static BLOCKING_NOTIFIER_HEAD(ideapad_laptop_chain_head);
+
+int ideapad_laptop_register_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&ideapad_laptop_chain_head, nb);
+}
+EXPORT_SYMBOL_NS_GPL(ideapad_laptop_register_notifier, IDEAPAD_LAPTOP);
+
+int ideapad_laptop_unregister_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_unregister(&ideapad_laptop_chain_head, nb);
+}
+EXPORT_SYMBOL_NS_GPL(ideapad_laptop_unregister_notifier, IDEAPAD_LAPTOP);
+
+void ideapad_laptop_call_notifier(unsigned long action, void *data)
+{
+	blocking_notifier_call_chain(&ideapad_laptop_chain_head, action, data);
+}
+EXPORT_SYMBOL_NS_GPL(ideapad_laptop_call_notifier, IDEAPAD_LAPTOP);
+
 static void ideapad_acpi_notify(acpi_handle handle, u32 event, void *data)
 {
 	struct ideapad_private *priv = data;
@@ -1872,6 +1905,8 @@ static int ideapad_acpi_add(struct platform_device *pdev)
 	if (err)
 		goto shared_init_failed;
 
+	ideapad_laptop_register_notifier(&ideapad_laptop_notifier);
+
 	return 0;
 
 shared_init_failed:
@@ -1903,6 +1938,8 @@ static void ideapad_acpi_remove(struct platform_device *pdev)
 	struct ideapad_private *priv = dev_get_drvdata(&pdev->dev);
 	int i;
 
+	ideapad_laptop_unregister_notifier(&ideapad_laptop_notifier);
+
 	ideapad_shared_exit(priv);
 
 	acpi_remove_notify_handler(priv->adev->handle,
diff --git a/drivers/platform/x86/ideapad-laptop.h b/drivers/platform/x86/ideapad-laptop.h
index 4498a96de5976..3eb0dcd6bf7ba 100644
--- a/drivers/platform/x86/ideapad-laptop.h
+++ b/drivers/platform/x86/ideapad-laptop.h
@@ -12,6 +12,11 @@
 #include <linux/acpi.h>
 #include <linux/jiffies.h>
 #include <linux/errno.h>
+#include <linux/notifier.h>
+
+int ideapad_laptop_register_notifier(struct notifier_block *nb);
+int ideapad_laptop_unregister_notifier(struct notifier_block *nb);
+void ideapad_laptop_call_notifier(unsigned long action, void *data);
 
 enum {
 	VPCCMD_R_VPC1 = 0x10,
-- 
2.39.5



