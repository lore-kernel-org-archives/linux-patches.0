Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C7B314A6B;
	Mon, 13 Apr 2026 16:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098851; cv=none; b=bnvNv4MyRujbcJb7mvPo/qaC8+tuSQgKiNYl+Nv2sA+vz4nVwktcxpo8Hm8d4dJr+8C2KxAo8aYoQGFYM8H7B6KlQHJGHTREgt8HyZ66QE9nfhHCEx1lVwLJoceN3fAG6hdkTR7TKUFBv4HQO2JTWfYiKkD4uD9Nnm6XbOLy5zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098851; c=relaxed/simple;
	bh=mDJ28eWkxk6XNIr1wIp/+3ywI8xqMTYTGYGh7mIehj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dqf8m7DoPS3e80aIh6eETI+PksveFGbm6pWSKZ/XhM14TRzBNCRPY+Wzre9raxawVz9efLmyR+zUioAMnUQ0YluUJkOUj9LE8SUGLdRSbyrgqLoRZ5pilXxAvHGTP7OHsrsTcixYxnsZDiQJ15hd6kMj/gSFEudGVB7NvzlsFew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=szYsTsAv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="szYsTsAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2CCC2BCAF;
	Mon, 13 Apr 2026 16:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098851;
	bh=mDJ28eWkxk6XNIr1wIp/+3ywI8xqMTYTGYGh7mIehj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=szYsTsAvrXKwRbmUqXJ1dm7WqEMIw7BPu+6Vsza54bGJgbSvAM1kEloHN8aXbx17y
	 esdysbR5599xYKhTRb3C1dkfpxvQ6QDRlIwngCOroChFRcplbiw9QheMFjJ4OM/eEQ
	 V1m8Bj3JGm0iQSVSVyW0ZZNh8A8HV6HG3m7Gl2aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Navaneeth K <knavaneeth786@gmail.com>
Subject: [PATCH 5.10 114/491] staging: rtl8723bs: properly validate the data in rtw_get_ie_ex()
Date: Mon, 13 Apr 2026 17:55:59 +0200
Message-ID: <20260413155823.309508145@linuxfoundation.org>
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
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
@@ -194,21 +194,25 @@ u8 *rtw_get_ie_ex(u8 *in_ie, uint in_len
 
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
-		} else {
-			cnt += in_ie[cnt+1]+2; /* goto next */
 		}
+		cnt += ie_len + 2; /* goto next */
 	}
 
 	return target_ie;


