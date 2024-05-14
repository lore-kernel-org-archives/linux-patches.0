Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26AF6E611;
	Tue, 14 May 2024 10:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683592; cv=none; b=OofZfusDtXCHHnMfZUyhEUL28rUgzbdlOIt4EVUcFz0s6OiyEx5TK8wgib1O+Ijc1XffIVRkJ6dpfL7u5ktgFhQREsOyVrYRIUq9jYSDZ61gARc5A5o+1yitbNVg3kLfjpa7jJZJ6xw7Y4tTLzvyK1veeg8h5MthcnzNo5yRcLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683592; c=relaxed/simple;
	bh=jvPG3mk2+7eU/OryOq6gx6Wha8r3q/V+P49KcWGJmsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJTKEsFmGUi02sNhYr6fZFn0TMQNM5IOuFS7F8aq6WrSmeJiYyeY2182CXMiMnxTkMwecTkBgqjXi4AfMpVmLNIT4PFXJWoshvkCoKiJ4uT8EJ6QqUiXGYT0s6/jpoZq5D9bgNt1vDH3HYTSv8cqlfeHP56SR47BDsHIZrpeFhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKK17hEt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKK17hEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8FEC32781;
	Tue, 14 May 2024 10:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683591;
	bh=jvPG3mk2+7eU/OryOq6gx6Wha8r3q/V+P49KcWGJmsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKK17hEtWsjbAIbCrOPZdz2l5IoWniZG1j65GUFYgylFAwfFMEIwiNYfHaTOmQnTX
	 gd3QLAgpQLQDZllBT1s1fwsqmpIwQbAkCh1LKr5a72HyKYf58YCisv4DYbMbw5agLq
	 IAczcReFNQKHuyLrmeYSch62XAyadOvlxx4icKcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 239/336] gpiolib: cdev: fix uninitialised kfifo
Date: Tue, 14 May 2024 12:17:23 +0200
Message-ID: <20240514101047.637097342@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 0b94c398c0649..5cca9e8803495 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -1199,6 +1199,8 @@ static int edge_detector_update(struct line *line,
 				struct gpio_v2_line_config *lc,
 				unsigned int line_idx, u64 edflags)
 {
+	u64 eflags;
+	int ret;
 	u64 active_edflags = READ_ONCE(line->edflags);
 	unsigned int debounce_period_us =
 			gpio_v2_line_config_debounce_period(lc, line_idx);
@@ -1210,6 +1212,18 @@ static int edge_detector_update(struct line *line,
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



