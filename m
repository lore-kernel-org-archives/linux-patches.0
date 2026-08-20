Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3353D47CC73;
	Thu, 20 Aug 2026 16:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243677; cv=none; b=ndu/UzkIwlTKtFkTU/624MuQSHh/fFoKFPPr36JQ864mA5D4e07RbAQJkAMSLd0dKzMqnt+ALftUNs6AyY79UdYJTZzv5P0EZUruWZ8ORcEbhjaRAAozbHTzS2dCQP5+v2TO+88iWnRAsF5lDF51kalJVw5Sw4GCtqkKRtFQEx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243677; c=relaxed/simple;
	bh=HSCfTe2Xqqr7VT6xhxICxX0RLF+l04h/llxuKjAC/ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzYXgfk1yA54Xb4vJNPo3fJnV8lwy8x6mbB4kCb1KX8YMp4R6+Rp7lR+JttGUBmhJF0WDvfEakpoAMsGJhe1HMoyjU1td7qSa3FV+oonDNvfgnvrmjVSFF/zNwsQC8wli/bpYOkbj8FA1m16bq3Wr+WJaSRTr50RPKSEDS0/3Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ofJiCpDV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ofJiCpDV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507381F00ACF;
	Thu, 20 Aug 2026 16:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243675;
	bh=CtWj88JZ4QpqMCWqe/xJhpMSu5iXoPMGBdlBAdXN66g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ofJiCpDV8CqW4fkUlEYPOTLK61NYl+nQUFr2ppHDsgnHx/9v81XhhcvEh5Gd2YYVA
	 yfbBICGgWV3jjgV8hMr09Hce8pF027BCrFFXygf7uQlbq1cWf3G+KHFvz/zhXBadmr
	 /VVjWuWVtYvg9Ril8gRX0+3DSlhxu7UVSYZE3V5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 177/272] drm/virtio: Return proper error codes instead of -1
Date: Thu, 20 Aug 2026 16:56:01 +0200
Message-ID: <20260820145236.770440657@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

[ Upstream commit 4c703f5d6f776eaa6a98611c9b5dfe800fbeb0c8 ]

Don't return -1 in error cases, return proper error code. The returned
error codes propagate to error messages and to userspace and it's always
good to have a meaningful error number for debugging purposes.

Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20220630200726.1884320-10-dmitry.osipenko@collabora.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Stable-dep-of: 4e1a53892ba7 ("drm/virtio: bound EDID block reads to the response buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/virtio/virtgpu_vq.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/virtio/virtgpu_vq.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vq.c
@@ -329,7 +329,7 @@ static int virtio_gpu_queue_ctrl_sgs(str
 		if (fence && vbuf->objs)
 			virtio_gpu_array_unlock_resv(vbuf->objs);
 		free_vbuf(vgdev, vbuf);
-		return -1;
+		return -ENODEV;
 	}
 
 	if (vgdev->has_indirect)
@@ -393,7 +393,7 @@ static int virtio_gpu_queue_fenced_ctrl_
 			if (!sgt) {
 				if (fence && vbuf->objs)
 					virtio_gpu_array_unlock_resv(vbuf->objs);
-				return -1;
+				return -ENOMEM;
 			}
 
 			elemcnt += sg_ents;
@@ -728,7 +728,7 @@ static int virtio_get_edid_block(void *d
 	size_t start = block * EDID_LENGTH;
 
 	if (start + len > le32_to_cpu(resp->size))
-		return -1;
+		return -EINVAL;
 	memcpy(buf, resp->edid + start, len);
 	return 0;
 }


