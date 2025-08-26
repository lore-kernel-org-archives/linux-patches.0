Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E129235208F;
	Tue, 26 Aug 2025 14:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216848; cv=none; b=I3lqMlz6RyG86kfvV+iOkqKtpWxzNdDbKtXi5XHljvHbfTuqUfr8djM753z6nEgecgmUsn7+8ZBML2vvaJCF4GVXo4CjlXE8QtvxFyxmyvpMyo4aSPTygh3hWJgMBpbsaptWy9Kk9ypaBdcJ+bneCsEk3LdGzYIYKP3nbW2cS6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216848; c=relaxed/simple;
	bh=ghC3mzWSkhiQdCv3/Q1GxYRWPHmCCgw3VhDaeN6LVS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVFBHTOPevVm84qwtWmTW1xn5Vccx37memj9fGEBmx2VeZIYihlokT1XZYSLP+8ABUEPG2oQhHz4ED/bRik4upMiMZB63A1ANgKBH+WNxJtLT/1PejsDnUtISJ/l3AlaTHvlgpQ8vLF14edO1KxZmsOmGN5zG5iaydTRq++tQwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJDiGyxD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJDiGyxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73166C4CEF1;
	Tue, 26 Aug 2025 14:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216847;
	bh=ghC3mzWSkhiQdCv3/Q1GxYRWPHmCCgw3VhDaeN6LVS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJDiGyxDCQi0IImxUXkbLZQxw+iq307VomJrZk2Z2LyUPI1P6kvXauGP2EGjkLtdh
	 1A3uydVfApz2N75Z7PnJnaRfX5hpdikZ3z3fpdudGhTCwrcY+L2M+pOAs+DOLe12wD
	 b3Oxdk41a6ypDhUFX7B8tAw7nAdXw6zyl/h8cROc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayi Li <lijiayi@kylinos.cn>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 564/644] memstick: Fix deadlock by moving removing flag earlier
Date: Tue, 26 Aug 2025 13:10:55 +0200
Message-ID: <20250826111000.507311054@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jiayi Li <lijiayi@kylinos.cn>

commit 99d7ab8db9d8230b243f5ed20ba0229e54cc0dfa upstream.

The existing memstick core patch: commit 62c59a8786e6 ("memstick: Skip
allocating card when removing host") sets host->removing in
memstick_remove_host(),but still exists a critical time window where
memstick_check can run after host->eject is set but before removing is set.

In the rtsx_usb_ms driver, the problematic sequence is:

rtsx_usb_ms_drv_remove:          memstick_check:
  host->eject = true
  cancel_work_sync(handle_req)     if(!host->removing)
  ...                              memstick_alloc_card()
                                     memstick_set_rw_addr()
                                       memstick_new_req()
                                         rtsx_usb_ms_request()
                                           if(!host->eject)
                                           skip schedule_work
                                       wait_for_completion()
  memstick_remove_host:                [blocks indefinitely]
    host->removing = true
    flush_workqueue()
    [block]

1. rtsx_usb_ms_drv_remove sets host->eject = true
2. cancel_work_sync(&host->handle_req) runs
3. memstick_check work may be executed here <-- danger window
4. memstick_remove_host sets removing = 1

During this window (step 3), memstick_check calls memstick_alloc_card,
which may indefinitely waiting for mrq_complete completion that will
never occur because rtsx_usb_ms_request sees eject=true and skips
scheduling work, memstick_set_rw_addr waits forever for completion.

This causes a deadlock when memstick_remove_host tries to flush_workqueue,
waiting for memstick_check to complete, while memstick_check is blocked
waiting for mrq_complete completion.

Fix this by setting removing=true at the start of rtsx_usb_ms_drv_remove,
before any work cancellation. This ensures memstick_check will see the
removing flag immediately and exit early, avoiding the deadlock.

Fixes: 62c59a8786e6 ("memstick: Skip allocating card when removing host")
Signed-off-by: Jiayi Li <lijiayi@kylinos.cn>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250804013604.1311218-1-lijiayi@kylinos.cn
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/memstick/core/memstick.c    |    1 -
 drivers/memstick/host/rtsx_usb_ms.c |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -548,7 +548,6 @@ EXPORT_SYMBOL(memstick_add_host);
  */
 void memstick_remove_host(struct memstick_host *host)
 {
-	host->removing = 1;
 	flush_workqueue(workqueue);
 	mutex_lock(&host->lock);
 	if (host->card)
--- a/drivers/memstick/host/rtsx_usb_ms.c
+++ b/drivers/memstick/host/rtsx_usb_ms.c
@@ -812,6 +812,7 @@ static int rtsx_usb_ms_drv_remove(struct
 	int err;
 
 	host->eject = true;
+	msh->removing = true;
 	cancel_work_sync(&host->handle_req);
 	cancel_delayed_work_sync(&host->poll_card);
 


