Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39984AE8CC;
	Mon, 31 Aug 2026 13:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184132; cv=none; b=n13CaS7oI57wP6K1o9gB/y+aFNDrWqD0+ptb/4CZT+c86vBZ9XddaTKFNcO8dsgk2P7S0Oz2PSH4GiPBLj6IHYIjMZo+somUsjnwY0hNkwUP0tlThYemCHgTPAByk84dGkRknp0PziE4y9n6l56fPioSHMjVE2nwv4RYqhObLhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184132; c=relaxed/simple;
	bh=kWvL4bLUAoVBnCnfKqqpBBBlzwOq5+70dAdPzk9iKCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQ9hbqBZjSkUFNc+dZ9RyHt+erZh0fd/ePU2wTBYGM7JfXV57vr3aMmZ7L5GQrzVYkQXUcg8o4BKiiKnD9igIMkLDFcUaCPjfZCg2oA/v3iWjd08mDl/wrKYeGIdjXcxBqgx4gpGLt+N87qC497rQo4Ii6S4IDbL/eViLhYL9wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jqRZdIqI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jqRZdIqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5581F00A3D;
	Mon, 31 Aug 2026 13:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184130;
	bh=eSFKnM79nO2+2lHjMocmov3QD3lW19LQ2mlAqZBZxHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jqRZdIqIPawp+Uvpb9TGK3sze9AC1ao6xydHnuQcILVMYX0cy9HbHgXUoHMtUYBJx
	 wGOnBvpl26J+TFbv5RIKhT4TE0kEaJdSNPCXqBeogK3xbBgR0jjq57DKniBMp2r1+G
	 k4tfrB1xv9cRNur7xxSfl3aFq7TPi3Ljhawot+Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH 6.18 39/83] usb: gadget: f_tcm: keep port count until LUN teardown completes
Date: Mon, 31 Aug 2026 15:34:15 +0200
Message-ID: <20260831133401.499183763@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

commit c39d0916da47d94909391876c9e5bd429ea7b1b9 upstream.

tcm_usbg_drop_nexus() permits session removal once tpg_port_count
reaches zero. However, usbg_port_unlink() currently decrements that
count from the fabric_pre_unlink() callback, before core_dev_del_lun()
waits for active se_lun references to drain.

If removal of the last LUN races a nexus removal, the latter can observe
a zero port count and call target_remove_session(). This frees
sess_cmd_map while an in-flight struct usbg_cmd, including its work item,
can still be accessed.

Overlapping the last-LUN unlink with nexus removal reproduces this
lifetime violation as a DEBUG_OBJECTS "free active" warning for
usbg_cmd_work, followed by a target-core BUG/Oops.

The generic target-core unlink path has no callback after
core_dev_del_lun() completes. Add an optional fabric_post_unlink()
callback and use it for the f_tcm port count. The count now remains
nonzero until core_dev_del_lun() has finished draining active LUN
references, preventing nexus removal from freeing the session during
command completion.

Fixes: c52661d60f63 ("usb-gadget: Initial merge of target module for UASP + BOT")
Cc: stable@vger.kernel.org
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Link: https://patch.msgid.link/20260807060733.3186624-1-shuangpeng.kernel@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/target_core_fabric_configfs.c |    8 ++++++++
 drivers/usb/gadget/function/f_tcm.c          |    2 +-
 include/target/target_core_fabric.h          |    2 ++
 3 files changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -690,6 +690,14 @@ static void target_fabric_port_unlink(
 	}
 
 	core_dev_del_lun(se_tpg, lun);
+
+	if (tf->tf_ops->fabric_post_unlink) {
+		/*
+		 * Allow fabrics to release state that must remain valid until
+		 * core_dev_del_lun() has drained all active LUN references.
+		 */
+		tf->tf_ops->fabric_post_unlink(se_tpg, lun);
+	}
 }
 
 static void target_fabric_port_release(struct config_item *item)
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -2023,7 +2023,7 @@ static const struct target_core_fabric_o
 	.fabric_enable_tpg		= usbg_enable_tpg,
 	.fabric_drop_tpg		= usbg_drop_tpg,
 	.fabric_post_link		= usbg_port_link,
-	.fabric_pre_unlink		= usbg_port_unlink,
+	.fabric_post_unlink		= usbg_port_unlink,
 	.fabric_init_nodeacl		= usbg_init_nodeacl,
 
 	.tfc_wwn_attrs			= usbg_wwn_attrs,
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -95,6 +95,8 @@ struct target_core_fabric_ops {
 				struct se_lun *);
 	void (*fabric_pre_unlink)(struct se_portal_group *,
 				struct se_lun *);
+	void (*fabric_post_unlink)(struct se_portal_group *se_tpg,
+				   struct se_lun *lun);
 	struct se_tpg_np *(*fabric_make_np)(struct se_portal_group *,
 				struct config_group *, const char *);
 	void (*fabric_drop_np)(struct se_tpg_np *);


