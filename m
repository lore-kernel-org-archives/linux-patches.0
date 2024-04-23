Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D73143889;
	Tue, 23 Apr 2024 21:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908588; cv=none; b=OPCijgxC4bAAteJpDkJmqbtwqy8/qkRgcAtdS6RRK11+Ni6YQb0gBoBiYUWFjKb0LKgvme3c0uSo/As8D1gPr2NOWPS+3UCyqJ0TNB2Jti2H0GQFkW6yz97hFRoUg/jl7qQBQlYe8guOvHfh/FQRP2ORDU/7zLBXeOxTe4NJlTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908588; c=relaxed/simple;
	bh=OyedTjjy+XCMhuXxDkKQ0nNFVRTJvKx/Pq60/SVPdTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VqiVDEaRMPi8tVckK1XRNC5wRtOEngPFDxRVtan9Aa+xUKPRNCmgccCF7cLZRCzklXwGwqynmCUQBqBf3LiUna9Fu5aSLetg53N76XcSnNdFzK6eR+tN5GklIVIaQ/tfLUEbvdbXxc8bfK2Up1DSmRd9XUs7jQME7uFcUPFEycM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sxqXs4s/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sxqXs4s/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45759C32783;
	Tue, 23 Apr 2024 21:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908588;
	bh=OyedTjjy+XCMhuXxDkKQ0nNFVRTJvKx/Pq60/SVPdTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sxqXs4s/6yU/2l9Qd2ADOE54gBF0ZPnXq+mNDG2FLGihSleKCjlD0qlvDzCC1qmn6
	 nigrmdx4uXMelDSiGeI03BuE3Fsm7uHszxH0bVxBswrZu2PiOSa44LEej+1qPEmBgo
	 flXrjUjb4eEJtWNSy8jrXC/hDAY5DSiur6iupMtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	"Dr. David Alan Gilbert" <dave@treblig.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/158] media: videobuf2: request more buffers for vb2_read
Date: Tue, 23 Apr 2024 14:37:39 -0700
Message-ID: <20240423213856.458697122@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 350ab13e1382f2afcc2285041a1e75b80d771c2c ]

The vb2 read support requests 1 buffer, leaving it to the driver
to increase this number to something that works.

Unfortunately, drivers do not deal with this reliably, and in fact
this caused problems for the bttv driver and reading from /dev/vbiX,
causing every other VBI frame to be all 0.

Instead, request as the number of buffers whatever is the maximum of
2 and q->min_buffers_needed+1.

In order to start streaming you need at least q->min_buffers_needed
queued buffers, so add 1 buffer for processing. And if that field
is 0, then choose 2 (again, one buffer is being filled while the
other one is being processed).

This certainly makes more sense than requesting just 1 buffer, and
the VBI bttv support is now working again.

It turns out that the old videobuf1 behavior of bttv was to allocate
8 (video) and 4 (vbi) buffers when used with read(). After the vb2
conversion that changed to 2 for both. With this patch it is 3, which
is really all you need.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: b7ec3212a73a ("media: bttv: convert to vb2")
Tested-by: Dr. David Alan Gilbert <dave@treblig.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index cf6727d9c81f3..468191438849e 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -2648,9 +2648,14 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 		return -EBUSY;
 
 	/*
-	 * Start with count 1, driver can increase it in queue_setup()
+	 * Start with q->min_buffers_needed + 1, driver can increase it in
+	 * queue_setup()
+	 *
+	 * 'min_buffers_needed' buffers need to be queued up before you
+	 * can start streaming, plus 1 for userspace (or in this case,
+	 * kernelspace) processing.
 	 */
-	count = 1;
+	count = max(2, q->min_buffers_needed + 1);
 
 	dprintk(q, 3, "setting up file io: mode %s, count %d, read_once %d, write_immediately %d\n",
 		(read) ? "read" : "write", count, q->fileio_read_once,
-- 
2.43.0



