Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA862156238;
	Mon,  6 Jan 2025 15:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176765; cv=none; b=auRsW+fNbA/TN+QBn3q1BQ73s5tnvm2wBBgK2rg0FShTd9cOrM+1pZ3Swfr6MaSe8zvDN7yKqarglkud1NxHU2lxWvyUD7UeRklfREWlcAXFpn0fXc4stXbA7F4qb27T7U74zFIlnFZX4KSvWZPYNCOdMf+ASBdvRMpNvltXU/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176765; c=relaxed/simple;
	bh=3nVGG/MO0zyQNLMoiXTsb5YxJMoLrQza/Y0JRyx3Wic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZASUMzofi8E6cb78SS1v4jg5t7cA2RHbXS0mKN5Ppa4MCnG/bROxhWNTO2+OOO7AaHnERVNzwGIIp2UUy+rfR7nlg1dsFRAMQdu4j9lj7a+mkGLF2VO+NhkMYJ/eFjPmVqGTnwp7TewPS+7/kpic1/0MIJflInM0KMLMm2Wev+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6mde+CH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6mde+CH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C972C4CEE2;
	Mon,  6 Jan 2025 15:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176764;
	bh=3nVGG/MO0zyQNLMoiXTsb5YxJMoLrQza/Y0JRyx3Wic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F6mde+CH/fJzIRIG2Jaq71xHhGE4584oMVNDlRUb8YJrkpBWGtscFCtIyNud8pGrU
	 aLYvc3Zf7mr+onL08zgk5pbVygW/0a5rBVrmAw2u/2h8bRuZvEspzIxfLNJcWMuZXe
	 fN6tc5hh6K+bKy4PLB+8zhSvuhBRCtMTSrMnx9cU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Hughes <hughsient@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 07/81] thunderbolt: Dont display nvm_version unless upgrade supported
Date: Mon,  6 Jan 2025 16:15:39 +0100
Message-ID: <20250106151129.715244516@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index edbd92435b41..5bd5c22a5085 100644
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
 
@@ -304,6 +303,19 @@ static ssize_t vendor_show(struct device *dev, struct device_attribute *attr,
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
@@ -313,6 +325,7 @@ static struct attribute *retimer_attrs[] = {
 };
 
 static const struct attribute_group retimer_group = {
+	.is_visible = retimer_is_visible,
 	.attrs = retimer_attrs,
 };
 
-- 
2.39.5



