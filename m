Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A8E15C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A62BC433D6;
	Mon,  5 Dec 2022 19:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670267856;
	bh=Pq34dXDKrqQp2q8DmQ/c37nAnMsIKg1JqrW53KanHYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=itV8Nq119XRj+Z/pYXc83I7WmtcJQ+z6Y4RJESYhr/KUePs9XWOSTa43h6N9ZXhQ8
	 KaPS3V2PLjD9KRynegSHM93qkWEC02FHK3tsmXfRPzJ0NEY+wTUtiZzMjkYv1cdW3s
	 dYNu0PVNELBQj4e3iIA9PlldrOLAC4JvWxYXsBKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 48/77] qlcnic: fix sleep-in-atomic-context bugs caused by msleep
Date: Mon,  5 Dec 2022 20:09:39 +0100
Message-Id: <20221205190802.576430073@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190800.868551051@linuxfoundation.org>
References: <20221205190800.868551051@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 8dbd6e4ce1b9c527921643d9e34f188a10d4e893 ]

The watchdog timer is used to monitor whether the process
of transmitting data is timeout. If we use qlcnic driver,
the dev_watchdog() that is the timer handler of watchdog
timer will call qlcnic_tx_timeout() to process the timeout.
But the qlcnic_tx_timeout() calls msleep(), as a result,
the sleep-in-atomic-context bugs will happen. The processes
are shown below:

   (atomic context)
dev_watchdog
  qlcnic_tx_timeout
    qlcnic_83xx_idc_request_reset
      qlcnic_83xx_lock_driver
        msleep

---------------------------

   (atomic context)
dev_watchdog
  qlcnic_tx_timeout
    qlcnic_83xx_idc_request_reset
      qlcnic_83xx_lock_driver
        qlcnic_83xx_recover_driver_lock
          msleep

Fix by changing msleep() to mdelay(), the mdelay() is
busy-waiting and the bugs could be mitigated.

Fixes: 629263acaea3 ("qlcnic: 83xx CNA inter driver communication mechanism")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
index 3c0862f9b381..079480b2786d 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
@@ -2992,7 +2992,7 @@ static void qlcnic_83xx_recover_driver_lock(struct qlcnic_adapter *adapter)
 		QLCWRX(adapter->ahw, QLC_83XX_RECOVER_DRV_LOCK, val);
 		dev_info(&adapter->pdev->dev,
 			 "%s: lock recovery initiated\n", __func__);
-		msleep(QLC_83XX_DRV_LOCK_RECOVERY_DELAY);
+		mdelay(QLC_83XX_DRV_LOCK_RECOVERY_DELAY);
 		val = QLCRDX(adapter->ahw, QLC_83XX_RECOVER_DRV_LOCK);
 		id = ((val >> 2) & 0xF);
 		if (id == adapter->portnum) {
@@ -3028,7 +3028,7 @@ int qlcnic_83xx_lock_driver(struct qlcnic_adapter *adapter)
 		if (status)
 			break;
 
-		msleep(QLC_83XX_DRV_LOCK_WAIT_DELAY);
+		mdelay(QLC_83XX_DRV_LOCK_WAIT_DELAY);
 		i++;
 
 		if (i == 1)
-- 
2.35.1



