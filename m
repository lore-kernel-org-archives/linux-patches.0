Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68677275AF6;
	Sun,  7 Sep 2025 20:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277487; cv=none; b=WvHNxwR9WT8sBtZAUIOGTD+0nk2SJTe4Hir5j3+/vJmA9+XZtLZB/dj5nGmfAQoLDjtXHHhPCoCyJvT6HSft4YVp+SSnc7hcZqyCcofq7S9/8ErS8ifKXrIoUOVZPZ6y8lKIta46ZIoQnRWEpVVMkTOweEMqjUUIKeYbYX7qBNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277487; c=relaxed/simple;
	bh=Rnw6kzMrfhv1IAeyOA9YAS/7LXp77XINH6rn5v2l/rE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CRyALsy6squHc4vgbfePtU+lkSdabramVHaLlGSVs02AcxEdGt47knlWYb1lVwyi9mT0pLf6OLjMbLujKLAlk7EyWoAc29MMFAL4RTeV4YzvH56AwRDecarMj6FZgMiDiuon2+gUQO6hDEY1noPca/vFgM1awFrVBkj8kljc8mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NydZi+YJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NydZi+YJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B39C4CEF8;
	Sun,  7 Sep 2025 20:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277487;
	bh=Rnw6kzMrfhv1IAeyOA9YAS/7LXp77XINH6rn5v2l/rE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NydZi+YJ3qmP8S4rVazUM5yyu05x23fcRz1sRoCiBPvCPA6IqOPXbYK4GXQsxKRwj
	 PsNZ/v++N/YwTyKXqrD5ilugntbmEXWSLRwIL+YmV0EbJJrPpHHLJ5+LShjUyZiuNL
	 zAM3sF4fhmjDkdgEjh0DXvLZrPFyexvpNalXdyQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Duoming Zhou <duoming@zju.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 031/183] wifi: brcmfmac: fix use-after-free when rescheduling brcmf_btcoex_info work
Date: Sun,  7 Sep 2025 21:57:38 +0200
Message-ID: <20250907195616.516145664@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 69ef8cf203d24..67c0c5a92f998 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c
@@ -393,10 +393,8 @@ void brcmf_btcoex_detach(struct brcmf_cfg80211_info *cfg)
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



