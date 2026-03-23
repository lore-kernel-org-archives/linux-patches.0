Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53343AE1B9;
	Mon, 23 Mar 2026 14:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274928; cv=none; b=YSxXGqfPMqHUVNqKMgQ3jCg9e/hu0kZus+IJeeJicvJMcj/WtOeLzTxMAz7mrNphTzlREo3CCyTuK1Bo6WnifSq3KdKznH2ByLRZBCjfpiOUIpZiRXCnR5AEaSY1+ipS95cH1tjOgQ7BL0SE6FgK6yebONgKISeWm1ELdUlFfCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274928; c=relaxed/simple;
	bh=nznFkB9wzQs9LWBP8BC1cVfOxtTVGlRUSS8dXWbutSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q6ovnSxvLiOKSZhUucGipqnpG5BRJbd/yZHtBNEtj+d/aEr9+F+VL8lN8mt/3wmXeccGV7IJNbqOoVlhg6il8ufDpH+jk0952OhXjKFSjwgj+qpZJ4m70bTPOAUIj7108AdcE6cXWRFjWjJ/vaNuiHwO/0FRINs4hpuUyHzXXXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PR0Bak98; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PR0Bak98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7882DC4CEF7;
	Mon, 23 Mar 2026 14:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274927;
	bh=nznFkB9wzQs9LWBP8BC1cVfOxtTVGlRUSS8dXWbutSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PR0Bak98JJfTt3zKv2SKTDbesJvhX+bWAdOSZXCTpetfmyVetH4NP+1hEjwbU+HGJ
	 Sce2gOk1bxQEB0umZOcWSkLnXSSlEHpf/RckLX6QmyCM3YONcoCQ+ySpGyvf27Q0IE
	 HSxSYiBi3XjpwgLeimsvNbqnVBjtlLFOxcQUh4yE=
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
Subject: [PATCH 6.18 159/212] libie: prevent memleak in fwlog code
Date: Mon, 23 Mar 2026 14:46:20 +0100
Message-ID: <20260323134508.774354066@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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



