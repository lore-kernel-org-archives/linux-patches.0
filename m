Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294F34BA96;
	Mon,  8 Jan 2024 15:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KOqvZRju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA6CC433C7;
	Mon,  8 Jan 2024 15:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726653;
	bh=zZhrLoOMeddNv+T8PQUNbxjIqz3cSeDvgXZK09E2Pb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KOqvZRjuUH408b481rcmWa2LMd728fg359ZhfMSz/YAZuSaXlFbdPs3RwqHxrAhqL
	 a121J+QERW9rUO3Pv/SDwlish9pJirSIsOwRmlt/p7o9C5WP/NFPz3MYIjNPBYhjAA
	 OAy9ZeGHTJFz+Q0Tkx7r/UB44T8jMzFXw+Ke8dIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/124] r8169: Fix PCI error on system resume
Date: Mon,  8 Jan 2024 16:07:42 +0100
Message-ID: <20240108150604.637524832@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 9c476269bff2908a20930c58085bf0b05ebd569a ]

Some r8168 NICs stop working upon system resume:

[  688.051096] r8169 0000:02:00.1 enp2s0f1: rtl_ep_ocp_read_cond == 0 (loop: 10, delay: 10000).
[  688.175131] r8169 0000:02:00.1 enp2s0f1: Link is Down
...
[  691.534611] r8169 0000:02:00.1 enp2s0f1: PCI error (cmd = 0x0407, status_errs = 0x0000)

Not sure if it's related, but those NICs have a BMC device at function
0:
02:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. Realtek RealManage BMC [10ec:816e] (rev 1a)

Trial and error shows that increase the loop wait on
rtl_ep_ocp_read_cond to 30 can eliminate the issue, so let
rtl8168ep_driver_start() to wait a bit longer.

Fixes: e6d6ca6e1204 ("r8169: Add support for another RTL8168FP")
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index bb787a52bc754..81fd31f6fac46 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1211,7 +1211,7 @@ static void rtl8168ep_driver_start(struct rtl8169_private *tp)
 {
 	r8168ep_ocp_write(tp, 0x01, 0x180, OOB_CMD_DRIVER_START);
 	r8168ep_ocp_write(tp, 0x01, 0x30, r8168ep_ocp_read(tp, 0x30) | 0x01);
-	rtl_loop_wait_high(tp, &rtl_ep_ocp_read_cond, 10000, 10);
+	rtl_loop_wait_high(tp, &rtl_ep_ocp_read_cond, 10000, 30);
 }
 
 static void rtl8168_driver_start(struct rtl8169_private *tp)
-- 
2.43.0



