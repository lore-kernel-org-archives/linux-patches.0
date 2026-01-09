Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C0C33B6F1;
	Fri,  9 Jan 2026 12:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960816; cv=none; b=GrxcuidsmmeOS6jRMV4xouvJLBWJW7GGu7VZk398xdQJc/UjN66NHRZBcThYF/RxYmKXbRAj46Fb3uITRkLh8ZH3hZvdOlvKMVEk7qAZnAzMkn7G4jsYu8yCFNymGV0XsrWVYLCSrRwVRUcNrdyngROSGeAYfQwrYis7BxKb9PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960816; c=relaxed/simple;
	bh=Zx+zHKmJ2wmLjd7dhnvZiMtuSKlJ8+A8Q1HG0yb/cNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gq8aU9CxcU6HBTCF7OmX29Nub8Ntuo2rH1MPQFItqNH8n4gmbKQq30Ukw4/QhfqAGaAnCaC8VnEygKTVAFmlYTOThIQ3EX45wBCdv7HhpX5xyu2GM884GJAZlMEb2fUb0YcwGaqcdB0Yq4ve8AEyV8XqdoUHgJ+r47R9J2+pKGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KI9XcltN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KI9XcltN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A06DC4CEF1;
	Fri,  9 Jan 2026 12:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960816;
	bh=Zx+zHKmJ2wmLjd7dhnvZiMtuSKlJ8+A8Q1HG0yb/cNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KI9XcltNzV2RoTwDoftb09bw8Ql3dRNFlT1of/CiY+bmyAdHEIXRllUVRDU2DybY0
	 UDr1dbH9PfiadL4h19FDCx3TRsuVVXDgOBKbpoQVUNykATBjlWo4I75xa0vtwTUWyE
	 rJOimy4C/RfMDbmD+ZiAzRoZmbmtJLZ0e79sLQuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aloka Dixit <aloka.dixit@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 503/737] wifi: mac80211: do not use old MBSSID elements
Date: Fri,  9 Jan 2026 12:40:42 +0100
Message-ID: <20260109112152.915302471@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aloka Dixit <aloka.dixit@oss.qualcomm.com>

[ Upstream commit a519be2f5d958c5804f2cfd68f1f384291271fab ]

When userspace brings down and deletes a non-transmitted profile,
it is expected to send a new updated Beacon template for the
transmitted profile of that multiple BSSID (MBSSID) group which
does not include the removed profile in MBSSID element. This
update comes via NL80211_CMD_SET_BEACON.

Such updates work well as long as the group continues to have at
least one non-transmitted profile as NL80211_ATTR_MBSSID_ELEMS
is included in the new Beacon template.

But when the last non-trasmitted profile is removed, it still
gets included in Beacon templates sent to driver. This happens
because when no MBSSID elements are sent by the userspace,
ieee80211_assign_beacon() ends up using the element stored from
earlier Beacon template.

Do not copy old MBSSID elements, instead userspace should always
include these when applicable.

Fixes: 2b3171c6fe0a ("mac80211: MBSSID beacon handling in AP mode")
Signed-off-by: Aloka Dixit <aloka.dixit@oss.qualcomm.com>
Link: https://patch.msgid.link/20251215174656.2866319-2-aloka.dixit@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1addfba4b285..16270bea49a2 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1147,7 +1147,6 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 
 	size = sizeof(*new) + new_head_len + new_tail_len;
 
-	/* new or old multiple BSSID elements? */
 	if (params->mbssid_ies) {
 		mbssid = params->mbssid_ies;
 		size += struct_size(new->mbssid_ies, elem, mbssid->cnt);
@@ -1157,15 +1156,6 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 		}
 		size += ieee80211_get_mbssid_beacon_len(mbssid, rnr,
 							mbssid->cnt);
-	} else if (old && old->mbssid_ies) {
-		mbssid = old->mbssid_ies;
-		size += struct_size(new->mbssid_ies, elem, mbssid->cnt);
-		if (old && old->rnr_ies) {
-			rnr = old->rnr_ies;
-			size += struct_size(new->rnr_ies, elem, rnr->cnt);
-		}
-		size += ieee80211_get_mbssid_beacon_len(mbssid, rnr,
-							mbssid->cnt);
 	}
 
 	new = kzalloc(size, GFP_KERNEL);
-- 
2.51.0



