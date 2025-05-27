Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B88F276057;
	Tue, 27 May 2025 16:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365062; cv=none; b=DNj38N63egTrtefUOrVDT63Y0qsGthIRihVY/gU0bA2Fg2S/g3GTuhXZM5tiambyhmk+FU3zPGxHdQGubeFE+HUp++onbRM7aICHZfM/rcINUU5gpHksDrwjdaNyig7O9uqPGQ+r833fk547mjSGaZR/M+Uh8f2cGI0i4UogG0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365062; c=relaxed/simple;
	bh=IW9u4E207UiGN1c4uPm7vxZM9djIsl3tV2KE5zLtLCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClOWklVVAa/sbeDab4lCsYuOW5jjCv3DcvRxhzseMzDPR/CRbci+7DG8HlY2qoNxrClrg2ORSCIHLCmcG6/OlXjqUAxwnw6rplMiHG5+emyYy/SYp9XL12+b8grd9naChbxXJGEWlmQiaT3XD+iZHt3v+0XS5Pb8N8w8ijKJZV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ROAW7nwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ROAW7nwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6819C4CEE9;
	Tue, 27 May 2025 16:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365062;
	bh=IW9u4E207UiGN1c4uPm7vxZM9djIsl3tV2KE5zLtLCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROAW7nwjcqnqNfT3qezoE6Sa3hbAjzyWpp5VJJCSVB+j1AhKZYIJ707ME9K93Lk9L
	 BgcU8SC0GW5hx4X/y/Qjx2U+nkphDq8pH6GOlyNv2C4dAdk5UMD8LZJy4Rm1Gw0tvr
	 jkI40NqI78cKYYwcV5Hk0XrO8QQ/g9Fsx4g+mL+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunke Cao <yunkec@google.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 256/626] media: uvcvideo: Add sanity check to uvc_ioctl_xu_ctrl_map
Date: Tue, 27 May 2025 18:22:29 +0200
Message-ID: <20250527162455.414665161@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 990262fdfce24d6055df9711424343d94d829e6a ]

Do not process unknown data types.

Tested-by: Yunke Cao <yunkec@google.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://lore.kernel.org/r/20250203-uvc-roi-v17-15-5900a9fed613@chromium.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_v4l2.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 7bcd706281daf..cb7d9fb589fca 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -106,6 +106,12 @@ static int uvc_ioctl_xu_ctrl_map(struct uvc_video_chain *chain,
 	struct uvc_control_mapping *map;
 	int ret;
 
+	if (xmap->data_type > UVC_CTRL_DATA_TYPE_BITMASK) {
+		uvc_dbg(chain->dev, CONTROL,
+			"Unsupported UVC data type %u\n", xmap->data_type);
+		return -EINVAL;
+	}
+
 	map = kzalloc(sizeof(*map), GFP_KERNEL);
 	if (map == NULL)
 		return -ENOMEM;
-- 
2.39.5



