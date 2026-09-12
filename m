Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C63D2F7F17;
	Sat, 12 Sep 2026 19:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241663; cv=none; b=KYBuD05AUKiM8VmmUG1CvYfz/YCzW0uQ5XedEmN68ymDU/n9gl/IguuauzeDlWAuSxY0upMw4gbffg1WYkK9wMf4O0QySuVDyy9qBfdxWU5IkW8sds2ZSkzTPJR2lmvC5y+uWfGIChJsWwsXZ45VxFM2mCW4F0DVLj/b7wdn4qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241663; c=relaxed/simple;
	bh=XKpAlbBOYTFxqy6CfQ1uawQMyOgxBBUgbq+RzFtAMOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1MOPW1KBx4O0pHvu1snO4aRxPhZl6v5Rl9/y8C5cv6C7Rk5gYLIr0iHrdW6aCUKkGXz91eFrl3Gp7K7ycq4xXa1Igwjb153Ael0fXn9tr+krPVQo+FrNtd58KR0uETg4l3PuneYuydwT9UlqTNbGIVFBzGR5Jto8bJsJiFTgII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKMPC3vy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKMPC3vy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582AB1F000FF;
	Sat, 12 Sep 2026 19:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241662;
	bh=0cd0ZSlUMlCfJvSCRXn/PeqzMTw4iIEK0AJ7gqrOH+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LKMPC3vyHOQ54D7VakVUrxNJf9pXR0KkMj8ZLBv3w5dcIRh2rYYoEPhhhAAdIDiTE
	 xgOxMPf5FOEbpJjAp2h5mRAx4a59pNAkUy/KVUXoRxWDntNcPO01YKgQnVlpF8eyDB
	 WCV8NZefHZ0JKL4e8/IFrCHHJiz8faVLAmiOB5kQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@nabladev.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 181/798] wifi: mwifiex: Detach sync cmd buffer on interrupted wait
Date: Sat, 12 Sep 2026 08:56:49 +0200
Message-ID: <20260912065521.180111639@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@nabladev.com>

commit ef06882c7d8a7400b67d0d003b1008093dd589ed upstream.

mwifiex synchronous commands keep the caller-provided data buffer in
cmd_node->data_buf. Several callers pass stack-allocated objects there.

If wait_event_interruptible_timeout() is interrupted, the caller can
return and release that stack object while the firmware command is still
the current command. A late firmware response then reaches the normal
response handler, which can copy data through cmd_node->data_buf into the
stale stack address.

This fixes a stack corruption observed during repeated association and
disassociation cycles. The panic trace showed the command wait being
interrupted immediately before a bad pointer dereference:

  cmd_wait_q terminated: -512
  Unable to handle kernel paging request at virtual address 002c583837384662
  Kernel panic - not syncing: stack-protector: Kernel stack is corrupted
  ...
  Tainted: [M]=MACHINE_CHECK

The fault address decodes as little-endian ASCII:

  0x002c583837384662 -> "bF878X,\0"

which is a fragment of the VERSION_EXT firmware string exposed as
debugfs "verext":

  w8997o-V4, RF878X, FP92, 16.92.21.p153.7

The same runs also showed corrupted control data containing:

  0x2400372e333531 -> "153.7\0$"

which is the tail of the same VERSION_EXT string. This points at a late
VERSION_EXT response writing through a stale stack-backed data_buf after
the interrupted wait returned.

After cancelling pending commands on an interrupted or timed-out wait,
detach the caller-owned data buffer from the still-current command. This
preserves the existing command cancellation behaviour while preventing a
late response from writing through a pointer whose lifetime ended with the
waiting caller.

Tested on an i.MX8MP board using an 88W8997.

Cc: stable@vger.kernel.org
Fixes: 3d026d09b28d ("mwifiex: cancel pending commands for signal")
Signed-off-by: Fabio Estevam <festevam@nabladev.com>
Link: https://patch.msgid.link/20260724203320.78793-1-festevam@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -69,6 +69,18 @@ int mwifiex_wait_queue_complete(struct m
 		mwifiex_dbg(adapter, ERROR, "cmd_wait_q terminated: %d\n",
 			    status);
 		mwifiex_cancel_all_pending_cmd(adapter);
+
+		/* The command response path writes through cmd_node->data_buf.
+		 * On an interrupted wait, the caller can return and release a
+		 * stack-allocated data_buf before a late firmware response is
+		 * processed. Detach the caller-owned buffer from the current
+		 * command so a late response cannot corrupt freed stack memory.
+		 */
+		spin_lock_bh(&adapter->mwifiex_cmd_lock);
+		if (adapter->curr_cmd == cmd_queued)
+			adapter->curr_cmd->data_buf = NULL;
+		spin_unlock_bh(&adapter->mwifiex_cmd_lock);
+
 		return status;
 	}
 


