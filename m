Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0E02F6930;
	Wed, 28 Jan 2026 15:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615027; cv=none; b=Fj3R6r8bJHTfzPF2jzSCWGBKSBTVplmXR3REgKU8zoHgfNM16EWKAXMEAGKFHvnKWrrLkk3HzQ/mbmSG9Kv8i6S/88h3aU0RW+1AwVqLScO8SekMb1Bp+fI3lEkX7oAGhEIqbANrvF1RRnnE8EzGwK5vDeONJXIs6ZH1gbz7KxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615027; c=relaxed/simple;
	bh=cveaMt7R6SVZZlpTahmWWAcWnlIL/MrfliUd4G4lk68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IgPPeB5VwOkZWy+YmubXS6ngir6qpZrEm7gfisNH8EGJYij80kNhoPembjcHrkfrLvjuH+guAiKLx07ZRWwcbqlzVu5QOBCjNtX6PLwoQGuWBZCxA+ZCRKGCsVa5rtzuEwAI031llOQ+6j2BGGU3Iss5GZ7f0NGMz5M/OBghbpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xTNQkiRO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xTNQkiRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEDB8C4CEF7;
	Wed, 28 Jan 2026 15:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615027;
	bh=cveaMt7R6SVZZlpTahmWWAcWnlIL/MrfliUd4G4lk68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xTNQkiROAHoUuzxpN0qFVLtjbLVsMcE+7Tg0Ak19Np2TRnL0ugXt0QLNDqtBXG3Jb
	 19SqGxZG2YHgZT7nX3/YMvuUvfhmydTTU7Qem963w0coUdiEQbxFPlxSRn4C2Ivs+G
	 UFOuII2sRH7VMyBd968fNl60CUB0YlZ7ke+rdie0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 057/169] platform/x86: hp-bioscfg: Fix kernel panic in GET_INSTANCE_ID macro
Date: Wed, 28 Jan 2026 16:22:20 +0100
Message-ID: <20260128145336.065230249@linuxfoundation.org>
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

commit 25150715e0b049b99df664daf05dab12f41c3e13 upstream.

The GET_INSTANCE_ID macro that caused a kernel panic when accessing sysfs
attributes:

1. Off-by-one error: The loop condition used '<=' instead of '<',
   causing access beyond array bounds. Since array indices are 0-based
   and go from 0 to instances_count-1, the loop should use '<'.

2. Missing NULL check: The code dereferenced attr_name_kobj->name
   without checking if attr_name_kobj was NULL, causing a null pointer
   dereference in min_length_show() and other attribute show functions.

The panic occurred when fwupd tried to read BIOS configuration attributes:

  Oops: general protection fault [#1] SMP KASAN NOPTI
  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  RIP: 0010:min_length_show+0xcf/0x1d0 [hp_bioscfg]

Add a NULL check for attr_name_kobj before dereferencing and corrects
the loop boundary to match the pattern used elsewhere in the driver.

Cc: stable@vger.kernel.org
Fixes: 5f94f181ca25 ("platform/x86: hp-bioscfg: bioscfg-h")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260115203725.828434-3-mario.limonciello@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.h
+++ b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.h
@@ -10,6 +10,7 @@
 
 #include <linux/wmi.h>
 #include <linux/types.h>
+#include <linux/string.h>
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -285,8 +286,9 @@ enum hp_wmi_data_elements {
 	{								\
 		int i;							\
 									\
-		for (i = 0; i <= bioscfg_drv.type##_instances_count; i++) { \
-			if (!strcmp(kobj->name, bioscfg_drv.type##_data[i].attr_name_kobj->name)) \
+		for (i = 0; i < bioscfg_drv.type##_instances_count; i++) { \
+			if (bioscfg_drv.type##_data[i].attr_name_kobj &&	\
+			    !strcmp(kobj->name, bioscfg_drv.type##_data[i].attr_name_kobj->name)) \
 				return i;				\
 		}							\
 		return -EIO;						\


