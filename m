Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA4D392831;
	Thu, 30 Jul 2026 15:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424704; cv=none; b=YAIYjJ2Gls/R7Cq1XywpKyO6hKbvJoPBs6dCcSd4MMnPdLMeosMHk1KFSRMjVFGHpTp+fpZa1GO9iw9beaG1KMV0zKXfrFrAw2zS9AqOVf0vNxx5lCNZFbn9J+VjffC0ptLPNvX6i0SVoSl5NZIOUHQdj1JUaQKemnsL2YeZGBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424704; c=relaxed/simple;
	bh=tpsVFlNw/IihU9d9VyHNxu+AL+z2R/hmyrEEOk65J+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4k5f5fVVa2sFL2IpY/lKSILkXLaaYVSwgz1KbaCBt25nf92YqW//19Gp7S5tr266aiQnLqWcZkELM33oOaMJqpw8hBNXAMI0BvBRKI9R6DEYqUJZQLByUbVUiz+zZ29NSiuagyRTJtobs1Eh830LHw/M0337eTbF3xHwsPSCAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ushu6/kk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ushu6/kk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2861F000E9;
	Thu, 30 Jul 2026 15:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424703;
	bh=GtHHSkLrtTBTlcXmL34OOr/D8nw04hcTyoRdWrE5SxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ushu6/kksxGOQXsuo41AddEHKGzrb+wag5GjMelK0hyQe8AIjrc6oPa+B8TrVa8oe
	 uEsEAeGoywWCS4RJiqv/zffiMZg97ShJaPb2E0SgmogAFBEaBsX2tEFiJk/eSAX0mv
	 eClyNbrOFXOFK9LPjENh1s1cw7CyTrBI9sKnMGmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Menachem Adin <menachem.adin@intel.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 6.18 486/675] mei: bus: access mei_device under device_lock on cleanup
Date: Thu, 30 Jul 2026 16:13:36 +0200
Message-ID: <20260730141455.451694796@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1317,15 +1318,16 @@ static void mei_dev_bus_put(struct mei_d
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


