Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA113AA1BC;
	Tue, 13 Oct 2026 12:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894191; cv=none; b=KivIXPHiYtQlinOIrtIbbVglOwypNFckpw7OfgPdHqgQgQ7oQ8egWqB77nIQhFwE4Q+orGBbc28oIkbHPE2InItJ2EOiWNxvJIgM/2M88qEwbGuyGutx8u7ZS99MBebiU55tKGlQJVfrfLHHaKYoePIKLHvVBg9YyVIEvRkj7Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894191; c=relaxed/simple;
	bh=2GfLQ1Pdh+Yd26q7XoHqcFukgcketP753bW60L+MXts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZGaDSJZhLWmtNWrJvjRIiEykfu6srb+V1Emz2eFb287M3HZ4Rs1CR1z8KiIDwI6ORfp38zXUFTlYfoCZ9vXua53+jx8psyEPZ7nFMhKlW/H7E7elwLThdYemxSBrhQTOSOSQZtUKSZ8EYKl8rYmM9JfcNNol4TWHZzbC8BWg7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLn4M5mL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLn4M5mL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF8F1F000FF;
	Tue, 13 Oct 2026 12:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894190;
	bh=7hbAF5ZuXYrA1RqHO7wnwODav5AC1rZ8g0EGcC109Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sLn4M5mL8r6IadyR/YUmS5ij1moqWiW0wph8VfxJoT0v3SCxiJxN0FFwluEqmzTsH
	 RDVJ4m8O8qgRGawp065qxD9qjpLG95QjExZ8CeDSBPwHmzQcihxu+5QRZfOo7Oij/F
	 QzpD1t4Bg9ft0YtSjnV5LFazdmtGguDu28MMdhio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 475/621] firmware: arm_scmi: Fix OF node reference handling
Date: Tue, 13 Oct 2026 13:37:50 +0200
Message-ID: <20261013112932.107181932@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 659705f5eb378cea462214b74bdc6240cdab53fc ]

SCMI devices store the DT node in dev.of_node through
device_set_node(), but that helper only assigns the fwnode and
of_node pointers without taking an OF node reference.

Take a reference when assigning the node and release it from the
SCMI device release path. With the device owning that reference,
remove the separate channel-side get/put pair from the core driver.

Fixes: 96da4a99ce50 ("firmware: arm_scmi: Set fwnode for the scmi_device")
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-12-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Stable-dep-of: 6abe8fe36b29 ("firmware: arm_scmi: Fix SCMI device destroy lifetimes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/bus.c    | 3 ++-
 drivers/firmware/arm_scmi/driver.c | 4 ----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/arm_scmi/bus.c b/drivers/firmware/arm_scmi/bus.c
index 3ead4085ad946..169fbcba7c3cb 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -426,6 +426,7 @@ static void scmi_device_release(struct device *dev)
 	struct scmi_device *scmi_dev = to_scmi_dev(dev);
 
 	scmi_device_release_syspower(scmi_dev);
+	of_node_put(dev->of_node);
 	kfree_const(scmi_dev->name);
 	kfree(scmi_dev);
 }
@@ -489,7 +490,7 @@ __scmi_device_create(struct device_node *np, struct device *parent,
 
 	scmi_dev->id = id;
 	scmi_dev->dev.parent = parent;
-	device_set_node(&scmi_dev->dev, of_fwnode_handle(np));
+	device_set_node(&scmi_dev->dev, of_fwnode_handle(of_node_get(np)));
 	scmi_dev->dev.bus = &scmi_bus_type;
 	scmi_dev->dev.release = scmi_device_release;
 	dev_set_name(&scmi_dev->dev, "scmi_dev.%d", id);
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 5a9d6df50679c..9e81d7c9a4494 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2703,14 +2703,12 @@ static int scmi_chan_setup(struct scmi_info *info, struct device_node *of_node,
 		devm_kfree(info->dev, cinfo);
 		return -EINVAL;
 	}
-	of_node_get(of_node);
 
 	cinfo->id = prot_id;
 	cinfo->dev = &tdev->dev;
 	cinfo->handle = &info->handle;
 	ret = info->desc->ops->chan_setup(cinfo, info->dev, tx);
 	if (ret) {
-		of_node_put(of_node);
 		scmi_device_destroy(info->dev, prot_id, name);
 		devm_kfree(info->dev, cinfo);
 		return ret;
@@ -2734,7 +2732,6 @@ static int scmi_chan_setup(struct scmi_info *info, struct device_node *of_node,
 		/* Destroy channel and device only if created by this call. */
 		if (tdev) {
 			info->desc->ops->chan_free(prot_id, cinfo, idr);
-			of_node_put(of_node);
 			scmi_device_destroy(info->dev, prot_id, name);
 			devm_kfree(info->dev, cinfo);
 		}
@@ -2820,7 +2817,6 @@ static int scmi_chan_destroy(int id, void *p, void *data)
 		struct scmi_info *info = handle_to_scmi_info(cinfo->handle);
 		struct scmi_device *sdev = to_scmi_dev(cinfo->dev);
 
-		of_node_put(cinfo->dev->of_node);
 		scmi_device_destroy(info->dev, cinfo->id, sdev->name);
 		cinfo->dev = NULL;
 	}
-- 
2.53.0



