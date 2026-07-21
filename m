Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907FE47143B;
	Tue, 21 Jul 2026 20:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664212; cv=none; b=ubTUNE/Icna1NjMzQhQ8wdV4KAFGBIkazD0uiM3cyHC7Jh62iE/E+HteA3UusqBhYMy8Ny9shAehhHePY5wrAAUyVJ9mAjEVEPXAqZvOVJme4/RBjNfCglqWZG6y9IgGz9P9hKuFJ3QVWpc3JPB+UnBrWGoU/ZsN9vplqfB0yiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664212; c=relaxed/simple;
	bh=0kvzXtKte4ZPYJmug6kb7nVunNvjzF/ePPO7X48kPPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSdm62ZYzkusXdcCxe1d6/fC4drVBrTCM3BfmPH3wdoX3qT2+tIg2aiXsVkut7c4zZVrXQlteNwACv+DmOhEI844n/VHPBGbm7OdDMCVa1JEo+maH2EhVFmX0uIiDtQwkdYGPgEr2Ng1kaQeiRGekbLVeoKAjLs6RuqaBV8E2Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ydalLsrl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ydalLsrl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6ED1F000E9;
	Tue, 21 Jul 2026 20:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664210;
	bh=N+GI4skcBYDTtkdU+fuJX2RbC2o6p2aaYqzFafYESK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ydalLsrlT1EyUgGTRDJysCP1z9aROfg8xsiHF4mGP7UKs9igInDBviBgh5f03SmOq
	 tKq8xEZ6xfRFf5ITFV+49kdYz5yN0z/yfiuPvf4zTm7knZ4LMTwhia2T6iYi3AESsS
	 /ZrRuztpCMRjYnub8b9DI9AlSKl8I/T1t7mEjHVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 1107/1276] wifi: rt2x00: avoid full teardown before work setup in probe
Date: Tue, 21 Jul 2026 17:25:50 +0200
Message-ID: <20260721152510.762208387@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 536fb3d739d75a03cb318c0c6fe799425cfea501 upstream.

rt2x00lib_probe_dev() uses the full rt2x00lib_remove_dev() teardown for
all probe failures. However, drv_data allocation and workqueue allocation
can fail before intf_work, autowakeup_work and sleep_work have been
initialized.

Do not enter the full remove path until the probe has reached the point
where those work items are set up. Return directly for drv_data allocation
failure, and use a small early cleanup path for workqueue allocation
failure.

This issue was found by our static analysis tool and then confirmed by
manual review of rt2x00lib_probe_dev() and rt2x00lib_remove_dev(). The
early probe exits should not call a common teardown path that assumes the
later work setup has already completed.

A QEMU PoC forced alloc_ordered_workqueue() to fail before the work
initializers are reached. The resulting fail path entered
rt2x00lib_remove_dev(), and DEBUG_OBJECTS reported invalid work drains with
rt2x00lib_probe_dev() and rt2x00lib_remove_dev() in the stack.

Fixes: 1ebbc48520a0 ("rt2x00: Introduce concept of driver data in struct rt2x00_dev.")
Fixes: 0439f5367c8d ("rt2x00: Move TX/RX work into dedicated workqueue")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260619073104.1809161-1-runyu.xiao@seu.edu.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -1382,7 +1382,7 @@ int rt2x00lib_probe_dev(struct rt2x00_de
 			                      GFP_KERNEL);
 		if (!rt2x00dev->drv_data) {
 			retval = -ENOMEM;
-			goto exit;
+			return retval;
 		}
 	}
 
@@ -1416,7 +1416,7 @@ int rt2x00lib_probe_dev(struct rt2x00_de
 	    alloc_ordered_workqueue("%s", 0, wiphy_name(rt2x00dev->hw->wiphy));
 	if (!rt2x00dev->workqueue) {
 		retval = -ENOMEM;
-		goto exit;
+		goto exit_free_drv_data;
 	}
 
 	INIT_WORK(&rt2x00dev->intf_work, rt2x00lib_intf_scheduled);
@@ -1489,6 +1489,14 @@ exit:
 	rt2x00lib_remove_dev(rt2x00dev);
 
 	return retval;
+
+exit_free_drv_data:
+	clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
+
+	kfree(rt2x00dev->drv_data);
+	rt2x00dev->drv_data = NULL;
+
+	return retval;
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_probe_dev);
 


