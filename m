Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8654F386454;
	Tue, 10 Mar 2026 11:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141173; cv=none; b=BzwyLHXiGphRwFBBkRr/mq+VNpoMAgkm6DelrRuv8EE/yfautQQI/i1TWSLgdiRQexN5rH6aX0C9Bke8uLNxt9D8zonWubWz998DSlGq797kH1pnKLzW9u7igpcB9wLcCplCsbKZVpzqT2ElvnxooddvviFOn7smHVFk4WHF1yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141173; c=relaxed/simple;
	bh=LHvUSIqIBXo444mrdQoAdP3dAvh15W6Gef/dvrjILLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NAEtOJIwPGEIFU3EEJEthKcIxl4rcTVnwAYKgKLJXSETzu4e/NTM4CvL2mM16Z2L0LT1MCTy33K9u41K0oi3QdVB5sPI7MToN/Jku2OhI+8+eOuUUAMhR6OGIg9TBoI9/D+Y8MrZ10/oiQcVc5vYcyXjZnU1D2YYjigxTxnAzLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nhtoLZFL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nhtoLZFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2204C2BC86;
	Tue, 10 Mar 2026 11:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141173;
	bh=LHvUSIqIBXo444mrdQoAdP3dAvh15W6Gef/dvrjILLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhtoLZFLycSdiPOLWXq4Rp9hx7M0DAFaHbiwBRnxHFVCgTTAnbz/ghUPkwcEBtcgn
	 7FG4pL3uXQEA2Nh0h+H9ADg3AZTiQXD6Tejf4wR/BtF3f5F5acWTNiOv19kVYawTVx
	 pOLDt6VzL0Pu/+1gFqt4hvgy3M/z1QxGCrzpHuoFAez75RL+GHV8Z+waRqxLpvdjZM
	 ZzA3P1c75CORoZmIeqpaWH4/EhgAZWmgk89GlvmrI/cXDPeHQl0lZdxiJhTJ7h7QPU
	 jZLhRdOVuTrTqkaxeh7kKo14LgqGKJrwvmQvGMfWbZosjLLiMkeg2/vY6Oe9ILnSj3
	 sKvJBLSbmw+hw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Corey Minyard <corey@minyard.net>,
	Breno Leitao <leitao@debian.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 174/311] ipmi: Fix use-after-free and list corruption on sender error
Date: Tue, 10 Mar 2026 07:03:41 -0400
Message-ID: <ab11913612fcb09a1bf52e26d0f0b90d7fa37f22.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Corey Minyard <corey@minyard.net>

commit 594c11d0e1d445f580898a2b8c850f2e3f099368 upstream.

The analysis from Breno:

When the SMI sender returns an error, smi_work() delivers an error
response but then jumps back to restart without cleaning up properly:

1. intf->curr_msg is not cleared, so no new message is pulled
2. newmsg still points to the message, causing sender() to be called
   again with the same message
3. If sender() fails again, deliver_err_response() is called with
   the same recv_msg that was already queued for delivery

This causes list_add corruption ("list_add double add") because the
recv_msg is added to the user_msgs list twice. Subsequently, the
corrupted list leads to use-after-free when the memory is freed and
reused, and eventually a NULL pointer dereference when accessing
recv_msg->done.

The buggy sequence:

  sender() fails
    -> deliver_err_response(recv_msg)  // recv_msg queued for delivery
    -> goto restart                    // curr_msg not cleared!
  sender() fails again (same message!)
    -> deliver_err_response(recv_msg)  // tries to queue same recv_msg
    -> LIST CORRUPTION

Fix this by freeing the message and setting it to NULL on a send error.
Also, always free the newmsg on a send error, otherwise it will leak.

Reported-by: Breno Leitao <leitao@debian.org>
Closes: https://lore.kernel.org/lkml/20260127-ipmi-v1-0-ba5cc90f516f@debian.org/
Fixes: 9cf93a8fa9513 ("ipmi: Allow an SMI sender to return an error")
Cc: stable@vger.kernel.org # 4.18
Reviewed-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_msghandler.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 3f48fc6ab596d..a590a67294e24 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -4852,8 +4852,15 @@ static void smi_work(struct work_struct *t)
 			if (newmsg->recv_msg)
 				deliver_err_response(intf,
 						     newmsg->recv_msg, cc);
-			else
-				ipmi_free_smi_msg(newmsg);
+			if (!run_to_completion)
+				spin_lock_irqsave(&intf->xmit_msgs_lock,
+						  flags);
+			intf->curr_msg = NULL;
+			if (!run_to_completion)
+				spin_unlock_irqrestore(&intf->xmit_msgs_lock,
+						       flags);
+			ipmi_free_smi_msg(newmsg);
+			newmsg = NULL;
 			goto restart;
 		}
 	}
-- 
2.51.0

