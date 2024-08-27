Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808051C688F;
	Tue, 27 Aug 2024 15:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772806; cv=none; b=G362SMsmNLIICgVaRNBC61Qd/zCc149PSSuMU1pwzvxrcaCVrHUJqAAU2e/enrbZgkWbSozHASKYfolgRx8dz8HokgbJsA45GqFCwtzCmDH/dfXr4kKNtj/W0aJP1JYX41H4qJvhXoxOBGZRrarVpAh891b5F4pvybokmkikcJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772806; c=relaxed/simple;
	bh=rkpaH7y/YSdmGtJPb9qLCU/ZfjlNnHaqAisfTzfrCSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZoEFbsoEZ8BXiFr71/nJbIyVfhXkFLSg2EychTe/rHOLuClX6HwkIeuNbSwmL42ZPoiLON4ryw8DOTapYiYa7Hj7U8i7XniOgAaB0TSKVqno+EYTV/0yWlsFSCa+3zllifmxNxuXlFatDj5Rgc+wM9RXvbJ5D8rBT8czngxWuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nk4nr0l2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nk4nr0l2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB26AC61050;
	Tue, 27 Aug 2024 15:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772806;
	bh=rkpaH7y/YSdmGtJPb9qLCU/ZfjlNnHaqAisfTzfrCSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nk4nr0l2XyicLFI9PsyWNjweZnbXvzyucT+8jAvwDn7lzJ1kyVAm0no+qa525Gx36
	 O4uUGaXrbigHehwM+za4S1DIlDeYxQhg+olx5TeLauda9EAt49NsPGagyVLOOEqO/k
	 5Ju62kiU4gwzPSSyCSn//ChHk5m43KLDeAU2AceA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 307/321] wifi: mac80211: fix flow dissection for forwarded packets
Date: Tue, 27 Aug 2024 16:40:15 +0200
Message-ID: <20240827143849.942105897@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Felix Fietkau <nbd@nbd.name>

commit 899c2c11810cfe38cb01c847d0df98e181ea5728 upstream.

Adjust the network header to point at the correct payload offset

Fixes: 986e43b19ae9 ("wifi: mac80211: fix receiving A-MSDU frames on mesh interfaces")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20230324120924.38412-2-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2855,7 +2855,7 @@ ieee80211_rx_mesh_data(struct ieee80211_
 		hdrlen += ETH_ALEN;
 	else
 		fwd_skb->protocol = htons(fwd_skb->len - hdrlen);
-	skb_set_network_header(fwd_skb, hdrlen);
+	skb_set_network_header(fwd_skb, hdrlen + 2);
 
 	info = IEEE80211_SKB_CB(fwd_skb);
 	memset(info, 0, sizeof(*info));


