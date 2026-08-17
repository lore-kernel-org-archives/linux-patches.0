Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90023ABD99;
	Mon, 17 Aug 2026 13:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974382; cv=none; b=gY5w2CZEHR+B3ZBVytoJI5pl/gr0vgar7/QS2hEVPJ8bm8s/2LqK1SfXyS9AE60UVCuapnRhgp/95xp3X4lVIS++ZLS6jn1fgLNbDnJFSUj/k4/8K+0vZjqEFDZtYKKb0OCGg2h/YBFjAEjIbR2I7EJeiDYWKVUmT4l5zoodeKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974382; c=relaxed/simple;
	bh=NEcLOtrNRjoYB/aCF4mTdSWm9TjNngDD1vCj2cHT3gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwxFyOZgp4kL/cb9rKUyK4xBeB3oAPEjr/7r434grn09wz2FWyxdaCrE54P6Df5Hs+O0KTlkG0m53UDLCtk8KmJupVxT3VezzU2Alfe7hIJVRGjQb++16imO8/+VEEIx7fMIZJbBnSfz0VseK3uF+BzE2G8q6R3tq5tooab1TQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pnc6kHdY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pnc6kHdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE751F000E9;
	Mon, 17 Aug 2026 13:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974379;
	bh=PoBwaBsIhFEk3OVNiUsK9kZustvZRejV+AxvEoJpmVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pnc6kHdYB0TUMLJotisTxIfiaElBFnls85tS7VfI0SZ3oaIFwl1WAHpJRNTs06NGH
	 v+gSPg8YIgHh2JSer5Bc2rkHgOgWSBGL9BFAb5utsHMeU7kzDvIEiptbbPDtPOm7hG
	 STqouWRmw7KasuDpJ5hP+k/2NS69O/lxDrBr6G6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>
Subject: [PATCH 7.1 185/271] staging: rtl8723bs: fix OOB read in WMM_param_handler()
Date: Mon, 17 Aug 2026 15:31:50 +0200
Message-ID: <20260817132544.430070590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -693,6 +693,9 @@ int WMM_param_handler(struct adapter *pa
 		return false;
 	}
 
+	if (pIE->length != WLAN_WMM_LEN)
+		return false;
+
 	if (!memcmp(&(pmlmeinfo->WMM_param), (pIE->data + 6), sizeof(struct WMM_para_element)))
 		return false;
 


