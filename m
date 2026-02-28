Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E39355049
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301022; cv=none; b=MeBVEVxDn90ulrgYFkETTPQ3ir2sO7TZ5XIFNFgHs7Oi3+TplKP5lLn0eKZdYnV3uUYNxdwRy/ed+i2+VeSZlzsWomDTSydqWbo0n3Nre3aGvzuSmB/3wNdQTQLmaEui0DGOGLpj5QihLANrxk80kV5wTtizxQVLMtL9yKrL4SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301022; c=relaxed/simple;
	bh=7Ai5J78US4WCWcSIRNjDnWgArYAcRIXbS/AvosGatCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQLMSL5HESJ2MoUp5qS8RwUCyUp3WHSVkjf6Xg4FVh2mP8UBQ4xu8Ki3tWX3WVtiJEfHGCCl/0tdMIq2R6tXqGgYwOFkrQrHgbuxzReNlRNw1bOudgX6eVxW6M5lclJlxo/GTlCSDL817SJXrHpOvRp9jbLItUnLExL9ux25tqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YV3oUxuZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YV3oUxuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9E9C19423;
	Sat, 28 Feb 2026 17:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301022;
	bh=7Ai5J78US4WCWcSIRNjDnWgArYAcRIXbS/AvosGatCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YV3oUxuZ/qcwJSSqRK67GSnIZmXwJBZYsnBrTAZJhBNPCKkNxUWVXtlo5DtDmxbYm
	 Ysgf4sU0mzwQOrSJaT/Tbnjj6n7bDyOcbYzyPna+DG+gu/0L5xOlXpZt4F96BawXA6
	 3xG6eB0k5qdFWGoqJiTfDWy7OI69zlA+UzOb2LBS7VZbPo91mnen1Y8tibvLcdKTsS
	 eAMguYz/m4kPjOQWMLFfH/QQ8l8YBUf/IIxcP7Zid+MCDy7l5uXlEt65t0av2Qldnw
	 3qAue6SxISfRqrT+3KSiGGS32suc2faHAzY+ML46gATWuyjp+Oaf8ZLarz3C1Yop7s
	 k1A5wbZwdIi2Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Yew, Chang Ching" <chang.ching.yew@intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 159/752] media: v4l2-async: Fix error handling on steps after finding a match
Date: Sat, 28 Feb 2026 12:37:50 -0500
Message-ID: <20260228174750.1542406-159-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 7345d6d356336c448d6b9230ed8704f39679fd12 ]

Once an async connection is found to be matching with an fwnode, a
sub-device may be registered (in case it wasn't already), its bound
operation is called, ancillary links are created, the async connection
is added to the sub-device's list of connections and removed from the
global waiting connection list. Further on, the sub-device's possible own
notifier is searched for possible additional matches.

Fix these specific issues:

- If v4l2_async_match_notify() failed before the sub-notifier handling,
  the async connection was unbound and its entry removed from the
  sub-device's async connection list. The latter part was also done in
  v4l2_async_match_notify().

- The async connection's sd field was only set after creating ancillary
  links in v4l2_async_match_notify(). It was however dereferenced in
  v4l2_async_unbind_subdev_one(), which was called on error path of
  v4l2_async_match_notify() failure.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: "Yew, Chang Ching" <chang.ching.yew@intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-async.c | 45 +++++++++++++++++++---------
 1 file changed, 31 insertions(+), 14 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index ee884a8221fbd..1c08bba9ecb91 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -343,7 +343,6 @@ static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
 				   struct v4l2_subdev *sd,
 				   struct v4l2_async_connection *asc)
 {
-	struct v4l2_async_notifier *subdev_notifier;
 	bool registered = false;
 	int ret;
 
@@ -389,6 +388,25 @@ static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
 	dev_dbg(notifier_dev(notifier), "v4l2-async: %s bound (ret %d)\n",
 		dev_name(sd->dev), ret);
 
+	return 0;
+
+err_call_unbind:
+	v4l2_async_nf_call_unbind(notifier, sd, asc);
+	list_del(&asc->asc_subdev_entry);
+
+err_unregister_subdev:
+	if (registered)
+		v4l2_device_unregister_subdev(sd);
+
+	return ret;
+}
+
+static int
+v4l2_async_nf_try_subdev_notifier(struct v4l2_async_notifier *notifier,
+				  struct v4l2_subdev *sd)
+{
+	struct v4l2_async_notifier *subdev_notifier;
+
 	/*
 	 * See if the sub-device has a notifier. If not, return here.
 	 */
@@ -404,16 +422,6 @@ static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
 	subdev_notifier->parent = notifier;
 
 	return v4l2_async_nf_try_all_subdevs(subdev_notifier);
-
-err_call_unbind:
-	v4l2_async_nf_call_unbind(notifier, sd, asc);
-	list_del(&asc->asc_subdev_entry);
-
-err_unregister_subdev:
-	if (registered)
-		v4l2_device_unregister_subdev(sd);
-
-	return ret;
 }
 
 /* Test all async sub-devices in a notifier for a match. */
@@ -445,6 +453,10 @@ v4l2_async_nf_try_all_subdevs(struct v4l2_async_notifier *notifier)
 		if (ret < 0)
 			return ret;
 
+		ret = v4l2_async_nf_try_subdev_notifier(notifier, sd);
+		if (ret < 0)
+			return ret;
+
 		/*
 		 * v4l2_async_match_notify() may lead to registering a
 		 * new notifier and thus changing the async subdevs
@@ -829,7 +841,11 @@ int __v4l2_async_register_subdev(struct v4l2_subdev *sd, struct module *module)
 			ret = v4l2_async_match_notify(notifier, v4l2_dev, sd,
 						      asc);
 			if (ret)
-				goto err_unbind;
+				goto err_unlock;
+
+			ret = v4l2_async_nf_try_subdev_notifier(notifier, sd);
+			if (ret)
+				goto err_unbind_one;
 
 			ret = v4l2_async_nf_try_complete(notifier);
 			if (ret)
@@ -853,9 +869,10 @@ int __v4l2_async_register_subdev(struct v4l2_subdev *sd, struct module *module)
 	if (subdev_notifier)
 		v4l2_async_nf_unbind_all_subdevs(subdev_notifier);
 
-	if (asc)
-		v4l2_async_unbind_subdev_one(notifier, asc);
+err_unbind_one:
+	v4l2_async_unbind_subdev_one(notifier, asc);
 
+err_unlock:
 	mutex_unlock(&list_lock);
 
 	sd->owner = NULL;
-- 
2.51.0

