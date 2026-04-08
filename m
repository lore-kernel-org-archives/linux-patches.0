Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1659F351C2E;
	Wed,  8 Apr 2026 18:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673341; cv=none; b=oLOY5CKT1VT3K+PcLcmTAJjdp3jjcvwQJEtOy5zjA+5jG0dMbkbxX46TDpOUyFz3s16doRwDuDvJuj/kCfgFUiW0qOcBed6x4GICw1xXM3mQmBHbxSrHNPWHE9snsx0UEn4nVKvBGSzH80u7pgErgeXokPsOHQ/sf+WR2gPMBy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673341; c=relaxed/simple;
	bh=3KeQslo5dO3LKs9E4dqEr5yIl8C4GcJebpwDQTbOUZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IUIy3BnKXlxUXqP5k5fSX9Q7gMwDOlEVsVb0GIXjmJgkaDwjdK+F2K4t9niWxQ3LeI7YUktVtL9SFR76wMhMFwnScxEFr++1Hr0jWRy8CZAFiqYcrQD+e66RWwZzmlZ33cAwqfJfcc9fN6veBVLyRpq5ru1CYhKbxVpemJzfJmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2MkiEfJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2MkiEfJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1263C19421;
	Wed,  8 Apr 2026 18:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673341;
	bh=3KeQslo5dO3LKs9E4dqEr5yIl8C4GcJebpwDQTbOUZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2MkiEfJkieLZOWV/46G6ToC3qiS80zJyJsvCyvOJKbvsO1wxdBYTeSiJhxTZKPGOC
	 NjABcQNDqA78qUHRPJtrs0T5RE+Jo9xWbRiMK3nvISkTZvtYhU28X4g1F5yLBeF/zV
	 up1xyIEZbkyxGHVjApNuhdDt173iTz5qHykG4ckk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Todd Brandt <todd.e.brandt@linux.intel.com>,
	stable <stable@kernel.org>,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 6.18 195/277] mei: me: reduce the scope on unexpected reset
Date: Wed,  8 Apr 2026 20:03:00 +0200
Message-ID: <20260408175941.145534240@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 8c27b1bce059a11a8d3c8682984e13866f0714af upstream.

After commit 2cedb296988c ("mei: me: trigger link reset if hw ready is unexpected")
some devices started to show long resume times (5-7 seconds).
This happens as mei falsely detects unready hardware,
starts parallel link reset flow and triggers link reset timeouts
in the resume callback.

Address it by performing detection of unready hardware only
when driver is in the MEI_DEV_ENABLED state instead of blacklisting
states as done in the original patch.
This eliminates active waitqueue check as in MEI_DEV_ENABLED state
there will be no active waitqueue.

Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Reported-by: Todd Brandt <todd.e.brandt@linux.intel.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221023
Tested-by: Todd Brandt <todd.e.brandt@linux.intel.com>
Fixes: 2cedb296988c ("mei: me: trigger link reset if hw ready is unexpected")
Cc: stable <stable@kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://patch.msgid.link/20260330083830.536056-1-alexander.usyskin@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -1337,19 +1337,13 @@ irqreturn_t mei_me_irq_thread_handler(in
 	/*  check if we need to start the dev */
 	if (!mei_host_is_ready(dev)) {
 		if (mei_hw_is_ready(dev)) {
-			/* synchronized by dev mutex */
-			if (waitqueue_active(&dev->wait_hw_ready)) {
-				dev_dbg(&dev->dev, "we need to start the dev.\n");
-				dev->recvd_hw_ready = true;
-				wake_up(&dev->wait_hw_ready);
-			} else if (dev->dev_state != MEI_DEV_UNINITIALIZED &&
-				   dev->dev_state != MEI_DEV_POWERING_DOWN &&
-				   dev->dev_state != MEI_DEV_POWER_DOWN) {
+			if (dev->dev_state == MEI_DEV_ENABLED) {
 				dev_dbg(&dev->dev, "Force link reset.\n");
 				schedule_work(&dev->reset_work);
 			} else {
-				dev_dbg(&dev->dev, "Ignore this interrupt in state = %d\n",
-					dev->dev_state);
+				dev_dbg(&dev->dev, "we need to start the dev.\n");
+				dev->recvd_hw_ready = true;
+				wake_up(&dev->wait_hw_ready);
 			}
 		} else {
 			dev_dbg(&dev->dev, "Spurious Interrupt\n");


