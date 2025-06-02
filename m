Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470A1223323;
	Mon,  2 Jun 2025 14:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873487; cv=none; b=KkqSZa9sgy2aQpKUsayo2JTECzHm8wiM+yGrQqbG2C/JLwUXnu9YHaKaS1DLA6rQkgBWMYeOfl5gUfwmZijmtkCgXGya5iNSfZwWv5qAykw/UE9Qt/QWxkbhicGBEHklI902F2bAs0w59m6Qvhti65D9HMjiKF6SUMRnUlbwo0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873487; c=relaxed/simple;
	bh=MWSiRZlnP4iXMDGnKODVvah6326vXDZnL/H9BZ3o+ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCIr9+KInqs8vwPkICOptSQ/B1LHDofTAzrEh9o6Qx0Mg1V/IV1ulVbYRrtOvcVwlD4OOq7CSjIQzJmVnZqyXWhUpJykf4nSXoCYalZ71rhmfcdpQJoTKd3g5HOmPhvsXgAZXtMkwIPZs7sCaNf6rnEAK3uWQDBlXLsKwPD1T2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijmcNsQz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijmcNsQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873CBC4CEEB;
	Mon,  2 Jun 2025 14:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873487;
	bh=MWSiRZlnP4iXMDGnKODVvah6326vXDZnL/H9BZ3o+ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ijmcNsQzPKjaR2aETJ9GpzPxp5mXhDjWey+4qII20c+hLFOAEAdhsqNUseXqmF1kO
	 nTHNPwUtWwsUWWtq1WCdGuM+QIQuXK9ZIteORkxkV7KlXuFU5JvkVVO+fIYgOCUs2V
	 MjTc73iH7HJKBnoZS3BDmhVDOsFUw8254sGsGp1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunke Cao <yunkec@google.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 157/444] media: uvcvideo: Add sanity check to uvc_ioctl_xu_ctrl_map
Date: Mon,  2 Jun 2025 15:43:41 +0200
Message-ID: <20250602134347.279030733@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



