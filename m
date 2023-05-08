Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CEE4168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BAEC433D2;
	Mon,  8 May 2023 10:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542449;
	bh=JHyBlDu5xq3xSrzJaYQ6lFBdF2CbXfRz3LoXwllnThU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DLv+NtATjSJzNNUrPAv2hrHvIIdvf5zM/upMeIOBWO6BW4zWiSvU9+8Jy/2ApJNfX
	 EzXM89odtqUfdHKPv6Ge8/P4e0VmP21MJ75+h903KJ6UI7+3FOXkdghnuY//quppon
	 lzA28XCOv3sBRthUOcTyZaCdypWzgUUhUZkMMppQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 438/663] drivers: staging: rtl8723bs: Fix locking in rtw_scan_timeout_handler()
Date: Mon,  8 May 2023 11:44:24 +0200
Message-Id: <20230508094442.286119718@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 3f467036093fedd7e231924327455fc609b5ef02 ]

Commit cc7ad0d77b51 ("drivers: staging: rtl8723bs: Fix deadlock in
rtw_surveydone_event_callback()") besides fixing the deadlock also
modified rtw_scan_timeout_handler() to use spin_[un]lock_irq()
instead of spin_[un]lock_bh().

Disabling the IRQs is not necessary since all code taking this lock
runs from either user contexts or from softirqs

rtw_scan_timeout_handler() is the only function taking pmlmepriv->lock
which uses spin_[un]lock_irq() for this. Switch back to
spin_[un]lock_bh() to make it consistent with the rest of the code.

Fixes: cc7ad0d77b51 ("drivers: staging: rtl8723bs: Fix deadlock in rtw_surveydone_event_callback()")
Cc: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230221145326.7808-2-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_mlme.c b/drivers/staging/rtl8723bs/core/rtw_mlme.c
index ea2a6566e51bf..091842d70d486 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -1590,11 +1590,11 @@ void rtw_scan_timeout_handler(struct timer_list *t)
 						  mlmepriv.scan_to_timer);
 	struct	mlme_priv *pmlmepriv = &adapter->mlmepriv;
 
-	spin_lock_irq(&pmlmepriv->lock);
+	spin_lock_bh(&pmlmepriv->lock);
 
 	_clr_fwstate_(pmlmepriv, _FW_UNDER_SURVEY);
 
-	spin_unlock_irq(&pmlmepriv->lock);
+	spin_unlock_bh(&pmlmepriv->lock);
 
 	rtw_indicate_scan_done(adapter, true);
 }
-- 
2.39.2



