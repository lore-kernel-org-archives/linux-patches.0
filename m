Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1841F2F0C5F;
	Mon, 22 Sep 2025 19:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569877; cv=none; b=cSzZFmlEYXxF+MQoyGUJepIe0YLcJjep/Fy8bP/oR/P2a37ArLDf2wl5yV2oEYTPAfh0Gj3yUzkCPPeBNpQtv+dibRZ4vrT06jta1yvq8JuU8UEl5dE6pTqeNR9a9TOMGutZK8dzgTFYpa4KVKkuLEnEWD/O+v8+Z2DdMtbtJzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569877; c=relaxed/simple;
	bh=kN8IVcQZkCaq+VDw9HzdMNOLWWPxKG4KtfNRI6GDdAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TlS+9VXPuahLtgwEzRQWSdNcgAUgHK9V7ZUQCPKxepLIZB9EKUJZuBfNKEvAXhHw2DmvlbRxR7H1oFkEgdtKwV0PWsJwVKZKnQE9k8JpNpY+CuecjIS9kEPP5c4lZboiQ0ssqb2hhmRvrjR4xJ+3HUVbrhmUppWfo9rd11sC4v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHqNPs1W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHqNPs1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51B4C4CEF0;
	Mon, 22 Sep 2025 19:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569877;
	bh=kN8IVcQZkCaq+VDw9HzdMNOLWWPxKG4KtfNRI6GDdAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PHqNPs1W4t+mzANczd4uE92WadW/MLfYGqBwhJhqsKl7j6vECIY4x80l9BFt4C77u
	 IE70K/IxkS45ZEiKGeXJyKCWi1L+BzjPvuG9M8PPLYzja5fn1lLOaBIqQniU6mMeWp
	 w4OJB5FimTWVa4txsS0gHz1NBZ/mfixoUAnl3Qf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <enjuk@amazon.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/105] igc: dont fail igc_probe() on LED setup error
Date: Mon, 22 Sep 2025 21:29:06 +0200
Message-ID: <20250922192409.518721995@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

From: Kohei Enju <enjuk@amazon.com>

[ Upstream commit 528eb4e19ec0df30d0c9ae4074ce945667dde919 ]

When igc_led_setup() fails, igc_probe() fails and triggers kernel panic
in free_netdev() since unregister_netdev() is not called. [1]
This behavior can be tested using fault-injection framework, especially
the failslab feature. [2]

Since LED support is not mandatory, treat LED setup failures as
non-fatal and continue probe with a warning message, consequently
avoiding the kernel panic.

[1]
 kernel BUG at net/core/dev.c:12047!
 Oops: invalid opcode: 0000 [#1] SMP NOPTI
 CPU: 0 UID: 0 PID: 937 Comm: repro-igc-led-e Not tainted 6.17.0-rc4-enjuk-tnguy-00865-gc4940196ab02 #64 PREEMPT(voluntary)
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
 RIP: 0010:free_netdev+0x278/0x2b0
 [...]
 Call Trace:
  <TASK>
  igc_probe+0x370/0x910
  local_pci_probe+0x3a/0x80
  pci_device_probe+0xd1/0x200
 [...]

[2]
 #!/bin/bash -ex

 FAILSLAB_PATH=/sys/kernel/debug/failslab/
 DEVICE=0000:00:05.0
 START_ADDR=$(grep " igc_led_setup" /proc/kallsyms \
         | awk '{printf("0x%s", $1)}')
 END_ADDR=$(printf "0x%x" $((START_ADDR + 0x100)))

 echo $START_ADDR > $FAILSLAB_PATH/require-start
 echo $END_ADDR > $FAILSLAB_PATH/require-end
 echo 1 > $FAILSLAB_PATH/times
 echo 100 > $FAILSLAB_PATH/probability
 echo N > $FAILSLAB_PATH/ignore-gfp-wait

 echo $DEVICE > /sys/bus/pci/drivers/igc/bind

Fixes: ea578703b03d ("igc: Add support for LEDs on i225/i226")
Signed-off-by: Kohei Enju <enjuk@amazon.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
Tested-by: Mor Bar-Gabay <morx.bar.gabay@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc.h      |  1 +
 drivers/net/ethernet/intel/igc/igc_main.c | 12 +++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 323db1e2be388..79d5fc5ac4fce 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -336,6 +336,7 @@ struct igc_adapter {
 	/* LEDs */
 	struct mutex led_mutex;
 	struct igc_led_classdev *leds;
+	bool leds_available;
 };
 
 void igc_up(struct igc_adapter *adapter);
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index aadc0667fa04a..9ba41a427e141 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -7169,8 +7169,14 @@ static int igc_probe(struct pci_dev *pdev,
 
 	if (IS_ENABLED(CONFIG_IGC_LEDS)) {
 		err = igc_led_setup(adapter);
-		if (err)
-			goto err_register;
+		if (err) {
+			netdev_warn_once(netdev,
+					 "LED init failed (%d); continuing without LED support\n",
+					 err);
+			adapter->leds_available = false;
+		} else {
+			adapter->leds_available = true;
+		}
 	}
 
 	return 0;
@@ -7226,7 +7232,7 @@ static void igc_remove(struct pci_dev *pdev)
 	cancel_work_sync(&adapter->watchdog_task);
 	hrtimer_cancel(&adapter->hrtimer);
 
-	if (IS_ENABLED(CONFIG_IGC_LEDS))
+	if (IS_ENABLED(CONFIG_IGC_LEDS) && adapter->leds_available)
 		igc_led_free(adapter);
 
 	/* Release control of h/w to f/w.  If f/w is AMT enabled, this
-- 
2.51.0



