Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B084480BE3;
	Tue, 14 May 2024 11:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686679; cv=none; b=a+WSDVV0zwShDXnj3xNcCaZcaG9ZX7ih2BnBdJi4sDat9lGYENoJvEfc0UZokNL3YTl45TOv+NekLtNOEr43jUt15HiMhl3hTfzHXlkV2EYkEEZEt95jZlvj1aZ788z/gt0IQd1Zd3eP88sHGnJCkEuOKr3AE12tFiHwd5KqLkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686679; c=relaxed/simple;
	bh=en9k31UJnObgTV/fQ9lxAv21F21XL8taC/jM9ZBdupk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NfCsmdkDUL7zEF3AR3u6Mm7tNbeRhv1QpbQhSZjiDUCCuvSgn5SFGjQknrb92oa2DmEa7mZGYsJutHQVq+LLEetroZZoEZhGyIJCs5XwZKteWBSZ/8NO3hC+3YA/RlL/rjTFWvQ3Fyc2X+xP0JyMqiA14Q3l+VeBWAhLRfmpaPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vbqVI5TF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vbqVI5TF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394C7C2BD10;
	Tue, 14 May 2024 11:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686679;
	bh=en9k31UJnObgTV/fQ9lxAv21F21XL8taC/jM9ZBdupk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vbqVI5TF7u8wJ0wLU+mRuaoWZKQatfjF+/rX2yVzqFozyt/KAAUkuaeBdKRdZ5meu
	 PYYMGxSIlA7gfCkmKC5ACyxuA3T/QV98euD44NHaRc9LYSlB1YMjG8jbqqoeRRRH+p
	 APyZPYR17DwjA9ik+t6b91G7ZZM9h18XQtLFtX4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 180/236] gpiolib: cdev: fix uninitialised kfifo
Date: Tue, 14 May 2024 12:19:02 +0200
Message-ID: <20240514101027.193651593@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6ee1074d49152..97e8335716b01 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -1201,6 +1201,8 @@ static int edge_detector_update(struct line *line,
 				struct gpio_v2_line_config *lc,
 				unsigned int line_idx, u64 edflags)
 {
+	u64 eflags;
+	int ret;
 	u64 active_edflags = READ_ONCE(line->edflags);
 	unsigned int debounce_period_us =
 			gpio_v2_line_config_debounce_period(lc, line_idx);
@@ -1212,6 +1214,18 @@ static int edge_detector_update(struct line *line,
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



