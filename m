Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADE13FA5CC;
	Mon, 17 Aug 2026 14:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977734; cv=none; b=nSRwaLrybiRl7EPIfYCas6zGu7/r8oA245iMYgrX3m6glvBlaY5ipxOks+AkyS9LFQmuZXmlt3eiIHzxNTFdK6vM6dfRkWpXMgXjq9XLmXS4wHHmrY5A3ZpvQdF0qjIj5LlZzDXaWdq81alFpvXkTyhWEkir5WxRrjWzf+IRJvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977734; c=relaxed/simple;
	bh=6vmeINfvz7oUGrhPOiJ/TNL1U0ABRtN8Ca1KbMexX+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zcu0gkeyZ3wmLTnqFgra40uTgCH/J8dyF5bNvHlL8JHRRtGabch7vH/mMfdGc0Ri1pP01gZmmUsOPtQUG95FAzJeFfD3XrcchbV0fjWL4usgcUJ8O9P+lqckpbJyTXQvZgqsz04X2ti2JOAxf4Wx4sR/PRtvlGM/YJ+zqlTI/hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BCIVXmmH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BCIVXmmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31301F00A3A;
	Mon, 17 Aug 2026 14:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977733;
	bh=mNzIp+OXZZZVCLwMDkUmDW/VpiY1JI1esHxXqFAuSHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BCIVXmmHZgYT/JTL8klPXMaKEeyHnycgVn6DQJnSMaUvUNNfpijHrfi+gM9DaSdkY
	 Yr9okms0eW6loo+/sl7PkHA/q0WpTRQyK6Tn2JdKE6GyHtVc5Wceij5k41FeFbrv9d
	 GOo2ALiYR9UGbY0CtWJk+h+q4A2vqka8dJyaaMXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>
Subject: [PATCH 5.15 430/456] staging: rtl8723bs: fix missing shared-key auth challenge length check
Date: Mon, 17 Aug 2026 15:33:40 +0200
Message-ID: <20260817132555.963291453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
@@ -911,7 +911,7 @@ unsigned int OnAuthClient(struct adapter
 			p = rtw_get_ie(pframe + WLAN_HDR_A3_LEN + _AUTH_IE_OFFSET_, WLAN_EID_CHALLENGE, (int *)&len,
 				pkt_len - WLAN_HDR_A3_LEN - _AUTH_IE_OFFSET_);
 
-			if (!p)
+			if (!p || len != WLAN_AUTH_CHALLENGE_LEN)
 				goto authclnt_fail;
 
 			memcpy((void *)(pmlmeinfo->chg_txt), (void *)(p + 2), len);


