Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052183;
	b=ME+bBZy2KPJMdSk05Svt0OjL4kqKtyI1PXBukoFD0MFo72wHUw/IJBWe0XyaX4cYmooS
	 pQnRNwbPTtYv9pvUJtygqvS3Gtl29n5WoEEaq7DlS07Rbh+ovIcN74z+cN9L6258WAl13
	 p6FrAtz3ekBbLf7en404oDBSRY2wQNLkqeDYSgdwLi17zGf1IF2EKAqLMcQakz3qLknUH
	 01qzyguAiaE4x6ljBSgwQyFWZooAoWHDos865pJEo0WOmInMk0PdM0bjDkVYgGDdV9dyT
	 AEJXMxT2XvSatN732QSdhh/8YFBUtfXnxsDGnUsAI371lkk8njGeSSrPZMAFwB4dqJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052183;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MJYmatPbEYg36e+J4JVL6wmESmPCKBCZLaEEeIJNDV0=;
	b=ngrgLCHECIRHYDIIOyTpBUMk+Hk5oR2X4XFJ9TI8gtN6dkBGpjy95UiFnop2H084bMT3
	 //YSEmlA1p2qaWWmJ/rk6fQNH875/+rZq7pN2vQPtY69gRn1YKJmLsfjnfrkz1TrtWzUN
	 QNcrQMmjolETF5MWzLeZY3/EWlr0GBdbhdvFsRNP0x6Gh2iNCFbEhtI/0k8mnL864EkQx
	 zWxpggTplxsrdU5pv+s+T0kI4rLp1sYQAABw9A7noydZC//UdJBOpWVchwUP92G3J272l
	 eNWGZwpBsHQDsBkONZZgKErmtx6wxDo7OjOmbyD3Y3EbsBpvwdQZfpkeL70WmHthTGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sNNzJbuK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FC9606A31C;
	Thu, 19 Nov 2026 01:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sNNzJbuK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5299B1F000C5;
	Thu, 19 Nov 2026 01:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052182;
	bh=MJYmatPbEYg36e+J4JVL6wmESmPCKBCZLaEEeIJNDV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sNNzJbuK2eDctSccilwy6QWdAUKhSY91S9Ubh2+bd6xquWcxDdGdcxVQOXHHUhqHv
	 6vJV7QxIdKy00RhxvE/0HOS2PQd7XOYvliINXcpiZ7Kol6zqYOF0gakn74EXK953f+
	 90gZlj2avu6YhqCUU4NF2UNbrYgE3clDjBI7ckr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0423/2214] staging: rtl8723bs: fix protected RX frame validation in decrypt path
Date: Wed, 18 Nov 2026 15:34:59 +0100
Message-ID: <20261118150027.803697180@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianchu Chen <flynnnchen@tencent.com>

[ Upstream commit 495cb31c791bdf3f9efef255a9587b05b0526c9d ]

The RX software decrypt path mishandles crafted protected frames from a
malicious AP in two ways:

1) decryptor() never checks that a protected frame is long enough to
hold the 802.11 header plus the per-cipher trailer.  All of
rtw_wep_decrypt(), rtw_tkip_decrypt() and rtw_aes_decrypt() compute

	length = hdr.len - hdrlen - iv_len;

and act on the result, and recvframe_chkmic() similarly computes

	datalen = hdr.len - hdrlen - iv_len - icv_len - 8;

for TKIP (the 8-byte Michael MIC is not accounted for in icv_len).
A frame shorter than hdrlen + iv_len + icv_len (+ 8 for TKIP) underflows
these unsigned subtractions, turning into a ~4 GiB iteration count in
aes_decipher()/arc4_crypt()/rtw_seccalctkipmic() or a ~4 GiB crc32_le()
length, causing out-of-bounds reads/writes of up to ~4 GiB starting from
the rx skb.  Reject such frames in decryptor() before touching the IV;
this covers all three ciphers and the TKIP MIC check, and also keeps the
unconditional iv[3] access within the frame.

2) validate_80211w_mgmt() keeps using the frame - two memcpys through
the stale rx_data pointer and a pkt_len update - before checking
whether decryptor() returned NULL.  On decrypt failure (e.g. a unicast
protected deauth/disassoc/action frame with a bad MIC, which this path
always software-decrypts) the skb has already been freed, so this is a
use-after-free read/write, and the caller's error path frees the frame
a second time, drifting free_recvframe_cnt.  Bail out immediately when
decryptor() fails, freeing the temporary mgmt_DATA buffer first.

Discovered by Atuin - Automated Vulnerability Discovery Engine.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Assisted-by: LLM
Cc: stable@vger.kernel.org
Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
Link: https://patch.msgid.link/8ee3bdd1c45034200cb1aa9a7e9b575b9584643a@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: Adjusted context for older syntax while preserving IS_MCAST() and rtw_zmalloc(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_recv.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_recv.c b/drivers/staging/rtl8723bs/core/rtw_recv.c
index 5b0a596eefb77..f6585c034a902 100644
--- a/drivers/staging/rtl8723bs/core/rtw_recv.c
+++ b/drivers/staging/rtl8723bs/core/rtw_recv.c
@@ -392,7 +392,21 @@ static union recv_frame *decryptor(struct adapter *padapter, union recv_frame *p
 	u32  res = _SUCCESS;
 
 	if (prxattrib->encrypt > 0) {
-		u8 *iv = precv_frame->u.hdr.rx_data+prxattrib->hdrlen;
+		u8 *iv;
+		u32 min_len = prxattrib->hdrlen + prxattrib->iv_len + prxattrib->icv_len;
+
+		/* TKIP appends an 8-byte Michael MIC that icv_len doesn't account for */
+		if (prxattrib->encrypt == _TKIP_)
+			min_len += 8;
+
+		/* a protected frame must be long enough to hold the IV and ICV/MIC */
+		if (precv_frame->u.hdr.len < min_len) {
+			rtw_free_recvframe(precv_frame,
+					   &padapter->recvpriv.free_recv_queue);
+			return NULL;
+		}
+
+		iv = precv_frame->u.hdr.rx_data + prxattrib->hdrlen;
 		prxattrib->key_index = (((iv[3])>>6)&0x3);
 
 		if (prxattrib->key_index > WEP_KEYS) {
@@ -1374,6 +1388,10 @@ static signed int validate_80211w_mgmt(struct adapter *adapter, union recv_frame
 				goto validate_80211w_fail;
 			}
 			precv_frame = decryptor(adapter, precv_frame);
+			if (!precv_frame) {
+				kfree(mgmt_DATA);
+				goto validate_80211w_fail;
+			}
 			/* save actual management data frame body */
 			memcpy(mgmt_DATA, ptr+pattrib->hdrlen+pattrib->iv_len, data_len);
 			/* overwrite the iv field */
@@ -1381,9 +1399,6 @@ static signed int validate_80211w_mgmt(struct adapter *adapter, union recv_frame
 			/* remove the iv and icv length */
 			pattrib->pkt_len = pattrib->pkt_len - pattrib->iv_len - pattrib->icv_len;
 			kfree(mgmt_DATA);
-			if (!precv_frame) {
-				goto validate_80211w_fail;
-			}
 		} else if (IS_MCAST(GetAddr1Ptr(ptr)) &&
 			(subtype == WIFI_DEAUTH || subtype == WIFI_DISASSOC)) {
 			signed int BIP_ret = _SUCCESS;
-- 
2.53.0



