Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2827C31619A;
	Mon, 13 Apr 2026 16:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099068; cv=none; b=N2XOBQa6ruP8FiqL4sDL3zrtty3Z0g3nwXFj8gyj2BLrnaTtwSi5CA+uqcU0KJC+tf0i9PQNnxIfIJtqiQ1RQI8CNc6oBBS5+opUdT/dySOn2qzvUnRdmvPyuBpwxfpz0XMmJpnrUHA6yL41rBsf866rNgNiFFC5hzW3Ee/QLVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099068; c=relaxed/simple;
	bh=kE0Io5b6nyIcqEu1y2CDlvv4hpgE4QfwUvjJPCoFFCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+DlnGhfp98ecHKR35kM7WKDO8CAkKdo+lUaHXAhFqfYWXCdhPo3aR+46JJc11s1LPrl5fEkMfeCN53Y81Dx3Xv199D/4Uo2jo82ZcAgNJixC22eO4BNmtz9/wIENiUl5adljD4lwgo3y/8a1TP515z0pc521ovIQyAlyCKc8Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/0C+slc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/0C+slc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0515C2BCAF;
	Mon, 13 Apr 2026 16:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099068;
	bh=kE0Io5b6nyIcqEu1y2CDlvv4hpgE4QfwUvjJPCoFFCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/0C+slcTi+iGnB97EQ+GhJvQ4VjD6l5PvUSSnY6NtAtOVjowthliDAnvsc89Np9X
	 5oCGaoa8uVGG3Xd3jT43Uqm6fvLYHmYHvXqpyBQOZUsy70i+uCOzU/P/s49b3gSQ0j
	 gKUUC3CidaQfXueD0OD//rrRelVd2lPUeoGwiUMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>
Subject: [PATCH 5.10 197/491] staging: rtl8723bs: fix null dereference in find_network
Date: Mon, 13 Apr 2026 17:57:22 +0200
Message-ID: <20260413155826.449000649@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Ethan Tidmore <ethantidmore06@gmail.com>

[ Upstream commit 41460a19654c32d39fd0e3a3671cd8d4b7b8479f ]

The variable pwlan has the possibility of being NULL when passed into
rtw_free_network_nolock() which would later dereference the variable.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable@vger.kernel.org
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Link: https://patch.msgid.link/20260202205429.20181-1-ethantidmore06@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -967,10 +967,12 @@ static void find_network(struct adapter
 	struct wlan_network *tgt_network = &pmlmepriv->cur_network;
 
 	pwlan = rtw_find_network(&pmlmepriv->scanned_queue, tgt_network->network.MacAddress);
-	if (pwlan)
-		pwlan->fixed = false;
-	else
+	if (!pwlan) {
 		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_, ("rtw_free_assoc_resources : pwlan == NULL\n\n"));
+		return;
+	}
+
+	pwlan->fixed = false;
 
 	if (check_fwstate(pmlmepriv, WIFI_ADHOC_MASTER_STATE) &&
 	    (adapter->stapriv.asoc_sta_count == 1))


