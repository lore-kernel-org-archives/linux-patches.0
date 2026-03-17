Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2DB2FE579;
	Tue, 17 Mar 2026 17:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767741; cv=none; b=JPfwdt9aJtygemz+EddsVGgcdbNPGXCU9JCRkI7v/ZSlBYi0dq95D8wYkDK0vZ+H+WruhqjYPqoREYJqdZ5QU18vjmE2Sh849hWvXsDbbfPHEQ1C+Dp7B5UAaeQPzZP8VJN2mPZA2xRi89cZsR7DMhGcJTwwy+0FA2nG03Iuscw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767741; c=relaxed/simple;
	bh=h99wV3EghYer1ntv9zU6d8J8i/FKo5iefcaNM6z0xEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e71o3ekv1qGODab+mbu14x+mAkqvWW7zL/Nxot3kLRctbYPUl8tK9IwXhA6IfeJ+IOZnGnGRp0EVrYiW6fbUTPLQcuvQM2+SiThNKaGMB9xShu52QkXD7Vats7Pfv113zUMgf/XFzCakO3/wBqgyk54ezbzQIUj9ikrCpMXLang=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YmL3P/qf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YmL3P/qf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42C8C19424;
	Tue, 17 Mar 2026 17:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767741;
	bh=h99wV3EghYer1ntv9zU6d8J8i/FKo5iefcaNM6z0xEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YmL3P/qfhLfowGpRFBAvIbnrrIqBq2wn682HFUwNaUOGOcHaMbuaQPBYEjQi2cbyM
	 fMMfycYUGByBlvHHgjyvmWQc9jYHAa/Jcjcubt1lElpXgCIBBJNptRsWahxA/GpQyK
	 s72e+zAEpYZd1ONzGh8hSnE01pwlsTlsFZ5kPJaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Kuen-Han Tsai <khtsai@google.com>
Subject: [PATCH 6.18 148/333] usb: gadget: f_ncm: Fix atomic context locking issue
Date: Tue, 17 Mar 2026 17:32:57 +0100
Message-ID: <20260317163004.846632061@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Kuen-Han Tsai <khtsai@google.com>

commit 0d6c8144ca4d93253de952a5ea0028c19ed7ab68 upstream.

The ncm_set_alt function was holding a mutex to protect against races
with configfs, which invokes the might-sleep function inside an atomic
context.

Remove the struct net_device pointer from the f_ncm_opts structure to
eliminate the contention. The connection state is now managed by a new
boolean flag to preserve the use-after-free fix from
commit 6334b8e4553c ("usb: gadget: f_ncm: Fix UAF ncm object at re-bind
after usb ep transport error").

BUG: sleeping function called from invalid context
Call Trace:
 dump_stack_lvl+0x83/0xc0
 dump_stack+0x14/0x16
 __might_resched+0x389/0x4c0
 __might_sleep+0x8e/0x100
 ...
 __mutex_lock+0x6f/0x1740
 ...
 ncm_set_alt+0x209/0xa40
 set_config+0x6b6/0xb40
 composite_setup+0x734/0x2b40
 ...

Fixes: 56a512a9b410 ("usb: gadget: f_ncm: align net_device lifecycle with bind/unbind")
Cc: stable@kernel.org
Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Link: https://patch.msgid.link/20260221-legacy-ncm-v2-2-dfb891d76507@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_ncm.c            |   29 ++++++++++---------------
 drivers/usb/gadget/function/u_ether_configfs.h |   11 ---------
 drivers/usb/gadget/function/u_ncm.h            |    1 
 3 files changed, 13 insertions(+), 28 deletions(-)

--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -58,6 +58,7 @@ struct f_ncm {
 	u8				notify_state;
 	atomic_t			notify_count;
 	bool				is_open;
+	bool				is_connected;
 
 	const struct ndp_parser_opts	*parser_opts;
 	bool				is_crc;
@@ -864,7 +865,6 @@ invalid:
 static int ncm_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 {
 	struct f_ncm		*ncm = func_to_ncm(f);
-	struct f_ncm_opts	*opts = func_to_ncm_opts(f);
 	struct usb_composite_dev *cdev = f->config->cdev;
 
 	/* Control interface has only altsetting 0 */
@@ -887,13 +887,12 @@ static int ncm_set_alt(struct usb_functi
 		if (alt > 1)
 			goto fail;
 
-		scoped_guard(mutex, &opts->lock)
-			if (opts->net) {
-				DBG(cdev, "reset ncm\n");
-				opts->net = NULL;
-				gether_disconnect(&ncm->port);
-				ncm_reset_values(ncm);
-			}
+		if (ncm->is_connected) {
+			DBG(cdev, "reset ncm\n");
+			ncm->is_connected = false;
+			gether_disconnect(&ncm->port);
+			ncm_reset_values(ncm);
+		}
 
 		/*
 		 * CDC Network only sends data in non-default altsettings.
@@ -926,8 +925,7 @@ static int ncm_set_alt(struct usb_functi
 			net = gether_connect(&ncm->port);
 			if (IS_ERR(net))
 				return PTR_ERR(net);
-			scoped_guard(mutex, &opts->lock)
-				opts->net = net;
+			ncm->is_connected = true;
 		}
 
 		spin_lock(&ncm->lock);
@@ -1374,16 +1372,14 @@ err:
 static void ncm_disable(struct usb_function *f)
 {
 	struct f_ncm		*ncm = func_to_ncm(f);
-	struct f_ncm_opts	*opts = func_to_ncm_opts(f);
 	struct usb_composite_dev *cdev = f->config->cdev;
 
 	DBG(cdev, "ncm deactivated\n");
 
-	scoped_guard(mutex, &opts->lock)
-		if (opts->net) {
-			opts->net = NULL;
-			gether_disconnect(&ncm->port);
-		}
+	if (ncm->is_connected) {
+		ncm->is_connected = false;
+		gether_disconnect(&ncm->port);
+	}
 
 	if (ncm->notify->enabled) {
 		usb_ep_disable(ncm->notify);
@@ -1687,7 +1683,6 @@ static struct usb_function_instance *ncm
 	if (!opts)
 		return ERR_PTR(-ENOMEM);
 
-	opts->net = NULL;
 	opts->ncm_os_desc.ext_compat_id = opts->ncm_ext_compat_id;
 	gether_setup_opts_default(&opts->net_opts, "usb");
 
--- a/drivers/usb/gadget/function/u_ether_configfs.h
+++ b/drivers/usb/gadget/function/u_ether_configfs.h
@@ -326,18 +326,9 @@ out:									\
 					      char *page)			\
 	{									\
 		struct f_##_f_##_opts *opts = to_f_##_f_##_opts(item);		\
-		const char *name;						\
 										\
 		guard(mutex)(&opts->lock);					\
-		rtnl_lock();							\
-		if (opts->net_opts.ifname_set)					\
-			name = opts->net_opts.name;				\
-		else if (opts->net)						\
-			name = netdev_name(opts->net);				\
-		else								\
-			name = "(inactive net_device)";				\
-		rtnl_unlock();							\
-		return sysfs_emit(page, "%s\n", name);				\
+		return sysfs_emit(page, "%s\n", opts->net_opts.name);		\
 	}									\
 										\
 	static ssize_t _f_##_opts_ifname_store(struct config_item *item,	\
--- a/drivers/usb/gadget/function/u_ncm.h
+++ b/drivers/usb/gadget/function/u_ncm.h
@@ -19,7 +19,6 @@
 
 struct f_ncm_opts {
 	struct usb_function_instance	func_inst;
-	struct net_device		*net;
 
 	struct gether_opts		net_opts;
 	struct config_group		*ncm_interf_group;


