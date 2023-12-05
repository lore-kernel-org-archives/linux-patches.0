Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122FF6AA0;
	Tue,  5 Dec 2023 03:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ktNU+qW9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C173C433C8;
	Tue,  5 Dec 2023 03:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746483;
	bh=b5VQQG++nfETrYao4+Kl4qgCpX2PPpPeHEEbP+VeXZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ktNU+qW9fWtn2ezZj5B7RQZmIXwpa+3dgiZTmhxF1kKoqUwHsXUC5Z1BfW26EFmt6
	 tTQKWTG7J1tRWU039NieIXsbsjjtx3JzCB/0B4Fydcqv8byWnQV7Rau/KAoDNbo1sw
	 hhhIw++5KqZKV/4IscS2g2xM2Kqo0Cgfa4z4zxOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Chen <free122448@hotmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 040/134] r8169: fix deadlock on RTL8125 in jumbo mtu mode
Date: Tue,  5 Dec 2023 12:15:12 +0900
Message-ID: <20231205031538.058935811@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

commit 59d395ed606d8df14615712b0cdcdadb2d962175 upstream.

The original change results in a deadlock if jumbo mtu mode is used.
Reason is that the phydev lock is held when rtl_reset_work() is called
here, and rtl_jumbo_config() calls phy_start_aneg() which also tries
to acquire the phydev lock. Fix this by calling rtl_reset_work()
asynchronously.

Fixes: 621735f59064 ("r8169: fix rare issue with broken rx after link-down on RTL8125")
Reported-by: Ian Chen <free122448@hotmail.com>
Tested-by: Ian Chen <free122448@hotmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/caf6a487-ef8c-4570-88f9-f47a659faf33@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -579,6 +579,7 @@ struct rtl8169_tc_offsets {
 enum rtl_flag {
 	RTL_FLAG_TASK_ENABLED = 0,
 	RTL_FLAG_TASK_RESET_PENDING,
+	RTL_FLAG_TASK_RESET_NO_QUEUE_WAKE,
 	RTL_FLAG_TASK_TX_TIMEOUT,
 	RTL_FLAG_MAX
 };
@@ -4582,6 +4583,8 @@ static void rtl_task(struct work_struct
 reset:
 		rtl_reset_work(tp);
 		netif_wake_queue(tp->dev);
+	} else if (test_and_clear_bit(RTL_FLAG_TASK_RESET_NO_QUEUE_WAKE, tp->wk.flags)) {
+		rtl_reset_work(tp);
 	}
 out_unlock:
 	rtnl_unlock();
@@ -4615,7 +4618,7 @@ static void r8169_phylink_handler(struct
 	} else {
 		/* In few cases rx is broken after link-down otherwise */
 		if (rtl_is_8125(tp))
-			rtl_reset_work(tp);
+			rtl_schedule_task(tp, RTL_FLAG_TASK_RESET_NO_QUEUE_WAKE);
 		pm_runtime_idle(d);
 	}
 


