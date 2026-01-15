Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89103A0E9A;
	Thu, 15 Jan 2026 17:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497936; cv=none; b=pIwqKVJqbcjSjayXSaX/jOyVHySdV+3aZEHIXG0eVP5ZUfbvFs7Fgf00QG4peh0FPmqCDvyKPX4yRNDtFxqA22EihQCxsg6ADBKKg1w/gEZ026EZcsJcMawnwyRrgknL5Lf2/BaXiSfFYFY9DfJn6Xh8itzsZQalEzzTBS/l+Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497936; c=relaxed/simple;
	bh=2wMi27ImmayVSaTbtrpotrjBBUswQJD3bv4ehfLHZ+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfPyuThlYelwTqNehrHf5hAAuvb804FgO/Fdtb3/KTpskVl59REIdQP67xVw1b5eXX+KJAeVIKXHDvAa/HmO+GXOZZGeoT0JcWWWM+4YgAiTguc6Rw5icX3AZUBVZyo7ayQax/wC2dq2FnwxW8Kh1h1N4l6QWtSF0QqM7w26SQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+YQ9bQ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+YQ9bQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DC8C116D0;
	Thu, 15 Jan 2026 17:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497935;
	bh=2wMi27ImmayVSaTbtrpotrjBBUswQJD3bv4ehfLHZ+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+YQ9bQ+XlBDvE1d6i4kinFyxFkxeqDspOIuLuvyV69pThp5c6CsQ+zNi/zP3iCyp
	 Y16ufuO6phKxveweQTfnXPzu3vOYR7EkhwqGaDjMqTzLBkKJScd4Y7Wteuw7zGoJp6
	 81ZUEisE4R9PZ51PK0BTPpLifJqGi9ca7iLUE824=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinhui Guo <guojinhui.liam@bytedance.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 256/554] ipmi: Fix the race between __scan_channels() and deliver_response()
Date: Thu, 15 Jan 2026 17:45:22 +0100
Message-ID: <20260115164255.501457202@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Jinhui Guo <guojinhui.liam@bytedance.com>

[ Upstream commit 936750fdba4c45e13bbd17f261bb140dd55f5e93 ]

The race window between __scan_channels() and deliver_response() causes
the parameters of some channels to be set to 0.

1.[CPUA] __scan_channels() issues an IPMI request and waits with
         wait_event() until all channels have been scanned.
         wait_event() internally calls might_sleep(), which might
         yield the CPU. (Moreover, an interrupt can preempt
         wait_event() and force the task to yield the CPU.)
2.[CPUB] deliver_response() is invoked when the CPU receives the
         IPMI response. After processing a IPMI response,
         deliver_response() directly assigns intf->wchannels to
         intf->channel_list and sets intf->channels_ready to true.
         However, not all channels are actually ready for use.
3.[CPUA] Since intf->channels_ready is already true, wait_event()
         never enters __wait_event(). __scan_channels() immediately
         clears intf->null_user_handler and exits.
4.[CPUB] Once intf->null_user_handler is set to NULL, deliver_response()
         ignores further IPMI responses, leaving the remaining
	 channels zero-initialized and unusable.

CPUA                             CPUB
-------------------------------  -----------------------------
__scan_channels()
 intf->null_user_handler
       = channel_handler;
 send_channel_info_cmd(intf,
       0);
 wait_event(intf->waitq,
       intf->channels_ready);
  do {
   might_sleep();
                                 deliver_response()
                                  channel_handler()
                                   intf->channel_list =
				         intf->wchannels + set;
                                   intf->channels_ready = true;
                                   send_channel_info_cmd(intf,
                                         intf->curr_channel);
   if (condition)
    break;
   __wait_event(wq_head,
          condition);
  } while(0)
 intf->null_user_handler
       = NULL;
                                 deliver_response()
                                  if (!msg->user)
                                   if (intf->null_user_handler)
                                    rv = -EINVAL;
                                  return rv;
-------------------------------  -----------------------------

Fix the race between __scan_channels() and deliver_response() by
deferring both the assignment intf->channel_list = intf->wchannels
and the flag intf->channels_ready = true until all channels have
been successfully scanned or until the IPMI request has failed.

Signed-off-by: Jinhui Guo <guojinhui.liam@bytedance.com>
Message-ID: <20250930074239.2353-2-guojinhui.liam@bytedance.com>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_msghandler.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index af563ee827aa..98ccba19292a 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -3292,8 +3292,6 @@ channel_handler(struct ipmi_smi *intf, struct ipmi_recv_msg *msg)
 			intf->channels_ready = true;
 			wake_up(&intf->waitq);
 		} else {
-			intf->channel_list = intf->wchannels + set;
-			intf->channels_ready = true;
 			rv = send_channel_info_cmd(intf, intf->curr_channel);
 		}
 
-- 
2.51.0



