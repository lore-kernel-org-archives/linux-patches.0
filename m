Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6452566;
	Tue, 27 May 2025 17:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367024; cv=none; b=dIX08Zx1jyNhM5EO/Uf51crYjfHz0RGgQZxMFrYbFuUifzoQZnbq19Z9AaovSpnat34dNgV9RcyRCak/3ufJowRsXvBTUyUyF2i39gQn24TVlpLql7yun2oOraO7T5s096UhKWH/hYEA+Pb72SVVT2mGY9zVJYsV8tsExeMsXzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367024; c=relaxed/simple;
	bh=zfDHf14W/8hc4G1rv0Xx9sTN7he+CevDgeQgJT8M5hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Et68hP0D5JJQ6bXnH4Lt6EsA9mmLLEYmsSvxPwF0vaij6ceWXf7h05rYjw2Eo0/FydAiIz1fVsRzgPheXPyiAf4/Bhenwdo4bdVCSkn1lx62N34armgIXcwPJ+AdMuLTkvX22gjuRabLpYY+Ek4crT80Cyd8fT9NAePGkWe4WgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0gZOF5TF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gZOF5TF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3377C4CEEA;
	Tue, 27 May 2025 17:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367024;
	bh=zfDHf14W/8hc4G1rv0Xx9sTN7he+CevDgeQgJT8M5hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0gZOF5TF4jM0ILN5EQVo/xBmDLpJQltvfOziB5DPC4Xu4eOQ7Ehmr3ro+zq5z5D0L
	 sCsP27ROlA2UqnRSBwMTxBNDvmNjZDZ/jZ/kLvZ2Ac/T5MABHJokkS2LOpKC0Ly4Rq
	 L7dPqUIiJOtKYSG+/D1BxBF4iEv6259mdJ7TH78I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 223/783] wifi: mac80211: fix warning on disconnect during failed ML reconf
Date: Tue, 27 May 2025 18:20:20 +0200
Message-ID: <20250527162522.201979133@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 0e104aa3676d020f6c442cd7fbaeb72adaaab6fc ]

If multi-link reconfiguration fails, we can disconnect with a local link
already allocated but the BSS entry not assigned yet, which leads to a
warning in cfg80211. Add a check to avoid the warning.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250308225541.699bd9cbabe5.I599d5ff69092a65e916e2acd25137ae9df8debe8@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 676274519cdfb..3f30c4c1f78bb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4298,7 +4298,7 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 			struct ieee80211_link_data *link;
 
 			link = sdata_dereference(sdata->link[link_id], sdata);
-			if (!link)
+			if (!link || !link->conf->bss)
 				continue;
 			cfg80211_unlink_bss(local->hw.wiphy, link->conf->bss);
 			link->conf->bss = NULL;
-- 
2.39.5



