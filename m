Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A730737B019;
	Sat, 12 Sep 2026 18:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239165; cv=none; b=HkuPaSplIOQReecvsgfpYTfcfv9dLJZYtr4Ip99YGA99QTtcAbqzbrQbjw3kjs36PDowHzr9eRme4MXYW5DyQClwpiehfkW5FQCfTHUyiLQ/+vG/VlLxVgZlsIQxJKKZkVaor/07CT28+nHCLjvroy5HHFt3FV+HXUa24x+7eU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239165; c=relaxed/simple;
	bh=wqk1StuimcL1t0bmDtIs5ny2PfZxHjkRzLWhadWzUC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQGv/HWDHNOEhNfP+JGdqtu7OcLFu8wNvJ2MlIIBrjlRj641i3o0cIZtQqGTraJd5xoAv1bh2J+B3k7/F08xMoHNcoFeoc6f+gguKvAekZbW8gNKTVRTZsujsXSbEYgYOnvtOUELfqksTA5dxd4LZFMAEvGQt4w63uKwubdWEYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RFZ/1KUm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RFZ/1KUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1447A1F000FF;
	Sat, 12 Sep 2026 18:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239164;
	bh=D4bwfgntIUriC4S11fYbQkUQ8jgJvA0WmkRQerfrdgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RFZ/1KUmmu2sqYKpd37KYica+zPbWiAToGhUEvgSYjjHBbAm1Yi1zVP1c66ksgSgV
	 QYNxCheAyhfViPOVMnNpkZAMmW6QD2sMnvlSvcyJv4crMQnrI809i38ssSfCW4NVIO
	 5O3rf5yaFKYwrWumfFwWf114u1Fc5fTxqLATTxy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivy Lopez <skunkolee@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 609/935] staging: rtl8723bs: use kfree_sensitive() for key material
Date: Sat, 12 Sep 2026 09:00:39 +0200
Message-ID: <20260912065540.812844198@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5f4f603b3b366..0678b15e6e778 100644
--- a/drivers/staging/rtl8723bs/core/rtw_cmd.c
+++ b/drivers/staging/rtl8723bs/core/rtw_cmd.c
@@ -933,7 +933,7 @@ u8 rtw_setstakey_cmd(struct adapter *padapter, struct sta_info *sta, u8 unicast_
 	if (enqueue) {
 		ph2c = rtw_zmalloc(sizeof(struct cmd_obj));
 		if (!ph2c) {
-			kfree(psetstakey_para);
+			kfree_sensitive(psetstakey_para);
 			res = _FAIL;
 			goto exit;
 		}
@@ -941,7 +941,7 @@ u8 rtw_setstakey_cmd(struct adapter *padapter, struct sta_info *sta, u8 unicast_
 		psetstakey_rsp = rtw_zmalloc(sizeof(struct set_stakey_rsp));
 		if (!psetstakey_rsp) {
 			kfree(ph2c);
-			kfree(psetstakey_para);
+			kfree_sensitive(psetstakey_para);
 			res = _FAIL;
 			goto exit;
 		}
@@ -952,7 +952,7 @@ u8 rtw_setstakey_cmd(struct adapter *padapter, struct sta_info *sta, u8 unicast_
 		res = rtw_enqueue_cmd(pcmdpriv, ph2c);
 	} else {
 		set_stakey_hdl(padapter, (u8 *)psetstakey_para);
-		kfree(psetstakey_para);
+		kfree_sensitive(psetstakey_para);
 	}
 exit:
 	return res;
@@ -992,7 +992,7 @@ u8 rtw_clearstakey_cmd(struct adapter *padapter, struct sta_info *sta, u8 enqueu
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



