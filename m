Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B81D511225;
	Wed, 30 Sep 2026 18:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792204; cv=none; b=bgFsKWUuqDAi8o0X4iEZj6uGb6Ems/gadxGiugkM+Wbdgimkcz7mx9pn9kncyA7QSA8n+oBEkNkgzJMkSsalOJjGlMnTLwicIRde3S2QfNIas80DYpKZx5SXkJiR/h3q/mj4k9jt1YHwUofdh6rSNit5tPS7FNr6FjfZmmDm2ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792204; c=relaxed/simple;
	bh=5fxtZDVF0ZJ+cBDyHiFtURykfvMyGngmDQ06LXEn7p0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CggAPNjC7gIfuKFgXoofTljQNvMaVQw8JMEeyEeSHi+g6fyaB/1rMxSa3a2qAPC0crftHnoU48xEekuF+5amDOE9IHoCkehrgx+bQNn0m5oBAidJ4QkoT/UUTJYH3QQroZm5hN/pO77WX3c5DZqT9kk74Jf5pEgqBXPVqXyvCck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qKZ4Awue; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qKZ4Awue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882E71F000FF;
	Wed, 30 Sep 2026 18:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792203;
	bh=TBQcCuNSuacwytizKtzceuQESsbnGAtA6wAYi7W7Z/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qKZ4AwuetRk+o5vfxdQkCZCvVlS0lTRB6dv+vN0wMBU/lELUQhYDLkcjyLjbrs/Z+
	 fDJFD8CqGr3hAiuLkhKb/qYYQLvf/fxyLz2iFyP9HdykGHKbTH4X5Yc7JeXySLSWHu
	 gz/zmlOoE3rTlN65JtLdnzWnCSQrWNsJV/JgX63w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 573/752] wifi: rsi: fix heap OOB write on key removal
Date: Wed, 30 Sep 2026 17:27:23 +0200
Message-ID: <20260930152410.693825486@linuxfoundation.org>
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


