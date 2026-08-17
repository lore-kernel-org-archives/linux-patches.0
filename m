Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB45E3AAF76;
	Mon, 17 Aug 2026 13:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975123; cv=none; b=dMN45ztNfzF4NTvmemO5SeZALkbFuuobJH20TRNgUtzBs/c2pLkMG/uOhtQ+fSLdPaVMhxjanpxDiFcpLjcxurkQspMPUOBurYZE77HYJ4+NsvuWDvLQLsOLKOf2pQZnMntOawdMcL6VkP5sTGq8XiLieA0w4QVHYamsOM9+o+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975123; c=relaxed/simple;
	bh=DIBFq7B6WqUBXppXIEiMs40bK19Neh5ecQr5TL/uweo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIY/78HlNgi7awMOsxK5FqXHiDszSRU9ietqvcD8ht64dC/puvIHfkXCfagKXO4tgnXp4NQbT5TEaERV9wT5alFiCW6o8q8IzGw1PdTp4e5G1DR2+XjVy22IZqYVe486Y2ezoJ5M3gVKeBQ5w5NIMHyxw0sGgcX3h6SESFJLljU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=avC54Q4r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="avC54Q4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64921F000E9;
	Mon, 17 Aug 2026 13:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975122;
	bh=4d4V7WXVpfYQ+TVqy17iRAPf4vqlvn82vCA/EJl2QFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=avC54Q4rSUeQ2TKvEMr2W13/Hazz04nTEjorx3Z8XXBloPFD9Kw2/YpKlKSC3SJZo
	 rJkjlUJUKw/3lGYc5nfqmN9Vz8C1t5bUtz/K/09Nq4UmVZHbO+rJMyXp4htzRFmXKj
	 SCROsQ5A9ZJb80Y7Ncn23xKeizFvDlqMGuH2QH+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>
Subject: [PATCH 6.18 171/250] staging: rtl8723bs: fix OOB read in WMM_param_handler()
Date: Mon, 17 Aug 2026 15:32:12 +0200
Message-ID: <20260817132543.612492362@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Muhammad Bilal <meatuni001@gmail.com>

commit ae21407350151bddfd4fea7aa39bd0643c0ca9d3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_wlan_util.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/staging/rtl8723bs/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8723bs/core/rtw_wlan_util.c
@@ -692,6 +692,9 @@ int WMM_param_handler(struct adapter *pa
 		return false;
 	}
 
+	if (pIE->length != WLAN_WMM_LEN)
+		return false;
+
 	if (!memcmp(&(pmlmeinfo->WMM_param), (pIE->data + 6), sizeof(struct WMM_para_element)))
 		return false;
 	else


