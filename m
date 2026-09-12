Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8909133C1BE;
	Sat, 12 Sep 2026 15:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227937; cv=none; b=IBTN8DMXmN33iDoftZMQzmmDjm9Nhqns6FaOPuxyM8YjjeNt84cg1Y1oiTeWnU4fsZDI8jfRimif6FtsYROLj3oouDbS/f/gezz7HggPtbjpIy3AwzOJ1RyUD4aek1QTn/0rtudTSKAKXRLt3TcWbfoxsOPoFeVUJqp/13Oj7fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227937; c=relaxed/simple;
	bh=Wq7f9KTA7jWj+st4QXzygqxjWNxm30jgs+KdRMCTOjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7o/Uiq3aoJzBwrbNjre3wrkcWMWlWSDDzLBlb1RgffGSyIO9SQK6RiSoCo58ENwwDaxxFcJwa2h4ZQ1Rntf4t6YxKtRbxSOgJupxE27709niH5YCChW9r22uflrLNgLLIBNOdMkaERCTZy0hLxT5CFGwVsBgkgky2ZEgmRnFRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pItuw5TT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pItuw5TT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446AB1F000FF;
	Sat, 12 Sep 2026 15:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227936;
	bh=adc9OVtMkC38QMZIKXzOzy1EvwHVAkOQzpB4lEDyeaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pItuw5TT78ibJJiqRMbLOm3z0ENmlYQHeSF9A7WzVv25jgREIBHRn7uHThjAm3kgr
	 jMM4gePihPAH2Ar89Uu3Z5mCgZDzSXvD8Bswjnzn7JDPae5I/9KUizcpqGoVFb1mE5
	 RJBC26yjkxHteaHy8aSMRi4IyLiFuJr1f8GX/Hz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.1 0241/1191] wifi: mt76: mt7615: avoid waiting for mac work under the mt76 mutex
Date: Sat, 12 Sep 2026 08:49:29 +0200
Message-ID: <20260912065553.625345612@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit bda8324270b1ac91bfba1df8928e0570e29759e8 upstream.

mt7615_suspend() acquired the mt76 mutex and then called
cancel_delayed_work_sync() on mac_work.  mt7615_mac_work() acquires the
same mutex via mt7615_mutex_acquire() at the top of the worker, so if
mac_work is already running and blocked on the mutex, the suspend path
deadlocks waiting for the work it holds the mutex against.

Flush scan_work and mac_work before taking the mutex, matching the
suspend paths in mt7921 and mt7925.  scan_work only takes the mt76
spinlock, but moving it keeps the sequence consistent.  This also keeps
mac_work from running over an already suspended HIF, which the previous
split (async cancel under the lock, sync cancel after release) would
have allowed.

Fixes: c6bf20109a3f ("mt76: mt7615: add WoW support")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260612041331.2596331-1-runyu.xiao@seu.edu.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -1217,11 +1217,12 @@ static int mt7615_suspend(struct ieee802
 	cancel_delayed_work_sync(&dev->pm.ps_work);
 	mt76_connac_free_pending_tx_skbs(&dev->pm, NULL);
 
+	cancel_delayed_work_sync(&phy->scan_work);
+	cancel_delayed_work_sync(&phy->mt76->mac_work);
+
 	mt7615_mutex_acquire(dev);
 
 	clear_bit(MT76_STATE_RUNNING, &phy->mt76->state);
-	cancel_delayed_work_sync(&phy->scan_work);
-	cancel_delayed_work_sync(&phy->mt76->mac_work);
 
 	set_bit(MT76_STATE_SUSPEND, &phy->mt76->state);
 	ieee80211_iterate_active_interfaces(hw,


