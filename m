Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C39832D7C7;
	Sat, 12 Sep 2026 20:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243201; cv=none; b=lk62wvARNV2xzNY2gD+tUX7RoNbDD305LDLoVVRdJiAV3iRwIjcp/SldFG55hIe0h64pLGG/fZL/ernF0XqHHQbVOlh0kux9kE8BEpp664YKcIXcoHCXJoUYJGCsPbhtgXAfYYdd8RmkE4cQelD/iYq8cZ4GkKilRPOnbGukva4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243201; c=relaxed/simple;
	bh=uiiSJp3TAT7yINmXSIO3XUyqKOqpF91EnvaLIhyXv9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5J9HCtJ6Xuua9QV/eQMoo6BPPb949kP4+y1fSwupA8Zo4UqtYKf8HAA9/fcm5coS/F/YOZlWXk4U4Gj8HMZ1noh+2yad10iswZFEnAOXsX8DXHI5lsS8VOy6tvSR/avsH5BzWoRi8DexUYeqDXLV9O3YU2mWU8+9Vl0drKO9/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhAc7zKK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhAc7zKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D80C1F000FF;
	Sat, 12 Sep 2026 19:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243200;
	bh=EVc9ruUfhPn0sldyaEht4iCJDICbmn7xGsGRlc20js4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LhAc7zKKLmji+yVsaIGZIEpXce+Qu+Cmzv4VY3iY7HeB303SDN0WIXqeBvDlXZLZN
	 fWt5Xd0qVzrFeMUdjBnI32VN8X0RjS7IQmMbODMIbiT7dlxP8txohpsDnMERvxgADU
	 7rXLBXmXywQZTXcxkqPMpZhXnn3n5JLPHUwBnfDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yinhao Hu <dddddd@hust.edu.cn>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 672/798] nfc: pn533: hold a reference to the request skb during send_frame
Date: Sat, 12 Sep 2026 09:05:00 +0200
Message-ID: <20260912065532.504962718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinhao Hu <dddddd@hust.edu.cn>

[ Upstream commit 47792358a624ea066455ef86b744159928cd7716 ]

__pn533_send_async() publishes the command and then calls
dev->phy_ops->send_frame(). Once dev->cmd is set, an incoming frame
can be matched to this command: the I2C threaded IRQ runs
pn533_recv_frame(), which queues cmd_complete_work, and
pn533_send_async_complete() frees cmd->req with consume_skb().

On the I2C transport, pn533_i2c_send_frame() still dereferences the same
skb after i2c_master_send() returns, so a completion that races the
send can free the skb while the transport is still using it.

The request skb is owned by the command object and may be freed by
command completion at any time after dev->cmd is published, so the
transport send path must not assume it stays alive. Hold a temporary
reference to the request skb across the send_frame() call so the
transport always sees a live skb even if completion races the send.
Add a pn533_send_cmd_frame() helper and use it from all three send
paths.

Fixes: 9815c7cf22da ("NFC: pn533: Separate physical layer from the core implementation")
Signed-off-by: Yinhao Hu <dddddd@hust.edu.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260626073434.3977525-1-dddddd@hust.edu.cn
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/pn533/pn533.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index 8c555497220d6..d0d69af8925cd 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -434,6 +434,18 @@ static int pn533_send_async_complete(struct pn533 *dev)
 	return rc;
 }
 
+static int pn533_send_cmd_frame(struct pn533 *dev, struct pn533_cmd *cmd)
+{
+	struct sk_buff *req = cmd->req;
+	int rc;
+
+	skb_get(req);
+	dev->cmd = cmd;
+	rc = dev->phy_ops->send_frame(dev, req);
+	dev_kfree_skb(req);
+	return rc;
+}
+
 static int __pn533_send_async(struct pn533 *dev, u8 cmd_code,
 			      struct sk_buff *req,
 			      pn533_send_async_complete_t complete_cb,
@@ -458,8 +470,7 @@ static int __pn533_send_async(struct pn533 *dev, u8 cmd_code,
 	mutex_lock(&dev->cmd_lock);
 
 	if (!dev->cmd_pending) {
-		dev->cmd = cmd;
-		rc = dev->phy_ops->send_frame(dev, req);
+		rc = pn533_send_cmd_frame(dev, cmd);
 		if (rc) {
 			dev->cmd = NULL;
 			goto error;
@@ -537,8 +548,7 @@ static int pn533_send_cmd_direct_async(struct pn533 *dev, u8 cmd_code,
 
 	pn533_build_cmd_frame(dev, cmd_code, req);
 
-	dev->cmd = cmd;
-	rc = dev->phy_ops->send_frame(dev, req);
+	rc = pn533_send_cmd_frame(dev, cmd);
 	if (rc < 0) {
 		dev->cmd = NULL;
 		kfree(cmd);
@@ -577,8 +587,7 @@ static void pn533_wq_cmd(struct work_struct *work)
 
 	mutex_unlock(&dev->cmd_lock);
 
-	dev->cmd = cmd;
-	rc = dev->phy_ops->send_frame(dev, cmd->req);
+	rc = pn533_send_cmd_frame(dev, cmd);
 	if (rc < 0) {
 		dev->cmd = NULL;
 		dev_kfree_skb(cmd->req);
-- 
2.53.0



