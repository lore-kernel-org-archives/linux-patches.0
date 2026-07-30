Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55A2390CBE;
	Thu, 30 Jul 2026 16:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427773; cv=none; b=bJ5ykJfpAXK+EORI7KRsMamfD+JmFeEEbo2Xkk/278JK8vLA4UauiNB2BnNWIZw4Hcf7qs0vEQutW9QT48gLp8ll0rkQWUGSg8LOfhj0YBW5hy1y9t1CB/TBZKT1+vw4E1IuOv9UFfdAk9dBSXInVjtHrY4H2JjsxQy59vPu4aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427773; c=relaxed/simple;
	bh=4ID6rNd7cQCHEOem6GIbt8Hl+PsvBl6CXv4usCbi8Kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mD3YSI4xTjkrbleFvOXpt3WdIu+EVl7LPWx67AdEHre4maMMvNrrFuetfCFcOOYi5gsTP6bM+4ZLc2fWYk/lsWJMEx8G+T6A+sFKQgHlS2nAFx8IwTkld1MZHuZ8+k6aox/mO6UYR2pGmZevwIprJ6JE2YP57nI2IZr7QS7prbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DHb6G7vS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DHb6G7vS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C420D1F000E9;
	Thu, 30 Jul 2026 16:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427772;
	bh=dim5RG6VbjKqHV3iuqvDwoeQ0JxEBcalJnEmPMZrnKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DHb6G7vSJ4yJpLmXZqoAQpopcZ+oC2II9uMHjyBRMkEVWDVdtxTT2Pg+Ne+9ZLwLV
	 NFd9t/Cdq3Kmm2wH1cbJhM8lQK/TnYgNRjPV0TscZTNP/kR3jpKWn/uDoInorGxPXS
	 ggmVu+T5NcGK3McSB625ZyBp3Qri14qLNDDThe+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Menachem Adin <menachem.adin@intel.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 6.6 289/484] mei: bus: access mei_device under device_lock on cleanup
Date: Thu, 30 Jul 2026 16:13:06 +0200
Message-ID: <20260730141429.775848271@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1269,15 +1270,16 @@ static void mei_dev_bus_put(struct mei_d
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


