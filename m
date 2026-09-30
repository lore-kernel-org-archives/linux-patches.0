Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2D14E322C;
	Wed, 30 Sep 2026 16:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784072; cv=none; b=GiGIJJembZ9TNVPveR6kq/e0cB/2ydU+mb/rHBDK3717ncwuLqRuce7g9oqI/VotUnRzk7x3zAE05+nqPsJRQFjwZm5ybwYquNqGYhimdQHqf9GjFGynz+QGR/D3TmmfsDq5UpVyEFuyRwOvquWSa/haKwmIR/t0mcRCKgSm2kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784072; c=relaxed/simple;
	bh=hhOGtycSRnSKMLt4uEqv9sjChUD7HPCdBdIdaGy/ies=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaTHKe942Xnp3crDzv/ahW83gQ04Jec7U6vBm8W+73HqWtaGWUSc9Lzaza7YD74TG6UOeu4bMnBXcc9oGF1+OzDdZRAEhskFQGGX2EkXy86tzQPMoPX2PDETKfS/ZIaNJwLJ0rmviylB1uolvdzVfGk7tdXtd++tSVZDOgkuXgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EcaWwpSh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EcaWwpSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C575F1F00898;
	Wed, 30 Sep 2026 16:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784068;
	bh=MEp3I464HbAhF1sD6mG6w5hv8KaGkU0zUGemUKdEFec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EcaWwpShhesYqjCxNZ9Aa/Lz3aiGnTodWMfPkR0iJh4DjvosnoinNvsYntTJioFJO
	 tYA4ZxFA2H7wSyD+PTg9+qmik0zfhtIU9M0L8s7uw0GCFQv4Jluz6gw36u9ODUvRiF
	 jAdZSVTv7KUdYeHrZc0HDbBhPWCLnlGAzr/qvxuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/982] wifi: nl80211: reject beacons with bad HE operation
Date: Wed, 30 Sep 2026 17:12:25 +0200
Message-ID: <20260930152416.988348401@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 8b9a100e1a76c52988b31099b349fd95a58c8768 ]

The HE operation element not only needs to be longer than
the fixed part, but also have an appropriate size for the
variable part inside of it. Check this.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260415144514.6217f5974fb5.Iff7ff6bcb159584e756d0f825c65860cdd53c6ea@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bb2d19057480b..069b04c29b64e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5805,8 +5805,12 @@ static int nl80211_calculate_ap_params(struct cfg80211_ap_settings *params)
 	if (cap && cap->datalen >= sizeof(*params->he_cap) + 1)
 		params->he_cap = (void *)(cap->data + 1);
 	cap = cfg80211_find_ext_elem(WLAN_EID_EXT_HE_OPERATION, ies, ies_len);
-	if (cap && cap->datalen >= sizeof(*params->he_oper) + 1)
+	if (cap && cap->datalen >= sizeof(*params->he_oper) + 1) {
 		params->he_oper = (void *)(cap->data + 1);
+		/* takes extension ID into account */
+		if (cap->datalen < ieee80211_he_oper_size((void *)params->he_oper))
+			return -EINVAL;
+	}
 	cap = cfg80211_find_ext_elem(WLAN_EID_EXT_EHT_CAPABILITY, ies, ies_len);
 	if (cap) {
 		if (!cap->datalen)
-- 
2.53.0



