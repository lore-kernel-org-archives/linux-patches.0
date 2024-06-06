Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1058219AA6A;
	Thu,  6 Jun 2024 14:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683034; cv=none; b=UEz4taTMtf1wBCsCisLv7cZDWqDY4NbnlBDpCvUI9MwYYj2JOrSoQ9sbjPoq9zq0rB6K4VeJ1avoAOJL6hn2V/yLPed4feOBlhrpHMuD+YEes0H6zXhhQpyO6xCvpiMw7CcF6OBIySswX8xHjBLFnJZ9y6j5l3bQxN9FwK7d3V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683034; c=relaxed/simple;
	bh=qgeRVi+V7l4NlsFrxVBSoPPzVG5+huE9rvfZPwT0hiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQXMOgL9tg9jN0HZPuMu0vSfjUC6KAnYs3Zu4JitcbEdKr7PBnYbWwpGw5MQujZ+fdzZmZxyUmBQVodMrTdi8jd2oHIj5vVQB6bsX6mmTSBetE3mMiefm/AY9OE/mxlQE0wTYzt6Za3MmDjrbKYUR6KWwx0VzxeGtZ1JxLcLiGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FLAY823T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FLAY823T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F27C4AF10;
	Thu,  6 Jun 2024 14:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683033;
	bh=qgeRVi+V7l4NlsFrxVBSoPPzVG5+huE9rvfZPwT0hiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FLAY823TlYm6421AVFtsX7o+m1SQPoRNNR8wPKpxTvdDAL0ZtvIDrZGScrHWatC+P
	 7MrR3MXAt65K9EGubPnF7m/PIms9ohd1Z1ikdrX0kwnmCprVsxaaOit0X3j21lMjR8
	 hb/DSIGvcBoIx0QFhPnCs4DjDmf6UUkfC1VZ96ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Stevens <stevensd@chromium.org>,
	David Hildenbrand <david@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 259/374] virtio_balloon: Give the balloon its own wakeup source
Date: Thu,  6 Jun 2024 16:03:58 +0200
Message-ID: <20240606131700.554448225@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Stevens <stevensd@chromium.org>

[ Upstream commit 810d831bbbf3cbd86e5aa91c8485b4d35186144d ]

Wakeup sources don't support nesting multiple events, so sharing a
single object between multiple drivers can result in one driver
overriding the wakeup event processing period specified by another
driver. Have the virtio balloon driver use the wakeup source of the
device it is bound to rather than the wakeup source of the parent
device, to avoid conflicts with the transport layer.

Note that although the virtio balloon's virtio_device itself isn't what
actually wakes up the device, it is responsible for processing wakeup
events. In the same way that EPOLLWAKEUP uses a dedicated wakeup_source
to prevent suspend when userspace is processing wakeup events, a
dedicated wakeup_source is necessary when processing wakeup events in a
higher layer in the kernel.

Fixes: b12fbc3f787e ("virtio_balloon: stay awake while adjusting balloon")
Signed-off-by: David Stevens <stevensd@chromium.org>
Acked-by: David Hildenbrand <david@redhat.com>
Message-Id: <20240321012445.1593685-2-stevensd@google.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_balloon.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 1f5b3dd31fcfc..89bc8da80519f 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -450,7 +450,7 @@ static void start_update_balloon_size(struct virtio_balloon *vb)
 	vb->adjustment_signal_pending = true;
 	if (!vb->adjustment_in_progress) {
 		vb->adjustment_in_progress = true;
-		pm_stay_awake(vb->vdev->dev.parent);
+		pm_stay_awake(&vb->vdev->dev);
 	}
 	spin_unlock_irqrestore(&vb->adjustment_lock, flags);
 
@@ -462,7 +462,7 @@ static void end_update_balloon_size(struct virtio_balloon *vb)
 	spin_lock_irq(&vb->adjustment_lock);
 	if (!vb->adjustment_signal_pending && vb->adjustment_in_progress) {
 		vb->adjustment_in_progress = false;
-		pm_relax(vb->vdev->dev.parent);
+		pm_relax(&vb->vdev->dev);
 	}
 	spin_unlock_irq(&vb->adjustment_lock);
 }
@@ -1029,6 +1029,15 @@ static int virtballoon_probe(struct virtio_device *vdev)
 
 	spin_lock_init(&vb->adjustment_lock);
 
+	/*
+	 * The virtio balloon itself can't wake up the device, but it is
+	 * responsible for processing wakeup events passed up from the transport
+	 * layer. Wakeup sources don't support nesting/chaining calls, so we use
+	 * our own wakeup source to ensure wakeup events are properly handled
+	 * without trampling on the transport layer's wakeup source.
+	 */
+	device_set_wakeup_capable(&vb->vdev->dev, true);
+
 	virtio_device_ready(vdev);
 
 	if (towards_target(vb))
-- 
2.43.0



