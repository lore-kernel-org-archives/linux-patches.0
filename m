Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063267;
	b=A4ES8qq14IhPNSwTn5ytjrv6x5OTvsGjl+Z3oJazqcscrccNmUGHDQVxH6vZ/70lPGRQ
	 UCXRjj/aTevo7BHO7BBECSPi+BmfCMxE+jTM2+quMMeop9jywKXDq+tbmkRFe3hFDI9oN
	 4tnIblLn1JKGMexM6oWDXAAgNgPCcWvIEBJTnym2Ed7ofy4pkWSq+EyUJhfrrOaDBAJQg
	 J7uN7cISTSlljX1xYfO2UunRI5rBRmzuY7GoV1PhigZ53PNp7z4hrcs5pyrsdJPN8CkV6
	 Zuj3Yoq3AEXd/KJl+bX3623cbzIdbXDdP8b1Ge9d7niEEQsfssUEjakX/RXUQowfZGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063267;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=isBWlDrvUr4H+vG0hAmVIIkBn+FrMz+W/cmOfgmRmHM=;
	b=XjnVuB9BCveMYsrzUT+zuSfVoKpY0LDb6Gv9AgCkVx/j/69yNE40U+o1xv8ZtOYgDucJ
	 mLmXFLzWYzRuUMY0vO4lOkqUQ44NbEW8208oERaY7j4VOOiD8+vQgm9hEOMBCnrbDs+ZO
	 RTmWfgxizHR4zexis5KTsW/sBQ9C57+i0i2JJPHbIwHigQV5qXsxKjrJh43imAGHEEfOZ
	 1mPssMVgpmnhLyYAk0gL5LROpd7OyVAsn9lXNn7Mypi18lKZywrybl2irTHaPZyee5DHS
	 cbSNDL6VhvjI+T+dmhJF6q3/dLtlz0qsaYhW3b4zuUfwc6lZ0CiJgGEDGbEGmaapOUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oUikKE1g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5CF606A331;
	Sat,  7 Nov 2026 14:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oUikKE1g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184F71F0089F;
	Sat,  7 Nov 2026 14:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063267;
	bh=isBWlDrvUr4H+vG0hAmVIIkBn+FrMz+W/cmOfgmRmHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oUikKE1goc67V5MkAZqD763GatbxB6q/Te1v68GkxfwpaHf9Cv7eNo3lysFd7V70T
	 xLCpMl4wucJVppMHhSdOGe3qbbIgypWfWsAhdcbiescMNx/fPUFUzvzEI9mRlh07bG
	 /w9yQO2v/r63nhlejZrkr9iKd9exVQhQ7RzO70kY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Danesh Petigara <danesh.petigara@broadcom.com>,
	Justin Chen <justin.chen@broadcom.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 465/869] mailbox: bcm74110: Cap rx_svc_init_list growth to prevent PMC-induced OOM
Date: Sat,  7 Nov 2026 08:52:27 -0500
Message-ID: <20261107134909.427027197@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit eb2ee504757674450a5e03e36e6b9340f064e599 ]

bcm74110_rx_push_init_msg() allocates a GFP_ATOMIC struct for every
BCM_MSG_SVC_INIT word received from the PMC co-processor and appends it
to rx_svc_init_list with no cap on list length.  The only consumers of
this list (bcm74110_rx_pop_init_msg_block / bcm74110_rx_flush_msg) are
called only during probe and at shutdown respectively; after probe
completes, PMC firmware can continuously inject BCM_MSG_SVC_INIT words,
exhausting GFP_ATOMIC reserves and causing a whole-device denial of
service.

Add BCM74110_INIT_MSG_MAX (16 entries) as the maximum list depth.
bcm74110_rx_push_init_msg() now checks the count under the existing
rx_svc_list_lock before allocating; if the cap is reached the message is
dropped and a rate-limited warning is emitted.  The new rx_svc_init_count
field is decremented by bcm74110_rx_pop_init_msg() on successful dequeue
and reset to zero by bcm74110_rx_flush_msg() on shutdown.

Fixes: 52436007b862 ("mailbox: Add support for bcm74110")
Cc: stable@vger.kernel.org
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Assisted-by: Anthropic:claude-sonnet-4.6 cursor
Signed-off-by: Danesh Petigara <danesh.petigara@broadcom.com>
Acked-by: Justin Chen <justin.chen@broadcom.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/bcm74110-mailbox.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/mailbox/bcm74110-mailbox.c b/drivers/mailbox/bcm74110-mailbox.c
index 2e7e86f3e6a4a..0ae6c56b87869 100644
--- a/drivers/mailbox/bcm74110-mailbox.c
+++ b/drivers/mailbox/bcm74110-mailbox.c
@@ -97,6 +97,8 @@ struct bcm74110_mbox_chan {
 	int				type;
 };
 
+#define BCM74110_INIT_MSG_MAX		16
+
 struct bcm74110_mbox {
 	struct platform_device		*pdev;
 	void __iomem			*base;
@@ -105,6 +107,7 @@ struct bcm74110_mbox {
 	int				rx_chan;
 	int				rx_irq;
 	struct list_head		rx_svc_init_list;
+	unsigned int			rx_svc_init_count;
 	spinlock_t			rx_svc_list_lock;
 
 	struct mbox_controller		controller;
@@ -148,7 +151,15 @@ static void bcm74110_rx_push_init_msg(struct bcm74110_mbox *mbox, u32 val)
 	msg->msg = val;
 
 	spin_lock(&mbox->rx_svc_list_lock);
+	if (mbox->rx_svc_init_count >= BCM74110_INIT_MSG_MAX) {
+		spin_unlock(&mbox->rx_svc_list_lock);
+		kfree(msg);
+		dev_warn_ratelimited(&mbox->pdev->dev,
+				     "PMC INIT msg list full, dropping message\n");
+		return;
+	}
 	list_add_tail(&msg->list_entry, &mbox->rx_svc_init_list);
+	mbox->rx_svc_init_count++;
 	spin_unlock(&mbox->rx_svc_list_lock);
 }
 
@@ -225,6 +236,7 @@ static int bcm74110_rx_pop_init_msg(struct bcm74110_mbox *mbox, u32 func_type,
 				 list_entry) {
 		if (BCM_MSG_GET_FIELD(msg->msg, FUNC) == func_type) {
 			list_del(&msg->list_entry);
+			mbox->rx_svc_init_count--;
 			found = true;
 			break;
 		}
@@ -248,6 +260,7 @@ static void bcm74110_rx_flush_msg(struct bcm74110_mbox *mbox)
 
 	spin_lock_irqsave(&mbox->rx_svc_list_lock, flags);
 	list_splice_init(&mbox->rx_svc_init_list, &list_temp);
+	mbox->rx_svc_init_count = 0;
 	spin_unlock_irqrestore(&mbox->rx_svc_list_lock, flags);
 
 	list_for_each_entry_safe(msg, msg_tmp, &list_temp, list_entry) {
-- 
2.53.0



