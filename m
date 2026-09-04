Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0197B4137B2;
	Fri,  4 Sep 2026 05:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500221; cv=none; b=YzaBvumOIfVFxhTpbNCn29wcrzWVI8TiKQb8224UsBpUW8X8ljBUfTxtYy51dIBaAiRNdJhg+4wUxD0byO8Kqtb5MoAJKEiBN9pnlnlLr0XcDD+BqSWcEdtgnXziKM5pG2oV0jfHh9eZibBFYe3ezPc5z88++K2TZ8RcTE1TDFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500221; c=relaxed/simple;
	bh=RD0muWh/oZqJp3SKjkHl8hpOEm8wChvqYllP9gnHGtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aEOBuE/Y79wBF2/FkPX9g/0qFmucGprr+7oLopvwUzkYdYj+IPhYJxIPEyBopRxDnjjLJlUgWJs1JA1A5EgrXg5HoWfFuyBijCJrRowPhUkiceQzo6PW8a03kPtdaQbvrJZL0bWxkDufdHa4lCcfR+d2OZ0t1JvKlV0fgd09CFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RSGgkg5W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RSGgkg5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC211F00A3D;
	Fri,  4 Sep 2026 05:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500219;
	bh=fPBspul85xxe6haCdssGkR4KFwmZqw9DHXeWe0L4XhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RSGgkg5WsVmTF1EuDJ+WiwRmh5S+oozyk3Ylu60U9IEw3HQVpOtOJ/hbzLD5ztilJ
	 dQO7yMLga+1tpJv9ff9X8G3zwJNgotwVUhFH/31OyMhZldvMhdbvG5Dh4eTeaU22Tq
	 fnSbCZkloGTsG3YMUSmjJQVUruVQMAU5f4sdPYuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Traockl <281473483+Traockl@users.noreply.github.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 7.2 694/713] wifi: mt76: mt7925: cancel mlo_pm_work on stop
Date: Fri,  4 Sep 2026 07:01:02 +0200
Message-ID: <20260904045819.400585362@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devin Wittmayer <lucid_duck@justthetip.ca>

commit 81faf578320df2dfc682a96baa6e85851dd68b6f upstream.

mt7925 queues mlo_pm_work with a 5 second delay during multi-link
power-save setup and never cancels it on the stop path. If the device is
torn down inside that window, the work outlives the teardown and its timer
fires afterwards, trying to queue onto the workqueue that is already gone:

  workqueue: cannot queue mt7925_mlo_pm_work [mt7925_common] on wq phy0
  WARNING: kernel/workqueue.c:2283 at __queue_work+0x59/0xa0, CPU#1: swapper/1/0
   call_timer_fn+0x2a/0x140
   __run_timers+0x203/0x330
   run_timer_softirq+0x86/0xf0

mt7921 already has its own stop callback, so add one for mt7925 that
cancels the work before calling mt792x_stop(). mt7925_ops backs both the
PCIe and USB drivers, so this covers both.

Fixes: 276a56883257 ("wifi: mt76: mt7925: update the power-saving flow")
Cc: stable@vger.kernel.org
Tested-by: Traockl <281473483+Traockl@users.noreply.github.com>
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260627202946.25598-1-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -2485,10 +2485,19 @@ static void mt7925_channel_switch_rx_bea
 	}
 }
 
+static void mt7925_stop(struct ieee80211_hw *hw, bool suspend)
+{
+	struct mt792x_dev *dev = mt792x_hw_dev(hw);
+
+	cancel_delayed_work_sync(&dev->mlo_pm_work);
+
+	mt792x_stop(hw, suspend);
+}
+
 const struct ieee80211_ops mt7925_ops = {
 	.tx = mt792x_tx,
 	.start = mt7925_start,
-	.stop = mt792x_stop,
+	.stop = mt7925_stop,
 	.add_interface = mt7925_add_interface,
 	.remove_interface = mt792x_remove_interface,
 	.config = mt7925_config,


