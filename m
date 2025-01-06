Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7141D5CD7;
	Mon,  6 Jan 2025 15:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177181; cv=none; b=rgWmufmK+HD4ukP4TrUT6OVR9MklZz6vKl1CZqZB6PBm9HrIHyc7xKdkBfzIZR35B0ENoznjd8aTGTRY6/FWrCxQNsVZ/dvRxna1iPOvNbWt9KmXCok8L+nZPNODsZQduSKLExb+XBk7yTCR0nTiC5xcu3AOv60nKOJwl7AXUXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177181; c=relaxed/simple;
	bh=IHlmapyYtj2gOeI/jOC2xJEXt1+Vqndjrw4Y2NQw6Z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkySx5+xqDdpoWSuxMYsCopo6VdBsITJfkHRBRH+8JoWwRoy/F9PVSyjsHRQP/3AP/v6aIaHlwrBd0mLU8polv1QP1XeWn7UIaZIV10XBajhFI1GrsB71+r2NFahT/19kEKwNm2uytnLvCcgwx6jhhV7tSZqxBqHUIah1aHWzWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DyBpTrzp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DyBpTrzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D16C4CED2;
	Mon,  6 Jan 2025 15:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177180;
	bh=IHlmapyYtj2gOeI/jOC2xJEXt1+Vqndjrw4Y2NQw6Z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DyBpTrzpXrmYo9fSTQsRohuKAVnUkPBPRtAZCJ5rlG5wLLc1HoTiKO3EHWV+lzjIk
	 Ei7z286E64aZiCb+G5bZjO1kokKd3GlKqiI4iqkFyuiYbrjxHVjbx3akmzEMeIWCx4
	 cikWV0JFlZGao8BHPhMV8SnLysu8riE5JxWqmPug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Hughes <hughsient@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/222] thunderbolt: Dont display nvm_version unless upgrade supported
Date: Mon,  6 Jan 2025 16:14:42 +0100
Message-ID: <20250106151153.555349954@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit e34f1717ef0632fcec5cb827e5e0e9f223d70c9b ]

The read will never succeed if NVM wasn't initialized due to an unknown
format.

Add a new callback for visibility to only show when supported.

Cc: stable@vger.kernel.org
Fixes: aef9c693e7e5 ("thunderbolt: Move vendor specific NVM handling into nvm.c")
Reported-by: Richard Hughes <hughsient@gmail.com>
Closes: https://github.com/fwupd/fwupd/issues/8200
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/retimer.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/thunderbolt/retimer.c b/drivers/thunderbolt/retimer.c
index 47becb363ada..2ee8c5ebca7c 100644
--- a/drivers/thunderbolt/retimer.c
+++ b/drivers/thunderbolt/retimer.c
@@ -98,6 +98,7 @@ static int tb_retimer_nvm_add(struct tb_retimer *rt)
 
 err_nvm:
 	dev_dbg(&rt->dev, "NVM upgrade disabled\n");
+	rt->no_nvm_upgrade = true;
 	if (!IS_ERR(nvm))
 		tb_nvm_free(nvm);
 
@@ -177,8 +178,6 @@ static ssize_t nvm_authenticate_show(struct device *dev,
 
 	if (!rt->nvm)
 		ret = -EAGAIN;
-	else if (rt->no_nvm_upgrade)
-		ret = -EOPNOTSUPP;
 	else
 		ret = sysfs_emit(buf, "%#x\n", rt->auth_status);
 
@@ -331,6 +330,19 @@ static ssize_t vendor_show(struct device *dev, struct device_attribute *attr,
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
@@ -340,6 +352,7 @@ static struct attribute *retimer_attrs[] = {
 };
 
 static const struct attribute_group retimer_group = {
+	.is_visible = retimer_is_visible,
 	.attrs = retimer_attrs,
 };
 
-- 
2.39.5



