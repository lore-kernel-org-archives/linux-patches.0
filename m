Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE3E6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:15:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975BEC433F2;
	Mon, 16 Jan 2023 17:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673889304;
	bh=hkKlaTDS5zVIsVqmtQpaCq3AfrmnK3DQiV/yatDEVSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MTcn9nGXKEbVaHNXdtsjcIaXId3/EXnvNUDYVI3zAMOi+95yJyObIWC/kmJ8I8Hnq
	 IVuqXynf8X9f9oouLNY/r/TKPtNMTPTW/VRxx2hMNFsE26XpAEOaXzac6IH05F+tzm
	 lI/7PrTM1Q58tEGlGmcGjJY9ctAzJ1MmiXagZeAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 336/338] hvc/xen: lock console list traversal
Date: Mon, 16 Jan 2023 16:53:29 +0100
Message-Id: <20230116154835.736162064@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roger Pau Monne <roger.pau@citrix.com>

[ Upstream commit c0dccad87cf68fc6012aec7567e354353097ec1a ]

The currently lockless access to the xen console list in
vtermno_to_xencons() is incorrect, as additions and removals from the
list can happen anytime, and as such the traversal of the list to get
the private console data for a given termno needs to happen with the
lock held.  Note users that modify the list already do so with the
lock taken.

Adjust current lock takers to use the _irq{save,restore} helpers,
since the context in which vtermno_to_xencons() is called can have
interrupts disabled.  Use the _irq{save,restore} set of helpers to
switch the current callers to disable interrupts in the locked region.
I haven't checked if existing users could instead use the _irq
variant, as I think it's safer to use _irq{save,restore} upfront.

While there switch from using list_for_each_entry_safe to
list_for_each_entry: the current entry cursor won't be removed as
part of the code in the loop body, so using the _safe variant is
pointless.

Fixes: 02e19f9c7cac ('hvc_xen: implement multiconsole support')
Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Link: https://lore.kernel.org/r/20221130163611.14686-1-roger.pau@citrix.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/hvc/hvc_xen.c | 46 ++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index 2af089b2a343..625b5660b05f 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -65,17 +65,22 @@ static DEFINE_SPINLOCK(xencons_lock);
 
 static struct xencons_info *vtermno_to_xencons(int vtermno)
 {
-	struct xencons_info *entry, *n, *ret = NULL;
+	struct xencons_info *entry, *ret = NULL;
+	unsigned long flags;
 
-	if (list_empty(&xenconsoles))
-			return NULL;
+	spin_lock_irqsave(&xencons_lock, flags);
+	if (list_empty(&xenconsoles)) {
+		spin_unlock_irqrestore(&xencons_lock, flags);
+		return NULL;
+	}
 
-	list_for_each_entry_safe(entry, n, &xenconsoles, list) {
+	list_for_each_entry(entry, &xenconsoles, list) {
 		if (entry->vtermno == vtermno) {
 			ret  = entry;
 			break;
 		}
 	}
+	spin_unlock_irqrestore(&xencons_lock, flags);
 
 	return ret;
 }
@@ -236,7 +241,7 @@ static int xen_hvm_console_init(void)
 {
 	int r;
 	uint64_t v = 0;
-	unsigned long gfn;
+	unsigned long gfn, flags;
 	struct xencons_info *info;
 
 	if (!xen_hvm_domain())
@@ -271,9 +276,9 @@ static int xen_hvm_console_init(void)
 		goto err;
 	info->vtermno = HVC_COOKIE;
 
-	spin_lock(&xencons_lock);
+	spin_lock_irqsave(&xencons_lock, flags);
 	list_add_tail(&info->list, &xenconsoles);
-	spin_unlock(&xencons_lock);
+	spin_unlock_irqrestore(&xencons_lock, flags);
 
 	return 0;
 err:
@@ -296,6 +301,7 @@ static int xencons_info_pv_init(struct xencons_info *info, int vtermno)
 static int xen_pv_console_init(void)
 {
 	struct xencons_info *info;
+	unsigned long flags;
 
 	if (!xen_pv_domain())
 		return -ENODEV;
@@ -312,9 +318,9 @@ static int xen_pv_console_init(void)
 		/* already configured */
 		return 0;
 	}
-	spin_lock(&xencons_lock);
+	spin_lock_irqsave(&xencons_lock, flags);
 	xencons_info_pv_init(info, HVC_COOKIE);
-	spin_unlock(&xencons_lock);
+	spin_unlock_irqrestore(&xencons_lock, flags);
 
 	return 0;
 }
@@ -322,6 +328,7 @@ static int xen_pv_console_init(void)
 static int xen_initial_domain_console_init(void)
 {
 	struct xencons_info *info;
+	unsigned long flags;
 
 	if (!xen_initial_domain())
 		return -ENODEV;
@@ -336,9 +343,9 @@ static int xen_initial_domain_console_init(void)
 	info->irq = bind_virq_to_irq(VIRQ_CONSOLE, 0, false);
 	info->vtermno = HVC_COOKIE;
 
-	spin_lock(&xencons_lock);
+	spin_lock_irqsave(&xencons_lock, flags);
 	list_add_tail(&info->list, &xenconsoles);
-	spin_unlock(&xencons_lock);
+	spin_unlock_irqrestore(&xencons_lock, flags);
 
 	return 0;
 }
@@ -393,10 +400,12 @@ static void xencons_free(struct xencons_info *info)
 
 static int xen_console_remove(struct xencons_info *info)
 {
+	unsigned long flags;
+
 	xencons_disconnect_backend(info);
-	spin_lock(&xencons_lock);
+	spin_lock_irqsave(&xencons_lock, flags);
 	list_del(&info->list);
-	spin_unlock(&xencons_lock);
+	spin_unlock_irqrestore(&xencons_lock, flags);
 	if (info->xbdev != NULL)
 		xencons_free(info);
 	else {
@@ -477,6 +486,7 @@ static int xencons_probe(struct xenbus_device *dev,
 {
 	int ret, devid;
 	struct xencons_info *info;
+	unsigned long flags;
 
 	devid = dev->nodename[strlen(dev->nodename) - 1] - '0';
 	if (devid == 0)
@@ -495,9 +505,9 @@ static int xencons_probe(struct xenbus_device *dev,
 	ret = xencons_connect_backend(dev, info);
 	if (ret < 0)
 		goto error;
-	spin_lock(&xencons_lock);
+	spin_lock_irqsave(&xencons_lock, flags);
 	list_add_tail(&info->list, &xenconsoles);
-	spin_unlock(&xencons_lock);
+	spin_unlock_irqrestore(&xencons_lock, flags);
 
 	return 0;
 
@@ -596,10 +606,12 @@ static int __init xen_hvc_init(void)
 
 	info->hvc = hvc_alloc(HVC_COOKIE, info->irq, ops, 256);
 	if (IS_ERR(info->hvc)) {
+		unsigned long flags;
+
 		r = PTR_ERR(info->hvc);
-		spin_lock(&xencons_lock);
+		spin_lock_irqsave(&xencons_lock, flags);
 		list_del(&info->list);
-		spin_unlock(&xencons_lock);
+		spin_unlock_irqrestore(&xencons_lock, flags);
 		if (info->irq)
 			unbind_from_irqhandler(info->irq, NULL);
 		kfree(info);
-- 
2.35.1



