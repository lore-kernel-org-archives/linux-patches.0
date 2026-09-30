Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CD14E0B66;
	Wed, 30 Sep 2026 16:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786156; cv=none; b=OJDl/s7foDV6aPHIg1ETkzfyeNHljPvJ4KNS8J7VfKRLg79sWsYu06w4jeckvwUCaT75UB4JAksZ0TLas5VDzf6aBcmX+VNEuhLacyTCs/dvMR6fcyWW0JP6+FHTZN0S9jnE0QQymctnsPFtKH5cZKIMVTi7g5HiU9I71A1dbEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786156; c=relaxed/simple;
	bh=t/1nV6oWukBk52WimVZ1ld2PrWwTy7OJodiUc7Kl8bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2GE85lGWlImDK0NzZNTimZzuewl5N+uuxCyVpMwlcgmC/gCDeHx682KvZAkTgjtSGg3BzwmZ0thaIwPxnFwG/xQol7lbuRQRCQeb19qh8K4N3szvyoursSQquuquOeeNKBdQ+/kHdp5XRpTxdj+iYd6UHwendjCarqioIkeQRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2vNCXVJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2vNCXVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2CC1F000FF;
	Wed, 30 Sep 2026 16:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786155;
	bh=F6tTUroekxM1ravOliI0+tMGvjPJlQfDGm7oAqQ0SHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H2vNCXVJMz1rGB4XflvTrTiIjnwaEOhJyHdVLbIKpXwHy0LqlWEBJLz8+ILD0tcsd
	 6hHbYeWmUvbps2Xr2J0/rieNKAtdLv1l0gLxP+bQXAHNC3EHZtmmVeF1elMMP1Uq//
	 ufokaTOARKrV3CiIaQhymKNKnjWF5tqkQVyvfOa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 762/982] wifi: rsi: fix heap OOB write on key removal
Date: Wed, 30 Sep 2026 17:24:58 +0200
Message-ID: <20260930152433.120515873@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianchu Chen <flynnnchen@tencent.com>

commit e6c5ed7a98d7bc8b0f7918246f1c90ddb3f79dfa upstream.

When a key is removed (data == NULL), rsi_hal_load_key() runs:

	memset(&set_key[FRAME_DESC_SZ], 0, frame_len - FRAME_DESC_SZ);

set_key is a struct rsi_set_key *, so the subscript is scaled by
sizeof(struct rsi_set_key) (160 bytes): &set_key[FRAME_DESC_SZ] is
skb->data + 2560, and the memset writes 144 zero bytes starting
2.4KB past the end of the 160-byte skb data buffer, corrupting
unrelated heap objects. The intended byte offset would have been
(u8 *)set_key + FRAME_DESC_SZ.

The write fires on every DISABLE_KEY callback, so plain disconnects,
roams and interface teardowns trigger it on real networks.

The memset is redundant: the whole buffer is zeroed right after
allocation, so the frame sent to the device is byte-identical
without it. Drop the else branch; normal operation is unaffected.

Discovered by Atuin - Automated Vulnerability Discovery Engine.

Fixes: dad0d04fa7ba ("rsi: Add RS9113 wireless driver")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
Link: https://patch.msgid.link/90bb2b07007942064c04aa3729cedd9eb1e930b1@linux.dev
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -852,8 +852,6 @@ int rsi_hal_load_key(struct rsi_common *
 			memcpy(set_key->tx_mic_key, &data[16], 8);
 			memcpy(set_key->rx_mic_key, &data[24], 8);
 		}
-	} else {
-		memset(&set_key[FRAME_DESC_SZ], 0, frame_len - FRAME_DESC_SZ);
 	}
 
 	skb_put(skb, frame_len);


