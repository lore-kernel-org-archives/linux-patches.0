Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F314431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66502C433D2;
	Wed, 15 Mar 2023 12:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678884070;
	bh=VQBdy/b9AsaFWTPJJFTQN1CCxBXFZCaBKSUQfhykkl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s5fUbLJRDql8AmIxrab/Ng2ymWoaePlL8hSzYn+hrXRM9eZP2k8yH+RTcsiEOc2Oc
	 +s/VTfsdFlmHOf9O5sBjnuNXzf+xuUCfeRWCajfCG0pd2Tdpajow+VINdjU6SUeHAk
	 UaWQqYYdOcIP7mncBafNUdT/WgvvHuCQMmPxR4iY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 094/141] platform/x86: dell-ddv: Return error if buffer is empty
Date: Wed, 15 Mar 2023 13:13:17 +0100
Message-Id: <20230315115742.860584598@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 36d44825faf42903a0b92dd49a9620e2cbdcbe18 ]

In several cases, the DDV WMI interface can return buffers
with a length of zero. Return -ENODATA in such a case for
proper error handling. Also replace some -EIO errors with
more specialized ones.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20230126194021.381092-3-W_Armin@gmx.de
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Stable-dep-of: 0331b1b0ba65 ("platform/x86: dell-ddv: Fix temperature scaling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-wmi-ddv.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/dell/dell-wmi-ddv.c b/drivers/platform/x86/dell/dell-wmi-ddv.c
index 9cb6ae42dbdc8..f99c4cb686fdc 100644
--- a/drivers/platform/x86/dell/dell-wmi-ddv.c
+++ b/drivers/platform/x86/dell/dell-wmi-ddv.c
@@ -11,6 +11,7 @@
 #include <linux/debugfs.h>
 #include <linux/device.h>
 #include <linux/dev_printk.h>
+#include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/kstrtox.h>
 #include <linux/math.h>
@@ -125,21 +126,27 @@ static int dell_wmi_ddv_query_buffer(struct wmi_device *wdev, enum dell_ddv_meth
 	if (ret < 0)
 		return ret;
 
-	if (obj->package.count != 2)
-		goto err_free;
+	if (obj->package.count != 2 ||
+	    obj->package.elements[0].type != ACPI_TYPE_INTEGER ||
+	    obj->package.elements[1].type != ACPI_TYPE_BUFFER) {
+		ret = -ENOMSG;
 
-	if (obj->package.elements[0].type != ACPI_TYPE_INTEGER)
 		goto err_free;
+	}
 
 	buffer_size = obj->package.elements[0].integer.value;
 
-	if (obj->package.elements[1].type != ACPI_TYPE_BUFFER)
+	if (!buffer_size) {
+		ret = -ENODATA;
+
 		goto err_free;
+	}
 
 	if (buffer_size > obj->package.elements[1].buffer.length) {
 		dev_warn(&wdev->dev,
 			 FW_WARN "WMI buffer size (%llu) exceeds ACPI buffer size (%d)\n",
 			 buffer_size, obj->package.elements[1].buffer.length);
+		ret = -EMSGSIZE;
 
 		goto err_free;
 	}
@@ -151,7 +158,7 @@ static int dell_wmi_ddv_query_buffer(struct wmi_device *wdev, enum dell_ddv_meth
 err_free:
 	kfree(obj);
 
-	return -EIO;
+	return ret;
 }
 
 static int dell_wmi_ddv_query_string(struct wmi_device *wdev, enum dell_ddv_method method,
-- 
2.39.2



