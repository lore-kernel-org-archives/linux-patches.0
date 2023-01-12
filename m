Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858FE746A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:01:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5C9C433D2;
	Thu, 12 Jan 2023 14:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532100;
	bh=B05NQTeZWLpbNoyEtzdqPyOngzkdrRu1o+cnFfd7SH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t0kKUOoBK/g2IgXLpu89rzM5X8dcMu9drUF+DKomzuA/nqRhc0Qwd2d/ZL3YTV+dv
	 hUN15qaMWSLgX2xAmdgqy42LEIZJPmEJkrcCWe+HhX1Y6eon7G85ONo/S7XZfAPhN+
	 Wy7cI0NZFVsJ+AVGzNLoBi9lMxE/spUVklC9+Ky0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/783] platform/x86: huawei-wmi: fix return value calculation
Date: Thu, 12 Jan 2023 14:46:09 +0100
Message-Id: <20230112135526.616480608@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Barnabás Pőcze <pobrn@protonmail.com>

[ Upstream commit 0b9a1dcdb6a2c841899389bf2dd7a3e0e2aa0e99 ]

Previously, `huawei_wmi_input_setup()` returned the result of
logical or-ing the return values of two functions that return negative
errno-style error codes and one that returns `acpi_status`. If this
returned value was non-zero, then it was propagated from the platform
driver's probe function. That function should return a negative
errno-style error code, so the result of the logical or that
`huawei_wmi_input_setup()` returned was not appropriate.

Fix that by checking each function separately and returning the
error code unmodified.

Fixes: 1ac9abeb2e5b ("platform/x86: huawei-wmi: Move to platform driver")
Signed-off-by: Barnabás Pőcze <pobrn@protonmail.com>
Link: https://lore.kernel.org/r/20221005150032.173198-2-pobrn@protonmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/huawei-wmi.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/huawei-wmi.c b/drivers/platform/x86/huawei-wmi.c
index eac3e6b4ea11..935562c870c3 100644
--- a/drivers/platform/x86/huawei-wmi.c
+++ b/drivers/platform/x86/huawei-wmi.c
@@ -760,6 +760,9 @@ static int huawei_wmi_input_setup(struct device *dev,
 		const char *guid,
 		struct input_dev **idev)
 {
+	acpi_status status;
+	int err;
+
 	*idev = devm_input_allocate_device(dev);
 	if (!*idev)
 		return -ENOMEM;
@@ -769,10 +772,19 @@ static int huawei_wmi_input_setup(struct device *dev,
 	(*idev)->id.bustype = BUS_HOST;
 	(*idev)->dev.parent = dev;
 
-	return sparse_keymap_setup(*idev, huawei_wmi_keymap, NULL) ||
-		input_register_device(*idev) ||
-		wmi_install_notify_handler(guid, huawei_wmi_input_notify,
-				*idev);
+	err = sparse_keymap_setup(*idev, huawei_wmi_keymap, NULL);
+	if (err)
+		return err;
+
+	err = input_register_device(*idev);
+	if (err)
+		return err;
+
+	status = wmi_install_notify_handler(guid, huawei_wmi_input_notify, *idev);
+	if (ACPI_FAILURE(status))
+		return -EIO;
+
+	return 0;
 }
 
 static void huawei_wmi_input_exit(struct device *dev, const char *guid)
-- 
2.35.1



