Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE6D13541F;
	Tue, 14 May 2024 10:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684358; cv=none; b=iuCOFP6duFuHWv8rRySWpSJ3fhiBg0mOLeXEQLxRgHYGQGlo/NntgHyqn6IBMoZFVkzvutqCqle/iXZafc1xwITfNF8C5Go2MGiHmu/HUSyR7jpu+n7FNatSKyzaigl+ologWNjW/pepOKOIkfv0fz/mONHmwrpjlCmifHpbswU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684358; c=relaxed/simple;
	bh=gc5ICdMMyfcfgBU+JpTsC3UnDyLq3o6luivXMOEZ5RM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tmS56vcseSjW6B9Uk/4YpqBeGNfiahpxL478uaMqrzamIXFHl+FR696Ip93wxm7EC3WszB6pLUSnQE88KVDRv55aRXVZAw2p+3GVxiRXRFmC/Qg7mZu7jt0y/Q8GcGf+HgPsleyf3bat64vu7sjYBp/Iyy40IA1QT7PosvCnGoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNfo0NY9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNfo0NY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F64BC32782;
	Tue, 14 May 2024 10:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684357;
	bh=gc5ICdMMyfcfgBU+JpTsC3UnDyLq3o6luivXMOEZ5RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YNfo0NY9yuuGvND9e2yas9Dpso4Mmn7A3ENgpUv72awRKq0dEB+9S7HXOat3L5Lr8
	 q5chuBq+YmsAhUtM16Ba4SctlNCrvsmjmYohv+VoezYnz5FJYCJClVQ8HvOTwhLAVS
	 1YbaRVoriJZQurK9kvtPRxgCw0qW1tUPwFxFKZuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/301] wifi: nl80211: dont free NULL coalescing rule
Date: Tue, 14 May 2024 12:14:38 +0200
Message-ID: <20240514101032.507874462@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

[ Upstream commit 801ea33ae82d6a9d954074fbcf8ea9d18f1543a7 ]

If the parsing fails, we can dereference a NULL pointer here.

Cc: stable@vger.kernel.org
Fixes: be29b99a9b51 ("cfg80211/nl80211: Add packet coalesce support")
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240418105220.b328f80406e7.Id75d961050deb05b3e4e354e024866f350c68103@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9f6d8bcecfebe..c4f08f7eb741d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14052,6 +14052,8 @@ static int nl80211_set_coalesce(struct sk_buff *skb, struct genl_info *info)
 error:
 	for (i = 0; i < new_coalesce.n_rules; i++) {
 		tmp_rule = &new_coalesce.rules[i];
+		if (!tmp_rule)
+			continue;
 		for (j = 0; j < tmp_rule->n_patterns; j++)
 			kfree(tmp_rule->patterns[j].mask);
 		kfree(tmp_rule->patterns);
-- 
2.43.0



