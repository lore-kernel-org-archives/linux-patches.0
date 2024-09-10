Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E6E18893C;
	Tue, 10 Sep 2024 10:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965013; cv=none; b=fQ9Vs23UMs5qSliB6qUJmltipfLi1f1FOWR8s5Hf684QaezPyM/IH6jgt+zLBPp8uFV5ytl8mh/T2ftC25N7QPzSt8OBK1FEQ+is87aTckZs905lUmhwgv3fM4RynXMVTVyodCP1qJe7Gvm7oHHxtnOGVMgUtuRAO/HDVh2zn9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965013; c=relaxed/simple;
	bh=RQ5vC85m/T23st9yL+3Nq7ChicN1/gMUkjJb2CB+rWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IaH88J4jdriurM43HBKip/AqFD994i/CjE4m8OP0ADFcGG7OAVMIw9LFC+nRT048/W3nQblz8E1R9SwKvK7LxXI2jgzwwoI93js+/SY9MEXRC+UiOprRK/VClidKi3d+yPXEwE1iSYjGqvam68sekXrLP4N0kAOYe4yurjy8iWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bkC4dEyH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bkC4dEyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10069C4CEC3;
	Tue, 10 Sep 2024 10:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965013;
	bh=RQ5vC85m/T23st9yL+3Nq7ChicN1/gMUkjJb2CB+rWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bkC4dEyHx9A/14k2p4FgaXADh5B1FRipSQy8phZ3oJv2n5YXy7QD5cU859Xo/YdyW
	 FVXk4HxWVBcODihwU9sJa7MzAMW6vvYOPpbvP1EV8pN0NMLMR0LQHMb0N1bsYrkTwL
	 Q44hb1kXkICUzOhuHa0xIDOqF/jCUomirq61OsU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/186] media: vivid: dont set HDMI TX controls if there are no HDMI outputs
Date: Tue, 10 Sep 2024 11:33:23 +0200
Message-ID: <20240910092558.982574710@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 907781c2e613..2ce7f5567f51 100644
--- a/drivers/media/test-drivers/vivid/vivid-vid-cap.c
+++ b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
@@ -1802,8 +1802,10 @@ int vidioc_s_edid(struct file *file, void *_fh,
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
@@ -1827,8 +1829,10 @@ int vidioc_s_edid(struct file *file, void *_fh,
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



