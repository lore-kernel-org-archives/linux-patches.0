Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A63D27A476;
	Thu, 28 May 2026 20:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998505; cv=none; b=tK9VI6NMJ5VOtNSBm2S1/tOGZz+3wP79ugBRWa+WyUlELlZBLCy6Dhsa+sJdTh1TjeHmjovR0DCyaKYIpROT654QCJkT2FBH/jZA+YlMo3oMRNGVr7Ws+oLLPtIAtoiN8wqzzSLbOvIxMCptRBJisNW8hfoOSKSfuKHtjCTDB9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998505; c=relaxed/simple;
	bh=aXUS2bmaw5yGyC/EIPX1q1bGHKMiLhyDErRRPgsvr8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NNndssMwYroooVCqu08L0nW6B2WXE25CmMnPiRGA+7JA9RhBN56GzEt9YDQ+whhMAqFx9+NXRGodraCkw+dUSldOlDuzwXmEuKFKKDhs4/IsXie2gMLXzU5NvgaMEuU7mLPWdWqfq0kM1ljTQKxOS3/DJ9rxJ4bURm0UlNpEpGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oOEvnlL2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oOEvnlL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71861F000E9;
	Thu, 28 May 2026 20:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998504;
	bh=rrkVydFshfKH//iqI7uR9h/4udoXseSK/12ujXd+4m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oOEvnlL2fSs4OYuMc+8PynTKJclJYNKGL4zHZ0q1b4tUsdpl//OZU4kfFcwByD8xq
	 fJtHfYomq0zc4fe6GoH7kb9GFwyJnmJHmi0US2n81oHJ4+0dfk0042nGoek6wk+YHt
	 0l7D6UBEkbJqzSuVnCGZ92+QQ4ssvTw5y+z+5y0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.0 160/461] batman-adv: tt: reject oversized local TVLV buffers
Date: Thu, 28 May 2026 21:44:49 +0200
Message-ID: <20260528194651.682441378@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 1e9fab756f8395096d5bba7be0c373c4c8f5d165 upstream.

The commit 3a359bf5c61d ("batman-adv: reject oversized global TT response
buffers") added a check to ensure that a global return buffer size can be
stored in an u16. The same buffer handling also exists for the local data
buffer but was not touched.

A similar check should be also be in place for the local TVLV buffer. It
doesn't have the similar attack surface because it is only generated from
locally discovered MAC addresses but the dynamic nature could still cause
temporarily to large buffers.

Cc: stable@kernel.org
Fixes: 7ea7b4a14275 ("batman-adv: make the TT CRC logic VLAN specific")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/translation-table.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -877,12 +877,12 @@ batadv_tt_prepare_tvlv_local_data(struct
 {
 	struct batadv_tvlv_tt_vlan_data *tt_vlan;
 	struct batadv_meshif_vlan *vlan;
+	size_t change_offset;
 	u16 num_vlan = 0;
 	u16 vlan_entries = 0;
 	u16 total_entries = 0;
 	u16 tvlv_len;
 	u8 *tt_change_ptr;
-	int change_offset;
 
 	spin_lock_bh(&bat_priv->meshif_vlan_list_lock);
 	hlist_for_each_entry(vlan, &bat_priv->meshif_vlan_list, list) {
@@ -897,8 +897,10 @@ batadv_tt_prepare_tvlv_local_data(struct
 	if (*tt_len < 0)
 		*tt_len = batadv_tt_len(total_entries);
 
-	tvlv_len = *tt_len;
-	tvlv_len += change_offset;
+	if (check_add_overflow(*tt_len, change_offset, &tvlv_len)) {
+		tvlv_len = 0;
+		goto out;
+	}
 
 	*tt_data = kmalloc(tvlv_len, GFP_ATOMIC);
 	if (!*tt_data) {


