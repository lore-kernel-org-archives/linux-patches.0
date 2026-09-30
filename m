Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4524D2EFE;
	Wed, 30 Sep 2026 17:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788267; cv=none; b=feeWuB3A1sDbRifCqYdQ83djAHVCWWmgP1yv+6cbIWdbG7t3lltjEpIcu3eJFumRTZ2it0wgiu8H8ylbrSX5LI8jFco5YqIOwZUO6IehYBnQ3gnwydialuyz8SFfd7ikw1gfMjTQ3GDZXA9K7kIHx87sYKvvVIjWzp6uE2Q/DRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788267; c=relaxed/simple;
	bh=crJv70ofeV0Xq3eWbd63nz5iXRvbnN0txL5LCA9WuXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3WcUzEhkWGbm89ymOlHHRm4voNjkXQtYlkcWXjja6AWfUeXBRjzupYNQT8BwlsYCO0XuM3QUqorNKM5TmkSEQ6Qi2XfJEeTyLDVjOK4oIGc+23VAVyQ2RQduBiIp6Vw4LegNyfDqoWiHyTJjyxir41/MOTR/XhlcNEiBdffnfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WSNmslFu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WSNmslFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2C71F000FF;
	Wed, 30 Sep 2026 17:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788266;
	bh=M4qi5aK/SxFNEe5LkLFHGFJeBruwKPw+34/6GrNjDjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WSNmslFuIOlg77W/xagG8kUXDhJg4w6U8tOGpMdyHc9cAVLfXYby3A4nx4LyVUI2r
	 rT+G1XFNKZ2Pjm9Oybgq9UgipPpag84sG1Td+0lrNnw774kSw5JcvAoHxGiiNHDzsL
	 d/iQui/spryDTdbc/kjhGhx5r+xqbTPNT0J5+fmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arash Golgol <arash.golgol@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/877] media: video-i2c: fix buffer queue ordering
Date: Wed, 30 Sep 2026 17:15:30 +0200
Message-ID: <20260930152415.160019130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a091fd6d3e607..a4ddc10c5f22e 100644
--- a/drivers/media/i2c/video-i2c.c
+++ b/drivers/media/i2c/video-i2c.c
@@ -465,8 +465,9 @@ static int video_i2c_thread_vid_cap(void *priv)
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



