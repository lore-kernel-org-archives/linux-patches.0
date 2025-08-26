Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AD2259CB2;
	Tue, 26 Aug 2025 13:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213710; cv=none; b=h7ea5UC0Sl8MHiivs05UuUJPJ86U9WJGTRzhqXd1RxLKmuB0EZHP2MumTIFfqVA5bQgEoAq7tc2bg6SxgBFQaHZn/3Q2R0IoW5+062PzNZFZiMMhshEIJYJBkfFn9oP+AT44a7n45TdtFDHKigE3vGOdLvLsM86M5JpFYTskjwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213710; c=relaxed/simple;
	bh=kw0lDCbeZJvHXycC4f3qgWGXhocZip2TE9MSQC7AjNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8f2Cymi3HFo4DsU64XFegsnXonmAAWdDuZsKsEnb+FR8QCSh0u5cReeUTY9POE+JX8kjVt/iP+6HkRRpJDNrPoLKjwM4pqbAXsko7K9BlGT9Yd9PMSGIfOhgN0bGnGA0kjc6OECbnbyimYPwPtvk/w7/OCH/vTAKembl80y26s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZJ5+aw2Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZJ5+aw2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA528C4CEF1;
	Tue, 26 Aug 2025 13:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213710;
	bh=kw0lDCbeZJvHXycC4f3qgWGXhocZip2TE9MSQC7AjNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZJ5+aw2QkVpA0FlvRrmKr7MH+tXqFklsVA+M1Mi+cl7XC5X6vb+3uw/NRZeyUKyvW
	 YP4RQwvr1K4u2QQifuTVDRxzF2moBewDBe7tXTM87e1s4dhWJzKbB1fC7hFqmhEkMx
	 /NpnP6+kzzOQGc7agg8yKuTqATxeXeaITLAQdNYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 410/587] media: ivsc: Fix crash at shutdown due to missing mei_cldev_disable() calls
Date: Tue, 26 Aug 2025 13:09:19 +0200
Message-ID: <20250826111003.359696391@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Hans de Goede <hansg@kernel.org>

commit 0c92c49fc688cfadacc47ae99b06a31237702e9e upstream.

Both the ACE and CSI driver are missing a mei_cldev_disable() call in
their remove() function.

This causes the mei_cl client to stay part of the mei_device->file_list
list even though its memory is freed by mei_cl_bus_dev_release() calling
kfree(cldev->cl).

This leads to a use-after-free when mei_vsc_remove() runs mei_stop()
which first removes all mei bus devices calling mei_ace_remove() and
mei_csi_remove() followed by mei_cl_bus_dev_release() and then calls
mei_cl_all_disconnect() which walks over mei_device->file_list dereferecing
the just freed cldev->cl.

And mei_vsc_remove() it self is run at shutdown because of the
platform_device_unregister(tp->pdev) in vsc_tp_shutdown()

When building a kernel with KASAN this leads to the following KASAN report:

[ 106.634504] ==================================================================
[ 106.634623] BUG: KASAN: slab-use-after-free in mei_cl_set_disconnected (drivers/misc/mei/client.c:783) mei
[ 106.634683] Read of size 4 at addr ffff88819cb62018 by task systemd-shutdow/1
[ 106.634729]
[ 106.634767] Tainted: [E]=UNSIGNED_MODULE
[ 106.634770] Hardware name: Dell Inc. XPS 16 9640/09CK4V, BIOS 1.12.0 02/10/2025
[ 106.634773] Call Trace:
[ 106.634777]  <TASK>
...
[ 106.634871] kasan_report (mm/kasan/report.c:221 mm/kasan/report.c:636)
[ 106.634901] mei_cl_set_disconnected (drivers/misc/mei/client.c:783) mei
[ 106.634921] mei_cl_all_disconnect (drivers/misc/mei/client.c:2165 (discriminator 4)) mei
[ 106.634941] mei_reset (drivers/misc/mei/init.c:163) mei
...
[ 106.635042] mei_stop (drivers/misc/mei/init.c:348) mei
[ 106.635062] mei_vsc_remove (drivers/misc/mei/mei_dev.h:784 drivers/misc/mei/platform-vsc.c:393) mei_vsc
[ 106.635066] platform_remove (drivers/base/platform.c:1424)

Add the missing mei_cldev_disable() calls so that the mei_cl gets removed
from mei_device->file_list before it is freed to fix this.

Fixes: 78876f71b3e9 ("media: pci: intel: ivsc: Add ACE submodule")
Fixes: 29006e196a56 ("media: pci: intel: ivsc: Add CSI submodule")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hansg@kernel.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/intel/ivsc/mei_ace.c |    2 ++
 drivers/media/pci/intel/ivsc/mei_csi.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/media/pci/intel/ivsc/mei_ace.c
+++ b/drivers/media/pci/intel/ivsc/mei_ace.c
@@ -528,6 +528,8 @@ static void mei_ace_remove(struct mei_cl
 
 	ace_set_camera_owner(ace, ACE_CAMERA_IVSC);
 
+	mei_cldev_disable(cldev);
+
 	mutex_destroy(&ace->lock);
 }
 
--- a/drivers/media/pci/intel/ivsc/mei_csi.c
+++ b/drivers/media/pci/intel/ivsc/mei_csi.c
@@ -807,6 +807,8 @@ static void mei_csi_remove(struct mei_cl
 
 	pm_runtime_disable(&cldev->dev);
 
+	mei_cldev_disable(cldev);
+
 	mutex_destroy(&csi->lock);
 }
 


