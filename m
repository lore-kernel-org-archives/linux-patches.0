Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169601A76CB;
	Tue, 30 Jul 2024 17:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360139; cv=none; b=qDU8lXeRa9THRuxFTA0j3GUVcsshZV7AoO+s9NyNFh93ngbWlwOErLlv8uHtkJaaPxJUljpC7g05xd35DXKfErq6P0sq+UNO2/Sk2lYZkEAIvPNrmf+n5BidYmoo8gi0jrB5g5THrehl8CpvowkpMGUrYd03NQD7WpRpPDd8olc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360139; c=relaxed/simple;
	bh=vaAwIRjFm5fRsTmWch3dd5P0AXwvvqfDSW/02FY7AVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tC+0ON+oSn0LLg4iqnSCjExq4+uHReaUlPqOL4B1scocCzFryQf9v95t2FyRMcVti3j7Z+Kfyaq6+05Kea8bnYMGdpptRUexIb3LoRH7209ryV2/MjCyxBUpkWA1C2IHJE6rhEuqlI6x/B9IbR7cq4nJMLwe8A7AhCl8rXtJMrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pbf0Vc58; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pbf0Vc58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0E2C32782;
	Tue, 30 Jul 2024 17:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360139;
	bh=vaAwIRjFm5fRsTmWch3dd5P0AXwvvqfDSW/02FY7AVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pbf0Vc582xHX3SrZHpgh8NAmK0mni0xqGBffVuSVS7QUbjza5aTQTef1/JOA8MI/Y
	 ia8K85+2CaQkfuxTv/MAS7iCXz05hrbHSrXrVd/NZ2RJB1+/BtZ7XI6OlplPaGgghZ
	 mzwSjgUrPX93ftXoxofhbBVB+L7Ai0Cw0G1Xzqmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Yao <hao.yao@intel.com>,
	Wentong Wu <wentong.wu@intel.com>,
	Jason Chen <jason.z.chen@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.10 609/809] media: ivsc: csi: add separate lock for v4l2 control handler
Date: Tue, 30 Jul 2024 17:48:05 +0200
Message-ID: <20240730151748.890384190@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -126,6 +126,8 @@ struct mei_csi {
 	struct v4l2_ctrl_handler ctrl_handler;
 	struct v4l2_ctrl *freq_ctrl;
 	struct v4l2_ctrl *privacy_ctrl;
+	/* lock for v4l2 controls */
+	struct mutex ctrl_lock;
 	unsigned int remote_pad;
 	/* start streaming or not */
 	int streaming;
@@ -559,11 +561,13 @@ static int mei_csi_init_controls(struct
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
@@ -755,6 +759,7 @@ err_entity:
 
 err_ctrl_handler:
 	v4l2_ctrl_handler_free(&csi->ctrl_handler);
+	mutex_destroy(&csi->ctrl_lock);
 	v4l2_async_nf_unregister(&csi->notifier);
 	v4l2_async_nf_cleanup(&csi->notifier);
 
@@ -774,6 +779,7 @@ static void mei_csi_remove(struct mei_cl
 	v4l2_async_nf_unregister(&csi->notifier);
 	v4l2_async_nf_cleanup(&csi->notifier);
 	v4l2_ctrl_handler_free(&csi->ctrl_handler);
+	mutex_destroy(&csi->ctrl_lock);
 	v4l2_async_unregister_subdev(&csi->subdev);
 	v4l2_subdev_cleanup(&csi->subdev);
 	media_entity_cleanup(&csi->subdev.entity);


