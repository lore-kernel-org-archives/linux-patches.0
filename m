Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD9618B487;
	Tue, 10 Sep 2024 10:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964179; cv=none; b=oSTRj6kZXOvV4BZjyvwYf8r98JZUtjpRu4+e1ax43SswVY6i4v9FCKMJk7a/YsqCJ2LgZjZLHy4eR80t7dFd1+nnMAt0lYo+INghcdyvDGI3EhAiPqn0ZT6bnrz89FOj6DONQkv2osZBqiCtVbpcDpfpzNc9VcIBEp8A0CKR+Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964179; c=relaxed/simple;
	bh=lGtM8AarloSTRVYuZ4KOcAGDU5Xh79at3sEE+BsixK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYBkQLahZhcTkXPuJIgSpnxnHuy3NwOqSif4NjfYZbHwm79iJz0EAElwetJAh8qQh5wyoRP3USrX7pnNu0c/5NSIjjpjWJRDpztiauH/uRobbYPTZiK1CduAyjQeGE5BC+wfQNsLeSD/RSJui4AXqxBgRSFv9w8tw2mlpXCjjBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yzg6bIoK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yzg6bIoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6715C4CEC3;
	Tue, 10 Sep 2024 10:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964179;
	bh=lGtM8AarloSTRVYuZ4KOcAGDU5Xh79at3sEE+BsixK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yzg6bIoKn2WG+P5i2lkpH30UQmdPU8mWO/017N2WjjV4OmQJ1CFHhLhfz8rP3f/wn
	 z6pP6EX33nrk2rs9IPW1fX8skFbpQ2KJ240gc4xkpvq1oigOQer+zbjnjwy+T4cEVL
	 V1cRH6Ktwok6y1mciBs9tm5T6HE3YL6NRf1PGuPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/269] media: vivid: dont set HDMI TX controls if there are no HDMI outputs
Date: Tue, 10 Sep 2024 11:31:14 +0200
Message-ID: <20240910092611.305226296@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 17763960b1784578e8fe915304b330922f646209 ]

When setting the EDID it would attempt to update two controls
that are only present if there is an HDMI output configured.

If there isn't any (e.g. when the vivid module is loaded with
node_types=1), then calling VIDIOC_S_EDID would crash.

Fix this by first checking if outputs are present.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vivid/vivid-vid-cap.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/test-drivers/vivid/vivid-vid-cap.c b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
index a81c17634daa..99325bfed643 100644
--- a/drivers/media/test-drivers/vivid/vivid-vid-cap.c
+++ b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
@@ -1557,8 +1557,10 @@ int vidioc_s_edid(struct file *file, void *_fh,
 		return -EINVAL;
 	if (edid->blocks == 0) {
 		dev->edid_blocks = 0;
-		v4l2_ctrl_s_ctrl(dev->ctrl_tx_edid_present, 0);
-		v4l2_ctrl_s_ctrl(dev->ctrl_tx_hotplug, 0);
+		if (dev->num_outputs) {
+			v4l2_ctrl_s_ctrl(dev->ctrl_tx_edid_present, 0);
+			v4l2_ctrl_s_ctrl(dev->ctrl_tx_hotplug, 0);
+		}
 		phys_addr = CEC_PHYS_ADDR_INVALID;
 		goto set_phys_addr;
 	}
@@ -1582,8 +1584,10 @@ int vidioc_s_edid(struct file *file, void *_fh,
 			display_present |=
 				dev->display_present[i] << j++;
 
-	v4l2_ctrl_s_ctrl(dev->ctrl_tx_edid_present, display_present);
-	v4l2_ctrl_s_ctrl(dev->ctrl_tx_hotplug, display_present);
+	if (dev->num_outputs) {
+		v4l2_ctrl_s_ctrl(dev->ctrl_tx_edid_present, display_present);
+		v4l2_ctrl_s_ctrl(dev->ctrl_tx_hotplug, display_present);
+	}
 
 set_phys_addr:
 	/* TODO: a proper hotplug detect cycle should be emulated here */
-- 
2.43.0



