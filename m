Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3330147D925;
	Thu, 20 Aug 2026 16:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243716; cv=none; b=PQZBF/4cftBl4WImTypnMn2OPIlUHgYI9r78oslnhchkPCnmEw4Bn8VMQkkD2gpMwFQkUHuJbGJdGQeRcHeJWCBIPMcRVqFHU3EVPJ6T6zbWWyflWnzO89sZpvT44agZMrXaIXFXdeXUD10yU4Dd0UoE3oViESe9x9zNoPrYk5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243716; c=relaxed/simple;
	bh=oacYpLYBDv9Ciz3zLFCLv+fydg4izatZ68O7kECUlfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBplaf39SiZGYa3R/RvNZLfPKrtb3Bu+zu4krHUhChX+fe/HQtKfi7Jq9f3figylo+XIlsYyR5yorb5Z4TirMtrFcctP9lD48lZ4s7gq9PNh3tU5/gF1vGqszfOO1oj0KXXcUIx2n7jzTm/AXuPty/mcIp0NgOqqehQjPwkPyeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OF5pMnJa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OF5pMnJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508801F000E9;
	Thu, 20 Aug 2026 16:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243712;
	bh=M3ct8aoqY+AwKBsJUt33w4M3JO+6/dtMhX+8tBqeOnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OF5pMnJaO5vJh+n6bTZhLqY0nTDG9Exv7CGqZEF15FTJZ3WWqfCx4xOOy/mdWMsqI
	 9J0QqQstWMfG7wWOx/yIhTUAfXvBzVsHTc0FIrJzlW7BvXr//Ni5ozgssRf34qHubf
	 QQfdYCCAMeKJ27Tep/mdC0hxk4qOa3QAI1pq4L94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 189/272] media: v4l: async: Set owner for async sub-devices
Date: Thu, 20 Aug 2026 16:56:13 +0200
Message-ID: <20260820145237.148367805@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 8a718752f5c339137c5b05e54f116cd26d5a4143 ]

Set the owner field of the async sub-devices by making
v4l2_async_register_subdev() a macro and obtaining THIS_MODULE that way.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Stable-dep-of: 06cb687a5132 ("media: v4l2-fwnode: Fix subdev owner overwritten in v4l2_async_register_subdev_sensor()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-async.c |    8 ++++++--
 include/media/v4l2-async.h           |    4 +++-
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -705,7 +705,7 @@ __v4l2_async_notifier_add_i2c_subdev(str
 }
 EXPORT_SYMBOL_GPL(__v4l2_async_notifier_add_i2c_subdev);
 
-int v4l2_async_register_subdev(struct v4l2_subdev *sd)
+int __v4l2_async_register_subdev(struct v4l2_subdev *sd, struct module *module)
 {
 	struct v4l2_async_notifier *subdev_notifier;
 	struct v4l2_async_notifier *notifier;
@@ -719,6 +719,8 @@ int v4l2_async_register_subdev(struct v4
 	if (!sd->fwnode && sd->dev)
 		sd->fwnode = dev_fwnode(sd->dev);
 
+	sd->owner = module;
+
 	mutex_lock(&list_lock);
 
 	INIT_LIST_HEAD(&sd->async_list);
@@ -769,9 +771,11 @@ err_unbind:
 
 	mutex_unlock(&list_lock);
 
+	sd->owner = NULL;
+
 	return ret;
 }
-EXPORT_SYMBOL(v4l2_async_register_subdev);
+EXPORT_SYMBOL(__v4l2_async_register_subdev);
 
 void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
 {
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -283,7 +283,9 @@ void v4l2_async_notifier_cleanup(struct
  *
  * @sd: pointer to &struct v4l2_subdev
  */
-int v4l2_async_register_subdev(struct v4l2_subdev *sd);
+#define v4l2_async_register_subdev(sd) \
+	__v4l2_async_register_subdev(sd, THIS_MODULE)
+int __v4l2_async_register_subdev(struct v4l2_subdev *sd, struct module *module);
 
 /**
  * v4l2_async_register_subdev_sensor - registers a sensor sub-device to the


