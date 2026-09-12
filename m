Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E480135FF6E;
	Sat, 12 Sep 2026 10:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208434; cv=none; b=nkBmR0ew3gFhkgX//N9ueTMRXObML7kkjo299JqFA/mee0ASfHrFfCZp3KWRPR7Pt+F6+BSod6iYFHGEmZxZkmFzrdqOqryy0Ce0QqDKVXlkUOHI64SnTpkYkWumQ235AJMSqIRr6dQV3FgYTBmFQYNP/l3tzRShgS9Iv+xGc4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208434; c=relaxed/simple;
	bh=YZCvYKxtRrP0UX/biJ4pdDV3BIV6MqccdBxtQsRYbJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/qcSJHzAbgpf3+LdKY1SBhDPR2AFFY5M5fIp4lQdJ4XPVaSoz+4IHfxCGEQtL6asFA8FTbcGTgJTjKPKlJr07c8lRDMxG7OSGqtNDHykFte3t6YXo/vXLEXb4YRr9AqQBXiBQRYvX52zPI2+TBVQuSMBQHxrgU0pCAHusmWCs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1y6HLoE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1y6HLoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91EE1F000FF;
	Sat, 12 Sep 2026 10:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208432;
	bh=y+ocvVlCP+yp8q565p8sM6rXzGZm13MQV4Sr5IGc3E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z1y6HLoETmZ2+xTgfOjfOIJFMqv3JZe/a1JDeIDTrfmH2YHeITIvF9aQc2CE/njTL
	 P8sQcda7U8gtCnAlfuG3mk1fScD7Kbtfq/mfYebaq+xSfBpgQ9vUYYbWBx36zHQmJC
	 K+4fSXGAwZvaiZ/NV/HGhryb+zC3x+PG/d2AV6Ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivy Lopez <skunkolee@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0599/1518] staging: rtl8723bs: use kfree_sensitive() for key material
Date: Sat, 12 Sep 2026 08:46:08 +0200
Message-ID: <20260912065636.973702291@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0091045f63f24..2701a80ad07de 100644
--- a/drivers/staging/rtl8723bs/core/rtw_cmd.c
+++ b/drivers/staging/rtl8723bs/core/rtw_cmd.c
@@ -889,7 +889,7 @@ u8 rtw_setstakey_cmd(struct adapter *padapter, struct sta_info *sta, u8 unicast_
 	if (enqueue) {
 		ph2c = kzalloc(sizeof(*ph2c), GFP_KERNEL);
 		if (!ph2c) {
-			kfree(psetstakey_para);
+			kfree_sensitive(psetstakey_para);
 			res = _FAIL;
 			goto exit;
 		}
@@ -897,7 +897,7 @@ u8 rtw_setstakey_cmd(struct adapter *padapter, struct sta_info *sta, u8 unicast_
 		psetstakey_rsp = kzalloc(sizeof(*psetstakey_rsp), GFP_KERNEL);
 		if (!psetstakey_rsp) {
 			kfree(ph2c);
-			kfree(psetstakey_para);
+			kfree_sensitive(psetstakey_para);
 			res = _FAIL;
 			goto exit;
 		}
@@ -908,7 +908,7 @@ u8 rtw_setstakey_cmd(struct adapter *padapter, struct sta_info *sta, u8 unicast_
 		res = rtw_enqueue_cmd(pcmdpriv, ph2c);
 	} else {
 		set_stakey_hdl(padapter, (u8 *)psetstakey_para);
-		kfree(psetstakey_para);
+		kfree_sensitive(psetstakey_para);
 	}
 exit:
 	return res;
@@ -948,7 +948,7 @@ u8 rtw_clearstakey_cmd(struct adapter *padapter, struct sta_info *sta, u8 enqueu
 		psetstakey_rsp = kzalloc(sizeof(*psetstakey_rsp), GFP_KERNEL);
 		if (!psetstakey_rsp) {
 			kfree(ph2c);
-			kfree(psetstakey_para);
+			kfree_sensitive(psetstakey_para);
 			res = _FAIL;
 			goto exit;
 		}
-- 
2.53.0



