Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8D349363D;
	Mon, 31 Aug 2026 14:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185149; cv=none; b=WJZXyDgLcfk90l2+ZT+2i2GhBtz6YQ404yckCcnD1kQWZ62k7L0Wi7SpMqOM/2JWNaL2hFWehWv96F6KKjtxHjuJxDLbPlgFyp/3uT9UJ9i10Np0+Vr2H4hci8TRZLkXqWZJK6ivkvUWCHJPPr1Lb9GbmGZZmsOVyscIx+IPchw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185149; c=relaxed/simple;
	bh=VjLJdTGGv67VxzJItH3g2UUoBTfEZ0fwXYyGpDAXKgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjXYSI/2FAeX4K0A02PcJz5zOkqvkB/pSXlEEpwygqottX4llugUYln8lqXnHKd1x0k6XuRGrpEbmr7nseR8gOju67NsGqW4Yi1oE2edp7hrDi90kpFnu756BfEXEjuVlTzbwAVEse8G1uOjjooSQb6wxy32gH/nZ6Ghlkv+Vcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jh8T6vV9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jh8T6vV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABCC1F000E9;
	Mon, 31 Aug 2026 14:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185147;
	bh=Q2XCsJW0xVX3fN5HKY56276uNMHQZaKkpgFvA2q1F2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jh8T6vV99/HaC+JXAymxO8t2tmoQ/rrd2MR1LXM1iYLhV/tWMby4Nshor2E9t+z25
	 r3Rm6Xl3j6H6KArLB3WV3EXTNChO3Y4eSpuCXZbYovDRIme/No/dZmqE2PZY5W+jzi
	 Xq2aGOBcg4539zN23jnCc07Yd5ix5QCH8OMhKwhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ibrahim Hashimov <security@auditcode.ai>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 32/69] HID: uclogic: fix use-after-free of inrange_timer on remove
Date: Mon, 31 Aug 2026 15:35:05 +0200
Message-ID: <20260831133400.097841064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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

From: Ibrahim Hashimov <security@auditcode.ai>

[ Upstream commit 506fd50a9027340f0e9dcc587d10ccb03312dba6 ]

uclogic_remove() cancels the pen in-range timer and then stops the
device:

	timer_delete_sync(&drvdata->inrange_timer);
	hid_hw_stop(hdev);

timer_delete_sync() only guarantees the timer is idle at that instant.
uclogic_raw_event_pen() keeps delivering pen reports until hid_hw_stop()
stops the transport several lines later, and every report with
pen->inrange == UCLOGIC_PARAMS_PEN_INRANGE_NONE re-arms the timer:

	mod_timer(&drvdata->inrange_timer, jiffies + msecs_to_jiffies(100));

A report landing between the timer_delete_sync() call and the transport
teardown in hid_hw_stop() re-arms inrange_timer after it was cancelled.
uclogic_remove() then returns and the devm drvdata is freed, while
hid_hw_stop() has already freed the input device drvdata->pen_input
points at, so when the timer fires ~100 ms later
uclogic_inrange_timeout() dereferences freed memory -- a use-after-free
in timer-softirq context.

Swapping the two calls is not a fix: stopping the device first frees
drvdata->pen_input via hidinput_disconnect() while the timer may still
be pending, so a timer already armed before removal fires on the freed
input device in the window before timer_delete_sync() runs.

Use timer_shutdown_sync() before hid_hw_stop() instead. It cancels the
timer, waits for a running callback while pen_input is still valid, and
prevents any further re-arming -- a later mod_timer() from an in-flight
report is silently ignored -- so the timer is provably dead before
hid_hw_stop() frees the inputs. This is the ordering the timer core
documents for this "timer re-armed from another path" teardown case.

Fixes: 01309e29eb95 ("HID: uclogic: Support in-range reporting emulation")
Cc: stable@vger.kernel.org
Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
Assisted-by: AuditCode-AI:2026.07
Signed-off-by: Jiri Kosina <jkosina@suse.com>
[ changed timer_delete_sync() to del_timer_sync() in the removed line to match the pre-rename API on this branch ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-uclogic-core.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-uclogic-core.c
+++ b/drivers/hid/hid-uclogic-core.c
@@ -346,7 +346,17 @@ static void uclogic_remove(struct hid_de
 {
 	struct uclogic_drvdata *drvdata = hid_get_drvdata(hdev);
 
-	del_timer_sync(&drvdata->inrange_timer);
+	/*
+	 * Shut the in-range timer down before stopping the device.
+	 * uclogic_raw_event_pen() re-arms inrange_timer on every pen report
+	 * and keeps running until hid_hw_stop() stops the transport, so a
+	 * plain timer_delete_sync() here can be undone by a report landing in
+	 * the window before hid_hw_stop().  timer_shutdown_sync() cancels the
+	 * timer and makes any later re-arm a no-op, so it is provably dead
+	 * before hid_hw_stop() frees the input device drvdata->pen_input
+	 * points at.
+	 */
+	timer_shutdown_sync(&drvdata->inrange_timer);
 	hid_hw_stop(hdev);
 	kfree(drvdata->desc_ptr);
 	uclogic_params_cleanup(&drvdata->params);


