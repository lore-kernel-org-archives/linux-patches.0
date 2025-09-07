Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBDD1F63CD;
	Sun,  7 Sep 2025 20:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277781; cv=none; b=sZ0dzcm0jvzyY0QsMLz3oK1Sr6gNVw5I9BzcSpkzx/FtYgbeppMAxg//fw/GEn6+MnKPKKrZc7zxwU9S714MyUGxmG25szhP7RPgGiDRAvIUKtPsiwQQupE5K2tre5Yb9ayw21VvEhhB8p3xhx58Rd2XzRCIImntgv7Vd3ipDk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277781; c=relaxed/simple;
	bh=OeZyowlguJJhpGcunSpYC1d1NQ3YPoO5Y2E6U+COPBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5KPnNz2+tvyIu1ThmHbBzELCsJflnrJyjokc9L/Xb+WGrDhUo2MViI262NNuQdTcBzF98YgCBwy4iWW3R8r60dh5mpS+1vWEKSdfNmn5kkqbEYjYmBNS22bteoh5io0ffyQxr6jX/DGT1YendgqpbK1uSKwSeN8akifMC6j0vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h/WPIy8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h/WPIy8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FEDDC4CEF0;
	Sun,  7 Sep 2025 20:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277780;
	bh=OeZyowlguJJhpGcunSpYC1d1NQ3YPoO5Y2E6U+COPBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h/WPIy8k/KrUDl0AUCEqhAJIZ26JwCFRLbCx3DvwdEbxIu7e3ray0QFnSAMKdbPWM
	 mFyD88iwgOZO+S3uIN99NEwUPl2sMx0SPV/HiDsMEXHRpSl7IHc7UbFy99VKGk6PE8
	 Izsih6AxkxxUn6XvZtqwDcTLj53jBB1PhLlZY5Ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Wang Haoran <haoranwangsec@gmail.com>,
	Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.16 068/183] i40e: remove read access to debugfs files
Date: Sun,  7 Sep 2025 21:58:15 +0200
Message-ID: <20250907195617.409393173@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 9fcdb1c3c4ba134434694c001dbff343f1ffa319 ]

The 'command' and 'netdev_ops' debugfs files are a legacy debugging
interface supported by the i40e driver since its early days by commit
02e9c290814c ("i40e: debugfs interface").

Both of these debugfs files provide a read handler which is mostly useless,
and which is implemented with questionable logic. They both use a static
256 byte buffer which is initialized to the empty string. In the case of
the 'command' file this buffer is literally never used and simply wastes
space. In the case of the 'netdev_ops' file, the last command written is
saved here.

On read, the files contents are presented as the name of the device
followed by a colon and then the contents of their respective static
buffer. For 'command' this will always be "<device>: ". For 'netdev_ops',
this will be "<device>: <last command written>". But note the buffer is
shared between all devices operated by this module. At best, it is mostly
meaningless information, and at worse it could be accessed simultaneously
as there doesn't appear to be any locking mechanism.

We have also recently received multiple reports for both read functions
about their use of snprintf and potential overflow that could result in
reading arbitrary kernel memory. For the 'command' file, this is definitely
impossible, since the static buffer is always zero and never written to.
For the 'netdev_ops' file, it does appear to be possible, if the user
carefully crafts the command input, it will be copied into the buffer,
which could be large enough to cause snprintf to truncate, which then
causes the copy_to_user to read beyond the length of the buffer allocated
by kzalloc.

A minimal fix would be to replace snprintf() with scnprintf() which would
cap the return to the number of bytes written, preventing an overflow. A
more involved fix would be to drop the mostly useless static buffers,
saving 512 bytes and modifying the read functions to stop needing those as
input.

Instead, lets just completely drop the read access to these files. These
are debug interfaces exposed as part of debugfs, and I don't believe that
dropping read access will break any script, as the provided output is
pretty useless. You can find the netdev name through other more standard
interfaces, and the 'netdev_ops' interface can easily result in garbage if
you issue simultaneous writes to multiple devices at once.

In order to properly remove the i40e_dbg_netdev_ops_buf, we need to
refactor its write function to avoid using the static buffer. Instead, use
the same logic as the i40e_dbg_command_write, with an allocated buffer.
Update the code to use this instead of the static buffer, and ensure we
free the buffer on exit. This fixes simultaneous writes to 'netdev_ops' on
multiple devices, and allows us to remove the now unused static buffer
along with removing the read access.

Fixes: 02e9c290814c ("i40e: debugfs interface")
Reported-by: Kunwu Chan <chentao@kylinos.cn>
Closes: https://lore.kernel.org/intel-wired-lan/20231208031950.47410-1-chentao@kylinos.cn/
Reported-by: Wang Haoran <haoranwangsec@gmail.com>
Closes: https://lore.kernel.org/all/CANZ3JQRRiOdtfQJoP9QM=6LS1Jto8PGBGw6y7-TL=BcnzHQn1Q@mail.gmail.com/
Reported-by: Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>
Closes: https://lore.kernel.org/all/20250722115017.206969-1-a.jahangirzad@gmail.com/
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Kunwu Chan <kunwu.chan@linux.dev>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/i40e/i40e_debugfs.c    | 123 +++---------------
 1 file changed, 19 insertions(+), 104 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
index 6cd9da662ae11..a5c794371dfe6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
@@ -40,48 +40,6 @@ static struct i40e_vsi *i40e_dbg_find_vsi(struct i40e_pf *pf, int seid)
  * setup, adding or removing filters, or other things.  Many of
  * these will be useful for some forms of unit testing.
  **************************************************************/
-static char i40e_dbg_command_buf[256] = "";
-
-/**
- * i40e_dbg_command_read - read for command datum
- * @filp: the opened file
- * @buffer: where to write the data for the user to read
- * @count: the size of the user's buffer
- * @ppos: file position offset
- **/
-static ssize_t i40e_dbg_command_read(struct file *filp, char __user *buffer,
-				     size_t count, loff_t *ppos)
-{
-	struct i40e_pf *pf = filp->private_data;
-	struct i40e_vsi *main_vsi;
-	int bytes_not_copied;
-	int buf_size = 256;
-	char *buf;
-	int len;
-
-	/* don't allow partial reads */
-	if (*ppos != 0)
-		return 0;
-	if (count < buf_size)
-		return -ENOSPC;
-
-	buf = kzalloc(buf_size, GFP_KERNEL);
-	if (!buf)
-		return -ENOSPC;
-
-	main_vsi = i40e_pf_get_main_vsi(pf);
-	len = snprintf(buf, buf_size, "%s: %s\n", main_vsi->netdev->name,
-		       i40e_dbg_command_buf);
-
-	bytes_not_copied = copy_to_user(buffer, buf, len);
-	kfree(buf);
-
-	if (bytes_not_copied)
-		return -EFAULT;
-
-	*ppos = len;
-	return len;
-}
 
 static char *i40e_filter_state_string[] = {
 	"INVALID",
@@ -1621,7 +1579,6 @@ static ssize_t i40e_dbg_command_write(struct file *filp,
 static const struct file_operations i40e_dbg_command_fops = {
 	.owner = THIS_MODULE,
 	.open =  simple_open,
-	.read =  i40e_dbg_command_read,
 	.write = i40e_dbg_command_write,
 };
 
@@ -1630,48 +1587,6 @@ static const struct file_operations i40e_dbg_command_fops = {
  * The netdev_ops entry in debugfs is for giving the driver commands
  * to be executed from the netdev operations.
  **************************************************************/
-static char i40e_dbg_netdev_ops_buf[256] = "";
-
-/**
- * i40e_dbg_netdev_ops_read - read for netdev_ops datum
- * @filp: the opened file
- * @buffer: where to write the data for the user to read
- * @count: the size of the user's buffer
- * @ppos: file position offset
- **/
-static ssize_t i40e_dbg_netdev_ops_read(struct file *filp, char __user *buffer,
-					size_t count, loff_t *ppos)
-{
-	struct i40e_pf *pf = filp->private_data;
-	struct i40e_vsi *main_vsi;
-	int bytes_not_copied;
-	int buf_size = 256;
-	char *buf;
-	int len;
-
-	/* don't allow partal reads */
-	if (*ppos != 0)
-		return 0;
-	if (count < buf_size)
-		return -ENOSPC;
-
-	buf = kzalloc(buf_size, GFP_KERNEL);
-	if (!buf)
-		return -ENOSPC;
-
-	main_vsi = i40e_pf_get_main_vsi(pf);
-	len = snprintf(buf, buf_size, "%s: %s\n", main_vsi->netdev->name,
-		       i40e_dbg_netdev_ops_buf);
-
-	bytes_not_copied = copy_to_user(buffer, buf, len);
-	kfree(buf);
-
-	if (bytes_not_copied)
-		return -EFAULT;
-
-	*ppos = len;
-	return len;
-}
 
 /**
  * i40e_dbg_netdev_ops_write - write into netdev_ops datum
@@ -1685,35 +1600,36 @@ static ssize_t i40e_dbg_netdev_ops_write(struct file *filp,
 					 size_t count, loff_t *ppos)
 {
 	struct i40e_pf *pf = filp->private_data;
+	char *cmd_buf, *buf_tmp;
 	int bytes_not_copied;
 	struct i40e_vsi *vsi;
-	char *buf_tmp;
 	int vsi_seid;
 	int i, cnt;
 
 	/* don't allow partial writes */
 	if (*ppos != 0)
 		return 0;
-	if (count >= sizeof(i40e_dbg_netdev_ops_buf))
-		return -ENOSPC;
 
-	memset(i40e_dbg_netdev_ops_buf, 0, sizeof(i40e_dbg_netdev_ops_buf));
-	bytes_not_copied = copy_from_user(i40e_dbg_netdev_ops_buf,
-					  buffer, count);
-	if (bytes_not_copied)
+	cmd_buf = kzalloc(count + 1, GFP_KERNEL);
+	if (!cmd_buf)
+		return count;
+	bytes_not_copied = copy_from_user(cmd_buf, buffer, count);
+	if (bytes_not_copied) {
+		kfree(cmd_buf);
 		return -EFAULT;
-	i40e_dbg_netdev_ops_buf[count] = '\0';
+	}
+	cmd_buf[count] = '\0';
 
-	buf_tmp = strchr(i40e_dbg_netdev_ops_buf, '\n');
+	buf_tmp = strchr(cmd_buf, '\n');
 	if (buf_tmp) {
 		*buf_tmp = '\0';
-		count = buf_tmp - i40e_dbg_netdev_ops_buf + 1;
+		count = buf_tmp - cmd_buf + 1;
 	}
 
-	if (strncmp(i40e_dbg_netdev_ops_buf, "change_mtu", 10) == 0) {
+	if (strncmp(cmd_buf, "change_mtu", 10) == 0) {
 		int mtu;
 
-		cnt = sscanf(&i40e_dbg_netdev_ops_buf[11], "%i %i",
+		cnt = sscanf(&cmd_buf[11], "%i %i",
 			     &vsi_seid, &mtu);
 		if (cnt != 2) {
 			dev_info(&pf->pdev->dev, "change_mtu <vsi_seid> <mtu>\n");
@@ -1735,8 +1651,8 @@ static ssize_t i40e_dbg_netdev_ops_write(struct file *filp,
 			dev_info(&pf->pdev->dev, "Could not acquire RTNL - please try again\n");
 		}
 
-	} else if (strncmp(i40e_dbg_netdev_ops_buf, "set_rx_mode", 11) == 0) {
-		cnt = sscanf(&i40e_dbg_netdev_ops_buf[11], "%i", &vsi_seid);
+	} else if (strncmp(cmd_buf, "set_rx_mode", 11) == 0) {
+		cnt = sscanf(&cmd_buf[11], "%i", &vsi_seid);
 		if (cnt != 1) {
 			dev_info(&pf->pdev->dev, "set_rx_mode <vsi_seid>\n");
 			goto netdev_ops_write_done;
@@ -1756,8 +1672,8 @@ static ssize_t i40e_dbg_netdev_ops_write(struct file *filp,
 			dev_info(&pf->pdev->dev, "Could not acquire RTNL - please try again\n");
 		}
 
-	} else if (strncmp(i40e_dbg_netdev_ops_buf, "napi", 4) == 0) {
-		cnt = sscanf(&i40e_dbg_netdev_ops_buf[4], "%i", &vsi_seid);
+	} else if (strncmp(cmd_buf, "napi", 4) == 0) {
+		cnt = sscanf(&cmd_buf[4], "%i", &vsi_seid);
 		if (cnt != 1) {
 			dev_info(&pf->pdev->dev, "napi <vsi_seid>\n");
 			goto netdev_ops_write_done;
@@ -1775,21 +1691,20 @@ static ssize_t i40e_dbg_netdev_ops_write(struct file *filp,
 			dev_info(&pf->pdev->dev, "napi called\n");
 		}
 	} else {
-		dev_info(&pf->pdev->dev, "unknown command '%s'\n",
-			 i40e_dbg_netdev_ops_buf);
+		dev_info(&pf->pdev->dev, "unknown command '%s'\n", cmd_buf);
 		dev_info(&pf->pdev->dev, "available commands\n");
 		dev_info(&pf->pdev->dev, "  change_mtu <vsi_seid> <mtu>\n");
 		dev_info(&pf->pdev->dev, "  set_rx_mode <vsi_seid>\n");
 		dev_info(&pf->pdev->dev, "  napi <vsi_seid>\n");
 	}
 netdev_ops_write_done:
+	kfree(cmd_buf);
 	return count;
 }
 
 static const struct file_operations i40e_dbg_netdev_ops_fops = {
 	.owner = THIS_MODULE,
 	.open = simple_open,
-	.read = i40e_dbg_netdev_ops_read,
 	.write = i40e_dbg_netdev_ops_write,
 };
 
-- 
2.50.1



