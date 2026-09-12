Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69499305680;
	Sat, 12 Sep 2026 14:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224504; cv=none; b=St8CLsGzfdwhLz5hdDzls1YSsOJtFpZ/D/gKTju6qKxjCKkIKyzvh9eYWU+5vPzevDAONncXe0r7bKq9QaXvCBKh3NC0rB0fZ0Ftwda+5bHjZ7TRQMj2J6Mwha2Y+TP3NRjgnwJgK/rP91yR7fKQuVM9YVsWeBAtd0fK62D6azI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224504; c=relaxed/simple;
	bh=DoBU6SY8axtOJVbMiTJsHPD92bBiJZmlzLC/xnk8Jfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CylH2Q2rE7TjB7sgrz+/30qRZwydztn+pp+6XQY296WANUiljNp98bKHMvpFI31mj324vqao43uThC8GImOXQKmDVuicSF4aeUOqKlEZuZtFtJwfrq3bh2yePrgwpcGWhzBdVYGs6y827WP/uOXD0hTElm9uMtxqz98J7DAIr6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vmam1GqX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vmam1GqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14F61F000FF;
	Sat, 12 Sep 2026 14:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224503;
	bh=Je+5yFeApft7jH1r/j3S17pkXqF89D5CTHEAKra8Ygc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vmam1GqXFi7SxQ6HwsdvkGLo373dNqCqoAMhDRgvvhQovOm2CxWpa3WFuP7Pg0DuP
	 gpHST2n6ziADG6smESx5F+rO57rVp1+NBl+J/aANfCocgF5Fu3DykWkn1GYeCnbIn8
	 sSNgcuxGxqUNHWjGfB1Ccje7I0HZ7U8LaLcZJDdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1007/1424] wifi: mac80211: skip unused probe response countdown offsets
Date: Sat, 12 Sep 2026 08:57:19 +0200
Message-ID: <20260912065629.863150087@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit fd2bf5e718108c00732eb07fd94a5d8830f62a9f ]

mac80211 copies cfg80211's variable-length countdown offset list into a
zero-initialized fixed-size array, leaving unused entries at zero. The
beacon branch already skips those zero entries, but the AP probe-response
branch writes through them unconditionally.

When a probe-response template has no countdown offset, the write through
an unused zero entry overwrites resp->data[0], corrupting the first byte of
the template. cfg80211 already bounds explicitly supplied non-zero offsets
in nl80211_parse_counter_offsets(), so this is a zero-sentinel bug, not an
out-of-bounds write.

Skip zero probe-response offsets, matching the beacon path.

Fixes: af296bdb8da4 ("mac80211: move csa counters from sdata to beacon/presp")
Link: https://lore.kernel.org/all/20260708195911.84365-6-enderaoelyther@gmail.com/
Assisted-by: Codex:gpt-5
Assisted-by: Claude:opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260723011001.76851-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e3841099bbdaa..5ea7572aae3df 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -5035,7 +5035,8 @@ static void ieee80211_set_beacon_cntdwn(struct ieee80211_sub_if_data *sdata,
 		if (sdata->vif.type == NL80211_IFTYPE_AP && resp) {
 			u16 *resp_offsets = resp->cntdwn_counter_offsets;
 
-			resp->data[resp_offsets[i]] = count;
+			if (resp_offsets[i])
+				resp->data[resp_offsets[i]] = count;
 		}
 	}
 }
-- 
2.53.0



