Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC3739FDD;
	Fri, 24 Nov 2023 18:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PEOPs0Qt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A31C433CC;
	Fri, 24 Nov 2023 18:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850281;
	bh=3YvzGVHHoqveHFgAWiwlecoI4y8PiCL4ufmwjVcNVr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PEOPs0QtaBW2xkTAT4/KlnQfVVsficauYwRGIXQu+n+goZwyrOyi3TrGdylMc/t2C
	 ovl/E+LNG+z2+Dgq9PAVwyBQS2QEqnGuOBrElVWPtg1Y1gPA8214XrsirtfSD/m6Zu
	 pSm2iXAl6+O31lP5+nULSvKgAGN3pVqj2JK+197U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	ChunHao Lin <hau@realtek.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 482/530] r8169: fix network lost after resume on DASH systems
Date: Fri, 24 Nov 2023 17:50:48 +0000
Message-ID: <20231124172042.762364219@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: ChunHao Lin <hau@realtek.com>

commit 868c3b95afef4883bfb66c9397482da6840b5baf upstream.

Device that support DASH may be reseted or powered off during suspend.
So driver needs to handle DASH during system suspend and resume. Or
DASH firmware will influence device behavior and causes network lost.

Fixes: b646d90053f8 ("r8169: magic.")
Cc: stable@vger.kernel.org
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: ChunHao Lin <hau@realtek.com>
Link: https://lore.kernel.org/r/20231109173400.4573-3-hau@realtek.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4648,10 +4648,16 @@ static void rtl8169_down(struct rtl8169_
 	rtl8169_cleanup(tp);
 	rtl_disable_exit_l1(tp);
 	rtl_prepare_power_down(tp);
+
+	if (tp->dash_type != RTL_DASH_NONE)
+		rtl8168_driver_stop(tp);
 }
 
 static void rtl8169_up(struct rtl8169_private *tp)
 {
+	if (tp->dash_type != RTL_DASH_NONE)
+		rtl8168_driver_start(tp);
+
 	pci_set_master(tp->pci_dev);
 	phy_init_hw(tp->phydev);
 	phy_resume(tp->phydev);


