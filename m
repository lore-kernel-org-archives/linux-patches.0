Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A017B320CC0;
	Mon, 18 Aug 2025 12:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521574; cv=none; b=thjtq7TCfvMF60FUd3v4Lulz8ovM7nPAK3KQ8DSegW1uVRZBbRRbB30Cmx2ZfC+zoOsiSlO0p16ZFSQKAY+M0Us6IB+dRx0hx7VgaT3Mf6T3DaGe0pOV5sFTxp7KSdWerADbdb8dFCKRjjmhGtSyXPVdIZPZ4+jEMITkSFJJmHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521574; c=relaxed/simple;
	bh=1lWSP3kPALO9X+K0TF9Eh0f2AU0cRVu+kotkqsNeNjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmyaph96Pmxa/dVVayPSJhM34D9dQwOyPKVwY1B2VmzpBsBSNtd7tam1LBNu0auUJ/3cr5+Kht6iqpibH+0hmzlHbltb20KACwl16OE4v1by5J9GSk56eSXYrrheDPoEcTqUuut4JUPRNdpENbe2ItztSuOwc9DZGDIU1umIf6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ow8k9Be0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ow8k9Be0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F17C4CEEB;
	Mon, 18 Aug 2025 12:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521574;
	bh=1lWSP3kPALO9X+K0TF9Eh0f2AU0cRVu+kotkqsNeNjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ow8k9Be01LoLqgOpmT/xlcHBS9FSn8BI+eejOeGOOMXw1frxxn+AXyIetbz6AJYyJ
	 cghQYYg9FHJZFzCaPMbGtbAWZHrYSoHHDbeqaj8SYmz+3uKIDNlNF+8RET0g2P6vjv
	 8J8938/3jqdcTJqnQg+anGXqxTMakQkHLKz9Az60=
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
Subject: [PATCH 6.12 061/444] ptp: prevent possible ABBA deadlock in ptp_clock_freerun()
Date: Mon, 18 Aug 2025 14:41:27 +0200
Message-ID: <20250818124451.234586648@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



