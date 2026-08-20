Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA0247D474;
	Thu, 20 Aug 2026 16:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243717; cv=none; b=gwcI8HP/yLR0bbf1pAtoZ3muQfsoQzYoUDJ08v63RtsLyCM3/0wn6rq5NM7zIJ81t3yASm8sluD2TJt2a2VDyh6UQUfpb+CuTDonMKZNMTJNwFL+HV8FFVx3xoM+lCFbK10CbRzTuhXSCr+igOGg9zKJHSotwdRjEgwgip9Eq14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243717; c=relaxed/simple;
	bh=nKGcIbdCzZV202Fszzmn2tCLXCC/DVNnlMLEYPR3FZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYIVYZPTZma8PHI8xSVQX3+ssTa8GaEcdrcY1ZDOkLVoFJ4UXBU6HMmehBwNqpKmswDJNTc0i73U1CdQ8H6NjU61N41lzQWBsHfljWf3hK97yUEFQc0O21y4VJvn+KLDVx1lCjGfGJxnOj7ukDIjmpYsxMP/jzv6eTPRvuMu1NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UOC2Zp2E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UOC2Zp2E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349D91F00A3A;
	Thu, 20 Aug 2026 16:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243715;
	bh=8ILXvjQP8+v8PTuY8D5nICaQ7LyB0QWfrrEk2VZET1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UOC2Zp2EWMsKwW4BsTduyDQ7m0h614N8zQ/GN0t1268LkxcpJ00lxsdr5AkVBdAcn
	 GaRd3FoUPZhmbNcY9TRLUXA0BP91nZlOppzvV0fLsW9o+EiMYdRiA3V3QEnbocA86c
	 jJWkLJf/WLNZyraf6t2TPNaQnBKdRsmE2eVjf/xQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Mirela Rabulea <mirela.rabulea@nxp.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 190/272] media: v4l2-fwnode: Fix subdev owner overwritten in v4l2_async_register_subdev_sensor()
Date: Thu, 20 Aug 2026 16:56:14 +0200
Message-ID: <20260820145237.177912957@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mirela Rabulea <mirela.rabulea@nxp.com>

[ Upstream commit 06cb687a5132fcffe624c0070576ab852ac6b568 ]

The v4l2 helper v4l2_async_register_subdev_sensor() calls
v4l2_async_register_subdev(), which is a macro that expands to
__v4l2_async_register_subdev(sd,THIS_MODULE). Since the macro is expanded
inside v4l2-fwnode.c, THIS_MODULE resolves to the v4l2-fwnode module
rather than the sensor driver module that originally set sd->owner. When
v4l2-fwnode is built-in, THIS_MODULE evaluates to NULL, which then
overwrites the sensor driver's owner with NULL.

This causes the problem that the sensor module's reference count is never
incremented during async registration, so the module can be removed while
the subdevice is still in use by a notifier (e.g., a CSI-2 receiver
bridge driver).

Fix this by renaming v4l2_async_register_subdev_sensor() to
__v4l2_async_register_subdev_sensor() with an added explicit module
argument and introducing a wrapper macro:
    #define v4l2_async_register_subdev_sensor(sd) \
        __v4l2_async_register_subdev_sensor(sd, THIS_MODULE)

This ensures the sensor driver module is properly referenced even when
the sensor driver does not init the owner field before calling
v4l2_async_register_subdev_sensor() and prevents premature module removal.

Fixes: aef69d54755d ("media: v4l: fwnode: Add a convenience function for registering sensors")
Cc: stable@vger.kernel.org
Suggested-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/linux-media/20240315073125.275501-2-sakari.ailus@linux.intel.com/
Signed-off-by: Mirela Rabulea <mirela.rabulea@nxp.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-fwnode.c |    6 +++---
 include/media/v4l2-async.h            |    4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -1318,7 +1318,7 @@ v4l2_async_notifier_parse_fwnode_sensor(
 	return 0;
 }
 
-int v4l2_async_register_subdev_sensor(struct v4l2_subdev *sd)
+int __v4l2_async_register_subdev_sensor(struct v4l2_subdev *sd, struct module *module)
 {
 	struct v4l2_async_notifier *notifier;
 	int ret;
@@ -1340,7 +1340,7 @@ int v4l2_async_register_subdev_sensor(st
 	if (ret < 0)
 		goto out_cleanup;
 
-	ret = v4l2_async_register_subdev(sd);
+	ret = __v4l2_async_register_subdev(sd, module);
 	if (ret < 0)
 		goto out_unregister;
 
@@ -1357,7 +1357,7 @@ out_cleanup:
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(v4l2_async_register_subdev_sensor);
+EXPORT_SYMBOL_GPL(__v4l2_async_register_subdev_sensor);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -306,8 +306,10 @@ int __v4l2_async_register_subdev(struct
  * An error is returned if the module is no longer loaded on any attempts
  * to register it.
  */
+#define v4l2_async_register_subdev_sensor(sd) \
+	__v4l2_async_register_subdev_sensor(sd, THIS_MODULE)
 int __must_check
-v4l2_async_register_subdev_sensor(struct v4l2_subdev *sd);
+__v4l2_async_register_subdev_sensor(struct v4l2_subdev *sd, struct module *module);
 
 /**
  * v4l2_async_unregister_subdev - unregisters a sub-device to the asynchronous


