Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6288518455B;
	Tue, 30 Jul 2024 16:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356541; cv=none; b=G/QdAAk2kNzLh61WLKBAnWa5V9o7fU/HMVnhaEu9sNbulbcONlJG3uJJKr/Zm5qrCBMIuSc2ZCODa+xl/xh8nL9t4LKskiIyCm39NsDXYJh1kFhuVOJU43wNG7BXMs3P7oZ+uCLBp1sOOo2A3slQ0u3yWC4lSlmx+DH6CzDMbJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356541; c=relaxed/simple;
	bh=+XEQh5ySgIOxV/y5agGG7fxhQtBmOLJ3FSniNp8cGpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acUgOGWVsO3R7t+ZMyPDwRcR7FvAo2+5NhHCxJmIuET16+OP74xLDevNmZOtPDv5J3LpuLoDoMzX2BYxdYXrkhFP4F8rFy4ouZfyR4BCM6o4ihQ/jd4b8qcS+RJh9FZOZPhnc7UsRM3zhSoBUghwN1xQk9RupWL+AyspKOMtx8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1y7BvF7y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1y7BvF7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D458AC32782;
	Tue, 30 Jul 2024 16:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356541;
	bh=+XEQh5ySgIOxV/y5agGG7fxhQtBmOLJ3FSniNp8cGpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1y7BvF7ysVIyR/bmPoAIAU2GX5LmJg9P1geFlOMZO8JgaJUQz66nIPdIk8RIllfLo
	 pEI6wkB90vxwICH4Ql+2TPNQLZ4GGJUBy4PyDsEV905b9IIZ+a9e1s/Pegl2KfnBZj
	 stXXqLb/TTGAdYztJ79z81U0jmxtPgmABDctMYQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 160/809] wifi: mac80211: fix TTLM teardown work
Date: Tue, 30 Jul 2024 17:40:36 +0200
Message-ID: <20240730151730.922247523@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 2fe0a605d083b884490ee4de02be071b5b4291b1 ]

The worker calculates the wrong sdata pointer, so if it ever
runs, it'll crash. Fix that.

Fixes: a17a58ad2ff2 ("wifi: mac80211: add support for tearing down negotiated TTLM")
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240506211853.e6471800c76d.I8b7c2d6984c89a11cd33d1a610e9645fa965f6e1@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a5f2d3cfe60d2..edac1578d425c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -6834,7 +6834,7 @@ static void ieee80211_teardown_ttlm_work(struct wiphy *wiphy,
 	u16 new_dormant_links;
 	struct ieee80211_sub_if_data *sdata =
 		container_of(work, struct ieee80211_sub_if_data,
-			     u.mgd.neg_ttlm_timeout_work.work);
+			     u.mgd.teardown_ttlm_work);
 
 	if (!sdata->vif.neg_ttlm.valid)
 		return;
-- 
2.43.0



