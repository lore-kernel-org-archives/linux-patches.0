Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0211E1C688F;
	Tue, 27 Aug 2024 15:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772803; cv=none; b=T29Bozk43K5rnM7QT38xy681PwpRBSP5pfMTWXuf/ueUNDwMFls6Ocf06KNDbj7PVHHu0O5L1XpiTSQEBCBC3rODCGGwZcM6qDvHYyZCscjUsgZsTE8R0tBWL2yW/EawVLZd67JIYNSjYEmGo1ExXwYTug3xAXQzCRDljn+pypc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772803; c=relaxed/simple;
	bh=ZrKePidaATG9u+Tz+p0aVJ0zs3xXbi1rp1mj3y5+LVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sx6aFJLFCidGLsBZxj7DSwG54Pdj5DKHEXof7qpJx0X9Uz1g8HmubKPACY3dbExj+9LXzdHX0ZZnGzZNGNrq6kFYfK06zuKXJIoxUY455aCXvefvVz0oRd/FTwtX3qZ+mddFzoI/jmqlAqluNtqSWK69/cRQzCEDb5sdgtyQWeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bd0ajIU+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bd0ajIU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F354C61050;
	Tue, 27 Aug 2024 15:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772802;
	bh=ZrKePidaATG9u+Tz+p0aVJ0zs3xXbi1rp1mj3y5+LVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bd0ajIU+dDr7vEhoc3YVtrM6Mb5ORWQTf516K8UiJHlZFLpSGITkGoi1wPCw6q7m0
	 GhKgrdyOUHLg2kKfvnH6OE78KVRNKoOYhrWgfDMuVF84O6YjUdjgixJcvkH2GSYqd8
	 suTMlARcJnAeZMgpG9EX3H36zJoq2qDDc6kY4CAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 306/321] wifi: mac80211: fix mesh forwarding
Date: Tue, 27 Aug 2024 16:40:14 +0200
Message-ID: <20240827143849.903591734@linuxfoundation.org>
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

commit 8f0149a8ac59c12cd47271ac625c27dac5621d3a upstream.

Linearize packets (needed for forwarding A-MSDU subframes).

Fixes: 986e43b19ae9 ("wifi: mac80211: fix receiving A-MSDU frames on mesh interfaces")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20230324120924.38412-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/rx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2838,6 +2838,9 @@ ieee80211_rx_mesh_data(struct ieee80211_
 
 		if (skb_cow_head(fwd_skb, hdrlen - sizeof(struct ethhdr)))
 			return RX_DROP_UNUSABLE;
+
+		if (skb_linearize(fwd_skb))
+			return RX_DROP_UNUSABLE;
 	}
 
 	fwd_hdr = skb_push(fwd_skb, hdrlen - sizeof(struct ethhdr));


