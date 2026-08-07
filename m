Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C703A3E7A;
	Fri,  7 Aug 2026 15:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116451; cv=none; b=Cs3g+PXceGPCw3oqqZformU4Uiww+z6BEbRkseKaaAebuYmkU4gCjEEtPBVmGTTP5wlcwqqC+Olc2jWsyrgAkrAkRWsdvl2WQKiDb7lpbykgH3eCv27GPCRhUk7yEryuiXViykQL00N5phiJqVZ45zYG/FlH9qAjJkvBLNOsbWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116451; c=relaxed/simple;
	bh=M7HcIId71Ba0aDcxzrSBqiw2kTdfPE9hRNnbVOPnQCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7LHnB9p8Sy0x6bVZGWgWbbK5lCSU/6OeASijmM2eE1Mqt1844bBFKQAWBChr7VY1I425NjEKV/MpTrxUXpXjBgW4hD3OqZGfzu0bhu927f0zh2IlBXIGB/7Z51qQz4QQf3xKdnpGiiF+g7i0Q5AhYmw0AykNRppV2vUpzp5uek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H0Wu3x0J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H0Wu3x0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8A91F000E9;
	Fri,  7 Aug 2026 15:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116450;
	bh=2SLcRwmDRyGij/mLG8Jj70wAGAA7F88TgtDuXsXlN4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H0Wu3x0J7UlVFCqTPs+1UzTXahSMvKWQFfmXR8T4gcx9oh+AHTVcrR3CV6vIbL6MR
	 wi8UNEijyf8f86GjbCxJvVgenOti1ihoHvYMCGj4baWM4ZAaZaQlWg6popM+vrjYSF
	 RMbT2ySTnXdlakZh+BSMjxkkvFZwwBXyz4FO/I2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 236/261] media: v4l: async: Set owner for async sub-devices
Date: Fri,  7 Aug 2026 16:39:53 +0200
Message-ID: <20260807143420.470311202@linuxfoundation.org>
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
@@ -798,7 +798,7 @@ v4l2_async_connection_unique(struct v4l2
 }
 EXPORT_SYMBOL_GPL(v4l2_async_connection_unique);
 
-int v4l2_async_register_subdev(struct v4l2_subdev *sd)
+int __v4l2_async_register_subdev(struct v4l2_subdev *sd, struct module *module)
 {
 	struct v4l2_async_notifier *subdev_notifier;
 	struct v4l2_async_notifier *notifier;
@@ -822,6 +822,8 @@ int v4l2_async_register_subdev(struct v4
 		return -EINVAL;
 	}
 
+	sd->owner = module;
+
 	mutex_lock(&list_lock);
 
 	list_for_each_entry(notifier, &notifier_list, notifier_entry) {
@@ -869,9 +871,11 @@ err_unbind_one:
 err_unlock:
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
@@ -310,7 +310,9 @@ void v4l2_async_nf_cleanup(struct v4l2_a
  *
  * @sd: pointer to &struct v4l2_subdev
  */
-int v4l2_async_register_subdev(struct v4l2_subdev *sd);
+#define v4l2_async_register_subdev(sd) \
+	__v4l2_async_register_subdev(sd, THIS_MODULE)
+int __v4l2_async_register_subdev(struct v4l2_subdev *sd, struct module *module);
 
 /**
  * v4l2_async_register_subdev_sensor - registers a sensor sub-device to the


