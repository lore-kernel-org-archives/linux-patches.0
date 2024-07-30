Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA1283A17;
	Tue, 30 Jul 2024 17:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358911; cv=none; b=AwR13BPDpMlxXrIIeZTbH6mxaHiC+UEqaZCZurnjfeTpO0xX6pS8z4pko5vR2QGjWOdMc0YhcWXEs2Ul40C3BV11oiBhqLD1fv2/MBlpsLKz2d3YJjY6A/M0ms8PE6hwE9tkp1tT07MQanmyC9V6fToSYb0TIU0uiQFYKAZQiLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358911; c=relaxed/simple;
	bh=GvTEXq65clS9lLTpk9F/GN1dweZJSlZqE4DJ0JCx/XY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dPV//quUUszIGpjLUwAH4FWAD+maremzkP0ji2ig29FvXqpSpYuS42VUGds+cA91cVh+xB2v2oyEuvvwjvJMHzNzqLd7vm3lCByvV3kRAPTwBLyZ3w80h9bm80P8lxR9/dtDljgFsxmssC+C4OP+0sZdoBdhvNChOFLnoMz8beQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pnAZiLV7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pnAZiLV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4C3C32782;
	Tue, 30 Jul 2024 17:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358911;
	bh=GvTEXq65clS9lLTpk9F/GN1dweZJSlZqE4DJ0JCx/XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pnAZiLV7KgrhZubIolX6QO+GT3PV9vI48n8BV4do8dbP+pUhnxBs5x4E6Y83R7zBA
	 GrglSYE/mE0qj1dFkRWuh08G33Gdlz7B7JiVjlAdK8t84Vk2DAtGpwQh/BT18MH6np
	 TCE94DUjMuXx0x0WAzr45oNgALavZEAefBy2m3MM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Yao <hao.yao@intel.com>,
	Wentong Wu <wentong.wu@intel.com>,
	Jason Chen <jason.z.chen@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.6 408/568] media: ivsc: csi: add separate lock for v4l2 control handler
Date: Tue, 30 Jul 2024 17:48:35 +0200
Message-ID: <20240730151655.815500039@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Wentong Wu <wentong.wu@intel.com>

commit c6be6471004e0e4d10d0514146d8c41550823d63 upstream.

There're possibilities that privacy status change notification happens
in the middle of the ongoing mei command which already takes the command
lock, but v4l2_ctrl_s_ctrl() would also need the same lock prior to this
patch, so this may results in circular locking problem. This patch adds
one dedicated lock for v4l2 control handler to avoid described issue.

Fixes: 29006e196a56 ("media: pci: intel: ivsc: Add CSI submodule")
Cc: stable@vger.kernel.org # for 6.6 and later
Reported-by: Hao Yao <hao.yao@intel.com>
Signed-off-by: Wentong Wu <wentong.wu@intel.com>
Tested-by: Jason Chen <jason.z.chen@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/intel/ivsc/mei_csi.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/media/pci/intel/ivsc/mei_csi.c
+++ b/drivers/media/pci/intel/ivsc/mei_csi.c
@@ -124,6 +124,8 @@ struct mei_csi {
 	struct v4l2_ctrl_handler ctrl_handler;
 	struct v4l2_ctrl *freq_ctrl;
 	struct v4l2_ctrl *privacy_ctrl;
+	/* lock for v4l2 controls */
+	struct mutex ctrl_lock;
 	unsigned int remote_pad;
 	/* start streaming or not */
 	int streaming;
@@ -609,11 +611,13 @@ static int mei_csi_init_controls(struct
 	u32 max;
 	int ret;
 
+	mutex_init(&csi->ctrl_lock);
+
 	ret = v4l2_ctrl_handler_init(&csi->ctrl_handler, 2);
 	if (ret)
 		return ret;
 
-	csi->ctrl_handler.lock = &csi->lock;
+	csi->ctrl_handler.lock = &csi->ctrl_lock;
 
 	max = ARRAY_SIZE(link_freq_menu_items) - 1;
 	csi->freq_ctrl = v4l2_ctrl_new_int_menu(&csi->ctrl_handler,
@@ -772,6 +776,7 @@ err_entity:
 
 err_ctrl_handler:
 	v4l2_ctrl_handler_free(&csi->ctrl_handler);
+	mutex_destroy(&csi->ctrl_lock);
 	v4l2_async_nf_unregister(&csi->notifier);
 	v4l2_async_nf_cleanup(&csi->notifier);
 
@@ -791,6 +796,7 @@ static void mei_csi_remove(struct mei_cl
 	v4l2_async_nf_unregister(&csi->notifier);
 	v4l2_async_nf_cleanup(&csi->notifier);
 	v4l2_ctrl_handler_free(&csi->ctrl_handler);
+	mutex_destroy(&csi->ctrl_lock);
 	v4l2_async_unregister_subdev(&csi->subdev);
 	v4l2_subdev_cleanup(&csi->subdev);
 	media_entity_cleanup(&csi->subdev.entity);


