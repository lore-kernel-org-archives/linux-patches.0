Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BD428980F;
	Wed,  8 Apr 2026 18:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674793; cv=none; b=YQIT9o/6xSdJqcDUR93X9YfOYVeoHZ1vo4XNDePlLD77wQphNv60VYznRCpm2SELiAxvgAIU1QHZK8XNYZ5YYE4n+CQRB+dOrPqUIl1BpY6A+yKBCxlvh4jGoM5cHfoMEBfKLJu5+FgpGvwcPVWL+L36P6Z+nEbCcLuXL1f6Xdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674793; c=relaxed/simple;
	bh=VFr1f+ghxRWxylhQ0GHgrPsyuIFedEbTZ0heJH6rRoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfp1eSKjAyTRWyKTErWQ9CzvxWnVuLN3/AHd4iT/4kuaznzU6EDtY6iPh4ohmCxQwsv3C8H6rxwDJuS5gqrxwjbIe5DCpTwYqw6XVv9I+kGzMNYELHtYpdzem9BhR+JMIPdtYuYS3WWihtEqtp++U/8LieCYsD91eFqTgQdNqqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mc/eWj6D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mc/eWj6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF09CC19421;
	Wed,  8 Apr 2026 18:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674793;
	bh=VFr1f+ghxRWxylhQ0GHgrPsyuIFedEbTZ0heJH6rRoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mc/eWj6Dc0UoFJYClRM7SPUWI5xy3k/u763gz9jayzjlJYu3jtAh31635vZ9LToB3
	 sODRiT4kka9A3eapqQvu0yr0HA8mMfOtwnqf3cQuwbplCGsjgUn16oMAydxFrCvXxQ
	 xhfatoLuBw4oRdR18EFHWAR9Qzi28luIGKnVh04Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Todd Brandt <todd.e.brandt@linux.intel.com>,
	stable <stable@kernel.org>,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 6.19 235/311] mei: me: reduce the scope on unexpected reset
Date: Wed,  8 Apr 2026 20:03:55 +0200
Message-ID: <20260408175948.170009340@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


