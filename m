Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A1334D916;
	Wed, 30 Sep 2026 16:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785663; cv=none; b=hQECsJsOTi5Vb4YHCX+k7/rGBVqbozj8pEHaY53vs30d8oFJSiqCwtWBh0xYJzECo66ENt1drFzs+1y0Wy/UC1Ff6XgBSW34Dqtm7gTRwI62sqkT7hy9gJ17KtbyF/MNT+MEHeX4rAL9yFJ0GyayGP/RQeRckwJTZ+TOMNEic54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785663; c=relaxed/simple;
	bh=j0+lVO5TUkHfZx+f8ZUf+EnccuGKvI1oJMMIRUC/B4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQmGF1MHYdTjRJZaSzy6r5GguNyrs6HbNZznFO3N4KWy9wjyt6iVDnB6a4KAde8js5xay7+gbsoQYf8RZfbfE2MEe7THxkslxIfy7aPGgk4pT+VIcDBoO1UXdPtpaGsx/kw5gudasejTK0nBEDv9ES7irH6Qj4Z9ssq/2rGHMU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1SPfrgZw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1SPfrgZw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158DF1F000FF;
	Wed, 30 Sep 2026 16:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785662;
	bh=JC04J8Kh1OVFnDRRYmqBHrke3pPX3Wl9YUqPnBLk29I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1SPfrgZw6xtdU45MUHpHeJq11VWEAgwV8n40zwmqX9mRuq3gRPSaGdoBAudcZebRQ
	 KSZvPau+8g1gQhaNJaGsUtO0WM9Um0x8y/pn4oqgNuYWmHiqdODkAjTZHFACHfoqXy
	 HzvbC9sA6YzDbpYiUJKiohTjvpDKji0sAzCM67Z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arash Golgol <arash.golgol@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 586/982] media: video-i2c: fix buffer queue ordering
Date: Wed, 30 Sep 2026 17:22:02 +0200
Message-ID: <20260930152429.368794106@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 83a4fc95252fa..d6aecf07040b1 100644
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



