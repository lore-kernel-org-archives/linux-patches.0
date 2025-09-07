Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AB41B424F;
	Sun,  7 Sep 2025 20:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276503; cv=none; b=rjlPdYB3hPX3GcD9zumX699db6zPNz2H0VYTDQrQl5WqJ1ABf11KS5gV/in/c3zgIClIaSxVzz4P3w7dKNY3U8etLvm8jgfXj3o31Gm4lBMBnw0Pcmjl/EdIcsZdRsXueUyX5T92bxk4aQizTT4t5H4Wm4oD/w/s2fzG+pT1L5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276503; c=relaxed/simple;
	bh=Y40r+SWOfe32VC5fudmzH6lmvNkcat6iHvMECARg3FE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R0w+o52+ZRkz6aPK2u0QDFucNoFRlbCS/fS3j7YKhC7xTfhydFRQuxof2cPSBVCvJjmujdhsQlTEdxcKnFD8WyVOG8SD/Mx0bakXL6vgDYlcQZfgUCdPhQ1kRdIvEB6l17Gn1XcLwvNDwv7piwYro9oWC397DDqBJJz+UwMs2hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JsSEHtND; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JsSEHtND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D4CC4CEF0;
	Sun,  7 Sep 2025 20:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276503;
	bh=Y40r+SWOfe32VC5fudmzH6lmvNkcat6iHvMECARg3FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JsSEHtND6cTo4gftyAeJ9k/wv61vzXZUEKlBpa+7t+yyJUzLhH4YPnwnPUd2HVOiO
	 HEvElheuh/Zc4C2RYxUlrMrBGP/inl+pSQQB6K4xE3oKtpnDLXtDb8tfGbYsDhASxO
	 HkJ+6vlaUCzKPWjZ4hRcsayBVHRWILubQlLkCLdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Duoming Zhou <duoming@zju.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/121] wifi: brcmfmac: fix use-after-free when rescheduling brcmf_btcoex_info work
Date: Sun,  7 Sep 2025 21:57:36 +0200
Message-ID: <20250907195610.334436176@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 9cb83d4be0b9b697eae93d321e0da999f9cdfcfc ]

The brcmf_btcoex_detach() only shuts down the btcoex timer, if the
flag timer_on is false. However, the brcmf_btcoex_timerfunc(), which
runs as timer handler, sets timer_on to false. This creates critical
race conditions:

1.If brcmf_btcoex_detach() is called while brcmf_btcoex_timerfunc()
is executing, it may observe timer_on as false and skip the call to
timer_shutdown_sync().

2.The brcmf_btcoex_timerfunc() may then reschedule the brcmf_btcoex_info
worker after the cancel_work_sync() has been executed, resulting in
use-after-free bugs.

The use-after-free bugs occur in two distinct scenarios, depending on
the timing of when the brcmf_btcoex_info struct is freed relative to
the execution of its worker thread.

Scenario 1: Freed before the worker is scheduled

The brcmf_btcoex_info is deallocated before the worker is scheduled.
A race condition can occur when schedule_work(&bt_local->work) is
called after the target memory has been freed. The sequence of events
is detailed below:

CPU0                           | CPU1
brcmf_btcoex_detach            | brcmf_btcoex_timerfunc
                               |   bt_local->timer_on = false;
  if (cfg->btcoex->timer_on)   |
    ...                        |
  cancel_work_sync();          |
  ...                          |
  kfree(cfg->btcoex); // FREE  |
                               |   schedule_work(&bt_local->work); // USE

Scenario 2: Freed after the worker is scheduled

The brcmf_btcoex_info is freed after the worker has been scheduled
but before or during its execution. In this case, statements within
the brcmf_btcoex_handler() — such as the container_of macro and
subsequent dereferences of the brcmf_btcoex_info object will cause
a use-after-free access. The following timeline illustrates this
scenario:

CPU0                            | CPU1
brcmf_btcoex_detach             | brcmf_btcoex_timerfunc
                                |   bt_local->timer_on = false;
  if (cfg->btcoex->timer_on)    |
    ...                         |
  cancel_work_sync();           |
  ...                           |   schedule_work(); // Reschedule
                                |
  kfree(cfg->btcoex); // FREE   |   brcmf_btcoex_handler() // Worker
  /*                            |     btci = container_of(....); // USE
   The kfree() above could      |     ...
   also occur at any point      |     btci-> // USE
   during the worker's execution|
   */                           |

To resolve the race conditions, drop the conditional check and call
timer_shutdown_sync() directly. It can deactivate the timer reliably,
regardless of its current state. Once stopped, the timer_on state is
then set to false.

Fixes: 61730d4dfffc ("brcmfmac: support critical protocol API for DHCP")
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://patch.msgid.link/20250822050839.4413-1-duoming@zju.edu.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c
index 00794086cc7c9..bf80675667ba3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c
@@ -392,10 +392,8 @@ void brcmf_btcoex_detach(struct brcmf_cfg80211_info *cfg)
 	if (!cfg->btcoex)
 		return;
 
-	if (cfg->btcoex->timer_on) {
-		cfg->btcoex->timer_on = false;
-		timer_shutdown_sync(&cfg->btcoex->timer);
-	}
+	timer_shutdown_sync(&cfg->btcoex->timer);
+	cfg->btcoex->timer_on = false;
 
 	cancel_work_sync(&cfg->btcoex->work);
 
-- 
2.50.1



