Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2503A3E7A;
	Fri,  7 Aug 2026 15:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116454; cv=none; b=fi0Py5O2ftMtAoTze5yccKBgznnkX15ultEn4oYvudka5TdlFFMMvQtbJ/Ur2hXsvyWAeMatWWmHi9wporiXyDk/sFAlm2xZjp6aM/Kk0SZiY+B7cKDLE1nruMDXV6dLGcPfB1thlopt5oNgywykKsagVXBkvuGfemhdLRnXKM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116454; c=relaxed/simple;
	bh=/I58egwUuWAN4Z5ESgwZ9vdZ91DUXjCks9xwu1bWOHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sl+T9BYOW3hrjGCpRRwplh5yApb82kURPwZchKjmNb7hUK6r+pEoms27MhZi68M0HIdzjhxNMxSOyseCBEIag9M6u9s16G4Xuqhx8s6a8vHsNpVRySuxmHWj2nx8MyIoCMdWeNynUznNtuhqfYLND8Wl2NxSC/s1hFo85D7i+W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WIKkRoW/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WIKkRoW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D757E1F00A3A;
	Fri,  7 Aug 2026 15:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116453;
	bh=x3GIUkazTwi6WMRKjcN0MubGGYbO9a6KNFmDk9xHCXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WIKkRoW/U1l/yXRxT8zlasMKDwzFqF+nfauU+FhzB6NniXb1wnJahivreDERVDpOx
	 I2yHjpUwMOUoT69I0wpOr52mF/Jx9sCt4ySQ5vVvWqdMb49j8XPjEqsxqTtSjk3Rlx
	 yAM8OOEYNFMIwSbTvJmnHZy2N/HBPgPYgMDgyDWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Mirela Rabulea <mirela.rabulea@nxp.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 237/261] media: v4l2-fwnode: Fix subdev owner overwritten in v4l2_async_register_subdev_sensor()
Date: Fri,  7 Aug 2026 16:39:54 +0200
Message-ID: <20260807143420.491938682@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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
@@ -1203,7 +1203,7 @@ v4l2_async_nf_parse_fwnode_sensor(struct
 	return 0;
 }
 
-int v4l2_async_register_subdev_sensor(struct v4l2_subdev *sd)
+int __v4l2_async_register_subdev_sensor(struct v4l2_subdev *sd, struct module *module)
 {
 	struct v4l2_async_notifier *notifier;
 	int ret;
@@ -1229,7 +1229,7 @@ int v4l2_async_register_subdev_sensor(st
 	if (ret < 0)
 		goto out_cleanup;
 
-	ret = v4l2_async_register_subdev(sd);
+	ret = __v4l2_async_register_subdev(sd, module);
 	if (ret < 0)
 		goto out_unregister;
 
@@ -1247,7 +1247,7 @@ out_cleanup:
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(v4l2_async_register_subdev_sensor);
+EXPORT_SYMBOL_GPL(__v4l2_async_register_subdev_sensor);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -333,8 +333,10 @@ int __v4l2_async_register_subdev(struct
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


