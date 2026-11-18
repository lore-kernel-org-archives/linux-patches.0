Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058028;
	b=uXmnNikf4MrMPC+a368g5Nsd7sOuiv5UREK1so6oyCKIQhkI5fP8YIsVXl29KbJggdhs
	 JtYtodn2AnVRyBTyGbFpqEev7vW9bUJt7wXe2Lu8Q2GGUwMVjNhfaAk7Kov2jgKedcJlY
	 LQFP7wr1skVz18+I+SBm8PJbVmdU6yurTfCvxezr/l3EQg6U3s1QfSkm1dShx84XjjO1L
	 0vkx3GFX3xBmvz+WovmO90o3Zs6Q8ObUOy71rzQ8rqV+HF5dnmIh+93kDwxD49MrClbMN
	 hPDieIycKohuXUwT3qxdss1vRmu+E/1mJUsGYImq1fFaziJzCamwvu16zdO9uji6Kjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058028;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bhngQn23qxqfKqYWOn91KzTS+fUHKussVym54tkvB2A=;
	b=J7EyQmIl83xhHouOF1I3vfH6ANwlzZVFQy5NBwIHm8ZDczE9ocOyrVbajLplk8CHLPO1
	 e3gykxZE5WH3T6nS8SX73W0CV/iCkzsUgw5LKHGqbhgpzx4Ly4BayIYuWAPftREXcWVDq
	 Gy4XZa9xiLRsHJQMe1DbLi2vGRbJLwsMsVkcC4rWaBlLmGR2y7OYyKrXP7bll0dxWq+gp
	 OZ7f0IomF4np9BTb9zEu/KY46/ytdQpGnvFlbKPEdAj1HICIOIkqwdf/OtvFGci7Eth8/
	 DzOiN8ZfEHHcMawwMJxNJE3EKgohQeJSIAJQKyDood3Uo/MWetw5RkE6SJef+1PVVYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QSOwKsEK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D73606A31C;
	Thu, 19 Nov 2026 03:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QSOwKsEK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA931F000C4;
	Thu, 19 Nov 2026 03:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058028;
	bh=bhngQn23qxqfKqYWOn91KzTS+fUHKussVym54tkvB2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QSOwKsEKiVxtpR1/e5y8CL9ap7T/9hK09A0Tgl3bH2AwhrKY2ELkDWrzjxrPtkUO5
	 Vs5FuSqVbOSOZv7/W6WzmpGFH93Z2B8fYyJFmS1wmqtpegiWTB8PU0/N9pmF4fh+yk
	 QPRfJr/jq1PhVdqLWO9hpvzdUG5b+RyQuiwiVnKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0339/1848] staging: rtl8723bs: fix protected RX frame validation in decrypt path
Date: Wed, 18 Nov 2026 15:39:37 +0100
Message-ID: <20261118145926.657134848@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Retained the existing DBG_871X() debug message in the relocated decrypt-failure branch. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_recv.c | 25 ++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_recv.c b/drivers/staging/rtl8723bs/core/rtw_recv.c
index 0e6fb03ff85c8..8ed6ded1bef79 100644
--- a/drivers/staging/rtl8723bs/core/rtw_recv.c
+++ b/drivers/staging/rtl8723bs/core/rtw_recv.c
@@ -451,7 +451,21 @@ union recv_frame *decryptor(struct adapter *padapter, union recv_frame *precv_fr
 	RT_TRACE(_module_rtl871x_recv_c_, _drv_info_, ("prxstat->decrypted =%x prxattrib->encrypt = 0x%03x\n", prxattrib->bdecrypted, prxattrib->encrypt));
 
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
@@ -1426,6 +1440,11 @@ static sint validate_80211w_mgmt(struct adapter *adapter, union recv_frame *prec
 				goto validate_80211w_fail;
 			}
 			precv_frame = decryptor(adapter, precv_frame);
+			if (!precv_frame) {
+				kfree(mgmt_DATA);
+				DBG_871X("%s mgmt descrypt fail  !!!!!!!!!\n", __func__);
+				goto validate_80211w_fail;
+			}
 			/* save actual management data frame body */
 			memcpy(mgmt_DATA, ptr+pattrib->hdrlen+pattrib->iv_len, data_len);
 			/* overwrite the iv field */
@@ -1433,10 +1452,6 @@ static sint validate_80211w_mgmt(struct adapter *adapter, union recv_frame *prec
 			/* remove the iv and icv length */
 			pattrib->pkt_len = pattrib->pkt_len - pattrib->iv_len - pattrib->icv_len;
 			kfree(mgmt_DATA);
-			if (!precv_frame) {
-				DBG_871X("%s mgmt descrypt fail  !!!!!!!!!\n", __func__);
-				goto validate_80211w_fail;
-			}
 		} else if (IS_MCAST(GetAddr1Ptr(ptr)) &&
 			(subtype == WIFI_DEAUTH || subtype == WIFI_DISASSOC)) {
 			sint BIP_ret = _SUCCESS;
-- 
2.53.0



