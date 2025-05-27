Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35812110E;
	Tue, 27 May 2025 17:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367206; cv=none; b=hy0KAiChGb184Tn43Af8bElNY7Otbqig9vd4QSC8UMMY+o5waQ6RIOouVgKz49PcYqH6EgQ6ksddvejqTlqNT6UWziVRT7gsravqly77Xl0gyaBTtf8zkByUk/biMzx7sBbrhB0VO2pIkvQnulkEt10pwuh1jT29VcXhRB91FXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367206; c=relaxed/simple;
	bh=WFiqgz5i+7FCXhBEokZuukw0Xtb2OGtImyXnYyNtkmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XEiETOUSR05wC3FN9kmiiL1djKOJUkF0EFyo/GQPOvZlahNKBeEP/GWF8Sryj9VZaZVXIJx3G8Mf0s7yPUZII4fKzdYtg/thkO7BwmpcpnVpKsZeoH2GpulbPFo7nkrQYfLX4Tq+SyQ4wQZXH1E/PgSrh2RQuN+E3aTknuz8uhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bM7YaHqP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bM7YaHqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A207C4CEE9;
	Tue, 27 May 2025 17:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367206;
	bh=WFiqgz5i+7FCXhBEokZuukw0Xtb2OGtImyXnYyNtkmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bM7YaHqPH23ZqYo4LkGsjZOmg66PCSnsPpeeh2ycLVxRdKsov7WjVoNk7SfSzLv0D
	 SSLL+OeWhutGhW/co4/FMMWbTyttdC2TXLzLfraZn3nsF1tDkYdjoqWcG/Y02XQjQF
	 q3yDWxKeUlVas/1XdUbDuuNTh4HYH1hXqH7Dj91k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunke Cao <yunkec@google.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 311/783] media: uvcvideo: Add sanity check to uvc_ioctl_xu_ctrl_map
Date: Tue, 27 May 2025 18:21:48 +0200
Message-ID: <20250527162525.735222681@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 93c6cdb238812..75216507cbdcf 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -108,6 +108,12 @@ static int uvc_ioctl_xu_ctrl_map(struct uvc_video_chain *chain,
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



