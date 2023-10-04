Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FC51D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:03:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74882C433C7;
	Wed,  4 Oct 2023 18:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442615;
	bh=skz9xfT9EN94jVUpughBOxcLZLhGhKxTtYDgWdzWLNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nXlRGZGjqKBL1V6dBc+cT1/mQN97mvdTFP17l5QcrzHMew7rwRTO3d2moWv1WeEGM
	 vzvr6wOMILwIIM/MzlhsU4rCcbn26vtcV9VP+4Vhf7vX4alEuQbVk7Jt7BSZsCqfG1
	 FmBbf7dYiHum+2RnzdwPYWaIq3FQgObEedHE+rUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashant Malani <pmalani@chromium.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Stephen Boyd <swboyd@chromium.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 048/183] platform/x86: intel_scu_ipc: Check status after timeout in busy_loop()
Date: Wed,  4 Oct 2023 19:54:39 +0200
Message-ID: <20231004175205.979922304@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit e0b4ab3bb92bda8d12f55842614362989d5b2cb3 ]

It's possible for the polling loop in busy_loop() to get scheduled away
for a long time.

  status = ipc_read_status(scu); // status = IPC_STATUS_BUSY
  <long time scheduled away>
  if (!(status & IPC_STATUS_BUSY))

If this happens, then the status bit could change while the task is
scheduled away and this function would never read the status again after
timing out. Instead, the function will return -ETIMEDOUT when it's
possible that scheduling didn't work out and the status bit was cleared.
Bit polling code should always check the bit being polled one more time
after the timeout in case this happens.

Fix this by reading the status once more after the while loop breaks.
The readl_poll_timeout() macro implements all of this, and it is
shorter, so use that macro here to consolidate code and fix this.

There were some concerns with using readl_poll_timeout() because it uses
timekeeping, and timekeeping isn't running early on or during the late
stages of system suspend or early stages of system resume, but an audit
of the code concluded that this code isn't called during those times so
it is safe to use the macro.

Cc: Prashant Malani <pmalani@chromium.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Fixes: e7b7ab3847c9 ("platform/x86: intel_scu_ipc: Sleeping is fine when polling")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20230913212723.3055315-2-swboyd@chromium.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_scu_ipc.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index e7a3e34028178..96675bea88b10 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -19,6 +19,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 
@@ -232,19 +233,15 @@ static inline u32 ipc_data_readl(struct intel_scu_ipc_dev *scu, u32 offset)
 /* Wait till scu status is busy */
 static inline int busy_loop(struct intel_scu_ipc_dev *scu)
 {
-	unsigned long end = jiffies + IPC_TIMEOUT;
-
-	do {
-		u32 status;
-
-		status = ipc_read_status(scu);
-		if (!(status & IPC_STATUS_BUSY))
-			return (status & IPC_STATUS_ERR) ? -EIO : 0;
+	u8 status;
+	int err;
 
-		usleep_range(50, 100);
-	} while (time_before(jiffies, end));
+	err = readx_poll_timeout(ipc_read_status, scu, status, !(status & IPC_STATUS_BUSY),
+				 100, jiffies_to_usecs(IPC_TIMEOUT));
+	if (err)
+		return err;
 
-	return -ETIMEDOUT;
+	return (status & IPC_STATUS_ERR) ? -EIO : 0;
 }
 
 /* Wait till ipc ioc interrupt is received or timeout in 10 HZ */
-- 
2.40.1



