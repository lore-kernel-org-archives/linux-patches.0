Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9950579EF;
	Sat, 30 Dec 2023 12:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FoemCF/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226B9C433C8;
	Sat, 30 Dec 2023 12:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937777;
	bh=FhTdmwuk5yHzPUZKf3Ukx0Ml4Fg1IqqY5JGZWZgZ5Ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FoemCF/WjoHMJuqrSiwGIAJ5cnLxFEvhZYrAmFunHOPMDtAyUdX7MdKLQ7lyFRLvL
	 06xvhDZSvUneXAECWYF/JGxRSYiBFxx+54C+hbaSevryG58BmEqJ6DyVsQQABE05RT
	 ARzD6oMA1c9Fbf0WmGEx3hHbhjODz+e5xmqHa64w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/156] wifi: mac80211: check defragmentation succeeded
Date: Sat, 30 Dec 2023 11:57:59 +0000
Message-ID: <20231230115813.199111872@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

[ Upstream commit 98849ba2aa9db46e62720fb686a9d63ed9887806 ]

We need to check that cfg80211_defragment_element()
didn't return an error, since it can fail due to bad
input, and we didn't catch that before.

Fixes: 8eb8dd2ffbbb ("wifi: mac80211: Support link removal using Reconfiguration ML element")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20231211085121.8595a6b67fc0.I1225edd8f98355e007f96502e358e476c7971d8c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0c9198997482b..73f8df03d159c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5805,7 +5805,7 @@ static void ieee80211_ml_reconfiguration(struct ieee80211_sub_if_data *sdata,
 {
 	const struct ieee80211_multi_link_elem *ml;
 	const struct element *sub;
-	size_t ml_len;
+	ssize_t ml_len;
 	unsigned long removed_links = 0;
 	u16 link_removal_timeout[IEEE80211_MLD_MAX_NUM_LINKS] = {};
 	u8 link_id;
@@ -5821,6 +5821,8 @@ static void ieee80211_ml_reconfiguration(struct ieee80211_sub_if_data *sdata,
 					     elems->scratch + elems->scratch_len -
 					     elems->scratch_pos,
 					     WLAN_EID_FRAGMENT);
+	if (ml_len < 0)
+		return;
 
 	elems->ml_reconf = (const void *)elems->scratch_pos;
 	elems->ml_reconf_len = ml_len;
-- 
2.43.0



