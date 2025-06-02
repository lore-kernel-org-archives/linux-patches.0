Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AA1225A20;
	Mon,  2 Jun 2025 14:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876120; cv=none; b=B9iiI2w58PmUKPd4xXRYKLqKq39rAjyRyojXLRz77f6nOOgt+fVHaju1xYeVoyOkmvaE9Pn/zgoLyzyGkGHdv9uxPxj8yY+qiywekCPDedI6loCNVe3x4Bvjt8U334UhzxIW77zHB2ZJwc+GKg8JPo/uzgrIWhxccrkfnq9dGoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876120; c=relaxed/simple;
	bh=yPul50c9mvgKoVlafZU3FWX7+16vcQA8vCTd0aPpxL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+73D/ItI2HVBIVQW3pI2ZgNVtNGh75wQDKeBk9dqRcwZVKQrNgFogqjN56SgVhcE6UkESBc1XOG1l1IG6vCJ5kUUjnIBe3ZUBxPjXEsNHm91li2t4NSBQv4g02/WH1MuGJODvba4EHNSXi80fx7M1SfSjdjXAr83mjNGZNXuso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LpcDLTdt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LpcDLTdt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D858BC4CEEB;
	Mon,  2 Jun 2025 14:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876120;
	bh=yPul50c9mvgKoVlafZU3FWX7+16vcQA8vCTd0aPpxL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LpcDLTdtlyxfO74bn/4VkCn9xmmCS2oHnewKEw6lGUwaCu62yh/jBjipo/N5c9Jrc
	 dAKal0vboZVhjPo2Pa+7t3JKdwQHAeZxWPn4a/fmlOKjw854Ppwj15ag2upAjBLEwT
	 ks/7lSBn0Lbe1ZNIbYJsDN0lHR96Ec9Brc0khh4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunke Cao <yunkec@google.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/207] media: uvcvideo: Add sanity check to uvc_ioctl_xu_ctrl_map
Date: Mon,  2 Jun 2025 15:47:29 +0200
Message-ID: <20250602134301.753149974@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a86d470a9f98f..2f8b485ddde04 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -35,6 +35,12 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain *chain,
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



