Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E8F258EF6;
	Tue, 11 Nov 2025 01:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824102; cv=none; b=riq7ARQ/qrUPsEfH6GVYgooC4T0wA1M6IfzzKEdhXdInimXImoC68s0XDByoa2udoqC/mcLh9nvct9lXWa/ZSmGiGpRmO5tpYdAG1Wglk/aKYfv0OaMUKVl22zwss5QHO0kC+QLcM+AhJs4bA4cYDU+LGTMXsDne1iO4w23FkqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824102; c=relaxed/simple;
	bh=EZShQ55Zbxax+Em9AeJfmU+82x3WCzyrpkW53sZlAD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IffAtEPif0cT33KxaTnP6yVWN/gRZ//nRAT9dCCQu+FVP0cIh+nS6qNiuxLehSasFVZZ+RNEbquBAfKlHcEeT8BGzc/9TKIrd6L+yGE8ov8CcGWtlHCd2JQCLL6gCg5ByQ4Z3nQubmn2GtaRKmdbz5J5ubK55WxWwbNltfymdew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1TnhG3FN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1TnhG3FN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB55C4CEFB;
	Tue, 11 Nov 2025 01:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824101;
	bh=EZShQ55Zbxax+Em9AeJfmU+82x3WCzyrpkW53sZlAD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1TnhG3FNBCqPVbAuGZmqa1ezKtW+x3lbVyqEXTD/Dlt2HntdkZ1QtKuGAJLxgQHpq
	 nNrVqvOdGVEVVMuQtvuU5DhTmZQRl+qOqod03x+sAsmh8f4g2K3YJHLV6rYxF+amQg
	 OswLdvnnknc011bLFydtD7SrpiR2qWFVeZKPgW+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramya Gnanasekar <ramya.gnanasekar@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 437/849] wifi: mac80211: Fix 6 GHz Band capabilities element advertisement in lower bands
Date: Tue, 11 Nov 2025 09:40:07 +0900
Message-ID: <20251111004546.997529381@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index a4a715f6f1c32..f37068a533f4e 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -624,6 +624,9 @@ int mesh_add_he_6ghz_cap_ie(struct ieee80211_sub_if_data *sdata,
 	if (!sband)
 		return -EINVAL;
 
+	if (sband->band != NL80211_BAND_6GHZ)
+		return 0;
+
 	iftd = ieee80211_get_sband_iftype_data(sband,
 					       NL80211_IFTYPE_MESH_POINT);
 	/* The device doesn't support HE in mesh mode or at all */
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f38881b927d17..c1b13b3411cdb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1850,7 +1850,8 @@ ieee80211_add_link_elems(struct ieee80211_sub_if_data *sdata,
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



