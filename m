Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1E330DEAC;
	Mon, 13 Apr 2026 16:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098491; cv=none; b=POWVTz+LClw2U9l8GwP8vQSxIAlsvA+B2OtTyb/A1QQsazWq/SHryL9YV221i8J3rYB7PYN+vQWwPEgn5WOkLVoxhwuWGd0Yqf5sjoVil82RTnParllbQGAAsuQwGj5HAGlzVJzh8wZ7GcyWG3QlgPHDghAoz7aPOXWscD+uh20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098491; c=relaxed/simple;
	bh=4+FoeYOj8/l3O5BaK+yNbvS1YMp8K5IjO0fLTLSN0Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIWZ+pngpxjnIioIcPTvMXZwav+BdpVOEWpEpOSzB0HvUmZWfA/mkURuVbLajnutZfDzB+GYRzsjIVKWEt5OGwHFnvhN20lMIdpmUlUysBblVkWwTEEVh6nZ++CgYgVWOgPoyVH+re+TZAxn/Cu3VMrNzHoy9FdutIzPapotZHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k2p0JqK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k2p0JqK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E776C2BCAF;
	Mon, 13 Apr 2026 16:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098491;
	bh=4+FoeYOj8/l3O5BaK+yNbvS1YMp8K5IjO0fLTLSN0Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k2p0JqK9bsFTrJIvtei+PYLGLLuL+vd+EM53IDvK8EgVHWXezyZJwGX2O5VjcFDDW
	 nMSIQo3edHWJ67tGnF/ZmJ2r3NXqnwjBveKrRD9y0P/yt4GRv4xm0wIFghpAaqj0IU
	 QP56YiUQ/gUzbH5TRyHMfmWtB4MR/HRk0HnKNA2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Robert Garcia <rob_garcia@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 513/570] gpiolib: cdev: fix uninitialised kfifo
Date: Mon, 13 Apr 2026 18:00:44 +0200
Message-ID: <20260413155849.666165308@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Kent Gibson <warthog618@gmail.com>

[ Upstream commit ee0166b637a5e376118e9659e5b4148080f1d27e ]

If a line is requested with debounce, and that results in debouncing
in software, and the line is subsequently reconfigured to enable edge
detection then the allocation of the kfifo to contain edge events is
overlooked.  This results in events being written to and read from an
uninitialised kfifo.  Read events are returned to userspace.

Initialise the kfifo in the case where the software debounce is
already active.

Fixes: 65cff7046406 ("gpiolib: cdev: support setting debounce")
Signed-off-by: Kent Gibson <warthog618@gmail.com>
Link: https://lore.kernel.org/r/20240510065342.36191-1-warthog618@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-cdev.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/gpio/gpiolib-cdev.c b/drivers/gpio/gpiolib-cdev.c
index 3cd19ab1fc2a0..d4b221c90bb20 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -896,6 +896,7 @@ static int edge_detector_update(struct line *line,
 				unsigned int line_idx,
 				u64 eflags, bool polarity_change)
 {
+	int ret;
 	unsigned int debounce_period_us =
 		gpio_v2_line_config_debounce_period(lc, line_idx);
 
@@ -907,6 +908,18 @@ static int edge_detector_update(struct line *line,
 	if (debounce_period_us && READ_ONCE(line->sw_debounced)) {
 		WRITE_ONCE(line->eflags, eflags);
 		WRITE_ONCE(line->desc->debounce_period_us, debounce_period_us);
+		/*
+		 * ensure event fifo is initialised if edge detection
+		 * is now enabled.
+		 */
+		eflags = eflags & GPIO_V2_LINE_EDGE_FLAGS;
+		if (eflags && !kfifo_initialized(&line->req->events)) {
+			ret = kfifo_alloc(&line->req->events,
+					  line->req->event_buffer_size,
+					  GFP_KERNEL);
+			if (ret)
+				return ret;
+		}
 		return 0;
 	}
 
-- 
2.53.0



