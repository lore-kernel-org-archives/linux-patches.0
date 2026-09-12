Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4837433F59A;
	Sat, 12 Sep 2026 12:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215150; cv=none; b=pOblNSOFkYlZC4RswXYNlUEUUUusoPMVisZzl0p+2kg1iRU/X4jN4jJb2YaJcu8R7qosO33h0Ikh+zM2HplGRHc8MAyHycWD7spAzTlmSBF8k9MVgw1c7b8V9uQafYBgqw4x7Zb48noSYmqU2DNcshnKgIH1noMktyBzYN6T5R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215150; c=relaxed/simple;
	bh=b5OoAUXRznVeWeZN+UFARmmLq9h+qJEAlGgWSZI1IJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSDSaMNLSqt9NlLyddekj+eB2Vtfzs6eMbCU5QL9VSAnAEzekDlb6UjvZO79gVKtx1JQ/sFJO0bu9HV67jAEQZlsYC4bO6+/gHXW57njE0AGtNNGo9/KeV9/sLdMpiigJj+p5+4899Bd3Zf+gbtgMappz7jrm76hGbZ/e07U7wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WKBhPJNS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WKBhPJNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019A81F000FF;
	Sat, 12 Sep 2026 12:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215149;
	bh=ISZp2ekpgb9cV5y4VFWV1cv9/66igW4cvKMv35U3H0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WKBhPJNSFc000HRokhpgFGRBcL77MyzlTrqWwzfn1UEJr6vn3TG8m1YWkmrJZ+sXI
	 S0ikrEjjjXfWChnYZRo1u0aEfzA4d5khQODXmS5H+uk6yF05h9cs/izFPjQcKiv7a/
	 TICIk1rP3kGc19JzK+mHw5+vaMG3l6RA6AjYyGvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Dan Carpenter <error27@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0430/1376] staging: rtl8723bs: fix mismatched free of HalData in rtw_sdio_if1_init()
Date: Sat, 12 Sep 2026 08:47:36 +0200
Message-ID: <20260912065617.118230412@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawei Feng <dawei.feng@seu.edu.cn>

[ Upstream commit 264676418b726baca7be49171e306b6aa05cceb0 ]

padapter->HalData is allocated via vzalloc(), but incorrectly freed
using kfree() in the rtw_sdio_if1_init() error path. Using kfree() to
release this vmalloc-backed buffer can lead to memory corruption.

Use rtw_hal_data_deinit() to pair the free correctly and free
HalData with vfree().

The bug was first flagged by an experimental static analysis tool we
are developing for kernel memory-management bugs. Manual inspection
confirms that the issue is still present in current mainline.

An x86_64 allyesconfig build showed no new warnings. As we do not have
suitable RTL8723BS SDIO hardware to test with, no runtime testing was
able to be performed.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Reviewed-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/20260525091836.812565-1-dawei.feng@seu.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
index d64998be6b2bb..c9a90d5293b02 100644
--- a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
+++ b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
@@ -309,8 +309,8 @@ static struct adapter *rtw_sdio_if1_init(struct dvobj_priv *dvobj, const struct
 	status = _SUCCESS;
 
 free_hal_data:
-	if (status != _SUCCESS && padapter->HalData)
-		kfree(padapter->HalData);
+	if (status != _SUCCESS)
+		rtw_hal_data_deinit(padapter);
 
 	if (status != _SUCCESS) {
 		rtw_wdev_unregister(padapter->rtw_wdev);
-- 
2.53.0



