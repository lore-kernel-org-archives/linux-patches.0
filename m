Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82F243C7C4;
	Thu, 30 Jul 2026 15:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426311; cv=none; b=SgDSR27g9URqVWnc6QaHtHmws0Cs5UEL+G3lsLa0r21zym2FkwLTT+iqks2Z78b/N3PmDMY78EMV7PVTOVzkB8TW2tAz9UD9aZHhCDWZrnfonl7eDllP6C4pOBgF7vTi5D+x8TO9CYlXjOjsxCFEP5YqvsmDAYsuFU5UWbrDrPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426311; c=relaxed/simple;
	bh=k+gpfvrIbpdL6U1ZSKGrSIpUv6WfdPPgm6txJus3gP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WhZT1AVgdyUnlzBSgYN1M4lm/8pRmrC3ef9BQnkH5DkcNPVk0pHC5ulpBzRwOV5shMiwO5Zn0vv4VW3NnjAY/rRYNuNQYcHP4g0zY3ObFgdP47tuhOSu0pm/MJtlCgYChKR6vNJK4H9GZYXGNSVPBwx00kKGPjDMVRxFVQ7+aqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0XMxXJpP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0XMxXJpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D711F000E9;
	Thu, 30 Jul 2026 15:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426309;
	bh=BzKUQGQR3GiUXU9nOHrxEqGwCs6UiNwPAAaxsZx424M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0XMxXJpPlpP6BCUBvZLvNYDH5PI0G8VJ4dqgs2dcNtYqFD6ikae0PWiA9JZDMqjjQ
	 34ymUmKwL56BKPKR6FQVoimwQh79RmpTsw/gM7Q7kkERXsN2n9MZDWy1w6Gw9cf5PC
	 pp4aH3FD+49RjNFRFsVbuHRVntXf9GUQSi/pYsU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Menachem Adin <menachem.adin@intel.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 6.12 372/602] mei: bus: access mei_device under device_lock on cleanup
Date: Thu, 30 Jul 2026 16:12:44 +0200
Message-ID: <20260730141443.777823957@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit f112ea910e554d58b4b39a4492b7d302f0f4204f upstream.

Fix couple of problems in mei_cl_bus_dev_release():

mei_cl_flush_queues() is running without lock.
bus->file_list access after mei_dev_bus_put(bus) can become a
use-after-free if this was the last reference to bus.

Protect queues cleanup and WARN traversal by device lock there
to avoid the concurrent access problems.
Move WARN traversal before mei_dev_bus_put(bus).

This file uses bus variable name for mei_device, adjust
code of mei_cl_bus_dev_release() to use bus variable too.

Cc: stable <stable@kernel.org>
Fixes: 35e8a426b16a ("mei: bus: Check for still connected devices in mei_cl_bus_dev_release()")
Reviewed-by: Menachem Adin <menachem.adin@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://patch.msgid.link/20260705151259.3054795-1-alexander.usyskin@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/bus.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -4,6 +4,7 @@
  * Intel Management Engine Interface (Intel MEI) Linux driver
  */
 
+#include <linux/cleanup.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
@@ -1353,15 +1354,16 @@ static void mei_dev_bus_put(struct mei_d
 static void mei_cl_bus_dev_release(struct device *dev)
 {
 	struct mei_cl_device *cldev = to_mei_cl_device(dev);
-	struct mei_device *mdev = cldev->cl->dev;
+	struct mei_device *bus = cldev->bus;
 	struct mei_cl *cl;
 
-	mei_cl_flush_queues(cldev->cl, NULL);
-	mei_me_cl_put(cldev->me_cl);
-	mei_dev_bus_put(cldev->bus);
-
-	list_for_each_entry(cl, &mdev->file_list, link)
-		WARN_ON(cl == cldev->cl);
+	scoped_guard(mutex, &bus->device_lock) {
+		mei_cl_flush_queues(cldev->cl, NULL);
+		mei_me_cl_put(cldev->me_cl);
+		list_for_each_entry(cl, &bus->file_list, link)
+			WARN_ON(cl == cldev->cl);
+	}
+	mei_dev_bus_put(bus);
 
 	kfree(cldev->cl);
 	kfree(cldev);


