Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A80248BB2;
	Wed, 15 Jan 2025 10:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937982; cv=none; b=h14CnNK0UXVFch7+eBled9xXT0X3nLcFu2p6ULFywt0PpXxxbD8m6c9D8FD6N4rZvLxraQaPVVe/YeflBDkS/Hy+P0MFottHtWhAdZYSt7MencxwcbsCYGjIxlprpo9iPF2lrGVZfk4LJFW+8K6XXm+RYwBWfCgnjWvS8O/ORSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937982; c=relaxed/simple;
	bh=2H/UugUuhND+c3LuA04HuuengeejP4j6egQLo4GOPrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABpsjWEv/RfFLYFRGbCh84XrWJNQggZYnoKDTxPw+n3nBJWIYYvobuMSWVezQOhfzTB2iAPQQotEeg4BEr0NoVPVskhD3xvNMhLP8u8UfCd4i0/5aaIclAXzwOuGTYKPwQojbXvf92BYECng7yLb6Una3B7Zvvis8FPW01mrvtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fHuTFybR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fHuTFybR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62036C4CEDF;
	Wed, 15 Jan 2025 10:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937981;
	bh=2H/UugUuhND+c3LuA04HuuengeejP4j6egQLo4GOPrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fHuTFybR+BUFpLyzKFKzmkC17YLtQusIwHz+tZp7/sC2gkCWCw9HstxNohVlOcg9A
	 YWpmmT8MkLdEDMh2pIbauB9AeLOFDNGx1hvx+meCKvWOURzuaBuECHxKPeff+lpSTk
	 r7PnOHHq5ET4k02G/4kUIQRkYAhv6WF8R2mR/Y/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Lan <lanhao@huawei.com>,
	Guangwei Zhang <zhangwangwei6@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/189] net: hns3: Resolved the issue that the debugfs query result is inconsistent.
Date: Wed, 15 Jan 2025 11:35:44 +0100
Message-ID: <20250115103608.276021780@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Lan <lanhao@huawei.com>

[ Upstream commit 5191a8d3c2ab5bc01930ea3425e06a739af5b0e9 ]

This patch modifies the implementation of debugfs:

When the user process stops unexpectedly, not all data of the file system
is read. In this case, the save_buf pointer is not released. When the
user process is called next time, save_buf is used to copy the cached
data to the user space. As a result, the queried data is stale.

To solve this problem, this patch implements .open() and .release() handler
for debugfs file_operations. moving allocation buffer and execution
of the cmd to the .open() handler and freeing in to the .release() handler.
Allocate separate buffer for each reader and associate the buffer
with the file pointer.
When different user read processes no longer share the buffer,
the stale data problem is fixed.

Fixes: 5e69ea7ee2a6 ("net: hns3: refactor the debugfs process")
Signed-off-by: Hao Lan <lanhao@huawei.com>
Signed-off-by: Guangwei Zhang <zhangwangwei6@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/20250106143642.539698-4-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  3 -
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    | 96 ++++++-------------
 2 files changed, 31 insertions(+), 68 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 27dbe367f3d3..d873523e84f2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -916,9 +916,6 @@ struct hnae3_handle {
 
 	u8 netdev_flags;
 	struct dentry *hnae3_dbgfs;
-	/* protects concurrent contention between debugfs commands */
-	struct mutex dbgfs_lock;
-	char **dbgfs_buf;
 
 	/* Network interface message level enabled bits */
 	u32 msg_enable;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 807eb3bbb11c..9bbece25552b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -1260,69 +1260,55 @@ static int hns3_dbg_read_cmd(struct hns3_dbg_data *dbg_data,
 static ssize_t hns3_dbg_read(struct file *filp, char __user *buffer,
 			     size_t count, loff_t *ppos)
 {
-	struct hns3_dbg_data *dbg_data = filp->private_data;
+	char *buf = filp->private_data;
+
+	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
+}
+
+static int hns3_dbg_open(struct inode *inode, struct file *filp)
+{
+	struct hns3_dbg_data *dbg_data = inode->i_private;
 	struct hnae3_handle *handle = dbg_data->handle;
 	struct hns3_nic_priv *priv = handle->priv;
-	ssize_t size = 0;
-	char **save_buf;
-	char *read_buf;
 	u32 index;
+	char *buf;
 	int ret;
 
+	if (!test_bit(HNS3_NIC_STATE_INITED, &priv->state) ||
+	    test_bit(HNS3_NIC_STATE_RESETTING, &priv->state))
+		return -EBUSY;
+
 	ret = hns3_dbg_get_cmd_index(dbg_data, &index);
 	if (ret)
 		return ret;
 
-	mutex_lock(&handle->dbgfs_lock);
-	save_buf = &handle->dbgfs_buf[index];
-
-	if (!test_bit(HNS3_NIC_STATE_INITED, &priv->state) ||
-	    test_bit(HNS3_NIC_STATE_RESETTING, &priv->state)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	if (*save_buf) {
-		read_buf = *save_buf;
-	} else {
-		read_buf = kvzalloc(hns3_dbg_cmd[index].buf_len, GFP_KERNEL);
-		if (!read_buf) {
-			ret = -ENOMEM;
-			goto out;
-		}
-
-		/* save the buffer addr until the last read operation */
-		*save_buf = read_buf;
-
-		/* get data ready for the first time to read */
-		ret = hns3_dbg_read_cmd(dbg_data, hns3_dbg_cmd[index].cmd,
-					read_buf, hns3_dbg_cmd[index].buf_len);
-		if (ret)
-			goto out;
-	}
+	buf = kvzalloc(hns3_dbg_cmd[index].buf_len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 
-	size = simple_read_from_buffer(buffer, count, ppos, read_buf,
-				       strlen(read_buf));
-	if (size > 0) {
-		mutex_unlock(&handle->dbgfs_lock);
-		return size;
+	ret = hns3_dbg_read_cmd(dbg_data, hns3_dbg_cmd[index].cmd,
+				buf, hns3_dbg_cmd[index].buf_len);
+	if (ret) {
+		kvfree(buf);
+		return ret;
 	}
 
-out:
-	/* free the buffer for the last read operation */
-	if (*save_buf) {
-		kvfree(*save_buf);
-		*save_buf = NULL;
-	}
+	filp->private_data = buf;
+	return 0;
+}
 
-	mutex_unlock(&handle->dbgfs_lock);
-	return ret;
+static int hns3_dbg_release(struct inode *inode, struct file *filp)
+{
+	kvfree(filp->private_data);
+	filp->private_data = NULL;
+	return 0;
 }
 
 static const struct file_operations hns3_dbg_fops = {
 	.owner = THIS_MODULE,
-	.open  = simple_open,
+	.open  = hns3_dbg_open,
 	.read  = hns3_dbg_read,
+	.release = hns3_dbg_release,
 };
 
 static int hns3_dbg_bd_file_init(struct hnae3_handle *handle, u32 cmd)
@@ -1379,13 +1365,6 @@ int hns3_dbg_init(struct hnae3_handle *handle)
 	int ret;
 	u32 i;
 
-	handle->dbgfs_buf = devm_kcalloc(&handle->pdev->dev,
-					 ARRAY_SIZE(hns3_dbg_cmd),
-					 sizeof(*handle->dbgfs_buf),
-					 GFP_KERNEL);
-	if (!handle->dbgfs_buf)
-		return -ENOMEM;
-
 	hns3_dbg_dentry[HNS3_DBG_DENTRY_COMMON].dentry =
 				debugfs_create_dir(name, hns3_dbgfs_root);
 	handle->hnae3_dbgfs = hns3_dbg_dentry[HNS3_DBG_DENTRY_COMMON].dentry;
@@ -1395,8 +1374,6 @@ int hns3_dbg_init(struct hnae3_handle *handle)
 			debugfs_create_dir(hns3_dbg_dentry[i].name,
 					   handle->hnae3_dbgfs);
 
-	mutex_init(&handle->dbgfs_lock);
-
 	for (i = 0; i < ARRAY_SIZE(hns3_dbg_cmd); i++) {
 		if ((hns3_dbg_cmd[i].cmd == HNAE3_DBG_CMD_TM_NODES &&
 		     ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2) ||
@@ -1425,24 +1402,13 @@ int hns3_dbg_init(struct hnae3_handle *handle)
 out:
 	debugfs_remove_recursive(handle->hnae3_dbgfs);
 	handle->hnae3_dbgfs = NULL;
-	mutex_destroy(&handle->dbgfs_lock);
 	return ret;
 }
 
 void hns3_dbg_uninit(struct hnae3_handle *handle)
 {
-	u32 i;
-
 	debugfs_remove_recursive(handle->hnae3_dbgfs);
 	handle->hnae3_dbgfs = NULL;
-
-	for (i = 0; i < ARRAY_SIZE(hns3_dbg_cmd); i++)
-		if (handle->dbgfs_buf[i]) {
-			kvfree(handle->dbgfs_buf[i]);
-			handle->dbgfs_buf[i] = NULL;
-		}
-
-	mutex_destroy(&handle->dbgfs_lock);
 }
 
 void hns3_dbg_register_debugfs(const char *debugfs_dir_name)
-- 
2.39.5



