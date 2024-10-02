Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C981D0499;
	Wed,  2 Oct 2024 14:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878447; cv=none; b=L+H5Or/IhSCXYel3L2tXilx8upUyQexEp4mFIcgDiAOQUs3xcsgYS6EuH2rrOIJp7KICtnE78ShMM26S2ANmFyUxXg0f/7SmP3l/uYP6aITmTHm15LnuHvWwa58NUtTWvDlG4NifyEn6mcBY0zJNcyWEQzf67pPQoo6k4w8ARi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878447; c=relaxed/simple;
	bh=9RjDgkebZhS8VpIVp0mmziK302P5la4Toor5lzS71Yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmUR6wpjkcNpHXFIxl2k+BYFh4eVWRetLZQ+UvC/Jm69EGvgGRqG59En5hUyu2Ye29V02R6npINqtV7FTti5a6iP+vVwZjbK08/3PWaY31yQonBbuOcrrLeJgqbagFXfZRnJNtUFlxKTlr7ED3M1AO0kvvHo++NxE3FRGmp+xpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IWtSiqTz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IWtSiqTz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84655C4CEC2;
	Wed,  2 Oct 2024 14:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878446;
	bh=9RjDgkebZhS8VpIVp0mmziK302P5la4Toor5lzS71Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IWtSiqTzwgui2yATSuLdeiaUZsQVuL7+S9bTZ+08Sr6IFhqRmJV6NBenONInWFnla
	 yG+V6rbOwFZHu9+S3NmEL3fm+BX3OdCHLgX+sjn93R1BdMW0g+FgiS9gVuEHkipcQ4
	 YVS0F0oXZ4O0wTxBX0aRBXP7Srv39Lrx7FlfFIO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 417/634] driver core: Fix error handling in driver API device_rename()
Date: Wed,  2 Oct 2024 14:58:37 +0200
Message-ID: <20241002125827.564697731@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit 6d8249ac29bc23260dfa9747eb398ce76012d73c ]

For class-device, device_rename() failure maybe cause unexpected link name
within its class folder as explained below:

/sys/class/.../old_name -> /sys/devices/.../old_name
device_rename(..., new_name) and failed
/sys/class/.../new_name -> /sys/devices/.../old_name

Fixed by undoing renaming link if renaming kobject failed.

Fixes: f349cf34731c ("driver core: Implement ns directory support for device classes.")
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20240722-device_rename_fix-v2-1-77de1a6c6495@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index b5399262198a6..6c1a944c00d9b 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -4515,9 +4515,11 @@ EXPORT_SYMBOL_GPL(device_destroy);
  */
 int device_rename(struct device *dev, const char *new_name)
 {
+	struct subsys_private *sp = NULL;
 	struct kobject *kobj = &dev->kobj;
 	char *old_device_name = NULL;
 	int error;
+	bool is_link_renamed = false;
 
 	dev = get_device(dev);
 	if (!dev)
@@ -4532,7 +4534,7 @@ int device_rename(struct device *dev, const char *new_name)
 	}
 
 	if (dev->class) {
-		struct subsys_private *sp = class_to_subsys(dev->class);
+		sp = class_to_subsys(dev->class);
 
 		if (!sp) {
 			error = -EINVAL;
@@ -4541,16 +4543,19 @@ int device_rename(struct device *dev, const char *new_name)
 
 		error = sysfs_rename_link_ns(&sp->subsys.kobj, kobj, old_device_name,
 					     new_name, kobject_namespace(kobj));
-		subsys_put(sp);
 		if (error)
 			goto out;
+
+		is_link_renamed = true;
 	}
 
 	error = kobject_rename(kobj, new_name);
-	if (error)
-		goto out;
-
 out:
+	if (error && is_link_renamed)
+		sysfs_rename_link_ns(&sp->subsys.kobj, kobj, new_name,
+				     old_device_name, kobject_namespace(kobj));
+	subsys_put(sp);
+
 	put_device(dev);
 
 	kfree(old_device_name);
-- 
2.43.0



