Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D2272618;
	Wed, 10 Dec 2025 03:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765338603; cv=none; b=p/PaTzNJTEESkxwnAK67pQVDbMEQ/7UGpGKFSpnWRadlc6jJDDVynyfB22FtAiZc3+dstgusYli1fRBLhAaqPjCYY7F6BOkiF5LEfUauxCv8lMIvaR7rt5iX0DE7c0MCNFsI0JUo/gHau9CeKcPf+iDigh0Z3K486iKu6Ib0nvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765338603; c=relaxed/simple;
	bh=OHfnrpfgygon8ZVld9NZYNgWEsAt15xFUVwowXAjx0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g1X02HvxMdQOVtZBku1jHje24uuEvHF3dDPfK6PurVY1VxpGAUKISpGVTapj9SqhS2TtM6ml8LHfzGdwpJXF9ZgimTKlptM3vK8QAopwVONPSLv7EVY8MUPzImVjV3vE+RZI0PsXn93avf91+KbzbtQ+qGLgpuce2kd8G/bkjf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q2trdG7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q2trdG7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930B7C4CEF1;
	Wed, 10 Dec 2025 03:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765338602;
	bh=OHfnrpfgygon8ZVld9NZYNgWEsAt15xFUVwowXAjx0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q2trdG7GOCV+xQ0BMuf+avVIvytjb5QdtEeLOFpwczGlCRD+p0frIbs9veQwHnYN2
	 GrErt4I2oF8eYce1BRlNWnfvSlGq7HeN7Paik/uJGza1OyG9Df7LEoaQIKLifIaLZ3
	 rethaVcxpBF7nQYz2zOt9XhkTBODuaFeEl1pfJ+H6yJVanU3fLw+mobz+CxwOIm8c8
	 NnOgQrpAK+xv/DRp6xYLmWYgiQj8r11Gxp3iOW9XffZU1bFgXYS9mlCJyJsGPoMJk0
	 ApV6nNVVwtH77Ty5zsS9CJjG5RPoXF7Vk3sv7uooZlwJqM9aGhko+zJvqpfNplIMQG
	 lSVrS3mtoGavg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jinhui Guo <guojinhui.liam@bytedance.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>,
	openipmi-developer@lists.sourceforge.net
Subject: [PATCH AUTOSEL 6.18-5.10] ipmi: Fix the race between __scan_channels() and deliver_response()
Date: Tue,  9 Dec 2025 22:49:01 -0500
Message-ID: <20251210034915.2268617-20-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251210034915.2268617-1-sashal@kernel.org>
References: <20251210034915.2268617-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

## Summary Analysis

### 1. BUG MECHANISM

This commit fixes a **race condition** between two IPMI functions:

- `__scan_channels()`: Initiates channel scanning, sets
  `null_user_handler = channel_handler`, then waits for `channels_ready`
- `channel_handler()` (called via `deliver_response()`): Processes IPMI
  responses for each channel

**The Bug** (introduced in commit 31b0b0730ad2a from September 2017):

In `channel_handler()`, after processing channel N's response (where N <
IPMI_MAX_CHANNELS-1):
1. Lines 3420-3421 set `channels_ready = true` **prematurely**
2. Then sends request for channel N+1
3. `__scan_channels()` may see `channels_ready == true` and exit the
   wait loop early
4. `__scan_channels()` sets `null_user_handler = NULL`
5. Responses for channels N+1, N+2, etc. arrive but are **discarded**
   because `null_user_handler` is NULL
6. Remaining channels are **zero-initialized and unusable**

### 2. THE FIX

The fix simply **removes 2 lines** that prematurely set `channels_ready
= true` in the `else` branch. After the fix, `channels_ready = true` is
only set when:
- All channels have been scanned (`curr_channel >= IPMI_MAX_CHANNELS`),
  OR
- An error occurs (`rv != 0`)

### 3. CLASSIFICATION

| Criteria | Assessment |
|----------|------------|
| Bug type | Race condition causing data corruption (zero-init channels)
|
| Impact | IPMI channels become unusable on affected systems |
| Size | 2 lines removed - minimal and surgical |
| Risk | Very LOW - only removes premature assignments |
| Subsystem | IPMI - used for server management |

### 4. STABLE BACKPORT CRITERIA

| Criterion | Status |
|-----------|--------|
| Obviously correct | ✅ Yes - simply delays setting flag until the right
time |
| Fixes real bug | ✅ Yes - race causes channels to be zero-initialized |
| User impacting | ✅ Yes - affects IPMI hardware management |
| Small and contained | ✅ Yes - 2 lines in single file |
| No new features | ✅ Correct - pure bug fix |
| No API changes | ✅ Correct - internal change only |

### 5. SIGNALS

**Positive signals:**
- Fixes a real race condition with clear cause and effect
- Minimal, surgical fix (2 lines removed)
- Bug has existed since 2017 (31b0b0730ad2a) - affects all current LTS
  kernels
- IPMI maintainer (Corey Minyard) signed off
- Detailed commit message explains the race with CPU timing diagram

**Missing signals:**
- No explicit `Cc: stable@vger.kernel.org` tag
- No explicit `Fixes: 31b0b0730ad2a` tag (though it should have one)
- No Tested-by/Reviewed-by tags

### 6. RISK vs BENEFIT

- **Benefit**: Fixes a race condition that makes IPMI channels unusable
  on servers
- **Risk**: Extremely low - the fix only removes code that ran at the
  wrong time; the correct code paths for setting `channels_ready` are
  untouched
- **Affected users**: Server/data center users relying on IPMI for
  hardware management

### 7. DEPENDENCIES

The fix is standalone and doesn't depend on other commits. The affected
code has existed unchanged since 2017, so it should apply cleanly to all
active stable kernels.

### CONCLUSION

This is a clear backport candidate. The commit fixes a real race
condition that causes IPMI channels to become unusable. The fix is
minimal (2 lines removed), obviously correct (simply delays a flag until
the right time), and carries virtually no regression risk. IPMI is
critical infrastructure for server management, making this fix important
for stable users.

**YES**

 drivers/char/ipmi/ipmi_msghandler.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 3700ab4eba3e7..d3f84deee4513 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -3417,8 +3417,6 @@ channel_handler(struct ipmi_smi *intf, struct ipmi_recv_msg *msg)
 			intf->channels_ready = true;
 			wake_up(&intf->waitq);
 		} else {
-			intf->channel_list = intf->wchannels + set;
-			intf->channels_ready = true;
 			rv = send_channel_info_cmd(intf, intf->curr_channel);
 		}
 
-- 
2.51.0

