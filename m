Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6E33ABD99;
	Mon, 17 Aug 2026 13:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975089; cv=none; b=uqrtbIC8VUwHkc/X/qKYACdJW1qu0kvLFNTD/12oa0pLObkz0rVIdF5gVyS2LDOR6pxQQ4oFYOuAZoD4XIDf2nkWXyVrIEGOzP5KVLWRD47evfHJfeVf6hZjERHbl9wcvdM6OF2BGD92MHr0pnjgfFr4IFldooc+OkbbGvfpXno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975089; c=relaxed/simple;
	bh=W6OR/3jdz8iiGCWSDAQ0qoVtGkTq1VFRpW+v75RA5tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eue9YXXcNbYY4HWzjmT/a03qzgJVIofMsw5Dv0AeKodwh+A+zJykAj+kXnwLQnrNHud4iGmgi8bkNTnRTuQQcIEW9zBNrlfcifNpLZbPHsrfbR561smAx02bYZytx+R7MhapkqjXDOqVOHNXkNCq/Z/96xKTJ3ZE2vrIGpn1Ilk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGeEDUWZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGeEDUWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40ECB1F000E9;
	Mon, 17 Aug 2026 13:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975087;
	bh=82uiP2hhdYM++JcNqcNKNKw9VIEb0Z1h900iYQ1MzGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mGeEDUWZuyLIzYCdweNZv00mq2pF6ccxThlq9l7ltJZQR5QugHOcmP7UCz0KUJijL
	 AoNwKfiNQ4GQHF3VAMdOVciLoVadQ8FTDdE6c5ofSh8lceWDIvn70qmXb17Efl0dL0
	 XWx8dOd/Zy+Wat6+m4fTHVZqlduEYB8rVb3v8gug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.18 118/250] thunderbolt: icm: Preserve USB4 proxy data-valid bit
Date: Mon, 17 Aug 2026 15:31:19 +0200
Message-ID: <20260817132541.406977907@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

commit e48844ece5e3ed1d1eb865f6da2b16f62cd9f86d upstream.

The ICM USB4 switch operation request encodes two values in
request.data_len_valid: bit 4 marks the data payload valid, while bits
3:0 hold the payload length in dwords.  A zero length with the valid bit
set represents the full 16-dword data array.

icm_usb4_switch_op() sets the valid bit when a transmit payload is
present.  For payloads shorter than the full 16 dwords, it then assigns
the length to the whole field and clears the valid bit that was just set.
The payload is still copied into the request, but the descriptor sent to
firmware marks that data as invalid.

This affects USB4 router operations that send short payloads through the
firmware connection manager.  In particular, USB4 NVM writes can send a
short final block when the image size is not aligned to the 64-byte proxy
payload size.  Firmware may then ignore or reject that final block, while
full 16-dword blocks are unaffected because they are encoded as length 0
with the valid bit set.

OR the short payload length into data_len_valid so the valid bit is
preserved.

Fixes: 9039387e166e ("thunderbolt: Add USB4 router operation proxy for firmware connection manager")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/icm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thunderbolt/icm.c
+++ b/drivers/thunderbolt/icm.c
@@ -2325,7 +2325,7 @@ static int icm_usb4_switch_op(struct tb_
 	if (tx_data_len) {
 		request.data_len_valid |= ICM_USB4_SWITCH_DATA_VALID;
 		if (tx_data_len < ARRAY_SIZE(request.data))
-			request.data_len_valid =
+			request.data_len_valid |=
 				tx_data_len & ICM_USB4_SWITCH_DATA_LEN_MASK;
 		memcpy(request.data, tx_data, tx_data_len * sizeof(u32));
 	}


