Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2FE522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B7AC433C7;
	Sun,  9 Jul 2023 11:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902439;
	bh=NRFJa74ckjxQsHN0APTOipxGEglvwSnL5vPcFgFgiKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVM+yZCOXgDL3gSN5rCEYYMKSvV5RMgvD1TwdgSTmX1p/+ByUGZE7RrBVjOq/bWNQ
	 XcxTClyL7yo6WcmZwPNCmD19HT+eQvBK4iNi34H26l2W41+dzo5y2OjLFlwD/hn3zP
	 B8Xdh2U5h0ihUVTPiKhPb8t2Eo+aqDnQCbTL2SWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Michal Wilczynski <michal.wilczynski@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 377/431] platform/x86/dell/dell-rbtn: Fix resources leaking on error path
Date: Sun,  9 Jul 2023 13:15:25 +0200
Message-ID: <20230709111500.001999799@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michal Wilczynski <michal.wilczynski@intel.com>

[ Upstream commit 966cca72ab20289083521a385fa56035d85a222d ]

Currently rbtn_add() in case of failure is leaking resources. Fix this
by adding a proper rollback. Move devm_kzalloc() before rbtn_acquire(),
so it doesn't require rollback in case of failure. While at it, remove
unnecessary assignment of NULL to device->driver_data and unnecessary
whitespace, plus add a break for the default case in a switch.

Suggested-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Suggested-by: Pali Rohár <pali@kernel.org>
Fixes: 817a5cdb40c8 ("dell-rbtn: Dell Airplane Mode Switch driver")
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Reviewed-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/20230613084310.2775896-1-michal.wilczynski@intel.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-rbtn.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/dell/dell-rbtn.c b/drivers/platform/x86/dell/dell-rbtn.c
index aa0e6c9074942..c8fcb537fd65d 100644
--- a/drivers/platform/x86/dell/dell-rbtn.c
+++ b/drivers/platform/x86/dell/dell-rbtn.c
@@ -395,16 +395,16 @@ static int rbtn_add(struct acpi_device *device)
 		return -EINVAL;
 	}
 
+	rbtn_data = devm_kzalloc(&device->dev, sizeof(*rbtn_data), GFP_KERNEL);
+	if (!rbtn_data)
+		return -ENOMEM;
+
 	ret = rbtn_acquire(device, true);
 	if (ret < 0) {
 		dev_err(&device->dev, "Cannot enable device\n");
 		return ret;
 	}
 
-	rbtn_data = devm_kzalloc(&device->dev, sizeof(*rbtn_data), GFP_KERNEL);
-	if (!rbtn_data)
-		return -ENOMEM;
-
 	rbtn_data->type = type;
 	device->driver_data = rbtn_data;
 
@@ -420,10 +420,12 @@ static int rbtn_add(struct acpi_device *device)
 		break;
 	default:
 		ret = -EINVAL;
+		break;
 	}
+	if (ret)
+		rbtn_acquire(device, false);
 
 	return ret;
-
 }
 
 static void rbtn_remove(struct acpi_device *device)
@@ -442,7 +444,6 @@ static void rbtn_remove(struct acpi_device *device)
 	}
 
 	rbtn_acquire(device, false);
-	device->driver_data = NULL;
 }
 
 static void rbtn_notify(struct acpi_device *device, u32 event)
-- 
2.39.2



