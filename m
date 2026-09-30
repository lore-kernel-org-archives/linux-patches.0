Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86E13C0A06;
	Wed, 30 Sep 2026 19:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796010; cv=none; b=gBV1k6NPUc61MK0RVFx4fwrS/Hm6eoEp00YZdaEO2vtn43j50zIJBChsWIyJ0rikmMN7xK2p85T5ndN9cl0iUOviEZnIj3JmVT+3CA4iRBz93qbdJ3tzgYQQKxee/Y/7Vh27Lv/zQ22XiVR0U2F48wgaH3yZgr2EZBwy2ttnzuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796010; c=relaxed/simple;
	bh=q7Hj8o6nPPDto1ZpNQmOREfhBJ8nsSzx7adf8DhcmPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEldiQ+5N0F+v1Cv+iFyfy7kSCDPa6cq5hkbPIssFnaSTuWQhEL2p/7Xtz29EHrLTPku4F7DJ7FyBuUxbZvIc2A9byLoK2mImHc61AnUDkMcNiqu4AgQMQUsEGAIhV96KdVdoghO9LoMneai3VYdRm57GBxiPwLQtPOmDfNzIW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bpDNRMCH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bpDNRMCH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA441F000FF;
	Wed, 30 Sep 2026 19:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796009;
	bh=rUFcJDDIP6evODATvqX4BpKrSxUCGqvEB+mQ+yEDL6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bpDNRMCH3xVXzOSm6DXdD1wWilBDmZqf9VLQ9TZ+GBBDkn43NTm01BFVUaweOfH6P
	 7kIxoQUwOa54m2uUghNaJeGuUYvlF1b1tnUS1pFRV89bxQ7Qu4wrpvN4pOuXxaRWbZ
	 xH2gSsVJGRMQA7AOzeCgYkiRZCo2lLcr0gEOQyyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arash Golgol <arash.golgol@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0717/1193] media: video-i2c: fix buffer queue ordering
Date: Wed, 30 Sep 2026 17:23:21 +0200
Message-ID: <20260930152450.180428990@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7a975e2eab00b..325ee77ba4466 100644
--- a/drivers/media/i2c/video-i2c.c
+++ b/drivers/media/i2c/video-i2c.c
@@ -464,8 +464,9 @@ static int video_i2c_thread_vid_cap(void *priv)
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



