Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2507834D3B9;
	Tue,  6 Jan 2026 17:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720047; cv=none; b=s46N2NcIgh9RIP/NCOQYrtfG0HQ09gbDd6/VyW4MYpaIRCaGTd0Mt+y5sd76la1NQecj7zLnfa1i+eiI8PP1zHOOGBYqAemSXJs2T42s2TnZC/rmdALHtR/t3Nff5EB5YEKD69LCkN1oJeD/IbN98bU+MVQ3OaTt2Z5U35ARjcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720047; c=relaxed/simple;
	bh=z1PS1wS8GTkgGDyhpZtoHmygKqiD0TxuyBkwoK2DwNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Isdfpkv7h4ZenzHQNlzmzvwk+472f9QFNkMj4nJXoXW61lsA4SMkvnYFDXt59SMFuOkbHCW6UTxwfdArO56KOTaHsjsiF7XjQQ8cBonslC4cDyOMQOhdlcTMGoZxU871AdGFuxYeq/5oi2yaOCKI/sy7pF8HQd8JhQjMfO4ia8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G90tqYyU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G90tqYyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2424C116C6;
	Tue,  6 Jan 2026 17:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720047;
	bh=z1PS1wS8GTkgGDyhpZtoHmygKqiD0TxuyBkwoK2DwNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G90tqYyUXoweDH3eJCNo26+fNFXit1KzHMNZgZxcACPVPGrGQwJEhLZx65PL3OUff
	 NDU/HjWq9+5+iXH7la4yodIITZLFS+epbe047rOLzbXiFJb7uW/cZ5eJqTwcPUtFXk
	 nNHSX5V7V415McN+qJ41piBRkDqhTC2CvyE+6Pkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinhui Guo <guojinhui.liam@bytedance.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 119/567] ipmi: Fix the race between __scan_channels() and deliver_response()
Date: Tue,  6 Jan 2026 17:58:21 +0100
Message-ID: <20260106170455.731795405@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 99fe01321971..29106325aba7 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -3414,8 +3414,6 @@ channel_handler(struct ipmi_smi *intf, struct ipmi_recv_msg *msg)
 			intf->channels_ready = true;
 			wake_up(&intf->waitq);
 		} else {
-			intf->channel_list = intf->wchannels + set;
-			intf->channels_ready = true;
 			rv = send_channel_info_cmd(intf, intf->curr_channel);
 		}
 
-- 
2.51.0



