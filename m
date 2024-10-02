Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280F51D0438;
	Wed,  2 Oct 2024 14:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880135; cv=none; b=J9+8OpDX90DabgGxYUlu9VoqxfzfhXoQWFUwi8JXJXNpibCfPNMVKITcz9XemRFOeFLVBu14UxwA0c3s8fcVNaaP5lp096ptzy4rt+iCk/lUX5ui9nOntIi2kio+J5r7XKcnQ83LRKJkiehuDygMe1GoH1JDvZxmU+FZUeo+37U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880135; c=relaxed/simple;
	bh=8cOmDY4IdBe5aFijQa4joQR3zCv6SE0zVKZPJQWf3VU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0X3f9JMdRHd/d9iiWwwHpJAthlxGQMHFwXYMAmysS1LC7PgkSDKoaz+J4aQFAh9d9Hg5L3ZpxB0MAPcH2nIV1nCzX3ckLWG5Ls+0bDF0fyOkbzEm1iWKi4oZydJaXt8QzVPwODkWH4h4HPwNSbSEBz4XIiOXvpGaONVQt1S9BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MUBPLApi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MUBPLApi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D64C4CEC2;
	Wed,  2 Oct 2024 14:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880135;
	bh=8cOmDY4IdBe5aFijQa4joQR3zCv6SE0zVKZPJQWf3VU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MUBPLApiK13o2+QhAdXvT3RS43Dmm07lXQuNFtn/t2NfuzzWoBtLJ6D5ZxbcJi+Y5
	 3AQasSvxt9PVADt7ivM2/CnoNBj0dzfUTPYppc0EiLwy7UK6Kh7Wu8HaDGZIn913tG
	 JPENt7jnr2YrMht4W8IZX7ahDstSIgzuQeeRURHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 355/538] driver core: Fix error handling in driver API device_rename()
Date: Wed,  2 Oct 2024 14:59:54 +0200
Message-ID: <20241002125806.440489994@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cb323700e952f..60a0a4630a5bb 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -4485,9 +4485,11 @@ EXPORT_SYMBOL_GPL(device_destroy);
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
@@ -4502,7 +4504,7 @@ int device_rename(struct device *dev, const char *new_name)
 	}
 
 	if (dev->class) {
-		struct subsys_private *sp = class_to_subsys(dev->class);
+		sp = class_to_subsys(dev->class);
 
 		if (!sp) {
 			error = -EINVAL;
@@ -4511,16 +4513,19 @@ int device_rename(struct device *dev, const char *new_name)
 
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



