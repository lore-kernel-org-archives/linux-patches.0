Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1E978C9C;
	Sat, 12 Sep 2026 14:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223968; cv=none; b=tg2zqm1a9CKYA8TRCeHaS/SOChdb3AZA+dv+O2Rdt9+JznUkSt4nWdM+Fojpzx9p/Mi1MdvMbJzNnvtYmJWAwaSQQ3TAXvoELKsJykrozc28PHcezS1+jfiJSqLVWHaUEwWBmb+AUM3Z6GmU7edUdn7WbYM478CrGAwJLfHskdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223968; c=relaxed/simple;
	bh=ElvX7JrVhi5HFrc79aUYfrSv9WVezSeYsQrfn+oBU0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6u16qmnCA7G+YZdccag0Oy8D50xAMqz6g8f4M3omdMjRi2miCLX3EPqlEDtbrQP0AeKZDiBGsnj9mXRT1mSfYw+vyiq3NY+zWi1u07NfQwG0IIXGQZCUZ5junpLvhndwHMmfVvoJ5fyASaehCCzi3SttiXosDQvC5ZOc7iLNGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wqHllFbX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wqHllFbX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0ACF1F000FF;
	Sat, 12 Sep 2026 14:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223967;
	bh=6FFCn/7jje086+BTry5sSHKy9rP4SCZX2OxIKQnD6x0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wqHllFbXVevR4AcJ6CurFOj946IiyMEpKFkBPgAWlad0tpAT7Kdma7Chc+lEp7awk
	 ZYMLuEMe71OL2NYpz1WTlJHxglti19GEM2EBgfdF53yxN7MFqHG4QvswSnwv42y6MW
	 2NCWqPQjYRJEdB9/MzOavAGvD7c585hz4AJd9IOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivy Lopez <skunkolee@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0896/1424] staging: rtl8723bs: use kfree_sensitive() for key material
Date: Sat, 12 Sep 2026 08:55:28 +0200
Message-ID: <20260912065627.394765435@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivy Lopez <skunkolee@gmail.com>

[ Upstream commit d205dfa8cb825f1954ca1cfa474fc50bf06ee4aa ]

The set_stakey_parm struct contains a 16-byte encryption key.
Use kfree_sensitive() instead of kfree() to ensure the key
material is zeroed before the memory is freed, preventing
potential information leaks.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Signed-off-by: Ivy Lopez <skunkolee@gmail.com>
Link: https://patch.msgid.link/20260717220135.17836-1-skunkolee@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_cmd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_cmd.c b/drivers/staging/rtl8723bs/core/rtw_cmd.c
index d3f10a3cf972a..fd112f3ad7464 100644
--- a/drivers/staging/rtl8723bs/core/rtw_cmd.c
+++ b/drivers/staging/rtl8723bs/core/rtw_cmd.c
@@ -895,7 +895,7 @@ u8 rtw_setstakey_cmd(struct adapter *padapter, struct sta_info *sta, u8 unicast_
 	if (enqueue) {
 		ph2c = rtw_zmalloc(sizeof(struct cmd_obj));
 		if (!ph2c) {
-			kfree(psetstakey_para);
+			kfree_sensitive(psetstakey_para);
 			res = _FAIL;
 			goto exit;
 		}
@@ -903,7 +903,7 @@ u8 rtw_setstakey_cmd(struct adapter *padapter, struct sta_info *sta, u8 unicast_
 		psetstakey_rsp = rtw_zmalloc(sizeof(struct set_stakey_rsp));
 		if (!psetstakey_rsp) {
 			kfree(ph2c);
-			kfree(psetstakey_para);
+			kfree_sensitive(psetstakey_para);
 			res = _FAIL;
 			goto exit;
 		}
@@ -914,7 +914,7 @@ u8 rtw_setstakey_cmd(struct adapter *padapter, struct sta_info *sta, u8 unicast_
 		res = rtw_enqueue_cmd(pcmdpriv, ph2c);
 	} else {
 		set_stakey_hdl(padapter, (u8 *)psetstakey_para);
-		kfree(psetstakey_para);
+		kfree_sensitive(psetstakey_para);
 	}
 exit:
 	return res;
@@ -954,7 +954,7 @@ u8 rtw_clearstakey_cmd(struct adapter *padapter, struct sta_info *sta, u8 enqueu
 		psetstakey_rsp = rtw_zmalloc(sizeof(struct set_stakey_rsp));
 		if (!psetstakey_rsp) {
 			kfree(ph2c);
-			kfree(psetstakey_para);
+			kfree_sensitive(psetstakey_para);
 			res = _FAIL;
 			goto exit;
 		}
-- 
2.53.0



