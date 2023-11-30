Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0243A495C2;
	Thu, 30 Nov 2023 16:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jap5yiGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84565C433C8;
	Thu, 30 Nov 2023 16:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361425;
	bh=HLzvgKCiW5Lv9YwxAr5w9uQXffhPLrM4JNDLvnEbWs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jap5yiGtohJRLFpaNgbYzg3lN/IzVxPUExrijzyT0412ba/SfBK49STJsM9IECrdc
	 b/QWyyeIiPWzTEtYTc/HgrkJBovRjrJAWUK4a2KjsED6/s3JC70amDKLWfq7jPfbiQ
	 MgjU3LRR2fYMmExisl1S60RYEONxu/FKw0T+GEq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/112] net: wangxun: fix kernel panic due to null pointer
Date: Thu, 30 Nov 2023 16:21:05 +0000
Message-ID: <20231130162140.898829253@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit 8ba2c459668cfe2aaacc5ebcd35b4b9ef8643013 ]

When the device uses a custom subsystem vendor ID, the function
wx_sw_init() returns before the memory of 'wx->mac_table' is allocated.
The null pointer will causes the kernel panic.

Fixes: 79625f45ca73 ("net: wangxun: Move MAC address handling to libwx")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c      | 8 +++++---
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c   | 4 +---
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c | 4 +---
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index 85dc16faca544..52130df26aee5 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -1677,10 +1677,12 @@ int wx_sw_init(struct wx *wx)
 		wx->subsystem_device_id = pdev->subsystem_device;
 	} else {
 		err = wx_flash_read_dword(wx, 0xfffdc, &ssid);
-		if (!err)
-			wx->subsystem_device_id = swab16((u16)ssid);
+		if (err < 0) {
+			wx_err(wx, "read of internal subsystem device id failed\n");
+			return err;
+		}
 
-		return err;
+		wx->subsystem_device_id = swab16((u16)ssid);
 	}
 
 	wx->mac_table = kcalloc(wx->mac.num_rar_entries,
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index 2b431db6085a6..a4d63d2f3c5bb 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -121,10 +121,8 @@ static int ngbe_sw_init(struct wx *wx)
 
 	/* PCI config space info */
 	err = wx_sw_init(wx);
-	if (err < 0) {
-		wx_err(wx, "read of internal subsystem device id failed\n");
+	if (err < 0)
 		return err;
-	}
 
 	/* mac type, phy type , oem type */
 	ngbe_init_type_code(wx);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 5c3aed516ac20..d60c26ba0ba4c 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -362,10 +362,8 @@ static int txgbe_sw_init(struct wx *wx)
 
 	/* PCI config space info */
 	err = wx_sw_init(wx);
-	if (err < 0) {
-		wx_err(wx, "read of internal subsystem device id failed\n");
+	if (err < 0)
 		return err;
-	}
 
 	txgbe_init_type_code(wx);
 
-- 
2.42.0



