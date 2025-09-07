Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784962139C9;
	Sun,  7 Sep 2025 20:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277182; cv=none; b=U1JBbEq5cYihVjM4H/+649Ak1RqGZ231H0A9s37iJO4A365T6bZfq8MicY10LJUixhD6pE2Pkam/8VELpQcTtXBUgyhDWKazlIzgyA7gsYIPUf5Mtylj1f5epTRstHLXs97AYRWs6WSexscuvKRRSYhjYVgNYQeiULa2bPkfYRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277182; c=relaxed/simple;
	bh=pGVypDUrUc3+B2tlKzekorDtuo82CrgMLZv8pKWQeDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVT9xHWn1Tz/Ty5u9P+tVxIJDoGSf3UdAnRWq7EH65rrlllMUYBZh4vP7jWg93IDUxZx1JDxEiXeLGUVMXKRM3WlODVHic2u24f7XEhU9/20RKkIp/7wg4RiTUixGaPorvzeNgIjoluIUgK8WHbivf//k9mYg8wjuH8zY4HDXI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t4yWw5Fv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t4yWw5Fv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0194C4CEF8;
	Sun,  7 Sep 2025 20:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277182;
	bh=pGVypDUrUc3+B2tlKzekorDtuo82CrgMLZv8pKWQeDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t4yWw5FvE4g9cKuQ+R3qmyj5MJQAgDl/YzkXwoD+CQvbPvc0euVUvLUQBh2DEj6dr
	 lv7Sx/x1EAuy8svO2qkozHbcO+MspCOhkHDTzp+tusNisY1YY0Ky+P79NIS7dSCiqq
	 w/RwaQG3sNVKa2Pt4UxfBh3VsNPtqORMuR+iltzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.12 110/175] wifi: mt76: mt7996: Initialize hdr before passing to skb_put_data()
Date: Sun,  7 Sep 2025 21:58:25 +0200
Message-ID: <20250907195617.456775950@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 87b07a1fbc6b5c23d3b3584ab4288bc9106d3274 upstream.

A new warning in clang [1] points out a couple of places where a hdr
variable is not initialized then passed along to skb_put_data().

  drivers/net/wireless/mediatek/mt76/mt7996/mcu.c:1894:21: warning: variable 'hdr' is uninitialized when passed as a const pointer argument here [-Wuninitialized-const-pointer]
   1894 |         skb_put_data(skb, &hdr, sizeof(hdr));
        |                            ^~~
  drivers/net/wireless/mediatek/mt76/mt7996/mcu.c:3386:21: warning: variable 'hdr' is uninitialized when passed as a const pointer argument here [-Wuninitialized-const-pointer]
   3386 |         skb_put_data(skb, &hdr, sizeof(hdr));
        |                            ^~~

Zero initialize these headers as done in other places in the driver when
there is nothing stored in the header.

Cc: stable@vger.kernel.org
Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Link: https://github.com/llvm/llvm-project/commit/00dacf8c22f065cb52efb14cd091d441f19b319e [1]
Closes: https://github.com/ClangBuiltLinux/linux/issues/2104
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://patch.msgid.link/20250715-mt7996-fix-uninit-const-pointer-v1-1-b5d8d11d7b78@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -1834,8 +1834,8 @@ mt7996_mcu_get_mmps_mode(enum ieee80211_
 int mt7996_mcu_set_fixed_rate_ctrl(struct mt7996_dev *dev,
 				   void *data, u16 version)
 {
+	struct uni_header hdr = {};
 	struct ra_fixed_rate *req;
-	struct uni_header hdr;
 	struct sk_buff *skb;
 	struct tlv *tlv;
 	int len;
@@ -3115,7 +3115,7 @@ int mt7996_mcu_set_hdr_trans(struct mt79
 {
 	struct {
 		u8 __rsv[4];
-	} __packed hdr;
+	} __packed hdr = {};
 	struct hdr_trans_blacklist *req_blacklist;
 	struct hdr_trans_en *req_en;
 	struct sk_buff *skb;


