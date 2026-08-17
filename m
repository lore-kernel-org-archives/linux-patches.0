Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8053EF0DC;
	Mon, 17 Aug 2026 13:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974384; cv=none; b=Z+dWotic8H6vI0Wg1H3OqSrKHog2hFyw/h/qTNjYTXTWlThxl9X3WmaR3e3ObGfYfrMxKRYHwOZG82QYlyw91LMDiqaQG3YvomCTmT8JHWQk9dt0fHOi5BPJLRRAwFmLOZgUe1nUa2am5i/kg+pP+JMTHmZAox8oYiI8DdG9VA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974384; c=relaxed/simple;
	bh=YXpl2mM43kZH/+PAsWyrQ5HXN3HECk/BQaTBd+CF2xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdHD8BAOMC5dQLl3rXulwA5K7mM0BXL4ccw6B2wrRySZ9Y0gT2g5/HLqVNkqQKa9BCK0qSCIMQn5rsYvJ+m+sGstnasTaXsf/FFf+FCkZX3IWDLlTzdG19kW9k91EdscnUVlKeyVbcv4xXItKi5VasQJZa9oTvyW4Xp7AGWcj7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uwvrqYhJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uwvrqYhJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30DC1F00A3D;
	Mon, 17 Aug 2026 13:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974382;
	bh=S11cEXBi/dUoHRCesxYlqtSnet63n2Eaf7UHihvkf6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uwvrqYhJYRppjLWOg7wVMPgbvRD2LLetnpa6iF/nq0Zi69UW7v2Re6Ejvj9K6zNAb
	 bGPMZ0T+tYd/FaXBtZ+67wvySctKVQawp/W38Sj8dQWMZcH0H3P/UIozoK1F4sU1hH
	 3veoJnkZ+p4hx8lMjh75aEev2vMDHPnzpq+hBpC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>
Subject: [PATCH 7.1 186/271] staging: rtl8723bs: fix missing shared-key auth challenge length check
Date: Mon, 17 Aug 2026 15:31:51 +0200
Message-ID: <20260817132544.465007146@linuxfoundation.org>
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
@@ -897,7 +897,7 @@ unsigned int OnAuthClient(struct adapter
 			p = rtw_get_ie(pframe + WLAN_HDR_A3_LEN + _AUTH_IE_OFFSET_, WLAN_EID_CHALLENGE, (int *)&len,
 				pkt_len - WLAN_HDR_A3_LEN - _AUTH_IE_OFFSET_);
 
-			if (!p)
+			if (!p || len != WLAN_AUTH_CHALLENGE_LEN)
 				goto authclnt_fail;
 
 			memcpy(pmlmeinfo->chg_txt, p + 2, len);


