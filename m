Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323823C10A0;
	Wed, 23 Sep 2026 14:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174140; cv=none; b=Xf/GivJ19YJDSQnGbXWxR1jJ79RMWngwGSmSJB5sv9f9JwMHhO63j7Z+hsAXhRKnsCpmZXs1dTmb5N7WPOfF/TAtVOzvFZXkKFdkpShzCNi58SIyzF5J1R+eHg4f6kYjti6jk5r3qAWt4cLm+jV4b0gHSVMj6asU2N2nb+t1czQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174140; c=relaxed/simple;
	bh=f73UN/gZm5hAXquL+ROxsu3wEuzd6xAyzvddZtvkios=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LK6PQXwtIa5trgdIov64Z0TUP2GpS8AF5TSN42d1FDrr3YVurG/xtvLGOeebBpHTPDVlgrdPIkElAw/6Se/p1Qp8VO+q6svT7XRtxmn1agbuM8j3q+XduI9vKUe2V954f1oBqdPvjnCuYZ8OqVgCXDy1I40TprFUO1fbWAIrgY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2BfRmgbz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2BfRmgbz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BDBF1F000FF;
	Wed, 23 Sep 2026 14:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174139;
	bh=tsV+FIz+ke7YSfZFETUhW+80UfeOPkn/dzx+AZnTrMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2BfRmgbzIXwS6bOaM65vjFYUXxTn+xe2t0R3yBYTbI8AJSfxC84ZjyLVOMk2WkIK9
	 GdHKy1buibNZqhhaipOFuk4RO35B/QCTHKVprYZ++40Do0EEGPU46BHrJwSF9lZfLx
	 yfHbHrR82GIPrRWFZyuKorInDNf6nwJ79QoxUKD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arash Golgol <arash.golgol@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 014/398] media: video-i2c: fix buffer queue ordering
Date: Wed, 23 Sep 2026 16:01:28 +0200
Message-ID: <20260923140643.810421518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arash Golgol <arash.golgol@gmail.com>

[ Upstream commit bc4574c265ed738849e46d942617100580fcedd2 ]

Queued buffers are added to the tail of vid_cap_active in
buffer_queue(), but the capture kthread also retrieves buffers from
the tail of the list.

This makes the queue behave as LIFO instead of FIFO when multiple
buffers are queued.

Fix this by retrieving buffers from the head of the list.

Signed-off-by: Arash Golgol <arash.golgol@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/video-i2c.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
index 20889f94610cb..3584678756979 100644
--- a/drivers/media/i2c/video-i2c.c
+++ b/drivers/media/i2c/video-i2c.c
@@ -454,8 +454,9 @@ static int video_i2c_thread_vid_cap(void *priv)
 		spin_lock(&data->slock);
 
 		if (!list_empty(&data->vid_cap_active)) {
-			vid_cap_buf = list_last_entry(&data->vid_cap_active,
-						 struct video_i2c_buffer, list);
+			vid_cap_buf = list_first_entry(&data->vid_cap_active,
+						       struct video_i2c_buffer,
+						       list);
 			list_del(&vid_cap_buf->list);
 		}
 
-- 
2.53.0



