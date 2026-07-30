Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8193769FD;
	Thu, 30 Jul 2026 15:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426213; cv=none; b=b7NLk/+bTsiRPNbD17mBJ/TVmVEFB8PoYXKhOqZaRNFY/7zcQKa+xKCmw7wwO4lxNMIQmBuZ+ONSJQPU35fVaIwEMxLXCVILQCP7dKKxdaQ+j0r1OGhUSffuQczPcWnKcy6xv+GnGqwo0DdxWMWarKHvCWFo0kzJgndwee+hOsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426213; c=relaxed/simple;
	bh=aJYG8DY0hcznsr+w2DPyknedJb+iu1s6PAWyi2hwVnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jI1EKxyZbZP9J+upn0fOH4O+axnsSBwdzMZ/jyzsLE1M3Q837lkeRt0M0CJLqpDXK7+eZ1HXu/A88WQuG7UJOSZ93I1oQ1xCXw2A2oc4rUsfeYpfO1cOdDgPKKC6iFuw0YFBd2VQZLpFPzvIaayT8fueekHujb1tesge73sGnrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aiNROOk4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aiNROOk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1363E1F000E9;
	Thu, 30 Jul 2026 15:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426212;
	bh=NC9gB4HjkTvolcazcvwM97uFx3cD9mVlBy/SJSXRAVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aiNROOk4fF3nJ67PbR4jC8X0rvYE0/nfb1yzeLIEiVaovgkGQXTibw4ay04p7KlQv
	 jmOZ+Tjyo4MPfVwpJLWx9mrVi/u9YK1GfRXL6of/RzThBQ7PtfefWKWv/VJimwHS5j
	 Td2PYxcIufxsf0fPMTvmvxA9t8YXotHs0hBC8AYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 341/602] media: vivid: fix cleanup bugs in vivid_init()
Date: Thu, 30 Jul 2026 16:12:13 +0200
Message-ID: <20260730141443.127516282@linuxfoundation.org>
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
@@ -2291,8 +2291,10 @@ static int __init vivid_init(void)
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
@@ -2313,7 +2315,7 @@ static int __init vivid_init(void)
 destroy_hdmi_wq:
 	destroy_workqueue(update_hdmi_ctrls_workqueue);
 unreg_driver:
-	platform_driver_register(&vivid_pdrv);
+	platform_driver_unregister(&vivid_pdrv);
 unreg_device:
 	platform_device_unregister(&vivid_pdev);
 free_output_strings:


