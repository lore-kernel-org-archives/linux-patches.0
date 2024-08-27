Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0FD1C6881;
	Tue, 27 Aug 2024 15:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772816; cv=none; b=luJeo9wtow3/VbynEH4DK8Tx2qGLnT9bJNnwpiBX36WkvjcbnqAOFsrkUu7GnYyGNqdhtR2HCgjejU9Jkmlc8Msv2+8zlm3IZ4BYG0c+gBNSxXJ+wbHHrKE8GUbD0K1iAHby+gYjLDi2zePatFYMZIBBt68kde18CsVUL+QYvDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772816; c=relaxed/simple;
	bh=mPCREV2AgQuXJZcMy/UXOW2tnVkt11jtnUBAUOiOE5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=en+0sd+2JKVqjX7avO6d9+34u4Oso2DeqYswUBPkXnh/uOwIL5+OacrX0Ypu8sVw3eZW21gUNTgXUfhUIpxOn3vtwtWs47UUGIQzJ4krpXaSn3fjqmwrz/H+U4+dfnQMgydBQUn32xlpAa2K+MtAFYHi6cF9YxEZoPXtbKJBaJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zJMeXAE3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJMeXAE3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2348C61050;
	Tue, 27 Aug 2024 15:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772816;
	bh=mPCREV2AgQuXJZcMy/UXOW2tnVkt11jtnUBAUOiOE5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zJMeXAE3J15w/eOfQwVDzMg5xxwyODKZ2+6nu5peX2fO8aue+9q/aNmPn1DmXzdHR
	 zOEkHnu8L3v9iaDLlUYI49DVmmkDlliqXuXbs2SRUSvTusqjQdeaJPjxLNlwt7hdXt
	 7j+93C/GUVgGK7DSc5oc8+Wo9WUbs6guD2yjVydg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 310/321] wifi: mac80211: fix potential null pointer dereference
Date: Tue, 27 Aug 2024 16:40:18 +0200
Message-ID: <20240827143850.057132414@linuxfoundation.org>
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

commit a16fc38315f2c69c520ee769976ecb9c706b8560 upstream.

rx->sta->amsdu_mesh_control is being passed to ieee80211_amsdu_to_8023s
without checking rx->sta. Since it doesn't make sense to accept A-MSDU
packets without a sta, simply add a check earlier.

Fixes: 6e4c0d0460bd ("wifi: mac80211: add a workaround for receiving non-standard mesh A-MSDU")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20230330090001.60750-2-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/rx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2938,7 +2938,7 @@ __ieee80211_rx_h_amsdu(struct ieee80211_
 					  data_offset, true))
 		return RX_DROP_UNUSABLE;
 
-	if (rx->sta && rx->sta->amsdu_mesh_control < 0) {
+	if (rx->sta->amsdu_mesh_control < 0) {
 		bool valid_std = ieee80211_is_valid_amsdu(skb, true);
 		bool valid_nonstd = ieee80211_is_valid_amsdu(skb, false);
 
@@ -3014,7 +3014,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx
 		}
 	}
 
-	if (is_multicast_ether_addr(hdr->addr1))
+	if (is_multicast_ether_addr(hdr->addr1) || !rx->sta)
 		return RX_DROP_UNUSABLE;
 
 	if (rx->key) {


