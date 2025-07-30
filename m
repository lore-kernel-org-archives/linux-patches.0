Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC29F293C42;
	Wed, 30 Jul 2025 09:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868661; cv=none; b=iqtEn5aGSZip88nTD0w53YdE3vlOH3Ni6RahXSIPLtmVWPiolpxW5NumHx7Rc+r85NiFvx47o0xZPxh6OD5vBcMbYW8W3OBX1TpfRW+uZIy74dIGXY6tgCclwKq4PXkASAS+pBhn8HO6yqfwfd6QqFB1obHFNAj1XNbX1wIktkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868661; c=relaxed/simple;
	bh=JTGXs4U2DQOCuD7DmtvVldJcAw2Mqyvo7t5h3l3p8gY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IL3BPy/YPZzJVzX1oGCHib3fkLYvPRvjNeeIcVbHH+2foPM4EW7GaKe+7eBjx8JJFyVwg/ZPKjSwk2+46dVNQXaF4/DY/+AuEoMWbtbRFK2udhh4YZlXz9AYgimsV3hWzMyE6PVtVwcg1ZYfR8ShW1yT0cpOM2asXjEy95FNMUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i+Ov0EWd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i+Ov0EWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296ABC4CEE7;
	Wed, 30 Jul 2025 09:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868661;
	bh=JTGXs4U2DQOCuD7DmtvVldJcAw2Mqyvo7t5h3l3p8gY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+Ov0EWdZraB+i0rF7x6NcmNdE7jkfDaJ589NM8rHwP95hkFh1ehmNVMXUJ4zInGl
	 kdAsog881M6HU9FjtyWiC68rE/6PNdGTkyGv24ufFFGJeqGuc9io3wOtDEM1XBk6Pq
	 qaPl7U6beJfQkMKFGdwsrzrZEHdpF6PSNXY7l7pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Markus=20Bl=C3=B6chl?= <markus@blochl.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	John Stultz <jstultz@google.com>
Subject: [PATCH 6.12 045/117] timekeeping: Zero initialize system_counterval when querying time from phc drivers
Date: Wed, 30 Jul 2025 11:35:14 +0200
Message-ID: <20250730093235.312193373@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Blöchl <markus@blochl.de>

commit 67c632b4a7fbd6b76a08b86f4950f0f84de93439 upstream.

Most drivers only populate the fields cycles and cs_id of system_counterval
in their get_time_fn() callback for get_device_system_crosststamp(), unless
they explicitly provide nanosecond values.

When the use_nsecs field was added to struct system_counterval, most
drivers did not care.  Clock sources other than CSID_GENERIC could then get
converted in convert_base_to_cs() based on an uninitialized use_nsecs field,
which usually results in -EINVAL during the following range check.

Pass in a fully zero initialized system_counterval_t to cure that.

Fixes: 6b2e29977518 ("timekeeping: Provide infrastructure for converting to/from a base clock")
Signed-off-by: Markus Blöchl <markus@blochl.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <jstultz@google.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20250720-timekeeping_uninit_crossts-v2-1-f513c885b7c2@blochl.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timekeeping.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1218,7 +1218,7 @@ int get_device_system_crosststamp(int (*
 				  struct system_time_snapshot *history_begin,
 				  struct system_device_crosststamp *xtstamp)
 {
-	struct system_counterval_t system_counterval;
+	struct system_counterval_t system_counterval = {};
 	struct timekeeper *tk = &tk_core.timekeeper;
 	u64 cycles, now, interval_start;
 	unsigned int clock_was_set_seq = 0;


