Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5117C13AEF
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fPdZCXtP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDC3C433C7;
	Tue, 31 Oct 2023 17:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698771872;
	bh=1+Cz1p6ODlhopJiTI/JcYF4F8fnwEyGV+i5RZHkox6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPdZCXtPyD0oevMv/VaGCdS4TIqFUXkbR1DRQRm3hGOy9ubcMiJeBq3b12ul3My+R
	 jlywYbQrBQWimjP87YHvZm0skd37z+QwhdiZTJ9msIc9Qdup3xB6vXqClBvY3KtuFY
	 E3j5Ts2cuN7Lzy9re/dJhmlE+NYfoxGQS6wWDHbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Grant Grundler <grundler@chromium.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 48/86] r8152: Cancel hw_phy_work if we have an error in probe
Date: Tue, 31 Oct 2023 18:01:13 +0100
Message-ID: <20231031165920.086943714@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165918.608547597@linuxfoundation.org>
References: <20231031165918.608547597@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit bb8adff9123e492598162ac1baad01a53891aef6 ]

The error handling in rtl8152_probe() is missing a call to cancel the
hw_phy_work. Add it in to match what's in the cleanup code in
rtl8152_disconnect().

Fixes: a028a9e003f2 ("r8152: move the settings of PHY to a work queue")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Grant Grundler <grundler@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 3cc8e324c5c6c..fb9c1f3f6e5a4 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9826,6 +9826,7 @@ static int rtl8152_probe(struct usb_interface *intf,
 
 out1:
 	tasklet_kill(&tp->tx_tl);
+	cancel_delayed_work_sync(&tp->hw_phy_work);
 	if (tp->rtl_ops.unload)
 		tp->rtl_ops.unload(tp);
 	usb_set_intfdata(intf, NULL);
-- 
2.42.0



