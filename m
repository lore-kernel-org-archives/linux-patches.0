Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A312932A3EE;
	Mon, 18 Aug 2025 13:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523113; cv=none; b=LC2xtZXe5b8dbhlRzZMhiS4gVow6C9LmxORB2OvDqFt2yuaDU8IzmMp96AsJawAL6VtF+UVFViMduYF7oLAzbxxPXSdSfoePEelVLHgDoRQxHmMvIboZDtD1YjjPdpC3j9l8LStYVTNDMgy3hVZcQzMGUrk8qIxLILEqUlvVDYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523113; c=relaxed/simple;
	bh=Fdq2QY4LZoXYJa3u1gYvDKgrQP/a+7SgrQ7xOU6AZWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bitmLVrMnbGfhauaQzyWkD44gwVboFgm16pV6OAS+aengYdh3uoHU1IS+iu7wBPY96IciT0tQQi+HJFWq2QjSGeLmu6+eDI8iESdruw7Eyuka/A7rrWCBXEvFfLz5FJHuc3RnQagxz4oY6Mg6lEA49VGRLJNosLjLt9RZqFKph4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G2f16HT/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G2f16HT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C0CC113D0;
	Mon, 18 Aug 2025 13:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523113;
	bh=Fdq2QY4LZoXYJa3u1gYvDKgrQP/a+7SgrQ7xOU6AZWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G2f16HT//Tbm76xY+NZLJbYz3zXVfFFGJn3cOywTH9uIJxpPBcEowpnDdnNVAr0vL
	 BzktByFuKtpxLUgWhP0aq6ITBO3pzlnY9367u068h+HCHn4rrJst7m2Iucr4kDNcqL
	 obOv5KIrUVXw6+4gRCjYeIxOmg9sHDDutFqZpm1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7cfb66a237c4a5fb22ad@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 074/515] ptp: prevent possible ABBA deadlock in ptp_clock_freerun()
Date: Mon, 18 Aug 2025 14:41:00 +0200
Message-ID: <20250818124501.233929628@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeongjun Park <aha310510@gmail.com>

[ Upstream commit 2efe41234dbd0a83fdb7cd38226c2f70039a2cd3 ]

syzbot reported the following ABBA deadlock:

       CPU0                           CPU1
       ----                           ----
  n_vclocks_store()
    lock(&ptp->n_vclocks_mux) [1]
        (physical clock)
                                     pc_clock_adjtime()
                                       lock(&clk->rwsem) [2]
                                        (physical clock)
                                       ...
                                       ptp_clock_freerun()
                                         ptp_vclock_in_use()
                                           lock(&ptp->n_vclocks_mux) [3]
                                              (physical clock)
    ptp_clock_unregister()
      posix_clock_unregister()
        lock(&clk->rwsem) [4]
          (virtual clock)

Since ptp virtual clock is registered only under ptp physical clock, both
ptp_clock and posix_clock must be physical clocks for ptp_vclock_in_use()
to lock &ptp->n_vclocks_mux and check ptp->n_vclocks.

However, when unregistering vclocks in n_vclocks_store(), the locking
ptp->n_vclocks_mux is a physical clock lock, but clk->rwsem of
ptp_clock_unregister() called through device_for_each_child_reverse()
is a virtual clock lock.

Therefore, clk->rwsem used in CPU0 and clk->rwsem used in CPU1 are
different locks, but in lockdep, a false positive occurs because the
possibility of deadlock is determined through lock-class.

To solve this, lock subclass annotation must be added to the posix_clock
rwsem of the vclock.

Reported-by: syzbot+7cfb66a237c4a5fb22ad@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7cfb66a237c4a5fb22ad
Fixes: 73f37068d540 ("ptp: support ptp physical/virtual clocks conversion")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250728062649.469882-1-aha310510@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_private.h | 5 +++++
 drivers/ptp/ptp_vclock.c  | 7 +++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index a6aad743c282..b352df4cd3f9 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -24,6 +24,11 @@
 #define PTP_DEFAULT_MAX_VCLOCKS 20
 #define PTP_MAX_CHANNELS 2048
 
+enum {
+	PTP_LOCK_PHYSICAL = 0,
+	PTP_LOCK_VIRTUAL,
+};
+
 struct timestamp_event_queue {
 	struct ptp_extts_event buf[PTP_MAX_TIMESTAMPS];
 	int head;
diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
index 7febfdcbde8b..8ed4b8598924 100644
--- a/drivers/ptp/ptp_vclock.c
+++ b/drivers/ptp/ptp_vclock.c
@@ -154,6 +154,11 @@ static long ptp_vclock_refresh(struct ptp_clock_info *ptp)
 	return PTP_VCLOCK_REFRESH_INTERVAL;
 }
 
+static void ptp_vclock_set_subclass(struct ptp_clock *ptp)
+{
+	lockdep_set_subclass(&ptp->clock.rwsem, PTP_LOCK_VIRTUAL);
+}
+
 static const struct ptp_clock_info ptp_vclock_info = {
 	.owner		= THIS_MODULE,
 	.name		= "ptp virtual clock",
@@ -213,6 +218,8 @@ struct ptp_vclock *ptp_vclock_register(struct ptp_clock *pclock)
 		return NULL;
 	}
 
+	ptp_vclock_set_subclass(vclock->clock);
+
 	timecounter_init(&vclock->tc, &vclock->cc, 0);
 	ptp_schedule_worker(vclock->clock, PTP_VCLOCK_REFRESH_INTERVAL);
 
-- 
2.50.1



