Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559AF216605;
	Tue, 29 Apr 2025 17:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947157; cv=none; b=sulyILuNbZw2xlWj77L6XBxgcKGka8rwcDOSE3c3OA69TU3rtm+RVQZ3mpZlKm6LgVQFR9+cqugWx2LrzIic0jLEklXxc0NW9ODxRwLZMW90yeOj9SY0VZ+X1rB8ZHQPPumaBaC0KKzlOs+SgSpSp02P33hpPimufGH7p7gFI5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947157; c=relaxed/simple;
	bh=lnhSOHg20twpGtvdabSg42qO6On6uwzTLYn3dftFQ5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvBQIHgr5I12/9v5afWV1VcS8mJ8ArieTds3rsztSAyYR0d44j6vx3N7Q7t38FlMMt2Lrs6sVrgQtdVUPZSpeQle6a2t12wucCO8OgZ4i7QbQ1g79IAPWSfqhITi8HR74es/WmG9CH2BHg5nG/VZHnb75hRyAkAy0CGlNlyge60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L9BLiu7v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L9BLiu7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDCCC4CEE9;
	Tue, 29 Apr 2025 17:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947157;
	bh=lnhSOHg20twpGtvdabSg42qO6On6uwzTLYn3dftFQ5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L9BLiu7vtZCxPgAFuuzFIxxyNCKOo6WtH4yiC3fSuSGxPiQpDhXrC/636OimCoNax
	 Q2gR8OPJTiRcPoO7mD8DQbVrQ7sDmdQJwcu2ygT0VC0nVPtODa7HCagrudBU3JsGBr
	 o+cT67aJ/GEDfXMJCSd4TZiWfgYpnGHbaa8exYBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Feng Liu <Feng.Liu3@windriver.com>,
	He Zhe <Zhe.He@windriver.com>
Subject: [PATCH 5.10 190/286] drivers: staging: rtl8723bs: Fix deadlock in rtw_surveydone_event_callback()
Date: Tue, 29 Apr 2025 18:41:34 +0200
Message-ID: <20250429161115.785008219@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duoming Zhou <duoming@zju.edu.cn>

commit cc7ad0d77b51c872d629bcd98aea463a3c4109e7 upstream.

There is a deadlock in rtw_surveydone_event_callback(),
which is shown below:

   (Thread 1)                  |      (Thread 2)
                               | _set_timer()
rtw_surveydone_event_callback()|  mod_timer()
 spin_lock_bh() //(1)          |  (wait a time)
 ...                           | rtw_scan_timeout_handler()
 del_timer_sync()              |  spin_lock_bh() //(2)
 (wait timer to stop)          |  ...

We hold pmlmepriv->lock in position (1) of thread 1 and use
del_timer_sync() to wait timer to stop, but timer handler
also need pmlmepriv->lock in position (2) of thread 2.
As a result, rtw_surveydone_event_callback() will block forever.

This patch extracts del_timer_sync() from the protection of
spin_lock_bh(), which could let timer handler to obtain
the needed lock. What`s more, we change spin_lock_bh() in
rtw_scan_timeout_handler() to spin_lock_irq(). Otherwise,
spin_lock_bh() will also cause deadlock() in timer handler.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://lore.kernel.org/r/20220409061836.60529-1-duoming@zju.edu.cn
[Minor context change fixed]
Signed-off-by: Feng Liu <Feng.Liu3@windriver.com>
Signed-off-by: He Zhe <Zhe.He@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -826,7 +826,9 @@ void rtw_surveydone_event_callback(struc
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_, ("rtw_surveydone_event_callback: fw_state:%x\n\n", get_fwstate(pmlmepriv)));
 
 	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY)) {
+		spin_unlock_bh(&pmlmepriv->lock);
 		del_timer_sync(&pmlmepriv->scan_to_timer);
+		spin_lock_bh(&pmlmepriv->lock);
 		_clr_fwstate_(pmlmepriv, _FW_UNDER_SURVEY);
 	} else {
 
@@ -1753,11 +1755,11 @@ void rtw_scan_timeout_handler(struct tim
 
 	DBG_871X(FUNC_ADPT_FMT" fw_state =%x\n", FUNC_ADPT_ARG(adapter), get_fwstate(pmlmepriv));
 
-	spin_lock_bh(&pmlmepriv->lock);
+	spin_lock_irq(&pmlmepriv->lock);
 
 	_clr_fwstate_(pmlmepriv, _FW_UNDER_SURVEY);
 
-	spin_unlock_bh(&pmlmepriv->lock);
+	spin_unlock_irq(&pmlmepriv->lock);
 
 	rtw_indicate_scan_done(adapter, true);
 }


