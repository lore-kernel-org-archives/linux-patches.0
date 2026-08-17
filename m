Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654233AAF76;
	Mon, 17 Aug 2026 13:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975126; cv=none; b=c9kWO8p6fGgwtpBl7pmDmM1lBVLWSzt8Cp8+70Vq2pvNaa/oHHVobUWjdEDX7jrf0KEktTdI1V4lc89Db2oXsMGi3+wMuUkMW9jQXSrfXKlDHR3FrnAe1+vsK2GI3l20h3qZ+zpDPLeZr1uWRMCjECDcrGN/xxjKgRYLEiypejY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975126; c=relaxed/simple;
	bh=nj7QygZIK79FVl+N4oWytrAIMPkcrfv+5vDHjFUMm4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cell9EMZwIrmkWA5QCgNlTTzFf3SQbUYCEV1tcGOcDMkcaJ0Nja4HOR9vOsfJtfZwA0IIJe0P3Y3oEJK2YXmFjRk0UTq/Myzgl7GStqPLyyV27eRBEAdtQVr1eqxeZ6qo7hDLEpoQgvysYomKJjfpJAA4JGntv7btzEPquSwqTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YsH5qfTR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YsH5qfTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28081F000E9;
	Mon, 17 Aug 2026 13:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975125;
	bh=fCRQAwpuKjAsQtODs41hU2bYb7jNAFhg8Zk9RtWZTAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YsH5qfTRf6ZmHjtcRL9MOLm6tW6mhK/kAoofFg5ZxaZ56g3x7SB3sWgWSeosTopXT
	 LDHS4h0ynF3lhoMcIYdpbML8di851qIymGyvgmlZ8nsmqV0vZ8RxWJUuHTvRDKTKP+
	 Fa4QpbxyS1F0RHkAY2OoKxHj/aMYd1g6aNNw9UWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>
Subject: [PATCH 6.18 172/250] staging: rtl8723bs: fix missing shared-key auth challenge length check
Date: Mon, 17 Aug 2026 15:32:13 +0200
Message-ID: <20260817132543.647258867@linuxfoundation.org>
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

From: Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>

commit 2c56ef658ac8c6bca36bc5574715e8f717207c6c upstream.

The WEP shared-key authentication handler uses the challenge-text
element's attacker-controlled length without checking it against the
fixed 128-byte chg_txt buffer.

In OnAuthClient() the length from rtw_get_ie() - up to 255 - is used
to perform memcpy() into the 128-byte pmlmeinfo->chg_txt, so a
malicious AP sending a malformed WLAN_EID_CHALLENGE element can
overflow/underfill chg_txt by up to 127 bytes. It is reachable over the
air, before association, during shared-key authentication. In the case
of an overflow, the driver can write out of bounds. In the case of an
underfill, the driver can echo stale buffer memory.

The challenge text is defined to be exactly 128 octets, which is
already provided as the WLAN_AUTH_CHALLENGE_LEN define; require the
element to be exactly that length before use.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>
Link: https://patch.msgid.link/20260720082409.168379-1-npetrakopoulos2003@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
@@ -913,7 +913,7 @@ unsigned int OnAuthClient(struct adapter
 			p = rtw_get_ie(pframe + WLAN_HDR_A3_LEN + _AUTH_IE_OFFSET_, WLAN_EID_CHALLENGE, (int *)&len,
 				pkt_len - WLAN_HDR_A3_LEN - _AUTH_IE_OFFSET_);
 
-			if (!p)
+			if (!p || len != WLAN_AUTH_CHALLENGE_LEN)
 				goto authclnt_fail;
 
 			memcpy((void *)(pmlmeinfo->chg_txt), (void *)(p + 2), len);


