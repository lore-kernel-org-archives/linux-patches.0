Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2904B3176FD;
	Tue, 17 Mar 2026 17:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768136; cv=none; b=f+dbxR0L2hL34e2Auuuqg62BpUiIgL/TbGAMD3BNjm664d68gK1MGF6bs2zhYtBKfBfZRk0NeDP9cmjTmN7CJ96CfMij0doV8csvT07f8JuBdPhpZ94aw2TOw8bzwNjJDW4AYK1FTREzqx90sQl+kGZAZ/CMgB1tIER2PLBgwX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768136; c=relaxed/simple;
	bh=zV+WFLKu6nlgo0ZW9kkRZC597CK4NoZZQ4Mjl5edDuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kE7p4MNqZUN3qs4CVs6kVFBI1/Ktfl8oxN2xYBytKTrIJOtah7nVCs/lWJvMH7vHJOAqk8MM9vxynBC1MvVMQn6F9lRiED5uZ4Afl+ixMqVhp6J2fiQQQMDaMkSdq2BONA4uPWil00VthRwQg/GsvrWSMINyoSgZE8xeSCkJvag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lm4i/UX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lm4i/UX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3D4C19424;
	Tue, 17 Mar 2026 17:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768136;
	bh=zV+WFLKu6nlgo0ZW9kkRZC597CK4NoZZQ4Mjl5edDuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lm4i/UX2SP88Rn7TxHjp4tZlK2YCgydVEiJU4yk+LseMt/phSS+REtCMHZG7ildoT
	 kg0754nZSkcx1ux5Ck1fSiUuEyGYJKRq194+JJ/Ci6I29S3ZNV7jF/ppkr4dXvzeZY
	 fmnRCg16BrwMg0FgAkc3gyp7DS9c/MbUrTDiMOZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Navaneeth K <knavaneeth786@gmail.com>
Subject: [PATCH 6.18 211/333] staging: rtl8723bs: properly validate the data in rtw_get_ie_ex()
Date: Tue, 17 Mar 2026 17:34:00 +0100
Message-ID: <20260317163007.189076701@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit f0109b9d3e1e455429279d602f6276e34689750a upstream.

Just like in commit 154828bf9559 ("staging: rtl8723bs: fix out-of-bounds
read in rtw_get_ie() parser"), we don't trust the data in the frame so
we should check the length better before acting on it

Cc: stable <stable@kernel.org>
Assisted-by: gkh_clanker_2000
Tested-by: Navaneeth K <knavaneeth786@gmail.com>
Reviewed-by: Navaneeth K <knavaneeth786@gmail.com>
Link: https://patch.msgid.link/2026022336-arrange-footwork-6e54@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
@@ -187,20 +187,25 @@ u8 *rtw_get_ie_ex(u8 *in_ie, uint in_len
 
 	cnt = 0;
 
-	while (cnt < in_len) {
+	while (cnt + 2 <= in_len) {
+		u8 ie_len = in_ie[cnt + 1];
+
+		if (cnt + 2 + ie_len > in_len)
+			break;
+
 		if (eid == in_ie[cnt]
-			&& (!oui || !memcmp(&in_ie[cnt+2], oui, oui_len))) {
+			&& (!oui || (ie_len >= oui_len && !memcmp(&in_ie[cnt + 2], oui, oui_len)))) {
 			target_ie = &in_ie[cnt];
 
 			if (ie)
-				memcpy(ie, &in_ie[cnt], in_ie[cnt+1]+2);
+				memcpy(ie, &in_ie[cnt], ie_len + 2);
 
 			if (ielen)
-				*ielen = in_ie[cnt+1]+2;
+				*ielen = ie_len + 2;
 
 			break;
 		}
-		cnt += in_ie[cnt+1]+2; /* goto next */
+		cnt += ie_len + 2; /* goto next */
 	}
 
 	return target_ie;


