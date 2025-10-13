Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1303081D1;
	Mon, 13 Oct 2025 15:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368429; cv=none; b=uYZE4SyfxbGr8vgC99pwcqafxPJ8XC35g7O8ZoG+XZxwalRIG0iP2l1iSpYAolu+tyZnfDvEGbiWdVMIWy4l99DadgFNr2NtYAk+U7l++1P+aGmo9W32eCgDTlVnFjxlMCEq9+DCTqpT6Vwy5F5MwC07uttGKuigtF0APrffRhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368429; c=relaxed/simple;
	bh=2M+1eKBu0cvXq+H4LqnvI3qs317JXRBB/Zk/8xHJZdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBAGinAIgic1H8ITAbPYs5P1TPKfezQP2FZ7NhkgelF+8lz0AQQx82q0Q27V9bJ1G+tZ87La6UEopvWMopjWv+OaDxtMLY/vyfHFEoyFqst+0Tmhw6JsfgxhKZrq+fWoKl7x2Px4kDJCRL/+E0KixINOqsqPa7XdJo4oWP8+z1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2j7Tc8VK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2j7Tc8VK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966F1C4CEE7;
	Mon, 13 Oct 2025 15:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368429;
	bh=2M+1eKBu0cvXq+H4LqnvI3qs317JXRBB/Zk/8xHJZdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2j7Tc8VKe4MG8t9cItUK+KNlO3KaynaRIAtZCTqH9S8166WUVP59Z74Vk8uQ1D+uB
	 AYY6SXXgDEs8S9ZA0gj4K+nsLi24kRZqgAciHwzktBO4D6/fZ9ftrKQHVh7wNuc1cI
	 SEOr8awpupFWo0YMCOXlUvg4+VhqNXeX3omjb/Fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 159/262] HID: hidraw: tighten ioctl command parsing
Date: Mon, 13 Oct 2025 16:45:01 +0200
Message-ID: <20251013144331.848883118@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <bentiss@kernel.org>

[ Upstream commit 75d5546f60b36900051d75ee623fceccbeb6750c ]

The handling for variable-length ioctl commands in hidraw_ioctl() is
rather complex and the check for the data direction is incomplete.

Simplify this code by factoring out the various ioctls grouped by dir
and size, and using a switch() statement with the size masked out, to
ensure the rest of the command is correctly matched.

Fixes: 9188e79ec3fd ("HID: add phys and name ioctls to hidraw")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hidraw.c        | 224 ++++++++++++++++++++----------------
 include/uapi/linux/hidraw.h |   2 +
 2 files changed, 124 insertions(+), 102 deletions(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index c887f48756f4b..bbd6f23bce789 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -394,27 +394,15 @@ static int hidraw_revoke(struct hidraw_list *list)
 	return 0;
 }
 
-static long hidraw_ioctl(struct file *file, unsigned int cmd,
-							unsigned long arg)
+static long hidraw_fixed_size_ioctl(struct file *file, struct hidraw *dev, unsigned int cmd,
+				    void __user *arg)
 {
-	struct inode *inode = file_inode(file);
-	unsigned int minor = iminor(inode);
-	long ret = 0;
-	struct hidraw *dev;
-	struct hidraw_list *list = file->private_data;
-	void __user *user_arg = (void __user*) arg;
-
-	down_read(&minors_rwsem);
-	dev = hidraw_table[minor];
-	if (!dev || !dev->exist || hidraw_is_revoked(list)) {
-		ret = -ENODEV;
-		goto out;
-	}
+	struct hid_device *hid = dev->hid;
 
 	switch (cmd) {
 		case HIDIOCGRDESCSIZE:
-			if (put_user(dev->hid->rsize, (int __user *)arg))
-				ret = -EFAULT;
+			if (put_user(hid->rsize, (int __user *)arg))
+				return -EFAULT;
 			break;
 
 		case HIDIOCGRDESC:
@@ -422,113 +410,145 @@ static long hidraw_ioctl(struct file *file, unsigned int cmd,
 				__u32 len;
 
 				if (get_user(len, (int __user *)arg))
-					ret = -EFAULT;
-				else if (len > HID_MAX_DESCRIPTOR_SIZE - 1)
-					ret = -EINVAL;
-				else if (copy_to_user(user_arg + offsetof(
-					struct hidraw_report_descriptor,
-					value[0]),
-					dev->hid->rdesc,
-					min(dev->hid->rsize, len)))
-					ret = -EFAULT;
+					return -EFAULT;
+
+				if (len > HID_MAX_DESCRIPTOR_SIZE - 1)
+					return -EINVAL;
+
+				if (copy_to_user(arg + offsetof(
+				    struct hidraw_report_descriptor,
+				    value[0]),
+				    hid->rdesc,
+				    min(hid->rsize, len)))
+					return -EFAULT;
+
 				break;
 			}
 		case HIDIOCGRAWINFO:
 			{
 				struct hidraw_devinfo dinfo;
 
-				dinfo.bustype = dev->hid->bus;
-				dinfo.vendor = dev->hid->vendor;
-				dinfo.product = dev->hid->product;
-				if (copy_to_user(user_arg, &dinfo, sizeof(dinfo)))
-					ret = -EFAULT;
+				dinfo.bustype = hid->bus;
+				dinfo.vendor = hid->vendor;
+				dinfo.product = hid->product;
+				if (copy_to_user(arg, &dinfo, sizeof(dinfo)))
+					return -EFAULT;
 				break;
 			}
 		case HIDIOCREVOKE:
 			{
-				if (user_arg)
-					ret = -EINVAL;
-				else
-					ret = hidraw_revoke(list);
-				break;
+				struct hidraw_list *list = file->private_data;
+
+				if (arg)
+					return -EINVAL;
+
+				return hidraw_revoke(list);
 			}
 		default:
-			{
-				struct hid_device *hid = dev->hid;
-				if (_IOC_TYPE(cmd) != 'H') {
-					ret = -EINVAL;
-					break;
-				}
+			/*
+			 * None of the above ioctls can return -EAGAIN, so
+			 * use it as a marker that we need to check variable
+			 * length ioctls.
+			 */
+			return -EAGAIN;
+	}
 
-				if (_IOC_NR(cmd) == _IOC_NR(HIDIOCSFEATURE(0))) {
-					int len = _IOC_SIZE(cmd);
-					ret = hidraw_send_report(file, user_arg, len, HID_FEATURE_REPORT);
-					break;
-				}
-				if (_IOC_NR(cmd) == _IOC_NR(HIDIOCGFEATURE(0))) {
-					int len = _IOC_SIZE(cmd);
-					ret = hidraw_get_report(file, user_arg, len, HID_FEATURE_REPORT);
-					break;
-				}
+	return 0;
+}
 
-				if (_IOC_NR(cmd) == _IOC_NR(HIDIOCSINPUT(0))) {
-					int len = _IOC_SIZE(cmd);
-					ret = hidraw_send_report(file, user_arg, len, HID_INPUT_REPORT);
-					break;
-				}
-				if (_IOC_NR(cmd) == _IOC_NR(HIDIOCGINPUT(0))) {
-					int len = _IOC_SIZE(cmd);
-					ret = hidraw_get_report(file, user_arg, len, HID_INPUT_REPORT);
-					break;
-				}
+static long hidraw_rw_variable_size_ioctl(struct file *file, struct hidraw *dev, unsigned int cmd,
+					  void __user *user_arg)
+{
+	int len = _IOC_SIZE(cmd);
+
+	switch (cmd & ~IOCSIZE_MASK) {
+	case HIDIOCSFEATURE(0):
+		return hidraw_send_report(file, user_arg, len, HID_FEATURE_REPORT);
+	case HIDIOCGFEATURE(0):
+		return hidraw_get_report(file, user_arg, len, HID_FEATURE_REPORT);
+	case HIDIOCSINPUT(0):
+		return hidraw_send_report(file, user_arg, len, HID_INPUT_REPORT);
+	case HIDIOCGINPUT(0):
+		return hidraw_get_report(file, user_arg, len, HID_INPUT_REPORT);
+	case HIDIOCSOUTPUT(0):
+		return hidraw_send_report(file, user_arg, len, HID_OUTPUT_REPORT);
+	case HIDIOCGOUTPUT(0):
+		return hidraw_get_report(file, user_arg, len, HID_OUTPUT_REPORT);
+	}
 
-				if (_IOC_NR(cmd) == _IOC_NR(HIDIOCSOUTPUT(0))) {
-					int len = _IOC_SIZE(cmd);
-					ret = hidraw_send_report(file, user_arg, len, HID_OUTPUT_REPORT);
-					break;
-				}
-				if (_IOC_NR(cmd) == _IOC_NR(HIDIOCGOUTPUT(0))) {
-					int len = _IOC_SIZE(cmd);
-					ret = hidraw_get_report(file, user_arg, len, HID_OUTPUT_REPORT);
-					break;
-				}
+	return -EINVAL;
+}
 
-				/* Begin Read-only ioctls. */
-				if (_IOC_DIR(cmd) != _IOC_READ) {
-					ret = -EINVAL;
-					break;
-				}
+static long hidraw_ro_variable_size_ioctl(struct file *file, struct hidraw *dev, unsigned int cmd,
+					  void __user *user_arg)
+{
+	struct hid_device *hid = dev->hid;
+	int len = _IOC_SIZE(cmd);
+	int field_len;
+
+	switch (cmd & ~IOCSIZE_MASK) {
+	case HIDIOCGRAWNAME(0):
+		field_len = strlen(hid->name) + 1;
+		if (len > field_len)
+			len = field_len;
+		return copy_to_user(user_arg, hid->name, len) ?  -EFAULT : len;
+	case HIDIOCGRAWPHYS(0):
+		field_len = strlen(hid->phys) + 1;
+		if (len > field_len)
+			len = field_len;
+		return copy_to_user(user_arg, hid->phys, len) ?  -EFAULT : len;
+	case HIDIOCGRAWUNIQ(0):
+		field_len = strlen(hid->uniq) + 1;
+		if (len > field_len)
+			len = field_len;
+		return copy_to_user(user_arg, hid->uniq, len) ?  -EFAULT : len;
+	}
 
-				if (_IOC_NR(cmd) == _IOC_NR(HIDIOCGRAWNAME(0))) {
-					int len = strlen(hid->name) + 1;
-					if (len > _IOC_SIZE(cmd))
-						len = _IOC_SIZE(cmd);
-					ret = copy_to_user(user_arg, hid->name, len) ?
-						-EFAULT : len;
-					break;
-				}
+	return -EINVAL;
+}
 
-				if (_IOC_NR(cmd) == _IOC_NR(HIDIOCGRAWPHYS(0))) {
-					int len = strlen(hid->phys) + 1;
-					if (len > _IOC_SIZE(cmd))
-						len = _IOC_SIZE(cmd);
-					ret = copy_to_user(user_arg, hid->phys, len) ?
-						-EFAULT : len;
-					break;
-				}
+static long hidraw_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct inode *inode = file_inode(file);
+	unsigned int minor = iminor(inode);
+	struct hidraw *dev;
+	struct hidraw_list *list = file->private_data;
+	void __user *user_arg = (void __user *)arg;
+	int ret;
 
-				if (_IOC_NR(cmd) == _IOC_NR(HIDIOCGRAWUNIQ(0))) {
-					int len = strlen(hid->uniq) + 1;
-					if (len > _IOC_SIZE(cmd))
-						len = _IOC_SIZE(cmd);
-					ret = copy_to_user(user_arg, hid->uniq, len) ?
-						-EFAULT : len;
-					break;
-				}
-			}
+	down_read(&minors_rwsem);
+	dev = hidraw_table[minor];
+	if (!dev || !dev->exist || hidraw_is_revoked(list)) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	if (_IOC_TYPE(cmd) != 'H') {
+		ret = -EINVAL;
+		goto out;
+	}
 
+	if (_IOC_NR(cmd) > HIDIOCTL_LAST || _IOC_NR(cmd) == 0) {
 		ret = -ENOTTY;
+		goto out;
 	}
+
+	ret = hidraw_fixed_size_ioctl(file, dev, cmd, user_arg);
+	if (ret != -EAGAIN)
+		goto out;
+
+	switch (_IOC_DIR(cmd)) {
+	case (_IOC_READ | _IOC_WRITE):
+		ret = hidraw_rw_variable_size_ioctl(file, dev, cmd, user_arg);
+		break;
+	case _IOC_READ:
+		ret = hidraw_ro_variable_size_ioctl(file, dev, cmd, user_arg);
+		break;
+	default:
+		/* Any other IOC_DIR is wrong */
+		ret = -EINVAL;
+	}
+
 out:
 	up_read(&minors_rwsem);
 	return ret;
diff --git a/include/uapi/linux/hidraw.h b/include/uapi/linux/hidraw.h
index d5ee269864e07..ebd701b3c18d9 100644
--- a/include/uapi/linux/hidraw.h
+++ b/include/uapi/linux/hidraw.h
@@ -48,6 +48,8 @@ struct hidraw_devinfo {
 #define HIDIOCGOUTPUT(len)    _IOC(_IOC_WRITE|_IOC_READ, 'H', 0x0C, len)
 #define HIDIOCREVOKE	      _IOW('H', 0x0D, int) /* Revoke device access */
 
+#define HIDIOCTL_LAST		_IOC_NR(HIDIOCREVOKE)
+
 #define HIDRAW_FIRST_MINOR 0
 #define HIDRAW_MAX_DEVICES 64
 /* number of reports to buffer */
-- 
2.51.0



