Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC4342DFEC;
	Tue, 21 Jul 2026 22:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674248; cv=none; b=gtcCP5asDpP9tRsDKcDMmndvhsGTD1Snd6MMcVjKdbwaOSnOlpeHtPReXGRf4FEwjDJX7lVqHPdA06LvLHbJmS+onj5dA8lW+9Be8+qdyMrZ/wU/rzQNUNWbP0GFPWCWCfA/3il5hWI9awHx2UThmVweSCqm3wmw8JYCtK9qWro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674248; c=relaxed/simple;
	bh=WIBgnav9bXPjWr9XHpFXZM9kn+9xUdYJ5gyRifekB8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NaB5UIaGq/iFvmvaep3n+HSCe9K9q7zRh0OZIezWRLt+Q9R7nEWgmBv74MwEMInT/Sb1JyKN8YfIL3TUaTEgBQwgfptgovQNOcWriNockUbH3L/VlcrDQE7AI3jLXIgp57aBKE8pWOfSa0V7z4iYn3p5gsrWYRPJQldLzZw7FC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMKj01lX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMKj01lX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E084D1F000E9;
	Tue, 21 Jul 2026 22:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674247;
	bh=xAxCBoQ9h+usBWi2Mr02Nzi8rCYFB0UmmY8xs4jwstg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yMKj01lX1FiQYJh22tZCpvk/A4nfE3+BZBm2AR6ufeGpyaKtObD5mpcdj/clE2YRG
	 5qaLi9AcHol69EVTUHDrmWd/Ax0kjODfDaNenKraqX6gEk2zjwC+gS+7LmDZqw9ANg
	 aE0U56GSIU9LimVEvnT8qenVCgAVwP7ABcc738X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.10 469/699] batman-adv: tt: prevent TVLV OOB check overflow
Date: Tue, 21 Jul 2026 17:23:48 +0200
Message-ID: <20260721152406.276274643@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 7a581d9aaba8c82bd6177fa36b2588eea77f6e2b upstream.

A TT unicast TVLV contains the number of VLANs stored in it. This number is
an u16 and gets multiplied by the size of the struct
batadv_tvlv_tt_vlan_data (8 bytes). The size can therefore overflow the u16
used to store the tt_vlan_len. All additional safety checks to prevent
out-of-bounds access of the TVLV buffer are invalid due to this overflow.

Using size_t prevents this overflow and ensures that the safety checks
compare against the actual buffer requirements.

Cc: stable@vger.kernel.org
Fixes: 7ea7b4a14275 ("batman-adv: make the TT CRC logic VLAN specific")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/translation-table.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -4338,7 +4338,8 @@ static int batadv_tt_tvlv_unicast_handle
 					     u16 tvlv_value_len)
 {
 	struct batadv_tvlv_tt_data *tt_data;
-	u16 tt_vlan_len, tt_num_entries;
+	u16 tt_num_entries;
+	size_t tt_vlan_len;
 	char tt_flag;
 	bool ret;
 


