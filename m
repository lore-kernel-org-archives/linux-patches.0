Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2412DC350;
	Tue, 11 Nov 2025 01:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823669; cv=none; b=S7DyX5sRGbkAHqBN4Dd9SgEiNEo4UrENKbTPCM9gR1kvQoimi7oJvgMD+cnzghGNuRfFpKQngAU8gdmSYyxZwOlHss5gC7lrSAX24mVlDfMU0wZa6VXcY48KOwY1CfnX0+nx7ZSInh11JIgrgB8skIbWggNw1ABNHWgkmi5IIGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823669; c=relaxed/simple;
	bh=14NOmhg5uCC1iLjCphVrmr3BK4x5yc4+oQqkbJbwa8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRtGIeogUeJOHuiiZRgLMLWZ8jQDErQ0i0wtx/BpT3x4z23WxDMl7kgin54GLDqTnfYfxt8JBIwGtC3KP4+PVoVS1AVmWyAL5dy27oLk+rfZRtAZXrj6wrY5tGCIydcBSBMxeX3n/9nTsxNEUZefg32bs3f8Ia2HVIHbfQHSWlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrS2ua38; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrS2ua38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7590C116B1;
	Tue, 11 Nov 2025 01:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823669;
	bh=14NOmhg5uCC1iLjCphVrmr3BK4x5yc4+oQqkbJbwa8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrS2ua38wHQawTpdXSc4kbBUezZ43qkfPWwbrQGd6FvIq3V/4ZWf06bmlqD3A1ysC
	 yFMjWO1pK42u4J1M3HOsqKGOTx5SUkBTeyjTrOZSeZTs78wZHTXbVIYtQ/4o/D8z4c
	 UfJ3PoAU+X9Lx6urViWEXPgr7t1nxJS5+fSiuxAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramya Gnanasekar <ramya.gnanasekar@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 297/565] wifi: mac80211: Fix 6 GHz Band capabilities element advertisement in lower bands
Date: Tue, 11 Nov 2025 09:42:33 +0900
Message-ID: <20251111004533.559002471@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ramya Gnanasekar <ramya.gnanasekar@oss.qualcomm.com>

[ Upstream commit e53f8b12a21c2974b66fa8c706090182da06fff3 ]

Currently, when adding the 6 GHz Band Capabilities element, the channel
list of the wiphy is checked to determine if 6 GHz is supported for a given
virtual interface. However, in a multi-radio wiphy (e.g., one that has
both lower bands and 6 GHz combined), the wiphy advertises support for
all bands. As a result, the 6 GHz Band Capabilities element is incorrectly
included in mesh beacon and station's association request frames of
interfaces operating in lower bands, without verifying whether the
interface is actually operating in a 6 GHz channel.

Fix this by verifying if the interface operates on 6 GHz channel
before adding the element. Note that this check cannot be placed
directly in ieee80211_put_he_6ghz_cap() as the same function is used to
add probe request elements while initiating scan in which case the
interface may not be operating in any band's channel.

Signed-off-by: Ramya Gnanasekar <ramya.gnanasekar@oss.qualcomm.com>
Signed-off-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20250606104436.326654-1-rameshkumar.sundaram@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh.c | 3 +++
 net/mac80211/mlme.c | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 50eb1d8cd43de..37e11320553e3 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -623,6 +623,9 @@ int mesh_add_he_6ghz_cap_ie(struct ieee80211_sub_if_data *sdata,
 	if (!sband)
 		return -EINVAL;
 
+	if (sband->band != NL80211_BAND_6GHZ)
+		return 0;
+
 	iftd = ieee80211_get_sband_iftype_data(sband,
 					       NL80211_IFTYPE_MESH_POINT);
 	/* The device doesn't support HE in mesh mode or at all */
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5a9a84a0cc35d..fd2bc70afa0cd 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1569,7 +1569,8 @@ static size_t ieee80211_assoc_link_elems(struct ieee80211_sub_if_data *sdata,
 		ieee80211_put_he_cap(skb, sdata, sband,
 				     &assoc_data->link[link_id].conn);
 		ADD_PRESENT_EXT_ELEM(WLAN_EID_EXT_HE_CAPABILITY);
-		ieee80211_put_he_6ghz_cap(skb, sdata, smps_mode);
+		if (sband->band == NL80211_BAND_6GHZ)
+			ieee80211_put_he_6ghz_cap(skb, sdata, smps_mode);
 	}
 
 	/*
-- 
2.51.0



