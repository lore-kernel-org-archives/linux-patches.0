Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363684E77FD;
	Wed, 30 Sep 2026 15:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783284; cv=none; b=WFPAe15GKIXqYdZnrw4iJiX2J6Al0ohtBuJlo2TtAke9NvVBdWEZIjmCkH9XS2A9YQE26lB5jjPZf561C/HJjmEHM7z8YxC4S+6JdCvvp8bg+3dBY78f+CodBN9BcqH/E1tf3oy9zdgn9DnAks0qbFoSqoGGe3wfWJRsFjhbAg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783284; c=relaxed/simple;
	bh=t9uGZ6tnifK7X1fEyPXqC9DvscDlEf84DjlsA/YwRI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UORAuMXkFgvNaEJZ4ooJd/GzGzNJW18ahjsGx+n7qbz7bUDabXzm7Zr6qh9BQP4f594Mp2nFvECYAVb6hnU7gRH14Gmur+GpDp88rJlygtU44xZrp/xLoLw8pRIW1x/KPvKXN9E1Dr8SLdFaFm3IFD6YevTM1O7WhLrboP9X3uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lcia55vk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lcia55vk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C16A1F00893;
	Wed, 30 Sep 2026 15:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783279;
	bh=i4m0JsY706oxNHs0xKlIrapZJVOAHYxJZARwpc6vTaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lcia55vkmDppEg1shFlHYTC/2ki48anHKyTSmU7ma0Qla5ybZQBPGJsllu8rkTsHE
	 YSwF7TOx95jtd+1ZBCFfp0GIU8qiYEKu3/AHJ0cV7NhnGiQmrl7Vd6kPuSr27/zUFS
	 1UVRWs3KKrJa5cwDiXuH23UYQvL0A9Emdohnruhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arash Golgol <arash.golgol@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 342/595] media: video-i2c: fix buffer queue ordering
Date: Wed, 30 Sep 2026 17:23:55 +0200
Message-ID: <20260930152355.034743760@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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
index 4ccd66cba2cae..1de7e47d0ae7d 100644
--- a/drivers/media/i2c/video-i2c.c
+++ b/drivers/media/i2c/video-i2c.c
@@ -458,8 +458,9 @@ static int video_i2c_thread_vid_cap(void *priv)
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



