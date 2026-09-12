Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8900147ACD7;
	Sat, 12 Sep 2026 18:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239447; cv=none; b=D5Hwup2cnkQyJe1xO64qtICnPuijHot9spSKbDRpfjYGm0Vyejc/6avFCjfGyRlaWdIRnxWzAXM99no4vP1674yKxu82Q83ZvWX1lacKzvsJLAtA0fV+Xi+11RpmHOLFqIlPw0u4mqD1HoEuvJ2nxJyZuHOILBk6X8BGQ5t/8VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239447; c=relaxed/simple;
	bh=UW6sOvcRV6FQEfXT/1VmqPQslKzqe+IkzhDkhgI5uvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFpP+EONtuIzx8tuOUrlobOVYoXAkOb4SUsY6o9XREUexR1idZsq8qJuMJqGLpOWxboGmTiNcCim1/E7UIMT1sanwA+qz9eqkB5hOU81yQtgXU7D5hSP1PN/0m5c4ZvJv7AyRG3kcBZWmYnRAofBqgCbbUopmGZ7lStJggaOYsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+juYeQd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+juYeQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188A51F000FF;
	Sat, 12 Sep 2026 18:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239446;
	bh=BEN34TfpW7DH398Y68vvnR1VzF8Z4VPzitmHmPP3ulI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0+juYeQdU5NwE6Try/Uf4GvcfaCht2OejQxQeDyPl8fYOj2r1y6Tdga1Hc40SA0lS
	 ztJIMasc8omwWOFL8EjsSVVCaKzO4jKC21wBDYT8/TWb2G1gS8aZFuQ5yre0HPzivv
	 9FuqbYaM2fcFsxG/78+Fw4jiMMJx6XleCSxQImzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 665/935] wifi: mac80211: skip unused probe response countdown offsets
Date: Sat, 12 Sep 2026 09:01:35 +0200
Message-ID: <20260912065542.094957626@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e1b0f7495cf0e..511bdb2e0aa29 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4862,7 +4862,8 @@ static void ieee80211_set_beacon_cntdwn(struct ieee80211_sub_if_data *sdata,
 		if (sdata->vif.type == NL80211_IFTYPE_AP && resp) {
 			u16 *resp_offsets = resp->cntdwn_counter_offsets;
 
-			resp->data[resp_offsets[i]] = count;
+			if (resp_offsets[i])
+				resp->data[resp_offsets[i]] = count;
 		}
 	}
 	rcu_read_unlock();
-- 
2.53.0



