Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99624BE423;
	Wed, 30 Sep 2026 18:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791812; cv=none; b=uTZyAUvG4+tlvSeJ/zM5k3ka6K3NGgefk3Sv3f6d5E03m4Z96UyRxqVddFMYRm2+0sV1DcctyY/pDnddpJtZmxcvLNTLkJzKzhlGLbaxNmLjZTI9BOknswBHW7fYsQjWU89xVFEAia9eKZ/2pPEEQUnH+z6T8dLwJbUVNBJCMIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791812; c=relaxed/simple;
	bh=sjgD0afMPwgwa/UND3rji13AaT5V3xrNP6Oa9XIWORw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYxihzsRPyMhrC6Wt4+5SHVn2LRdXe/IYlkzKk99AucqMpipucucPlli3hj15+bqalmqPv8chWaoni+gfUvmjvUT5zzXq0JCsHa+OpaRNeO8gjFYP1A0Y+W/X9c5K5PNYqJwb6zLW26OquabqwNVmOU6fhJBhuYw+0NhNibEDYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y6FX1ETd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y6FX1ETd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBA51F000FF;
	Wed, 30 Sep 2026 18:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791811;
	bh=x5f8CpZ0I4HvSnlJQazKkxZpPDmW1oHa/YMky3klz58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y6FX1ETd+BcNBWD9MKck74j7X+yn8vUzTKvL+pI0sqGCt/yMdSuMaDoIp3FVJ7Ccx
	 8A2X4r0JqXE/T4zCbS11tZ9TO4W+P4h+OS026T4YUBIXOUKNxJpBhER0gpkzLU2eA7
	 2JShuYMaPkTHG3PC1N0ZpwdA87tsXtBZQXy9RMsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arash Golgol <arash.golgol@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 434/752] media: video-i2c: fix buffer queue ordering
Date: Wed, 30 Sep 2026 17:25:04 +0200
Message-ID: <20260930152407.676063048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
index 545a75e32edc0..59b6a58eb2339 100644
--- a/drivers/media/i2c/video-i2c.c
+++ b/drivers/media/i2c/video-i2c.c
@@ -456,8 +456,9 @@ static int video_i2c_thread_vid_cap(void *priv)
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



