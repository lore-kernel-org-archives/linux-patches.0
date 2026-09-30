Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173B64E01E3;
	Wed, 30 Sep 2026 15:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783628; cv=none; b=uGXkVeXjRJ+U9u33eT4o+1BqcxmUCVv+LBrU3j7mJ5TITDTCYX1fcYd890nSIWfoLn4VNKqU3jukGXcXrgdO2Fxj/QXGcC+iWpP7QxsjTn87SVxrkiXH7B3hyRv0Kwv9qmOC0RJGAp4SldHzsB2/ekIuavDsH872zKV+ktwl/5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783628; c=relaxed/simple;
	bh=GO+hSOyQ1qqCy4TCPJmDaHiYF9wRqL1wYJ8qqPbcclI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=feUH+sFDDfNigIaAQ23601aBBKq7/JDiq98/XCJmNViqv88yEF9J80qCUDcyK659ki0//+tS7WSXiGA4RymoUA5HvNTfxse0+NkzMSo9IqsX7DMAYIltvP2yJnveIxjeuDeP+emvhiY3o2ylvieVJWwIGUzFQ8nGrBAXMepSN58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GyO9CXRZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GyO9CXRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3FE1F000FF;
	Wed, 30 Sep 2026 15:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783620;
	bh=2Rw0XyRJ8Kxl/ExhyS8giPt15Ico3D4UXYWLyvhmpBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GyO9CXRZoDVjR4vW2I5iot5F37Bj0IEFuBjUUso9FC/RL+yRNBjvGhFrIPOYVm7KF
	 8ITf8nwV2PzR6ChRgHWSVO5STHgaB5u7T54YZW100DEOk5fewtvdfQQmizxvqwwY50
	 ojO2+0VSYT8B2xee8kyUyyiYLRql4I3X3YTvhdBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 464/595] wifi: rsi: fix heap OOB write on key removal
Date: Wed, 30 Sep 2026 17:25:57 +0200
Message-ID: <20260930152357.662323040@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


