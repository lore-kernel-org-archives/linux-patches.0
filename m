Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCA832B125;
	Sat, 12 Sep 2026 16:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230150; cv=none; b=ss5EbXpf6PPgaU/TNJfJ+30PdqF3HE/A0aY4JUNmCXbYOXXa9EOgCrDhgpSccIciOUnWh1PvjZFQfNem6tgLpXW3ivq2h4MIPeJWlJt/6XFls+j0VlpS0oAKMOaCdK5kDGCqXC2OaNLc6kJKQOdvhyqGcpI+q3c7IPg99NPB+Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230150; c=relaxed/simple;
	bh=w02zgoHTT6RsjkAbCXHBUc1sI4SyxQQeRSJg/OSZW8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwH6SBILliH/44j9SkvvKtzMD/kpZ+P9rYf9eiC6KWShKrDPx15IGAsFMfCoiduLC1/kP2J1Uwyw1AaY/ynExC1B+adqlvWNOjEcUmEn8ypCnVjM9JR9i+ukCfjX2UyWMpI/H7l7sj0oeb6uI3CMKoa2ounG5cSHPbcVJ6cQagc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qQETwjuS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qQETwjuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B1D1F000FF;
	Sat, 12 Sep 2026 16:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230149;
	bh=H9sZVRJs302+u3Zzm/Ihkv5iA8IczX1TEcfBXBgdH8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qQETwjuSQ+ETMWFmrOwegfq0DGA6fng+uKvg7s7T+y3fiucZRQy9KTvaZWnbCDpdv
	 31nLyarBL7izn4k8jnym007I1KdXX5YhGrErb1rpUYr7iPgZUAA5kVLR5ovddVrnnM
	 RoghPBQkBGjbVzI3jKqOiGpj+Rmh3ynCCjrg41II=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivy Lopez <skunkolee@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0733/1191] staging: rtl8723bs: use kfree_sensitive() for key material
Date: Sat, 12 Sep 2026 08:57:41 +0200
Message-ID: <20260912065604.746340465@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



