Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1FE190664;
	Tue, 10 Sep 2024 10:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962878; cv=none; b=pYd1kfFstei+bmOLgOmfiDxjtfHB3r6fwSIvJN9U/j75uNc1Qh34fDEgLgSjNWFHliBqZT3943SmUhmSv/05WMzyUP/HmAUgS18l6SngJIpApGS3JhfF0bixlhPzHA6DHiUQm48jj/z77cLfi1SbYS8d05nPHKToQBUdlqAnB0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962878; c=relaxed/simple;
	bh=cqXq9y2QOMUcWwW+yl+pu3DGkMHrVXHW4ZDE8i00JBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJ4+HVCyn//1hvwvz0HNo7zDTNoKpmtHEy/HHZdD6ss4Wt3Ss+LnDcQHbpZHtSAZ2azOpv1FZtKFpOmhkvMVmblvtE6/Wwzz6KMEae5dkmoCC7nStMObetQz1e3qIh6vhSnVmQPbq8yKfgzcGYGBXXUANoxnI8IkssJjXlomLRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IT2SlomR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IT2SlomR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3176C4CEC6;
	Tue, 10 Sep 2024 10:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962878;
	bh=cqXq9y2QOMUcWwW+yl+pu3DGkMHrVXHW4ZDE8i00JBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IT2SlomRSkXmhlbBWg4ayDV/rYT6nQyO0AOT5n4U3RHl7vrmd7qRtTqLkDZdhvnYd
	 emM6Y491wZI+SnIJz5w0oiMtXsl31q4/KK1BRI7LTDYKJpAPEabwUsYG4PhVmt6Hf0
	 ttLafDXLdOrSW66g+9sY66qtgNpf1vA4qgJiJwRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/192] media: vivid: dont set HDMI TX controls if there are no HDMI outputs
Date: Tue, 10 Sep 2024 11:31:25 +0200
Message-ID: <20240910092600.504410224@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bff95cb57718..3864df45077d 100644
--- a/drivers/media/test-drivers/vivid/vivid-vid-cap.c
+++ b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
@@ -1810,8 +1810,10 @@ int vidioc_s_edid(struct file *file, void *_fh,
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
@@ -1835,8 +1837,10 @@ int vidioc_s_edid(struct file *file, void *_fh,
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



