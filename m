Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF2B34DCE4;
	Thu, 30 Jul 2026 14:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422731; cv=none; b=MEw+eHVS8nsVD1P3U79/2lZvAMVd+qf26dUjNknbmzB3/5PKIIHdRS9u7cMWuqSNvozD3O0Ji7UJq4zLzESdnBo/610J0GW8t5aQq1jvGgMjH/XqDvENjRkHlw+4u2ewM/09cxY+jDYiYpZwMoMpIDrJ5eiyUmdtB4sW9r43MUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422731; c=relaxed/simple;
	bh=rUFTuqkJ1py6hCYzixK0/FV1aSBQ5n/zgabTQm+C68U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGOGPRaJ6qyieENaHxvcJ5gvlvwi1sPGKdZmkAG65+80Vm1ygS97gwsM2OSX44KtIcGy4ickn9HvV5UdH4OTlVMIAI7+otnQ83D7C093czZ2D2bYdSEXG1Ha2L8w7p1rA7YdyXsj2gvMlh+HCLNv+KgUvx0z5P1NLewKXcWj8QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xspdWfpM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xspdWfpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B361F000E9;
	Thu, 30 Jul 2026 14:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422729;
	bh=hc/SYLWiY4l9x/K7Q3/WDg5OLimg2p8BjlDO5QIYQac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xspdWfpM+Wr49DScor/DAGrLC8kafZZEYe2xPzVmRIyXyVAs85qgc2rUVV2KmDEKm
	 nOzbIYauMaNbiHyVsO9IZ6WiGmAHhpOMMnerBx8wLbzdpO/Y29YZXfiIhCXIKIkDlA
	 QhZIYS85oZY6cicIQFBc85RPrkAhDtDMQgzQvlNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 536/744] media: vivid: fix cleanup bugs in vivid_init()
Date: Thu, 30 Jul 2026 16:13:29 +0200
Message-ID: <20260730141455.668514710@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit a07c179a92e949172ca52f6d4a13202ea88cd4b7 upstream.

When platform_device_register() fails in vivid_init(), the embedded
struct device in vivid_pdev has already been initialized by
device_initialize(), but the failure path jumps to free_output_strings
without dropping the device reference for the current platform device:

  vivid_init()
    -> platform_device_register(&vivid_pdev)
       -> device_initialize(&vivid_pdev.dev)
       -> setup_pdev_dma_masks(&vivid_pdev)
       -> platform_device_add(&vivid_pdev)

This leads to a reference leak when platform_device_register() fails.
Fix this by calling platform_device_put() before jumping to the common
cleanup path.

Also, the unreg_driver label incorrectly calls
platform_driver_register() instead of platform_driver_unregister(),
which breaks cleanup when workqueue creation fails after successful
driver registration. Fix that as well.

The reference leak was identified by a static analysis tool I developed
and confirmed by manual review. The incorrect cleanup call was found
during code inspection.

Fixes: f46d740fb0258 ("[media] vivid: turn this into a platform_device")
Fixes: d7c969f37515d ("media: vivid: Add 'Is Connected To' menu controls")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vivid/vivid-core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/media/test-drivers/vivid/vivid-core.c
+++ b/drivers/media/test-drivers/vivid/vivid-core.c
@@ -2289,8 +2289,10 @@ static int __init vivid_init(void)
 		}
 	}
 	ret = platform_device_register(&vivid_pdev);
-	if (ret)
+	if (ret) {
+		platform_device_put(&vivid_pdev);
 		goto free_output_strings;
+	}
 	ret = platform_driver_register(&vivid_pdrv);
 	if (ret)
 		goto unreg_device;
@@ -2311,7 +2313,7 @@ static int __init vivid_init(void)
 destroy_hdmi_wq:
 	destroy_workqueue(update_hdmi_ctrls_workqueue);
 unreg_driver:
-	platform_driver_register(&vivid_pdrv);
+	platform_driver_unregister(&vivid_pdrv);
 unreg_device:
 	platform_device_unregister(&vivid_pdev);
 free_output_strings:


