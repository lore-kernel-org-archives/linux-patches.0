Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7884357A4A;
	Tue, 17 Mar 2026 16:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766235; cv=none; b=FsU9U/zvoNPPA+NFBUbgbTy+vd92kkrf2POdV0iJzdcNFI2SX1R2eS+PARRgTxoDt4JE7FmGjoJ220NK0l7wKBD4Zi7Qi2DVb4HmoVxZ35//jUM+ehb9D+s5iKaEviA2QAi5JMICgSquFjkeVEniA9WhRGlCgfZZzMZyL1rxxhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766235; c=relaxed/simple;
	bh=m/2glunRJ71XD8QQ1fvpH8KPgmcsfcctkPFhvzion+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Edy+fOi7GDMAIdl4mn/0/yo8FBkrQwUgixdmIOs1xyUDihWzsR5ukgLghEtrx7E7EKtBnN1HPKF4AXtg+loDoILYU00WzCP1j6MVX9N/gH6kMlKVfhHkz4sunYESKRzVzW2jcMG5v3779smgtozsIz7CuSj9AxHx1CJFHhknQms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UScCfas1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UScCfas1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52859C4CEF7;
	Tue, 17 Mar 2026 16:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766235;
	bh=m/2glunRJ71XD8QQ1fvpH8KPgmcsfcctkPFhvzion+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UScCfas1mJjtuyU+PovQ2K7Sz2pSKHIGYiMn9MjLBAV93FxaYTQp5qHQmTPC1t7Bi
	 lwtkDxOOKwSkStZ4IionmfdnAM+I+zzdTZshr4/iLnYSATEh4CCkVRk7B+BRj8nbWA
	 fLUH6WEx+ImPw7Ni4ZjHORO3ZfD5r7ZSQAgB0cK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	stable <stable@kernel.org>,
	Kuen-Han Tsai <khtsai@google.com>
Subject: [PATCH 6.19 167/378] Revert "usb: gadget: f_ncm: Fix atomic context locking issue"
Date: Tue, 17 Mar 2026 17:32:04 +0100
Message-ID: <20260317163013.154037501@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

From: Kuen-Han Tsai <khtsai@google.com>

commit 11199720fac2debbe718aec11e026ab3330dc80d upstream.

This reverts commit 0d6c8144ca4d93253de952a5ea0028c19ed7ab68.

This commit is being reverted as part of a series-wide revert.

By deferring the net_device allocation to the bind() phase, a single
function instance will spawn multiple network devices if it is symlinked
to multiple USB configurations.

This causes regressions for userspace tools (like the postmarketOS DHCP
daemon) that rely on reading the interface name (e.g., "usb0") from
configfs. Currently, configfs returns the template "usb%d", causing the
userspace network setup to fail.

Crucially, because this patch breaks the 1:1 mapping between the
function instance and the network device, this naming issue cannot
simply be patched. Configfs only exposes a single 'ifname' attribute per
instance, making it impossible to accurately report the actual interface
name when multiple underlying network devices can exist for that single
instance.

All configurations tied to the same function instance are meant to share
a single network device. Revert this change to restore the 1:1 mapping
by allocating the network device at the instance level (alloc_inst).

Reported-by: David Heidelberg <david@ixit.cz>
Closes: https://lore.kernel.org/linux-usb/70b558ea-a12e-4170-9b8e-c951131249af@ixit.cz/
Fixes: 56a512a9b410 ("usb: gadget: f_ncm: align net_device lifecycle with bind/unbind")
Cc: stable <stable@kernel.org>
Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Link: https://patch.msgid.link/20260309-f-ncm-revert-v2-1-ea2afbc7d9b2@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_ncm.c            |   29 ++++++++++++++-----------
 drivers/usb/gadget/function/u_ether_configfs.h |   11 ++++++++-
 drivers/usb/gadget/function/u_ncm.h            |    1 
 3 files changed, 28 insertions(+), 13 deletions(-)

--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -58,7 +58,6 @@ struct f_ncm {
 	u8				notify_state;
 	atomic_t			notify_count;
 	bool				is_open;
-	bool				is_connected;
 
 	const struct ndp_parser_opts	*parser_opts;
 	bool				is_crc;
@@ -865,6 +864,7 @@ invalid:
 static int ncm_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 {
 	struct f_ncm		*ncm = func_to_ncm(f);
+	struct f_ncm_opts	*opts = func_to_ncm_opts(f);
 	struct usb_composite_dev *cdev = f->config->cdev;
 
 	/* Control interface has only altsetting 0 */
@@ -887,12 +887,13 @@ static int ncm_set_alt(struct usb_functi
 		if (alt > 1)
 			goto fail;
 
-		if (ncm->is_connected) {
-			DBG(cdev, "reset ncm\n");
-			ncm->is_connected = false;
-			gether_disconnect(&ncm->port);
-			ncm_reset_values(ncm);
-		}
+		scoped_guard(mutex, &opts->lock)
+			if (opts->net) {
+				DBG(cdev, "reset ncm\n");
+				opts->net = NULL;
+				gether_disconnect(&ncm->port);
+				ncm_reset_values(ncm);
+			}
 
 		/*
 		 * CDC Network only sends data in non-default altsettings.
@@ -925,7 +926,8 @@ static int ncm_set_alt(struct usb_functi
 			net = gether_connect(&ncm->port);
 			if (IS_ERR(net))
 				return PTR_ERR(net);
-			ncm->is_connected = true;
+			scoped_guard(mutex, &opts->lock)
+				opts->net = net;
 		}
 
 		spin_lock(&ncm->lock);
@@ -1372,14 +1374,16 @@ err:
 static void ncm_disable(struct usb_function *f)
 {
 	struct f_ncm		*ncm = func_to_ncm(f);
+	struct f_ncm_opts	*opts = func_to_ncm_opts(f);
 	struct usb_composite_dev *cdev = f->config->cdev;
 
 	DBG(cdev, "ncm deactivated\n");
 
-	if (ncm->is_connected) {
-		ncm->is_connected = false;
-		gether_disconnect(&ncm->port);
-	}
+	scoped_guard(mutex, &opts->lock)
+		if (opts->net) {
+			opts->net = NULL;
+			gether_disconnect(&ncm->port);
+		}
 
 	if (ncm->notify->enabled) {
 		usb_ep_disable(ncm->notify);
@@ -1683,6 +1687,7 @@ static struct usb_function_instance *ncm
 	if (!opts)
 		return ERR_PTR(-ENOMEM);
 
+	opts->net = NULL;
 	opts->ncm_os_desc.ext_compat_id = opts->ncm_ext_compat_id;
 	gether_setup_opts_default(&opts->net_opts, "usb");
 
--- a/drivers/usb/gadget/function/u_ether_configfs.h
+++ b/drivers/usb/gadget/function/u_ether_configfs.h
@@ -326,9 +326,18 @@ out:									\
 					      char *page)			\
 	{									\
 		struct f_##_f_##_opts *opts = to_f_##_f_##_opts(item);		\
+		const char *name;						\
 										\
 		guard(mutex)(&opts->lock);					\
-		return sysfs_emit(page, "%s\n", opts->net_opts.name);		\
+		rtnl_lock();							\
+		if (opts->net_opts.ifname_set)					\
+			name = opts->net_opts.name;				\
+		else if (opts->net)						\
+			name = netdev_name(opts->net);				\
+		else								\
+			name = "(inactive net_device)";				\
+		rtnl_unlock();							\
+		return sysfs_emit(page, "%s\n", name);				\
 	}									\
 										\
 	static ssize_t _f_##_opts_ifname_store(struct config_item *item,	\
--- a/drivers/usb/gadget/function/u_ncm.h
+++ b/drivers/usb/gadget/function/u_ncm.h
@@ -19,6 +19,7 @@
 
 struct f_ncm_opts {
 	struct usb_function_instance	func_inst;
+	struct net_device		*net;
 
 	struct gether_opts		net_opts;
 	struct config_group		*ncm_interf_group;


