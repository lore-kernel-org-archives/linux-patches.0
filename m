Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4167B65BA3;
	Tue, 23 Jan 2024 01:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975093; cv=none; b=WImL3a+7+8FnY/WPbr1nPJK7sXDhMCjmPzG42Uw5Nl+ovspIc+T8Khl7QlsRQAVAr4vhFW7IqNp1x3bkVmOCsW+//qJNSpLxiPGi4iyjHtR/cMxU6G7WgTDvZpNHczryLsnWwqzXmkCFiNJNJmNyAGxk5z8VgxwFHog3aFijJ+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975093; c=relaxed/simple;
	bh=ydX8np908U5JJqI7uD+MIhtZiYgorYFWgVI+woFwgRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/ntZ3Ibd0FRyJWKbD9Zf1S/clElU4XSD1J3VdU23VogaMltU2EihJVf1azyEpT2UcxLcZ/jhoF+LsUO7DJCz2cmweUuFq7bLgXGbNk0AmKtKBGF3JaOBg701EfLD5Z/RorS0EYA0shi7R8P3zmp0ZVwzAGgEHtaMLFeAFVHw1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rMsEzkSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMsEzkSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5765C433C7;
	Tue, 23 Jan 2024 01:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975093;
	bh=ydX8np908U5JJqI7uD+MIhtZiYgorYFWgVI+woFwgRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rMsEzkSbj4dxZ3kHUcjwsaDSg7eruHzKeW7KIrJ1ZpDmxQUDU677OAX7zGQ8aIl9c
	 VqqM8/6amoKOZHAIsnFgMgaCcbM0cQdY+U7f/E7I7mygf+STJsDqBPqQNRKe3TyBT+
	 w+K1F9pQXy9AcV/Z8XRQBY0mpEaxWBbKQsiBrXoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 235/583] media: visl: Hook the (TRY_)DECODER_CMD stateless ioctls
Date: Mon, 22 Jan 2024 15:54:46 -0800
Message-ID: <20240122235819.180679860@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

[ Upstream commit 3907f6ef8e0d55a88cdb0f7238363d24e26790ca ]

The (TRY_)DECODER_CMD ioctls are used to support flushing when holding
capture buffers is supported. This is the case of this driver but the
ioctls were never hooked to the ioctl ops.

Add them to correctly support flushing.

Fixes: 0c078e310b6d ("media: visl: add virtual stateless decoder driver")
Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/visl/visl-video.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/test-drivers/visl/visl-video.c b/drivers/media/test-drivers/visl/visl-video.c
index 7cac6a6456eb..9303a3e118d7 100644
--- a/drivers/media/test-drivers/visl/visl-video.c
+++ b/drivers/media/test-drivers/visl/visl-video.c
@@ -525,6 +525,9 @@ const struct v4l2_ioctl_ops visl_ioctl_ops = {
 	.vidioc_streamon		= v4l2_m2m_ioctl_streamon,
 	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
 
+	.vidioc_decoder_cmd		= v4l2_m2m_ioctl_stateless_decoder_cmd,
+	.vidioc_try_decoder_cmd		= v4l2_m2m_ioctl_stateless_try_decoder_cmd,
+
 	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
-- 
2.43.0



