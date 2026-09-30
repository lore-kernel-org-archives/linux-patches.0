Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6617E37A825;
	Wed, 30 Sep 2026 17:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791146; cv=none; b=GDbnzh1EOimbL2ytRMrFLXIqKWjPCJrpFdrPFy7CEdBOBBFuAfBxvTg/KBGpxudWHc3gX7id8075LUW0wutMO+nwKr7dhmCVVk3dLXDUciC46pesQj91/dn6lkz0G+g2cv7iiMWu6y4/tLqDBCH9ChwmzcL3cem6UOIPm4TX+rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791146; c=relaxed/simple;
	bh=15pFfdy6TBSfenEBySaQW7FP5O1x+a2ZFz3PnCuCbs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mL4w/U800jvGPuAzujsM6RkSm91TtYruTaDr0JxwJSZ2Oo3Xpn6WjV4JEE3ahxlHhZ11C94GRUrwtI8D2GX09IlQNiFnhzA1e6AfzSjhOg3T6fN0wP/vxJqyBMKoGlXQ7k+QmP29Hypl4VC8tDXgVWLee7JGW9ijn0mXOlv2IOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKqXA+jD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKqXA+jD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEBF1F000FF;
	Wed, 30 Sep 2026 17:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791145;
	bh=X0AyVzHVb2rEHyOGcEhd4zpCb0aL7dUd3vj9yv6EBFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LKqXA+jD/WUvV6GoejVRMrG+HDELqOA39/8vsenE9GWCOiDxvN4Ub3t43eJz3Z44g
	 Yyl47BeBbUXjUYTfLGLFUXIH+WvLueXTm5W0ItmCnqd/VYeBJHfSnJ7KlwpHscmi3v
	 zLOP50H12NdMmWCGgTavEk6EKEdMAoKQQ13H17xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 200/752] wifi: libipw: fix key index receive bound checks
Date: Wed, 30 Sep 2026 17:21:10 +0200
Message-ID: <20260930152402.549587270@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 74ed3669f26803b1761c1f55403062bea44c3466 ]

libipw_rx() reads skb->data[hdrlen + 3] to extract the WEP key index in
both the software-decrypt key selection path and the hardware-decrypted
IV/ICV strip path. In both places the existing guard only checks
skb->len >= hdrlen + 3, which proves bytes up to hdrlen + 2 but not the
byte at hdrlen + 3.

Require hdrlen + 4 bytes before reading that item in both paths. This is
a local source-boundary check only; it does not change the key index
semantics.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260705083519.23567-1-pengpeng@iscas.ac.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
index ae9d026374953..32efaba48a568 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
@@ -417,7 +417,7 @@ int libipw_rx(struct libipw_device *ieee, struct sk_buff *skb,
 	    ieee->host_mc_decrypt : ieee->host_decrypt;
 
 	if (can_be_decrypted) {
-		if (skb->len >= hdrlen + 3) {
+		if (skb->len >= hdrlen + 4) {
 			/* Top two-bits of byte 3 are the key index */
 			keyidx = skb->data[hdrlen + 3] >> 6;
 		}
@@ -663,7 +663,7 @@ int libipw_rx(struct libipw_device *ieee, struct sk_buff *skb,
 		int trimlen = 0;
 
 		/* Top two-bits of byte 3 are the key index */
-		if (skb->len >= hdrlen + 3)
+		if (skb->len >= hdrlen + 4)
 			keyidx = skb->data[hdrlen + 3] >> 6;
 
 		/* To strip off any security data which appears before the
-- 
2.53.0



