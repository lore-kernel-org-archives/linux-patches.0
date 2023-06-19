Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809A65381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A2CC433C8;
	Mon, 19 Jun 2023 10:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171353;
	bh=VFVGxBuqm5H4J4uwXFbJt8Tm/NJQ3pTZiq5CYB4ywaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wte8lB9GZtxZzD3nvskDjGPMKSEuoTs+DrzND28o9jctp+u4n4sx4Yo3usAUhK0ev
	 HmqFtHLjWLw7RdzXvxIen4KTp/5wVoLHx3c9IpXs5dEQOMRkQrV2Xv+kGlegV3DM7X
	 Z8ruSItLnw1dgvz4bRgfMU+9xM24iKn5kBG2a4lE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Romain Izard <romain.izard.pro@gmail.com>,
	Felipe Balbi <felipe.balbi@linux.intel.com>,
	Joakim Tjernlund <joakim.tjernlund@infinera.com>
Subject: [PATCH 4.19 25/49] usb: gadget: f_ncm: Add OS descriptor support
Date: Mon, 19 Jun 2023 12:30:03 +0200
Message-ID: <20230619102131.190677138@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102129.856988902@linuxfoundation.org>
References: <20230619102129.856988902@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Romain Izard <romain.izard.pro@gmail.com>

commit 793409292382027226769d0299987f06cbd97a6e upstream.

To be able to use the default USB class drivers available in Microsoft
Windows, we need to add OS descriptors to the exported USB gadget to
tell the OS that we are compatible with the built-in drivers.

Copy the OS descriptor support from f_rndis into f_ncm. As a result,
using the WINNCM compatible ID, the UsbNcm driver is loaded on
enumeration without the need for a custom driver or inf file.

Signed-off-by: Romain Izard <romain.izard.pro@gmail.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_ncm.c |   47 +++++++++++++++++++++++++++++++++---
 drivers/usb/gadget/function/u_ncm.h |    3 ++
 2 files changed, 47 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -23,6 +23,7 @@
 #include "u_ether.h"
 #include "u_ether_configfs.h"
 #include "u_ncm.h"
+#include "configfs.h"
 
 /*
  * This function is a "CDC Network Control Model" (CDC NCM) Ethernet link.
@@ -1434,6 +1435,16 @@ static int ncm_bind(struct usb_configura
 		return -EINVAL;
 
 	ncm_opts = container_of(f->fi, struct f_ncm_opts, func_inst);
+
+	if (cdev->use_os_string) {
+		f->os_desc_table = kzalloc(sizeof(*f->os_desc_table),
+					   GFP_KERNEL);
+		if (!f->os_desc_table)
+			return -ENOMEM;
+		f->os_desc_n = 1;
+		f->os_desc_table[0].os_desc = &ncm_opts->ncm_os_desc;
+	}
+
 	/*
 	 * in drivers/usb/gadget/configfs.c:configfs_composite_bind()
 	 * configurations are bound in sequence with list_for_each_entry,
@@ -1447,13 +1458,15 @@ static int ncm_bind(struct usb_configura
 		status = gether_register_netdev(ncm_opts->net);
 		mutex_unlock(&ncm_opts->lock);
 		if (status)
-			return status;
+			goto fail;
 		ncm_opts->bound = true;
 	}
 	us = usb_gstrings_attach(cdev, ncm_strings,
 				 ARRAY_SIZE(ncm_string_defs));
-	if (IS_ERR(us))
-		return PTR_ERR(us);
+	if (IS_ERR(us)) {
+		status = PTR_ERR(us);
+		goto fail;
+	}
 	ncm_control_intf.iInterface = us[STRING_CTRL_IDX].id;
 	ncm_data_nop_intf.iInterface = us[STRING_DATA_IDX].id;
 	ncm_data_intf.iInterface = us[STRING_DATA_IDX].id;
@@ -1470,6 +1483,10 @@ static int ncm_bind(struct usb_configura
 	ncm_control_intf.bInterfaceNumber = status;
 	ncm_union_desc.bMasterInterface0 = status;
 
+	if (cdev->use_os_string)
+		f->os_desc_table[0].if_id =
+			ncm_iad_desc.bFirstInterface;
+
 	status = usb_interface_id(c, f);
 	if (status < 0)
 		goto fail;
@@ -1549,6 +1566,9 @@ static int ncm_bind(struct usb_configura
 	return 0;
 
 fail:
+	kfree(f->os_desc_table);
+	f->os_desc_n = 0;
+
 	if (ncm->notify_req) {
 		kfree(ncm->notify_req->buf);
 		usb_ep_free_request(ncm->notify, ncm->notify_req);
@@ -1603,16 +1623,22 @@ static void ncm_free_inst(struct usb_fun
 		gether_cleanup(netdev_priv(opts->net));
 	else
 		free_netdev(opts->net);
+	kfree(opts->ncm_interf_group);
 	kfree(opts);
 }
 
 static struct usb_function_instance *ncm_alloc_inst(void)
 {
 	struct f_ncm_opts *opts;
+	struct usb_os_desc *descs[1];
+	char *names[1];
+	struct config_group *ncm_interf_group;
 
 	opts = kzalloc(sizeof(*opts), GFP_KERNEL);
 	if (!opts)
 		return ERR_PTR(-ENOMEM);
+	opts->ncm_os_desc.ext_compat_id = opts->ncm_ext_compat_id;
+
 	mutex_init(&opts->lock);
 	opts->func_inst.free_func_inst = ncm_free_inst;
 	opts->net = gether_setup_default();
@@ -1621,8 +1647,20 @@ static struct usb_function_instance *ncm
 		kfree(opts);
 		return ERR_CAST(net);
 	}
+	INIT_LIST_HEAD(&opts->ncm_os_desc.ext_prop);
+
+	descs[0] = &opts->ncm_os_desc;
+	names[0] = "ncm";
 
 	config_group_init_type_name(&opts->func_inst.group, "", &ncm_func_type);
+	ncm_interf_group =
+		usb_os_desc_prepare_interf_dir(&opts->func_inst.group, 1, descs,
+					       names, THIS_MODULE);
+	if (IS_ERR(ncm_interf_group)) {
+		ncm_free_inst(&opts->func_inst);
+		return ERR_CAST(ncm_interf_group);
+	}
+	opts->ncm_interf_group = ncm_interf_group;
 
 	return &opts->func_inst;
 }
@@ -1648,6 +1686,9 @@ static void ncm_unbind(struct usb_config
 
 	hrtimer_cancel(&ncm->task_timer);
 
+	kfree(f->os_desc_table);
+	f->os_desc_n = 0;
+
 	ncm_string_defs[0].id = 0;
 	usb_free_all_descriptors(f);
 
--- a/drivers/usb/gadget/function/u_ncm.h
+++ b/drivers/usb/gadget/function/u_ncm.h
@@ -20,6 +20,9 @@ struct f_ncm_opts {
 	struct net_device		*net;
 	bool				bound;
 
+	struct config_group		*ncm_interf_group;
+	struct usb_os_desc		ncm_os_desc;
+	char				ncm_ext_compat_id[16];
 	/*
 	 * Read/write access to configfs attributes is handled by configfs.
 	 *


