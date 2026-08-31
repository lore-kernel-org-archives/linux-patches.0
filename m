Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3B34908D9;
	Mon, 31 Aug 2026 14:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185089; cv=none; b=psKMPvOHeo3bD6c0bTZUKWJ7yxWjCTgN9kRcuf+vzUSm2ti58TNpvufP6v4ROhnG5iOVW+IxF+IB3cx/K7sXv+F3A2ilxdeXlg5E0FCJYGyxjXGS3Bj/QMuJ6txS++4cH/vqc+Q9RCqH3UJzzeH8imTvEdVfaIFgidugP1ao8Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185089; c=relaxed/simple;
	bh=YCT+5mPkBsYLkexlXwyrBWRHSFn/hsfSKoZ0hRz5eKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8H2fW8By5chB9nvGYWBtxQCtyiTWB4UhNrdEtLb/ZAwhjQfIebjaghF+SuPgCeHsC+N0yeBE3ihnx3R1JQ6X+e3lfxxN7nb4bs6CcZaO6gT9z0cFOLDTE5w4NMlE3dgeaFaZfyv5kP0kTtrNPfpzpNK50pFG5m6YLkR1CCkk68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s8Tl9iad; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s8Tl9iad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51101F000E9;
	Mon, 31 Aug 2026 14:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185087;
	bh=0erng9ZrCLKHQLKTJ9LYd2tWaIjaY40iCvyl1wNaCXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s8Tl9iadPTNHzaVjW74muuWTQmFoyHCllbhgPEIyn/coCI6498Q55BCKpkhUhTF1e
	 NzCK0ZUfTOETQqP4CHq1VRRDK5hXmBZW/hWraCbPS7BTRtxnnLg/z5k8o6M+it2CVR
	 3EZcs4qlcQubKNfC1wnvKcV2wtEzHzBKJcSrum80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH 5.15 49/69] usb: gadget: f_tcm: keep port count until LUN teardown completes
Date: Mon, 31 Aug 2026 15:35:22 +0200
Message-ID: <20260831133401.110722342@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -689,6 +689,14 @@ static void target_fabric_port_unlink(
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
@@ -1714,7 +1714,7 @@ static const struct target_core_fabric_o
 	.fabric_make_tpg		= usbg_make_tpg,
 	.fabric_drop_tpg		= usbg_drop_tpg,
 	.fabric_post_link		= usbg_port_link,
-	.fabric_pre_unlink		= usbg_port_unlink,
+	.fabric_post_unlink		= usbg_port_unlink,
 	.fabric_init_nodeacl		= usbg_init_nodeacl,
 
 	.tfc_wwn_attrs			= usbg_wwn_attrs,
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -94,6 +94,8 @@ struct target_core_fabric_ops {
 				struct se_lun *);
 	void (*fabric_pre_unlink)(struct se_portal_group *,
 				struct se_lun *);
+	void (*fabric_post_unlink)(struct se_portal_group *se_tpg,
+				   struct se_lun *lun);
 	struct se_tpg_np *(*fabric_make_np)(struct se_portal_group *,
 				struct config_group *, const char *);
 	void (*fabric_drop_np)(struct se_tpg_np *);


