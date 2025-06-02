Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FD322ACF3;
	Mon,  2 Jun 2025 15:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876919; cv=none; b=QzRcHs0xIZRYIfgxUjgp/AKuTku/uZ2PtzouIHSnNwXXfouShyix/GYjlnkjyoxQI5dGodOm0wVB//kJDVjeexw0/yWk5XV5umpX5OOoA3f8KZORnKPuEggdev7YW6tle02xR6Gc1Gabo48QDWTa0gqApFwl/KwhGVKQBB52sSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876919; c=relaxed/simple;
	bh=eSF4lt1PP65E0Xfqo0+tpxS6lLwWt4sgzq8E0QfnSDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkRC1CTL8ylq2L474X1eF5jIBPOhV/GknzJqnZ7JR3oxoTGuuJ2hApQOQQSNE7E/qp2os8VKxkxkFFJjWUM1Xv+TyCy2EaIvn8gAELIpcx0IIjDZbGR3b7ejgOlVD+8YCQMW3dIZQXO06qiyH27ydYgOrdXzfjfp3zawUe6QKqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DSFNVNSW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DSFNVNSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37FB2C4CEEB;
	Mon,  2 Jun 2025 15:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876919;
	bh=eSF4lt1PP65E0Xfqo0+tpxS6lLwWt4sgzq8E0QfnSDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DSFNVNSWErPs9M8i+F9XFRA6d0NvY3OEFBQGri0IJhqXC0tUZFR+sO0i/GIZtgql6
	 I4puyq4XmDuPgyVZe7G9tZz6hBUhIsmjeos5GlE0qWTGqd8o42bOGfGxq19x7rb7FR
	 ZCYYjqk/D4MoTZ59Wata8q9Nt+wC5z28Rnve0ZoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunke Cao <yunkec@google.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 116/325] media: uvcvideo: Add sanity check to uvc_ioctl_xu_ctrl_map
Date: Mon,  2 Jun 2025 15:46:32 +0200
Message-ID: <20250602134324.493049547@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bd4677a6e653a..0aaa4fce61dae 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -36,6 +36,12 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain *chain,
 	unsigned int size;
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



