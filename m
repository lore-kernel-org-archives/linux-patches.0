Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811172E06E4;
	Tue, 25 Aug 2026 13:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666391; cv=none; b=a6eDNbJ4HR1JY5zOfm+NXJGe2q3M/wC0vhs2pkvJbEwsbuEVH2dJMsEja0bCZId8dkvH2IG3cbPFou61QfF3qqJmDPLQlW9J+mHzYbRHZ/VKudSau6vMajLb4YDuzGGGI2E0XeJZVMV2Kun/fTD4lbr1wO3/mKQarnunJh73Df0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666391; c=relaxed/simple;
	bh=MImwtIqBrXSGVDWmBRwMXV3ftz8ZNrcchu/SQJryk0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XiOTeIh4pbicI2Msw6SWqsvdhE1rzRJhbJaRyPxNK+x7mWIxb14FH/M9I9kT2ev1t1HZjLiwCFnCKgCXa0ufzLH/CW8bNA1/BInnF9TI6DZliKO31YyjKLxUxNQk69KqUV3yCfWyLue9AMYXiUJ6MwfzsPRJfcX5YBfHvHvIaOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPHbavfh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPHbavfh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41481F000E9;
	Tue, 25 Aug 2026 13:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666390;
	bh=T5jl0JAEVIKsGvxkzd32nGAp3Mj07SL1/s/jCL6rI+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZPHbavfh/5qc6mREyMm+Uc/lnopfAMqv0j+FKTP68wp4ILDg4p0kLvXu74ZirPbIU
	 co0ow46vEbjtwKlGRgXLlQa3ImPzD25YWZQNah2nv41fevOwZb+7aHCT9iWXpYdBip
	 ytqu+7cN1QjfLC5jfyhUHDk6svH27u7j9/K4cSTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 09/57] staging: rtl8723bs: fix OOB read in WMM_param_handler()
Date: Tue, 25 Aug 2026 15:26:31 +0200
Message-ID: <20260825132541.671172662@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.342390421@linuxfoundation.org>
References: <20260825132541.342390421@linuxfoundation.org>
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

From: Muhammad Bilal <meatuni001@gmail.com>

[ Upstream commit ae21407350151bddfd4fea7aa39bd0643c0ca9d3 ]

WMM_param_handler() copies a fixed-size WMM parameter element out of a
received information element without checking that the element is long
enough, causing an out-of-bounds read for a short WMM IE.

The handler reads sizeof(struct WMM_para_element) (18) bytes at
pIE->data + 6, so it requires pIE->length to be at least 24
(WLAN_WMM_LEN), but it never validates the length. Two of its three
callers reach it after matching only the WMM OUI: OnAssocRsp() in
rtw_mlme_ext.c matches a 6-byte OUI, and join_cmd_hdl() matches a
4-byte OUI, before calling the handler. A vendor-specific IE carrying
the WMM OUI but a length between 6 and 23, placed in an association
response or in the IE blob handed to join_cmd_hdl(), passes the OUI
check and then makes the memcmp() and memcpy() at pIE->data + 6 read
past the end of the element. OnAssocRsp() parses a frame received from
the AP, so this is reachable from a remote peer.

The remaining caller in rtw_wlan_util.c already guards the handler with
"pIE->length == WLAN_WMM_LEN". Move the equivalent check into the
handler itself so every caller is covered; the sibling IE handlers in
the same parsing loop (HT_caps_handler(), HT_info_handler(),
ERP_IE_handler()) likewise bound their accesses by pIE->length.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260719041509.97894-1-meatuni001@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ changed `pIE->length` to `pIE->Length` due to pre-5.15 CamelCase field name in `struct ndis_80211_var_ie` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_wlan_util.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/staging/rtl8723bs/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8723bs/core/rtw_wlan_util.c
@@ -771,6 +771,9 @@ int WMM_param_handler(struct adapter *pa
 		return false;
 	}
 
+	if (pIE->Length != WLAN_WMM_LEN)
+		return false;
+
 	if (!memcmp(&(pmlmeinfo->WMM_param), (pIE->data + 6), sizeof(struct WMM_para_element)))
 		return false;
 	else


