Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E9438F656;
	Sat, 12 Sep 2026 19:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242874; cv=none; b=j4Snox5wxPKe4I/UNFR9CR/4TqDesKAE9H/9t/Zi4509Rp5itkCGNITn2M2jnpe5+QCBNErR+DebyOYC1BqR9NYqKD8RWI1HPlybUAbH7bOTUQfjz+mVLUN+WIegn1yRWwfqsvxX4vUrqkmqR11EP+geCehhRa4Lg4m7tGiekew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242874; c=relaxed/simple;
	bh=8spsnrMPdcbTJfTlaCjDKkFsD/9/AvQLZtW4JRgb6pU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yp6bNSd87E8O0Qzkd8OcQeGQ4ByIr6VM8aGxQ/HiTV7iNCAxhK1chQYAFCOQ5dMzSO5DGlBamwKsaEk6vAcgQPtsRYfZ75ie6U5pHC/cMZM8Sze2yZE2EUF4YhDz0F3h8N6j1Q2JdoYhMAfrNUL9sr5vU91NxYG0qoEVrQxdGAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z6EHj0Hg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z6EHj0Hg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE9D1F000FF;
	Sat, 12 Sep 2026 19:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242873;
	bh=zUNyRFMyTflx2cUmW7ZLCZWQr5IGY9y5AikUOpLj2kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z6EHj0Hg8z5yq95JxUokcML+iWEmtmJDQ8dfgU5QEjpiuT25G+N5B/eBHb6nWVJUr
	 9hvA12yBj9YexGZ3wPNUuT7fQ4HZz8e8lLGOQDpwapdHPqLeMO93JOX8WW02ZyufTA
	 hbPINw0fy9yAXbYRWQEOhyCqqD8Xcy3uNKi2ep60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivy Lopez <skunkolee@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 526/798] staging: rtl8723bs: use kfree_sensitive() for key material
Date: Sat, 12 Sep 2026 09:02:34 +0200
Message-ID: <20260912065529.189378835@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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
index 0af22e013db36..93ae6b9ae4971 100644
--- a/drivers/staging/rtl8723bs/core/rtw_cmd.c
+++ b/drivers/staging/rtl8723bs/core/rtw_cmd.c
@@ -989,7 +989,7 @@ u8 rtw_setstakey_cmd(struct adapter *padapter, struct sta_info *sta, u8 unicast_
 	if (enqueue) {
 		ph2c = rtw_zmalloc(sizeof(struct cmd_obj));
 		if (!ph2c) {
-			kfree(psetstakey_para);
+			kfree_sensitive(psetstakey_para);
 			res = _FAIL;
 			goto exit;
 		}
@@ -997,7 +997,7 @@ u8 rtw_setstakey_cmd(struct adapter *padapter, struct sta_info *sta, u8 unicast_
 		psetstakey_rsp = rtw_zmalloc(sizeof(struct set_stakey_rsp));
 		if (!psetstakey_rsp) {
 			kfree(ph2c);
-			kfree(psetstakey_para);
+			kfree_sensitive(psetstakey_para);
 			res = _FAIL;
 			goto exit;
 		}
@@ -1008,7 +1008,7 @@ u8 rtw_setstakey_cmd(struct adapter *padapter, struct sta_info *sta, u8 unicast_
 		res = rtw_enqueue_cmd(pcmdpriv, ph2c);
 	} else {
 		set_stakey_hdl(padapter, (u8 *)psetstakey_para);
-		kfree(psetstakey_para);
+		kfree_sensitive(psetstakey_para);
 	}
 exit:
 	return res;
@@ -1046,7 +1046,7 @@ u8 rtw_clearstakey_cmd(struct adapter *padapter, struct sta_info *sta, u8 enqueu
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



