Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9490188006;
	Mon, 23 Dec 2024 16:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970001; cv=none; b=C2CbmP/k9p2URdLSO4CcSwx9vfmKdYTx1k3Brmil47huVdkWFQjwLjNs4Prh+qaUEuEI5lYyEc7ndI6kNKm6fg2lUq0B+Fj1rzeY4sF9YHhPdGhimyKCUvTi/9jeu1M3nEw7undC4xvLCl+L6WO6L2BFmQbWbNrthO0xQQkvJbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970001; c=relaxed/simple;
	bh=3fCJUcY8idZHLO0A9v8tfaV4ztUvPWik3UzDClEoJ6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3KmCd7AqP85T0BYGh/IDCQArRxUoIaceXgB071fXHMCMeX5jlbN/ERb8zUb1HDJvn44lJA+q0FZNyVPb3h4EnT4oDUzA+KA/RcdrnPVLCKFBbXKmoXx5XiMoutvB8mbjdDqE0ehVJaVxGlCz0i8ONeA8y/M7Xi12k7Sulf87KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ntVS+UqM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ntVS+UqM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C2FC4CED3;
	Mon, 23 Dec 2024 16:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970001;
	bh=3fCJUcY8idZHLO0A9v8tfaV4ztUvPWik3UzDClEoJ6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ntVS+UqMkQPZgR6kg1QlDg2xPc3kGWLe8Jbu2cDbdkM5jzf1APbJiAej0P9MEtcXy
	 m9zQlhHVigV+rG/LKj7GDJMye+Y44tJt3BqHJuIBCbYaPTcB3GTHsHD2cgaGOv9YUW
	 vdqB4+1FRkUgPbv7kGCvzC1jwYweiVeF05UeSzcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Hughes <hughsient@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.12 084/160] thunderbolt: Dont display nvm_version unless upgrade supported
Date: Mon, 23 Dec 2024 16:58:15 +0100
Message-ID: <20241223155411.942334827@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit e34f1717ef0632fcec5cb827e5e0e9f223d70c9b upstream.

The read will never succeed if NVM wasn't initialized due to an unknown
format.

Add a new callback for visibility to only show when supported.

Cc: stable@vger.kernel.org
Fixes: aef9c693e7e5 ("thunderbolt: Move vendor specific NVM handling into nvm.c")
Reported-by: Richard Hughes <hughsient@gmail.com>
Closes: https://github.com/fwupd/fwupd/issues/8200
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/retimer.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/thunderbolt/retimer.c
+++ b/drivers/thunderbolt/retimer.c
@@ -103,6 +103,7 @@ static int tb_retimer_nvm_add(struct tb_
 
 err_nvm:
 	dev_dbg(&rt->dev, "NVM upgrade disabled\n");
+	rt->no_nvm_upgrade = true;
 	if (!IS_ERR(nvm))
 		tb_nvm_free(nvm);
 
@@ -182,8 +183,6 @@ static ssize_t nvm_authenticate_show(str
 
 	if (!rt->nvm)
 		ret = -EAGAIN;
-	else if (rt->no_nvm_upgrade)
-		ret = -EOPNOTSUPP;
 	else
 		ret = sysfs_emit(buf, "%#x\n", rt->auth_status);
 
@@ -323,8 +322,6 @@ static ssize_t nvm_version_show(struct d
 
 	if (!rt->nvm)
 		ret = -EAGAIN;
-	else if (rt->no_nvm_upgrade)
-		ret = -EOPNOTSUPP;
 	else
 		ret = sysfs_emit(buf, "%x.%x\n", rt->nvm->major, rt->nvm->minor);
 
@@ -342,6 +339,19 @@ static ssize_t vendor_show(struct device
 }
 static DEVICE_ATTR_RO(vendor);
 
+static umode_t retimer_is_visible(struct kobject *kobj, struct attribute *attr,
+				  int n)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct tb_retimer *rt = tb_to_retimer(dev);
+
+	if (attr == &dev_attr_nvm_authenticate.attr ||
+	    attr == &dev_attr_nvm_version.attr)
+		return rt->no_nvm_upgrade ? 0 : attr->mode;
+
+	return attr->mode;
+}
+
 static struct attribute *retimer_attrs[] = {
 	&dev_attr_device.attr,
 	&dev_attr_nvm_authenticate.attr,
@@ -351,6 +361,7 @@ static struct attribute *retimer_attrs[]
 };
 
 static const struct attribute_group retimer_group = {
+	.is_visible = retimer_is_visible,
 	.attrs = retimer_attrs,
 };
 


