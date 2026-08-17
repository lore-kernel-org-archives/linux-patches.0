Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE463E025C;
	Mon, 17 Aug 2026 14:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975714; cv=none; b=jUP01AMoc2eLqX8ct9tL2trB47XO31DmEhy5MXuISdoMBcQE+SxbfCcITzzvx9TDjx0RXC7BVxpRWElBdnGw4PxoXBUGL0sbcrsxNl1ugygJFbXXk2o6hnPokoGW+f2PoKfvLuwl48yO+r/sWo+MvI8KOok4N10q2QVVMOKqKOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975714; c=relaxed/simple;
	bh=agWqcl00CTmXeHVWjOGJbwWWIdGZQMbsjXGJRAvyZ6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3mC8MQA3HKgyw3eEriqxvOPeSk9zWUzf78eDkZMupzEKiwJzP9zjUXGspL2ro9KzqQzZ8Sw8ljYEyw1p3MwcuJXpAlO64fSaGCHG8UEzs2XGyEOJXX/ISksq0ySgmqDzSyxxvP2LKycFTFysLXG0LbaYtxR2x7PEDoB+1bYL/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bwkcZ0d9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bwkcZ0d9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD4C1F000E9;
	Mon, 17 Aug 2026 14:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975713;
	bh=K2DEsYORGMt+KgFFstLi0Ycg7BxkBj9r6o1sRpni0MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bwkcZ0d9k6LI3Up8vhYFpkxxGo7FfIc5+O1JwBU4ysCKQUdsiz095clYP53Y6jxhn
	 P8oIakLSiLDydp1KBwjGntPdK0VudwPo603XdJF593woMLRC5GfOani6xmkFXPbkhA
	 xo74EgMUrmbBxyU+rodFBecbyze/18h19LejP2+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 124/389] media: cedrus: skip invalid H.264 reference list entries
Date: Mon, 17 Aug 2026 15:29:23 +0200
Message-ID: <20260817132543.993016110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit 10358ea986c3c85516d1c8206486464f79d36e76 upstream.

Cedrus consumes H.264 ref_pic_list0/ref_pic_list1 entries from the
stateless slice control and later uses their indices to look up
decode->dpb[] in _cedrus_write_ref_list().

Rejecting such controls in cedrus_try_ctrl() would break existing
userspace, since stateless H.264 reference lists may legitimately carry
out-of-range indices for missing references. Instead, guard the actual
DPB lookup in Cedrus and skip entries whose indices do not fit the fixed
V4L2_H264_NUM_DPB_ENTRIES array.

This keeps the fix local to the driver use site and avoids out-of-bounds
reads from malformed or unsupported reference list entries.

Fixes: e000e1fa4bdbd ("media: uapi: h264: Update reference lists")
Cc: stable@vger.kernel.org
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Tested-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus_h264.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/staging/media/sunxi/cedrus/cedrus_h264.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_h264.c
@@ -190,6 +190,9 @@ static void _cedrus_write_ref_list(struc
 		u8 dpb_idx;
 
 		dpb_idx = ref_list[i].index;
+		if (dpb_idx >= V4L2_H264_NUM_DPB_ENTRIES)
+			continue;
+
 		dpb = &decode->dpb[dpb_idx];
 
 		if (!(dpb->flags & V4L2_H264_DPB_ENTRY_FLAG_ACTIVE))


