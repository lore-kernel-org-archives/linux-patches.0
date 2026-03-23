Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7077F1F91F6;
	Mon, 23 Mar 2026 13:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274264; cv=none; b=ecpcDurb2TwP27F428qgD/LjMnmCRgJ0NslsM0njcHiJiN6/ZCobv03byeqJ/iEtqZnsOh3AGKXgGOwy48Se/KMHXYtJ4vfzUYWGuCKO8wpgLYlONw89Rydta8ndhJbBXUTK7hC7gnAB3HLdwSd7x9vmmvqiccDCB46mlZuxM9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274264; c=relaxed/simple;
	bh=2/6O9ncgUkHf+dQJQl/EpLYKZCDj7pZVv9bXhogGP0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VTh9hebAf9YQNQ4W118arhzBi1zrss9fHnDXfD47c+/d1Y45zz3pbrWQjaluMnFSumr/TyZdXuTKQKmN2e38W1DyJHsWN4cnwHUz24MXXcaV4vIZ1PCnk6Q6uE3m01Lr9s5uHMH/5Hzwin1b9cfYrlDHYZUa+BhqwOhqRc+v+94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RmaCBwLB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RmaCBwLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45FFC4CEF7;
	Mon, 23 Mar 2026 13:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274264;
	bh=2/6O9ncgUkHf+dQJQl/EpLYKZCDj7pZVv9bXhogGP0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RmaCBwLBeIaaTX4Bvmr1VwYZTttnmod7TBKIEuZL4vPsUtjjuW0XZk2OPn1IomH/+
	 mk0mt0FU1mYtAVNN62uipJ2AjLMYA/3R55aSS0lfFTFUObnXTqS31V8MOmuE7eCOOr
	 AUcyhthIQzTuceAQuxPUQxcZ4LhgzI5dVh/Nxr6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.19 160/220] libie: prevent memleak in fwlog code
Date: Mon, 23 Mar 2026 14:45:37 +0100
Message-ID: <20260323134509.621696970@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

[ Upstream commit 6850deb61118345996f03b87817b4ae0f2f25c38 ]

All cmd_buf buffers are allocated and need to be freed after usage.
Add an error unwinding path that properly frees these buffers.

The memory leak happens whenever fwlog configuration is changed. For
example:

$echo 256K > /sys/kernel/debug/ixgbe/0000\:32\:00.0/fwlog/log_size

Fixes: 96a9a9341cda ("ice: configure FW logging")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/libie/fwlog.c | 49 +++++++++++++++++-------
 1 file changed, 36 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/libie/fwlog.c b/drivers/net/ethernet/intel/libie/fwlog.c
index 5d890d9d3c4d5..3b32986c2978a 100644
--- a/drivers/net/ethernet/intel/libie/fwlog.c
+++ b/drivers/net/ethernet/intel/libie/fwlog.c
@@ -433,17 +433,21 @@ libie_debugfs_module_write(struct file *filp, const char __user *buf,
 	module = libie_find_module_by_dentry(fwlog->debugfs_modules, dentry);
 	if (module < 0) {
 		dev_info(dev, "unknown module\n");
-		return -EINVAL;
+		count = -EINVAL;
+		goto free_cmd_buf;
 	}
 
 	cnt = sscanf(cmd_buf, "%s", user_val);
-	if (cnt != 1)
-		return -EINVAL;
+	if (cnt != 1) {
+		count = -EINVAL;
+		goto free_cmd_buf;
+	}
 
 	log_level = sysfs_match_string(libie_fwlog_level_string, user_val);
 	if (log_level < 0) {
 		dev_info(dev, "unknown log level '%s'\n", user_val);
-		return -EINVAL;
+		count = -EINVAL;
+		goto free_cmd_buf;
 	}
 
 	if (module != LIBIE_AQC_FW_LOG_ID_MAX) {
@@ -458,6 +462,9 @@ libie_debugfs_module_write(struct file *filp, const char __user *buf,
 			fwlog->cfg.module_entries[i].log_level = log_level;
 	}
 
+free_cmd_buf:
+	kfree(cmd_buf);
+
 	return count;
 }
 
@@ -515,23 +522,31 @@ libie_debugfs_nr_messages_write(struct file *filp, const char __user *buf,
 		return PTR_ERR(cmd_buf);
 
 	ret = sscanf(cmd_buf, "%s", user_val);
-	if (ret != 1)
-		return -EINVAL;
+	if (ret != 1) {
+		count = -EINVAL;
+		goto free_cmd_buf;
+	}
 
 	ret = kstrtos16(user_val, 0, &nr_messages);
-	if (ret)
-		return ret;
+	if (ret) {
+		count = ret;
+		goto free_cmd_buf;
+	}
 
 	if (nr_messages < LIBIE_AQC_FW_LOG_MIN_RESOLUTION ||
 	    nr_messages > LIBIE_AQC_FW_LOG_MAX_RESOLUTION) {
 		dev_err(dev, "Invalid FW log number of messages %d, value must be between %d - %d\n",
 			nr_messages, LIBIE_AQC_FW_LOG_MIN_RESOLUTION,
 			LIBIE_AQC_FW_LOG_MAX_RESOLUTION);
-		return -EINVAL;
+		count = -EINVAL;
+		goto free_cmd_buf;
 	}
 
 	fwlog->cfg.log_resolution = nr_messages;
 
+free_cmd_buf:
+	kfree(cmd_buf);
+
 	return count;
 }
 
@@ -588,8 +603,10 @@ libie_debugfs_enable_write(struct file *filp, const char __user *buf,
 		return PTR_ERR(cmd_buf);
 
 	ret = sscanf(cmd_buf, "%s", user_val);
-	if (ret != 1)
-		return -EINVAL;
+	if (ret != 1) {
+		ret = -EINVAL;
+		goto free_cmd_buf;
+	}
 
 	ret = kstrtobool(user_val, &enable);
 	if (ret)
@@ -624,6 +641,8 @@ libie_debugfs_enable_write(struct file *filp, const char __user *buf,
 	 */
 	if (WARN_ON(ret != (ssize_t)count && ret >= 0))
 		ret = -EIO;
+free_cmd_buf:
+	kfree(cmd_buf);
 
 	return ret;
 }
@@ -682,8 +701,10 @@ libie_debugfs_log_size_write(struct file *filp, const char __user *buf,
 		return PTR_ERR(cmd_buf);
 
 	ret = sscanf(cmd_buf, "%s", user_val);
-	if (ret != 1)
-		return -EINVAL;
+	if (ret != 1) {
+		ret = -EINVAL;
+		goto free_cmd_buf;
+	}
 
 	index = sysfs_match_string(libie_fwlog_log_size, user_val);
 	if (index < 0) {
@@ -712,6 +733,8 @@ libie_debugfs_log_size_write(struct file *filp, const char __user *buf,
 	 */
 	if (WARN_ON(ret != (ssize_t)count && ret >= 0))
 		ret = -EIO;
+free_cmd_buf:
+	kfree(cmd_buf);
 
 	return ret;
 }
-- 
2.51.0



