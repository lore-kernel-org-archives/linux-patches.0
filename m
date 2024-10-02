Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177981D0B9B;
	Wed,  2 Oct 2024 13:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876495; cv=none; b=K9tF3LnV9ApFz4Hsuhc6czeROCnJNV+FDsodAMmpzNuKd51pVDnD8O5XP3JY3UHOYlRA4EQWpO/kE3c18WoYO2tXz6DDLrjLLElS6w8DaFHFPCXSF2uxvO4DcPP7Fvahz3PPqKP9B04tFwp5z5ghStVGkPTrBTmfHNKpCYceinU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876495; c=relaxed/simple;
	bh=e2rgpZ0/CCNcyTusu4MR10BHwlp5c8UM5dK16TiPQLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhyHibem7/THpxsYTOy3GQBcEq8ug4y06sUHkUaFfsou8QjXnnqR31ppoD5+o0b43XCUIVK+SPh0YlFLXVypmCr1KFMNHFqaLyyXUM03ErsjhpMniX8cDn/2jThaRw21V04Qx6a2Af7HWGCCJRbhRs6wtxdQbBEWjb85cfXvkME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xu+L7oWH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xu+L7oWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EA3C4CEC5;
	Wed,  2 Oct 2024 13:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876494;
	bh=e2rgpZ0/CCNcyTusu4MR10BHwlp5c8UM5dK16TiPQLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xu+L7oWH1eGIilQgBlk1cVS/vhWqp9oFQBxgxEPei6FnyPKNOBg+8q/I1wcKVRqcE
	 X+1Mdc+EmT2LTs+4x4/D7IfjvKtdU02Jk4CbTiDkO+7LwwIpRs/EJVLqk6DImmxhJP
	 by8ik5ctavxCFdApkERGGgO2bfZylUDa58kgIxN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 456/695] driver core: Fix error handling in driver API device_rename()
Date: Wed,  2 Oct 2024 14:57:34 +0200
Message-ID: <20241002125840.658066133@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 8c0733d3aad8e..3b0f4b6153fc5 100644
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



