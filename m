Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9E6455626;
	Sat, 12 Sep 2026 18:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237194; cv=none; b=O6aKLUZFqJnXYg5etKjZ1WCwKDgios8rlJcjNmoGV5hCI2UKXjDhl2VJgsOynSFgOm9V5NLSuOEwGwqsmGniRAfehxU7UUk1215sQpml4Xg3OYW8QOyNAAvTk/YxnSavhMtNnLJFnawYsy8hO3FQ6gAQkWE4BZv/TagwXOCt/r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237194; c=relaxed/simple;
	bh=zW46op+52xyI/3DioXsFfW84rvV8tHDSTAfgoqWmR2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZ4ZZ8g8TiYiFDUGWrafePM00bNlftCy2JRYIKIFTLLNATDc4xfQ9USgF0ua7G03gERp3xBRQjvt1ekVhL9MZFLngUOOxuOUfkkaikaA57hft5IGP/NQ7M0HxhGvuTFWi78/+YWs0/w/yMRe3r06pAEoB+uCW1TYkf4qdMXPXqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D027+Dgz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D027+Dgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5361F000FF;
	Sat, 12 Sep 2026 18:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237193;
	bh=USQBI3iwIp8TIZnwwqVxcemrNiTf/ZlfEn2VCj7wM7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D027+DgzxLZTxXycKRElF58BuzL+WQ4Ags7bhce3YVnrnoj5x3IfEDzbjITvSHAFD
	 cz7TO+Dai1lQ4qJJOzWPOQ1Mel0N8MNRpucEy4BBQD7AqpRx3/V9I8m/kpdykcxmHU
	 CJ+yOXAm278gVjWYgiN9x+WcBTLw6rsgK8cYDWUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 5.15 207/935] wifi: mt76: mt7615: avoid waiting for mac work under the mt76 mutex
Date: Sat, 12 Sep 2026 08:53:57 +0200
Message-ID: <20260912065531.572101237@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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
@@ -1210,11 +1210,12 @@ static int mt7615_suspend(struct ieee802
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


