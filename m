Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF632C327E;
	Mon,  2 Jun 2025 14:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873690; cv=none; b=IL8IcMX2eUkxQ8N7dwcsaBFRp+X8voXa8QRqjkx/TyQe8qkglfpho5bIzyX7kiQgCW+/riJzKrJmBvg8xY0T1XqnOt/Jdy8/9+myaAUHr2232walCPZJRnDljxOqgffL6E3dBAoLYhZj8EgkpI4E9gJrthGeJwS6YZJq2z28AJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873690; c=relaxed/simple;
	bh=h36Mtz8DRZ8vuVClU52hBZHwhNbjNmR0+YsnTmYjyiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnJFJsUn+esgCbpcjDG4xwD9hXpcMzbgjZVfBaKQh5D6GTz+W8l2RBCt+yHprRdujtV6K9yID0Y0vIWvN482RmyX1SUnv7fHo/yuz6HzPHDAcQigT1BvpXwSkZyG5v1ZKxzSAaLi9lPeYCpAkwkkE99h+RIJqgn27aZSwbVLjrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vs2XT+II; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vs2XT+II"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915DAC4CEEB;
	Mon,  2 Jun 2025 14:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873689;
	bh=h36Mtz8DRZ8vuVClU52hBZHwhNbjNmR0+YsnTmYjyiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vs2XT+IIMNNPgUIihPd3C+fQ8j75MKqnfF9Uo+W2emsBBh4ZIV2DfWJgNRWzRGCjT
	 lmCtTK+ID6W8rJ6qbDPOL5lWa6YRzzCvKO8eF2Dw5WdIPA3a0yOyUCYErq6oT/mhgX
	 RxbmMCrM9xka+2CcND0Zd5MBQnau2bAz9wiSB2tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"Artem S. Tashkinov" <aros@gmx.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 220/444] media: test-drivers: vivid: dont call schedule in loop
Date: Mon,  2 Jun 2025 15:44:44 +0200
Message-ID: <20250602134349.838182368@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Hans Verkuil <hverkuil@xs4all.nl>

[ Upstream commit e4740118b752005cbed339aec9a1d1c43620e0b9 ]

Artem reported that the CPU load was 100% when capturing from
vivid at low resolution with ffmpeg.

This was caused by:

while (time_is_after_jiffies(cur_jiffies + wait_jiffies) &&
       !kthread_should_stop())
        schedule();

If there are no other processes running that can be scheduled,
then this is basically a busy-loop.

Change it to wait_event_interruptible_timeout() which doesn't
have that problem.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Reported-by: Artem S. Tashkinov <aros@gmx.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219570
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vivid/vivid-kthread-cap.c  | 11 ++++++++---
 drivers/media/test-drivers/vivid/vivid-kthread-out.c  | 11 ++++++++---
 .../media/test-drivers/vivid/vivid-kthread-touch.c    | 11 ++++++++---
 drivers/media/test-drivers/vivid/vivid-sdr-cap.c      | 11 ++++++++---
 4 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/media/test-drivers/vivid/vivid-kthread-cap.c b/drivers/media/test-drivers/vivid/vivid-kthread-cap.c
index 42048727d7ff3..b8cdffc9a1e9e 100644
--- a/drivers/media/test-drivers/vivid/vivid-kthread-cap.c
+++ b/drivers/media/test-drivers/vivid/vivid-kthread-cap.c
@@ -765,9 +765,14 @@ static int vivid_thread_vid_cap(void *data)
 			next_jiffies_since_start = jiffies_since_start;
 
 		wait_jiffies = next_jiffies_since_start - jiffies_since_start;
-		while (time_is_after_jiffies(cur_jiffies + wait_jiffies) &&
-		       !kthread_should_stop())
-			schedule();
+		if (!time_is_after_jiffies(cur_jiffies + wait_jiffies))
+			continue;
+
+		wait_queue_head_t wait;
+
+		init_waitqueue_head(&wait);
+		wait_event_interruptible_timeout(wait, kthread_should_stop(),
+					cur_jiffies + wait_jiffies - jiffies);
 	}
 	dprintk(dev, 1, "Video Capture Thread End\n");
 	return 0;
diff --git a/drivers/media/test-drivers/vivid/vivid-kthread-out.c b/drivers/media/test-drivers/vivid/vivid-kthread-out.c
index fac6208b51da8..015a7b166a1e6 100644
--- a/drivers/media/test-drivers/vivid/vivid-kthread-out.c
+++ b/drivers/media/test-drivers/vivid/vivid-kthread-out.c
@@ -235,9 +235,14 @@ static int vivid_thread_vid_out(void *data)
 			next_jiffies_since_start = jiffies_since_start;
 
 		wait_jiffies = next_jiffies_since_start - jiffies_since_start;
-		while (time_is_after_jiffies(cur_jiffies + wait_jiffies) &&
-		       !kthread_should_stop())
-			schedule();
+		if (!time_is_after_jiffies(cur_jiffies + wait_jiffies))
+			continue;
+
+		wait_queue_head_t wait;
+
+		init_waitqueue_head(&wait);
+		wait_event_interruptible_timeout(wait, kthread_should_stop(),
+					cur_jiffies + wait_jiffies - jiffies);
 	}
 	dprintk(dev, 1, "Video Output Thread End\n");
 	return 0;
diff --git a/drivers/media/test-drivers/vivid/vivid-kthread-touch.c b/drivers/media/test-drivers/vivid/vivid-kthread-touch.c
index fa711ee36a3fb..c862689786b69 100644
--- a/drivers/media/test-drivers/vivid/vivid-kthread-touch.c
+++ b/drivers/media/test-drivers/vivid/vivid-kthread-touch.c
@@ -135,9 +135,14 @@ static int vivid_thread_touch_cap(void *data)
 			next_jiffies_since_start = jiffies_since_start;
 
 		wait_jiffies = next_jiffies_since_start - jiffies_since_start;
-		while (time_is_after_jiffies(cur_jiffies + wait_jiffies) &&
-		       !kthread_should_stop())
-			schedule();
+		if (!time_is_after_jiffies(cur_jiffies + wait_jiffies))
+			continue;
+
+		wait_queue_head_t wait;
+
+		init_waitqueue_head(&wait);
+		wait_event_interruptible_timeout(wait, kthread_should_stop(),
+					cur_jiffies + wait_jiffies - jiffies);
 	}
 	dprintk(dev, 1, "Touch Capture Thread End\n");
 	return 0;
diff --git a/drivers/media/test-drivers/vivid/vivid-sdr-cap.c b/drivers/media/test-drivers/vivid/vivid-sdr-cap.c
index a81f26b769883..1dd59c710dae7 100644
--- a/drivers/media/test-drivers/vivid/vivid-sdr-cap.c
+++ b/drivers/media/test-drivers/vivid/vivid-sdr-cap.c
@@ -206,9 +206,14 @@ static int vivid_thread_sdr_cap(void *data)
 			next_jiffies_since_start = jiffies_since_start;
 
 		wait_jiffies = next_jiffies_since_start - jiffies_since_start;
-		while (time_is_after_jiffies(cur_jiffies + wait_jiffies) &&
-		       !kthread_should_stop())
-			schedule();
+		if (!time_is_after_jiffies(cur_jiffies + wait_jiffies))
+			continue;
+
+		wait_queue_head_t wait;
+
+		init_waitqueue_head(&wait);
+		wait_event_interruptible_timeout(wait, kthread_should_stop(),
+					cur_jiffies + wait_jiffies - jiffies);
 	}
 	dprintk(dev, 1, "SDR Capture Thread End\n");
 	return 0;
-- 
2.39.5



