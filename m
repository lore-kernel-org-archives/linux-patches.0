Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E875FF05;
	Tue, 13 Feb 2024 17:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845419; cv=none; b=X/fyQ0Bhf47xzybvtWpXu/j1+nVVQ3NTA0nkQ05F6oDQvA7q8CGfFWX1jAD5DDiaZXIS8H1cSHiPGWHHAEyHZYoEHVN0hdHmyzTx2hn4C+wtqD7NP6CI/+xTYbly+NtE/0kg/u2T16KcTSPXmqoPRTtjwRfYDc5dna8lkWaBaBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845419; c=relaxed/simple;
	bh=OfAzuEx5ulQeaus8m5bqSMVvAxWwPOtGcgdVUBE2uaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntrjTKiKulfHceM//kBRzrUqdd1OuvuGQ8bydr3BrctFRcPOs6TOaWwHtn8x6TGBbN0ZfsdVb3FvUqAiUW72LyjnUxuP3GSzUShuQ12uvygrcTWSfyZbWLq3Q9B9VuxIRoKCx1X0YcgY18reQdIKBn1kI86poYwGeGE4TdANWCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6FE31Tm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6FE31Tm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6728FC433F1;
	Tue, 13 Feb 2024 17:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845418;
	bh=OfAzuEx5ulQeaus8m5bqSMVvAxWwPOtGcgdVUBE2uaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D6FE31TmIUJI2J+so/0+ByzrkwKwekFnJZTXk/tz+3KcjFh7jYVCGKabg2B3orwGH
	 1fffnXJ1LU18bC8lPVaWvnNHWMBH+nQdQ6v9C/T5ZGoVdCjQRkwORLFI5dqL0ky5tm
	 ZrknD1Ce2ez+bpOjdsaZjA7quIb6uFCmtOUlnr60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/121] wifi: mac80211: fix waiting for beacons logic
Date: Tue, 13 Feb 2024 18:20:54 +0100
Message-ID: <20240213171854.312723760@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit a0b4f2291319c5d47ecb196b90400814fdcfd126 ]

This should be waiting if we don't have a beacon yet,
but somehow I managed to invert the logic. Fix that.

Fixes: 74e1309acedc ("wifi: mac80211: mlme: look up beacon elems only if needed")
Link: https://msgid.link/20240131164856.922701229546.I239b379e7cee04608e73c016b737a5245e5b23dd@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 73f8df03d159..d9e716f38b0e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -7727,8 +7727,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 
 		rcu_read_lock();
 		beacon_ies = rcu_dereference(req->bss->beacon_ies);
-
-		if (beacon_ies) {
+		if (!beacon_ies) {
 			/*
 			 * Wait up to one beacon interval ...
 			 * should this be more if we miss one?
-- 
2.43.0



