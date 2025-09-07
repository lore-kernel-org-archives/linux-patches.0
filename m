Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8824315A;
	Sun,  7 Sep 2025 20:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277880; cv=none; b=in5b6ynXDU5CIra5ozdphAGNMxqh6HrPlagNxISEWSlyl0rIwtXptXcq4uKFQj8UKIh8uZU11fEiGPxFAEK1sgAWSXUwmwLBEgqfth8uTqo71Fv504nMpKP9OnzdijuQFwwf1t3B2jVaaRY6fzJ44QOu4qLy8ZjHwnzhDRhXjC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277880; c=relaxed/simple;
	bh=2J0ksdMSyVSQeIPHzstJrzT2/PYPvaR6ToxKG1j7M0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iYU3KAQek7HKfEIPOGq36L0QqxRonbhVIuS4b5Z3SnDAzNoVvZL7lZl72js684wr4xnvN8zbLjv2ckIUsUB4fDw4U/RoVCBx87tIgSn8VyF+SGRPBr39Mo9yxdYcT88XRu1QNImKf8kjdeRFxjKol7j5IVKiVHVD5PS1BYkIdzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=deBFCEoU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="deBFCEoU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61B8C4CEF0;
	Sun,  7 Sep 2025 20:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277880;
	bh=2J0ksdMSyVSQeIPHzstJrzT2/PYPvaR6ToxKG1j7M0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=deBFCEoUtGxQF821XpxrG3JLsEehDhi0AGWewb9UEMm1btWnKLx+KIch61n9tJOEP
	 1rxf0J1ZN8G94QCglXdOTFljugnSElBQl8lApMr8/b3hDsmb+uqhmm6iQMZEuYVmvQ
	 PSZBbZ7p+pGUBJ7niRM98ch/VUJWncRr8a732xfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 151/183] platform/x86: asus-wmi: Fix racy registrations
Date: Sun,  7 Sep 2025 21:59:38 +0200
Message-ID: <20250907195619.404442217@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 5549202b9c02c2ecbc8634768a3da8d9e82d548d ]

asus_wmi_register_driver() may be called from multiple drivers
concurrently, which can lead to the racy list operations, eventually
corrupting the memory and hitting Oops on some ASUS machines.
Also, the error handling is missing, and it forgot to unregister ACPI
lps0 dev ops in the error case.

This patch covers those issues by introducing a simple mutex at
acpi_wmi_register_driver() & *_unregister_driver, and adding the
proper call of asus_s2idle_check_unregister() in the error path.

Fixes: feea7bd6b02d ("platform/x86: asus-wmi: Refactor Ally suspend/resume")
Link: https://bugzilla.suse.com/show_bug.cgi?id=1246924
Link: https://lore.kernel.org/07815053-0e31-4e8e-8049-b652c929323b@kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20250827052441.23382-1-tiwai@suse.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index f7191fdded14d..e72a2b5d158e9 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -5088,16 +5088,22 @@ static int asus_wmi_probe(struct platform_device *pdev)
 
 	asus_s2idle_check_register();
 
-	return asus_wmi_add(pdev);
+	ret = asus_wmi_add(pdev);
+	if (ret)
+		asus_s2idle_check_unregister();
+
+	return ret;
 }
 
 static bool used;
+static DEFINE_MUTEX(register_mutex);
 
 int __init_or_module asus_wmi_register_driver(struct asus_wmi_driver *driver)
 {
 	struct platform_driver *platform_driver;
 	struct platform_device *platform_device;
 
+	guard(mutex)(&register_mutex);
 	if (used)
 		return -EBUSY;
 
@@ -5120,6 +5126,7 @@ EXPORT_SYMBOL_GPL(asus_wmi_register_driver);
 
 void asus_wmi_unregister_driver(struct asus_wmi_driver *driver)
 {
+	guard(mutex)(&register_mutex);
 	asus_s2idle_check_unregister();
 
 	platform_device_unregister(driver->platform_device);
-- 
2.51.0



