Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A699613792B;
	Thu, 12 Dec 2024 16:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022645; cv=none; b=RKp4s2agdO6SfdAS9wo5TnSnJstkh4fkrP6xcYcrf9SWTDvtObZFDSC2236T+95UJfuDi85adRgP+YhGBux8ACpRSnpt8DVWoqXlhLzs2gAL/aaEYh+hCLQQ7MEQy6+SbYFzzxngYIHPCJOjyLQskBkA+YtapF1tJQu/N6/qM6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022645; c=relaxed/simple;
	bh=lVDj1pZR4dcFUTYLO8LT1h4Gxp3PiSOjERhaDPuLhXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nRzxWTkOL/lW9DHlQ/uF22bxM9/TmhZ6+n/qnqGLWUdGl9UNC9/B7zioCLZRqdnyV9kCLmcqR7lmD8DYXRYIugkAoz9HwKArhWIMRBq39LE4eT2pckVita4ad6bIr7XGyv3AEfl0zxOKFFyo5IJT0ats5kc6WPV9VdjarCLeL9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2oWDVIdz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2oWDVIdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D94CC4CECE;
	Thu, 12 Dec 2024 16:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022645;
	bh=lVDj1pZR4dcFUTYLO8LT1h4Gxp3PiSOjERhaDPuLhXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2oWDVIdz2CO71YyFj1y3m2FzvG5NSs9KF1y8sY8G7urkRhm6eK4w44JC+QaoiVdyy
	 DU5MQh6x/yH/6EASpUychVGGC7FeIpP2mg/tdscDuQmnEiRBWy8P9jW4QopY9mMF7r
	 V3XKdZAQzXom5WBTk0r9zHsqfM8FUlVSsULTJgf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiu-ji Chen <chenqiuji666@gmail.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.15 297/565] xen: Fix the issue of resource not being properly released in xenbus_dev_probe()
Date: Thu, 12 Dec 2024 15:58:12 +0100
Message-ID: <20241212144323.206867958@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -308,7 +308,7 @@ int xenbus_dev_probe(struct device *_dev
 	if (err) {
 		dev_warn(&dev->dev, "watch_otherend on %s failed.\n",
 		       dev->nodename);
-		return err;
+		goto fail_remove;
 	}
 
 	dev->spurious_threshold = 1;
@@ -317,6 +317,12 @@ int xenbus_dev_probe(struct device *_dev
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


