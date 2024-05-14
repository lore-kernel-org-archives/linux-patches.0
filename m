Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A168A200BF;
	Tue, 14 May 2024 11:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685635; cv=none; b=OSrfmAOp9RNbOuUeoaE7yuGWR2QwDE+bURK5GoxtFVrbhbwbohqggq8H8T3pJUuSv20Dur4znUmVm/U4B5EHWuXyeg/wWYQij0B/+lsRxCH5Akbn73ts0FuQXe6AFOLNV3ish0rW6QIhc1931+DuueIB+vL1Gey5kjCQxQW9+54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685635; c=relaxed/simple;
	bh=qt7IUO2q1JqS5PXhjNHoqAavAyCsj7PF2HFjTBHKMmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlwkAhSCQIKNwP2zzR/+xYBKaX3auFLPFflhYegYsFHcV6abPIxBgp/ubUy1+6cgbbM+DY8BU1jjE7q/BEL5y4LPNZv4/wYzNjUjtdfH6R0i1i+2BwitDV+hTRqZTNDpuYq+k1ioktMrCJi9yI2UoWdxt+FlQ/qRdrS+OR34veA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PPkzoMoD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PPkzoMoD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C296BC4AF09;
	Tue, 14 May 2024 11:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685635;
	bh=qt7IUO2q1JqS5PXhjNHoqAavAyCsj7PF2HFjTBHKMmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PPkzoMoD3TiD3pf93duvtNAz/gMwP7Yz+SWpUg8/3/8lEE3+uUqqs6TmzurVCGgxf
	 BlsRRhBK4U0soYB0soAcMJGaTKBDM2wkunLRn6/BsttbrTgdltl2oblBu/FQlAxEVE
	 yESez2pJfgmkPJ74iTsFjJwKmBy94mbbAdzbcWtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 218/301] gpiolib: cdev: fix uninitialised kfifo
Date: Tue, 14 May 2024 12:18:09 +0200
Message-ID: <20240514101040.489812495@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-cdev.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/gpio/gpiolib-cdev.c b/drivers/gpio/gpiolib-cdev.c
index 7037dc47ca0e0..b4b71e68b90de 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -1243,6 +1243,8 @@ static int edge_detector_update(struct line *line,
 				struct gpio_v2_line_config *lc,
 				unsigned int line_idx, u64 edflags)
 {
+	u64 eflags;
+	int ret;
 	u64 active_edflags = READ_ONCE(line->edflags);
 	unsigned int debounce_period_us =
 			gpio_v2_line_config_debounce_period(lc, line_idx);
@@ -1254,6 +1256,18 @@ static int edge_detector_update(struct line *line,
 	/* sw debounced and still will be...*/
 	if (debounce_period_us && READ_ONCE(line->sw_debounced)) {
 		line_set_debounce_period(line, debounce_period_us);
+		/*
+		 * ensure event fifo is initialised if edge detection
+		 * is now enabled.
+		 */
+		eflags = edflags & GPIO_V2_LINE_EDGE_FLAGS;
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
2.43.0



