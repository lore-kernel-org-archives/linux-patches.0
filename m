Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D0F18B49E;
	Tue, 10 Sep 2024 10:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963688; cv=none; b=K52KlnLrfXUMdrVkNBOuPOoS8L0gO3jBZBZbvl2f36ZGHBAKvKGWmm8MLTkrdHsfSBpIX6UlyYCaSQzBTvNWRJjy/xZtRiDu0452aUpBynWL4YLA5N27LjpAdy4IyxgOYRu2x00F4EzrlSZcWMrgyOwM9fAWjSSB9ZRImA2mAxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963688; c=relaxed/simple;
	bh=Jj/MCZQXIgVDnNYWjCQLWnxsDcDpbUSdoS35l4afo6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwPgL5p8wrq2z7Dag+S0muRdrc30wOKPg74mqu4tiyHZWTe1jxDcqh7kGauM13MlYhQXS9L3EOzp8GJjrHgjtx7AMIcSNUJRHeVwG/KRlLl/6fiG1hVNC/PfwJMCcQXo0rilkNW8/mZ/AGdjXVkDQmpXnx2VF9KN6EsumGxcOUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YEkZJXM8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YEkZJXM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0EFC4CEC3;
	Tue, 10 Sep 2024 10:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963688;
	bh=Jj/MCZQXIgVDnNYWjCQLWnxsDcDpbUSdoS35l4afo6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YEkZJXM87J+IYyrkZ8vw+iVqRo3ynjubOeZQ2YMeQq8w877voC3je+a6AgpsBIo6W
	 maUwJ/31YVfDPOSJ+5RU213uxgXdXMv4w0IztY3+yby6rw7zolZa9hrx65dGQeo71S
	 KoA2+c7oNAfGyoiMNurV0R9xZKBcIJEpZA0xE03w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/214] media: vivid: dont set HDMI TX controls if there are no HDMI outputs
Date: Tue, 10 Sep 2024 11:32:17 +0200
Message-ID: <20240910092603.501901257@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index af0ca7366abf..c663daedb82c 100644
--- a/drivers/media/test-drivers/vivid/vivid-vid-cap.c
+++ b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
@@ -1798,8 +1798,10 @@ int vidioc_s_edid(struct file *file, void *_fh,
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
@@ -1823,8 +1825,10 @@ int vidioc_s_edid(struct file *file, void *_fh,
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



