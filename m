Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFB41EEE3;
	Mon, 15 Apr 2024 14:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191592; cv=none; b=ezBgTC4PgvzB/xZv4cQz1gPU96lF5l59r8YsfOhT4S1e4xV4Am+5Wr+sk0a68WZ2J6LpohiFaI6G9TDP26jS3TgPlzH7laYlQ7QTIQYg4V73NaecFhwobKchVRsyFUjdsRHah7TNcpViH8y9h7DAGGZlkiOoYXELVpnAn99N4gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191592; c=relaxed/simple;
	bh=Xh87xGGtUpW5AofdfKZB7SOmQ8aEaiJ02Vwm+RK8jMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqlx83j0ByxoqpqmEEhQYRxb0fQ0Oorj28Ibf6UujW2Npwb0nq9v7howRXyj9JGPqd1IA67CKV9E3uqPuaZ0e9UEjiXMkwD0H07PUKFlXAQqETgZm13vw/m9itXCUqypenRorQK5X7bzt/rYJ8nkek38u4r7BQuw3PQ4E2LvFJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=epUnGrB1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="epUnGrB1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A45BC113CC;
	Mon, 15 Apr 2024 14:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191592;
	bh=Xh87xGGtUpW5AofdfKZB7SOmQ8aEaiJ02Vwm+RK8jMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=epUnGrB1xxJQYhXxVP8D1inj7s5zGJ5mF4aYkeQHZ5GLD9BEubAG1uO0x9r4y7wkE
	 MQBWCl0I9afYBu2M2Q79V9x5Mg84jBQ3HEzhqgMMV8uZvbaymLqJ1Y59/qV0ugIt2U
	 tjcNulSXSNOAMQlLtAJRK3B1G6kGsshcL2bfi69U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/122] firmware: arm_scmi: Make raw debugfs entries non-seekable
Date: Mon, 15 Apr 2024 16:19:46 +0200
Message-ID: <20240415141954.012099858@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit b70c7996d4ffb2e02895132e8a79a37cee66504f ]

SCMI raw debugfs entries are used to inject and snoop messages out of the
SCMI core and, as such, the underlying virtual files have no reason to
support seeking.

Modify the related file_operations descriptors to be non-seekable.

Fixes: 3c3d818a9317 ("firmware: arm_scmi: Add core raw transmission support")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20240315140324.231830-1-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/raw_mode.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/raw_mode.c b/drivers/firmware/arm_scmi/raw_mode.c
index 3505735185033..130d13e9cd6be 100644
--- a/drivers/firmware/arm_scmi/raw_mode.c
+++ b/drivers/firmware/arm_scmi/raw_mode.c
@@ -921,7 +921,7 @@ static int scmi_dbg_raw_mode_open(struct inode *inode, struct file *filp)
 	rd->raw = raw;
 	filp->private_data = rd;
 
-	return 0;
+	return nonseekable_open(inode, filp);
 }
 
 static int scmi_dbg_raw_mode_release(struct inode *inode, struct file *filp)
@@ -950,6 +950,7 @@ static const struct file_operations scmi_dbg_raw_mode_reset_fops = {
 	.open = scmi_dbg_raw_mode_open,
 	.release = scmi_dbg_raw_mode_release,
 	.write = scmi_dbg_raw_mode_reset_write,
+	.llseek = no_llseek,
 	.owner = THIS_MODULE,
 };
 
@@ -959,6 +960,7 @@ static const struct file_operations scmi_dbg_raw_mode_message_fops = {
 	.read = scmi_dbg_raw_mode_message_read,
 	.write = scmi_dbg_raw_mode_message_write,
 	.poll = scmi_dbg_raw_mode_message_poll,
+	.llseek = no_llseek,
 	.owner = THIS_MODULE,
 };
 
@@ -975,6 +977,7 @@ static const struct file_operations scmi_dbg_raw_mode_message_async_fops = {
 	.read = scmi_dbg_raw_mode_message_read,
 	.write = scmi_dbg_raw_mode_message_async_write,
 	.poll = scmi_dbg_raw_mode_message_poll,
+	.llseek = no_llseek,
 	.owner = THIS_MODULE,
 };
 
@@ -998,6 +1001,7 @@ static const struct file_operations scmi_dbg_raw_mode_notification_fops = {
 	.release = scmi_dbg_raw_mode_release,
 	.read = scmi_test_dbg_raw_mode_notif_read,
 	.poll = scmi_test_dbg_raw_mode_notif_poll,
+	.llseek = no_llseek,
 	.owner = THIS_MODULE,
 };
 
@@ -1021,6 +1025,7 @@ static const struct file_operations scmi_dbg_raw_mode_errors_fops = {
 	.release = scmi_dbg_raw_mode_release,
 	.read = scmi_test_dbg_raw_mode_errors_read,
 	.poll = scmi_test_dbg_raw_mode_errors_poll,
+	.llseek = no_llseek,
 	.owner = THIS_MODULE,
 };
 
-- 
2.43.0



