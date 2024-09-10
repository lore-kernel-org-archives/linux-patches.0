Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4DC18B465;
	Tue, 10 Sep 2024 09:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961617; cv=none; b=KEOadmVnV8Tdx/b/CKhpt46EGShxDQHyJFfzB9mwocyrpixXDxEk98D3VGpf0MMI2e5qr1cB0cduFwTi8Z30CYYJMGbiW7dqi04mjb6rLQ89YnAa/SMFEp/OnYnprcmZ9CxzWVdxRvXylRG7TiOZNV73dKQ49KDBBu1hTth4AxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961617; c=relaxed/simple;
	bh=56F3lvzjigPk8+OZMAt41Oc3FAIuhkXr8Q/jlIa0KHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ehrQ13PEJgElzeaa/Dncr2dNS4QUz7hUvUlu+f8TloAmZ84Ny0dsDnGOuz7KdZQWmiOLrhtn8YQs2vvFKi1wYDD86ISRzgVpwP0Murf07qp11fr+H7v/3EdFl/z885aJgg2JGJrqGJ3598k2rt3FErQdcUQDoRgiQYewl3Rumhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F354xhtk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F354xhtk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37BAC4CEC3;
	Tue, 10 Sep 2024 09:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961617;
	bh=56F3lvzjigPk8+OZMAt41Oc3FAIuhkXr8Q/jlIa0KHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F354xhtk02soFXnzQ+9j1ALn8vNzIRv/9EH2orC6wqSZ2IMRzVaoUWXoL/POok3QK
	 VVsuYNGxxbTScgdRxCQAsRTo2vIIDG/ItwrKLLHBYk5UcdHtncSp64WvMSAhbKpMbu
	 5GOi+yaeiFib04hrmrcKWyE4+aztyk2mgD86OR34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 130/375] media: vivid: dont set HDMI TX controls if there are no HDMI outputs
Date: Tue, 10 Sep 2024 11:28:47 +0200
Message-ID: <20240910092626.794131700@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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
index 3a3041a0378f..afa0dc5bcdae 100644
--- a/drivers/media/test-drivers/vivid/vivid-vid-cap.c
+++ b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
@@ -1554,8 +1554,10 @@ int vidioc_s_edid(struct file *file, void *_fh,
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
@@ -1579,8 +1581,10 @@ int vidioc_s_edid(struct file *file, void *_fh,
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



