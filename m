Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E051F75BC;
	Tue,  3 Dec 2024 16:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242156; cv=none; b=ivU/Nh11RMDfpwTjvi6q3xyKKZkLZn9ZnwViLFC8U9Cf//sGnC5hccRXop0DsNy3/43oVeB+jX1WB5ZC6+bBCZOcIhFpq8eyoVmLVTQK+yfT7hUTRbtpaIOGQOyqlJDB/58VK7TXLJ5QwRaOTy9BGzuF7CpmHzh0lNgpIW2cVOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242156; c=relaxed/simple;
	bh=FcS29hTitd+//2w+gJhCcntTtaYRbVDZ8SA9Notz6o0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4lQfrAHLox9M8m+2Q1G64t4B83h/0/72dM+HvUHf2Cr8Tv6ow6hqpbpCutj0WONLinOJuz3Glw2/v8eyZ1wzGTz9wedK03InrouUTTYMstioilyHpVy4p4JUdWL5NV3567RgJnOiMqFDJwfX9f6DdfF3fUmh5mLma1mWW+DVrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NsxAyQEI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NsxAyQEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56B3C4CECF;
	Tue,  3 Dec 2024 16:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242156;
	bh=FcS29hTitd+//2w+gJhCcntTtaYRbVDZ8SA9Notz6o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NsxAyQEIIIbNHbIZoubEpyQRxkvT3XXVOEGS6AWUV3kglAoafn62s+/xCYUhNYVJe
	 G35HmscGIoShB+HTLpifXqLzpfLPNNbgU2eeYkwAqKNVAGNRGYYHwyzQPUk2rKTq+K
	 8VQE8E3y5Pyt3aguZfRQk1GqvGzcfKLkqL/O85Rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiu-ji Chen <chenqiuji666@gmail.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.12 624/826] xen: Fix the issue of resource not being properly released in xenbus_dev_probe()
Date: Tue,  3 Dec 2024 15:45:51 +0100
Message-ID: <20241203144808.094233415@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Qiu-ji Chen <chenqiuji666@gmail.com>

commit afc545da381ba0c651b2658966ac737032676f01 upstream.

This patch fixes an issue in the function xenbus_dev_probe(). In the
xenbus_dev_probe() function, within the if (err) branch at line 313, the
program incorrectly returns err directly without releasing the resources
allocated by err = drv->probe(dev, id). As the return value is non-zero,
the upper layers assume the processing logic has failed. However, the probe
operation was performed earlier without a corresponding remove operation.
Since the probe actually allocates resources, failing to perform the remove
operation could lead to problems.

To fix this issue, we followed the resource release logic of the
xenbus_dev_remove() function by adding a new block fail_remove before the
fail_put block. After entering the branch if (err) at line 313, the
function will use a goto statement to jump to the fail_remove block,
ensuring that the previously acquired resources are correctly released,
thus preventing the reference count leak.

This bug was identified by an experimental static analysis tool developed
by our team. The tool specializes in analyzing reference count operations
and detecting potential issues where resources are not properly managed.
In this case, the tool flagged the missing release operation as a
potential problem, which led to the development of this patch.

Fixes: 4bac07c993d0 ("xen: add the Xenbus sysfs and virtual device hotplug driver")
Cc: stable@vger.kernel.org
Signed-off-by: Qiu-ji Chen <chenqiuji666@gmail.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Message-ID: <20241105130919.4621-1-chenqiuji666@gmail.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/xenbus/xenbus_probe.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -313,7 +313,7 @@ int xenbus_dev_probe(struct device *_dev
 	if (err) {
 		dev_warn(&dev->dev, "watch_otherend on %s failed.\n",
 		       dev->nodename);
-		return err;
+		goto fail_remove;
 	}
 
 	dev->spurious_threshold = 1;
@@ -322,6 +322,12 @@ int xenbus_dev_probe(struct device *_dev
 			 dev->nodename);
 
 	return 0;
+fail_remove:
+	if (drv->remove) {
+		down(&dev->reclaim_sem);
+		drv->remove(dev);
+		up(&dev->reclaim_sem);
+	}
 fail_put:
 	module_put(drv->driver.owner);
 fail:


