Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7BB3064A2;
	Wed, 28 Jan 2026 15:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615024; cv=none; b=WRKupbTjEM3aipsHrrlQ3wXlqcXYxnIX7CzWV4KkJP9/VgjytduDPKFEzwbhvuXh+xQpFYYB8QrZxgV2RTq7XFONiBjPGiBM+5SWVyFPfeLdcbyEvVA9FtncpWkMVN+yMaFgOQU30+CC3alk+1ILIXKdTSbRtqpe98cin/+GBtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615024; c=relaxed/simple;
	bh=XCqyg2+5nuqb/lrV0uJ1harZvl1rI8p3PyLKbaiZp+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cqI8y0BwdXl2pu2Ddc/TqdBGFoUVQBZwLnKgQawYAlChYe/UPJR9kQmpt37yiXWCpAoRVlmG1Obn0i0SaL9uMj+01nEO5RCOGkNxptrLjgOCv3a2lqRc4F9cQTXNq8IXdw97dgHCIBOR03uRd6XXlERDyYNLY/3xwDtxtJbMyfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iERfp6tJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iERfp6tJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A206C4CEF1;
	Wed, 28 Jan 2026 15:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615024;
	bh=XCqyg2+5nuqb/lrV0uJ1harZvl1rI8p3PyLKbaiZp+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iERfp6tJwnh06ROJ0VB3UQIbbNH0CrHCalUXkoOpibmCZ24NNZC1b4C+E5H7QkQg/
	 zX+G40tS0bbLCIoFf24K8tzIWxtlYatQM+ZNmBNb8ckNIBXp4Tg4xl8oUYwBr/m/Td
	 B3wrRhWvtH3trRGtFmcackIWDxTVkJheQkR2Znq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 056/169] platform/x86: hp-bioscfg: Fix kobject warnings for empty attribute names
Date: Wed, 28 Jan 2026 16:22:19 +0100
Message-ID: <20260128145336.029561576@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit fdee1b09721605f532352628d0a24623e7062efb upstream.

The hp-bioscfg driver attempts to register kobjects with empty names when
the HP BIOS returns attributes with empty name strings. This causes
multiple kernel warnings:

  kobject: (00000000135fb5e6): attempted to be registered with empty name!
  WARNING: CPU: 14 PID: 3336 at lib/kobject.c:219 kobject_add_internal+0x2eb/0x310

Add validation in hp_init_bios_buffer_attribute() to check if the
attribute name is empty after parsing it from the WMI buffer. If empty,
log a debug message and skip registration of that attribute, allowing the
module to continue processing other valid attributes.

Cc: stable@vger.kernel.org
Fixes: a34fc329b189 ("platform/x86: hp-bioscfg: bioscfg")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260115203725.828434-2-mario.limonciello@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
@@ -10,6 +10,8 @@
 #include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/printk.h>
+#include <linux/string.h>
 #include <linux/wmi.h>
 #include "bioscfg.h"
 #include "../../firmware_attributes_class.h"
@@ -784,6 +786,12 @@ static int hp_init_bios_buffer_attribute
 	if (ret < 0)
 		goto buff_attr_exit;
 
+	if (strlen(str) == 0) {
+		pr_debug("Ignoring attribute with empty name\n");
+		ret = 0;
+		goto buff_attr_exit;
+	}
+
 	if (attr_type == HPWMI_PASSWORD_TYPE ||
 	    attr_type == HPWMI_SECURE_PLATFORM_TYPE)
 		temp_kset = bioscfg_drv.authentication_dir_kset;


