Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9238C1D270F;
	Wed,  2 Oct 2024 14:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878100; cv=none; b=Pzlg4UppAvae6irUOtguY3bP7yb4fYOFGiZ55vGeEqrb8SNaPzmfcfkR2urh5a4NNnwgz78DkYbVrdRSh9mmsTN4S8dWRwI32JGiI/oP+IG5PKiB0pW0THJgngfi5grqujC93s4S7GcpPRnESSVsQnCFfUw6CZo1RQrfAV5dip4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878100; c=relaxed/simple;
	bh=4kc7uu06B8ovfXUEL+ucp1OZXypGB83Y487b7K8d2z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4QLz/iiK285jSzjRjvPcYoRS+07RlYQNvcMgNAyjnLP5xOURnygdu69zko3B8TXxwBK/iHDangR7zXICOm++G/kfZAxnLKxv/xAJXEqvGEp2QuZZpu/63nwHDH95P2OIqspQP3ERpSq9LSOMX2B9oBbCIkTvJRq1hg1DRdJY6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xo+ycBsx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xo+ycBsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F07AC4CEE8;
	Wed,  2 Oct 2024 14:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878100;
	bh=4kc7uu06B8ovfXUEL+ucp1OZXypGB83Y487b7K8d2z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xo+ycBsxZKc0Aezj+hRYEY5BebQa390qgg4Y0ubq/bwpWZiwst9yhtope0id3qzhW
	 seNuzO4e7Un41Wi1lDXxy3//Fd/YrvsaD46rWo5ThxCwxK3sU/LZCQxIQczLCoHA9V
	 61rtYLtIhZUfc38YxepMNMU8XblkIRKtQS/To604=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 271/634] s390/ap: Fix deadlock caused by recursive lock of the AP bus scan mutex
Date: Wed,  2 Oct 2024 14:56:11 +0200
Message-ID: <20241002125821.796944116@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 56199bb956c3ea82e39c72d2972ebf8c18c6a8c0 ]

There is a possibility to deadlock with an recursive
lock of the AP bus scan mutex ap_scan_bus_mutex:

  ... kernel: ============================================
  ... kernel: WARNING: possible recursive locking detected
  ... kernel: 5.14.0-496.el9.s390x #3 Not tainted
  ... kernel: --------------------------------------------
  ... kernel: kworker/12:1/130 is trying to acquire lock:
  ... kernel: 0000000358bc1510 (ap_scan_bus_mutex){+.+.}-{3:3}, at: ap_bus_force_rescan+0x92/0x108
  ... kernel:
	      but task is already holding lock:
  ... kernel: 0000000358bc1510 (ap_scan_bus_mutex){+.+.}-{3:3}, at: ap_scan_bus_wq_callback+0x28/0x60
  ... kernel:
	      other info that might help us debug this:
  ... kernel:  Possible unsafe locking scenario:
  ... kernel:        CPU0
  ... kernel:        ----
  ... kernel:   lock(ap_scan_bus_mutex);
  ... kernel:   lock(ap_scan_bus_mutex);
  ... kernel:
	      *** DEADLOCK ***

Here is how the callstack looks like:

  ... [<00000003576fe9ce>] process_one_work+0x2a6/0x748
  ... [<0000000358150c00>] ap_scan_bus_wq_callback+0x40/0x60   <- mutex locked
  ... [<00000003581506e2>] ap_scan_bus+0x5a/0x3b0
  ... [<000000035815037c>] ap_scan_adapter+0x5b4/0x8c0
  ... [<000000035814fa34>] ap_scan_domains+0x2d4/0x668
  ... [<0000000357d989b4>] device_add+0x4a4/0x6b8
  ... [<0000000357d9bb54>] bus_probe_device+0xb4/0xc8
  ... [<0000000357d9daa8>] __device_attach+0x120/0x1b0
  ... [<0000000357d9a632>] bus_for_each_drv+0x8a/0xd0
  ... [<0000000357d9d548>] __device_attach_driver+0xc0/0x140
  ... [<0000000357d9d3d8>] driver_probe_device+0x40/0xf0
  ... [<0000000357d9cec2>] really_probe+0xd2/0x460
  ... [<000000035814d7b0>] ap_device_probe+0x150/0x208
  ... [<000003ff802a5c46>] zcrypt_cex4_queue_probe+0xb6/0x1c0 [zcrypt_cex4]
  ... [<000003ff7fb2d36e>] zcrypt_queue_register+0xe6/0x1b0 [zcrypt]
  ... [<000003ff7fb2c8ac>] zcrypt_rng_device_add+0x94/0xd8 [zcrypt]
  ... [<0000000357d7bc52>] hwrng_register+0x212/0x228
  ... [<0000000357d7b8c2>] add_early_randomness+0x102/0x110
  ... [<000003ff7fb29c94>] zcrypt_rng_data_read+0x94/0xb8 [zcrypt]
  ... [<0000000358150aca>] ap_bus_force_rescan+0x92/0x108
  ... [<0000000358177572>] mutex_lock_interruptible_nested+0x32/0x40  <- lock again

Note this only happens when the very first random data providing
crypto card appears via hot plug in the system AND is in disabled
state ("deconfig"). Then the initial pull of random data fails and
a re-scan of the AP bus is triggered while already in the middle
of an AP bus scan caused by the appearing new hardware.

The fix is relatively simple once the scenario us understood:
The AP bus force rescan function will immediately return if there
is currently an AP bus scan running with the very same thread id.

Fixes: eacf5b3651c5 ("s390/ap: introduce mutex to lock the AP bus scan")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/ap_bus.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 99fadfb4cd9f2..09acc321d0133 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -107,6 +107,7 @@ debug_info_t *ap_dbf_info;
 static bool ap_scan_bus(void);
 static bool ap_scan_bus_result; /* result of last ap_scan_bus() */
 static DEFINE_MUTEX(ap_scan_bus_mutex); /* mutex ap_scan_bus() invocations */
+static struct task_struct *ap_scan_bus_task; /* thread holding the scan mutex */
 static atomic64_t ap_scan_bus_count; /* counter ap_scan_bus() invocations */
 static int ap_scan_bus_time = AP_CONFIG_TIME;
 static struct timer_list ap_scan_bus_timer;
@@ -1006,11 +1007,25 @@ bool ap_bus_force_rescan(void)
 	if (scan_counter <= 0)
 		goto out;
 
+	/*
+	 * There is one unlikely but nevertheless valid scenario where the
+	 * thread holding the mutex may try to send some crypto load but
+	 * all cards are offline so a rescan is triggered which causes
+	 * a recursive call of ap_bus_force_rescan(). A simple return if
+	 * the mutex is already locked by this thread solves this.
+	 */
+	if (mutex_is_locked(&ap_scan_bus_mutex)) {
+		if (ap_scan_bus_task == current)
+			goto out;
+	}
+
 	/* Try to acquire the AP scan bus mutex */
 	if (mutex_trylock(&ap_scan_bus_mutex)) {
 		/* mutex acquired, run the AP bus scan */
+		ap_scan_bus_task = current;
 		ap_scan_bus_result = ap_scan_bus();
 		rc = ap_scan_bus_result;
+		ap_scan_bus_task = NULL;
 		mutex_unlock(&ap_scan_bus_mutex);
 		goto out;
 	}
@@ -2284,7 +2299,9 @@ static void ap_scan_bus_wq_callback(struct work_struct *unused)
 	 * system_long_wq which invokes this function here again.
 	 */
 	if (mutex_trylock(&ap_scan_bus_mutex)) {
+		ap_scan_bus_task = current;
 		ap_scan_bus_result = ap_scan_bus();
+		ap_scan_bus_task = NULL;
 		mutex_unlock(&ap_scan_bus_mutex);
 	}
 }
-- 
2.43.0



