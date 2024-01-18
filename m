Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93ACC23746;
	Thu, 18 Jan 2024 10:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575586; cv=none; b=RPUbYtHCq3l4S0QQ8zi4z5iuA8WkYmMvv+n2hzlrT+Li6jlye89vGN41au1np9HSqxapmsq+snxeBN+YE4nd1gWH8obEDWnqoDfd1YYvK9rKnC2f00O25wxZCjUUocKXYIN4H9Wsh2jKUOrpUBhTqBVeaTFq5n/J0fGt3iifTjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575586; c=relaxed/simple;
	bh=56Pyrn5GF1x/1DoiAEcBmfJD8CZx+ZvpTpc1ntpeCCU=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=crKeSbgQ3vIPGyJTqOoeiD4plLdVKsnKct/64tEgITM5Tw9+BS3QF+4mmNCcweBuGfktOXk5Z/R5SFCamQRq5xXEnWxy9wmmstLH9H24dUR77KQSVvPUnRvWyi0SLzs1bp7IwxDubtdRK3HH63F+fKcKKDSLXnWCdgKT6SZsB3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=udoMy+Np; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="udoMy+Np"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4DFAC433F1;
	Thu, 18 Jan 2024 10:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575586;
	bh=56Pyrn5GF1x/1DoiAEcBmfJD8CZx+ZvpTpc1ntpeCCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=udoMy+NpxCVP+3/nKxgqYvqT1hOMrsVLfr5wnt1oZo6JRimr+3TBdu/Hw2fq4kzs3
	 +6DcNau0TQPNVLt+vfgagQ1a4RZecQv3ORH95Ak2f4dZXr7nQOPW4Z2/DVWhfcjieX
	 cXj37SRH7sY8gCFJBjOj1n+vVNF2cD95IoQdlBSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Greear <greearb@candelatech.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/100] wifi: mac80211: handle 320 MHz in ieee80211_ht_cap_ie_to_sta_ht_cap
Date: Thu, 18 Jan 2024 11:48:15 +0100
Message-ID: <20240118104311.191902091@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

From: Ben Greear <greearb@candelatech.com>

[ Upstream commit 00f7d153f3358a7c7e35aef66fcd9ceb95d90430 ]

The new 320 MHz channel width wasn't handled, so connecting
a station to a 320 MHz AP would limit the station to 20 MHz
(on HT) after a warning, handle 320 MHz to fix that.

Signed-off-by: Ben Greear <greearb@candelatech.com>
Link: https://lore.kernel.org/r/20231109182201.495381-1-greearb@candelatech.com
[write a proper commit message]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ht.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index ae42e956eff5..9bfe128ada47 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -271,6 +271,7 @@ bool ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 	case NL80211_CHAN_WIDTH_80:
 	case NL80211_CHAN_WIDTH_80P80:
 	case NL80211_CHAN_WIDTH_160:
+	case NL80211_CHAN_WIDTH_320:
 		bw = ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40 ?
 				IEEE80211_STA_RX_BW_40 : IEEE80211_STA_RX_BW_20;
 		break;
-- 
2.43.0



