Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C9C47CA76;
	Mon, 31 Aug 2026 13:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184624; cv=none; b=QihZPq3a1wVpSSRSIX3ZNELD+K2ThHJxN4Ym+Rq/DAa7QdArxOhczUn3lAfBbwkiCsiu1M82A7ShYwAldh3RCGZ0BC5IqWgIGsnsTWl7ly1v0FR6+12JIKIknELgFd/6MH7Q6ZlAtwLEU+C7KMEnrQHyekcdDU64Sc+SP+pzX9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184624; c=relaxed/simple;
	bh=PHVtTD3wwu/OG+dU2/Wtqzx8S3u9WeQ8HqPqWrRCGqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/WzfNSQTDQffsoNSAvdX/X8riPgHTvK/1FWDVwL5bTwuXg5WdyYiDTDv/J3414jK6Ktv9pP34MecTLQH2JP8CCx630i7MiEMYZOLW2eb5bT3we8jnO83ZNEdcXKpb6OPwMJpP6cdk/O+SKWk5uB7fLje4XkhuIS62iL6UpttWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SA2Wf/mY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SA2Wf/mY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9A61F000E9;
	Mon, 31 Aug 2026 13:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184623;
	bh=OACPLSKY/Mk41WY7/iZTkdFaRXQmWMLfUSwHzZp+t/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SA2Wf/mYLKfrbFeH0SXXtVmqFiGFlRt+Zs0L6xMOhf9ELW/mDtfNdBr51n8CGGaVC
	 4HCLHbwLgEdSXz6sK9QoFPSQs84z/Nq+Kf8Rjt4i/VCDfOTVEUVp9E0rnttTTM/cY0
	 /G9bgBghGeSIjA3eHTDoCkAww7JN33U6tIuDMyZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH 6.6 65/91] usb: gadget: f_tcm: keep port count until LUN teardown completes
Date: Mon, 31 Aug 2026 15:34:53 +0200
Message-ID: <20260831133403.080155735@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1678,7 +1678,7 @@ static const struct target_core_fabric_o
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


