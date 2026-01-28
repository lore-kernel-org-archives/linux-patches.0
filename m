Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C422DF155;
	Wed, 28 Jan 2026 15:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615657; cv=none; b=AgqZ8CD5lE4y2Y5ZN+ARvxnnouU+//5b3pfBrJRa1GmiCxjr0warkShLysFm45zkNbVf2vnF3IOqo2ko+LphJi2IK4ytamGuuDh0RiKnH5FQkCkcUFePoQ2fZKph4ILAYkfILwMVf0SmRD7F+6n5LdD3yWYnV+HSh/H3Jr2EjHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615657; c=relaxed/simple;
	bh=K/IOevqp3EXpTxRPxXXEZfzDbSECHytKFnhsNBuiM9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TmAO29aEJ/KEN7dME9G9JFftfO04Q+4FqSZOP6gySiYlKTJphI1OJ/cqrJuN9PPmaE/PgW4ZD1XA2CEjvoOL4FTNCresoVadzF6vu9VurYk6chFPor+tfznV88sevsiMyzGOkQTwdZCajEJVFNLYGSmmaiHV7yy6W1DC+Z+CI4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Znc1/HT1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Znc1/HT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D21BC4CEF1;
	Wed, 28 Jan 2026 15:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615657;
	bh=K/IOevqp3EXpTxRPxXXEZfzDbSECHytKFnhsNBuiM9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Znc1/HT1NDzg1bN8T1Jhr7NIHXTTGCD8Z+HROJVxuUrDxCUloVslMY7/kXe2AAN2Y
	 F0WZDkxIaAzTFIRyCdKZJd7X8TC20uF9jntATZVcehBWX7f20MnZ51Dvu/8CJmpA6w
	 UnoUPl/SDmOgeBtzehfnayHdnx9h8LsiJHU2YaJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 075/227] platform/x86: hp-bioscfg: Fix kernel panic in GET_INSTANCE_ID macro
Date: Wed, 28 Jan 2026 16:22:00 +0100
Message-ID: <20260128145347.042007260@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


