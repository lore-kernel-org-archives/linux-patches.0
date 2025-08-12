Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A501C8621;
	Tue, 12 Aug 2025 18:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022343; cv=none; b=WGTiQ49YJfuT9bdADWOOwPITAPBtzGdHvi0VLUtx9wm/TJe0sXazDlCZx7YifrupaUfJqPSHZMSTk22BdJwaP9hIsaxWm+yM5lLHAI0cJV48eZNu0j4i83hHy6O06/S2TOVJUn4ijVZOMUApPxpYhXSMu5tQFv4ZWKRk1ykJ2Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022343; c=relaxed/simple;
	bh=Ab2x/bG2qKrALfx+egnDzRZ/bForu5vEp26AIMIxQX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=moGAtju/Fi/lyqkHYaalGzsKfgxRCYIEeWksWw0vEzGRpt2xCG1FnI2WRB8I4mcjzycZ6tTGKXqM2CXo7maBNs/0OF2m1K66dNsimSxEgv11bo96xns4m58ThCbmnpzMSDTCmUbdl3suR4yFlNS/RCigYm82yeVq6VzP4ExzAKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sovjZlFf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sovjZlFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6209CC4CEF0;
	Tue, 12 Aug 2025 18:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022342;
	bh=Ab2x/bG2qKrALfx+egnDzRZ/bForu5vEp26AIMIxQX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sovjZlFfxIQKhJBtLCjK/cbykqYf4CKuxYD0ulPATmHKuKcGHpP4rTJ9yO1V+he2W
	 M7v9l83NP6agtgzy5q7ZIKiwgQTejWNa87NXCYETfO7LqRtzCkSFwiigmOaXBNTxnS
	 V42O7nPW3ct0aBGI80kAMP5Y9E9ob56V5ESgQ8VU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 127/369] wifi: nl80211: Set num_sub_specs before looping through sub_specs
Date: Tue, 12 Aug 2025 19:27:04 +0200
Message-ID: <20250812173019.549128533@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit 2ed9a9fc9976262109d04f1a3c75c46de8ce4f22 ]

The processing of the struct cfg80211_sar_specs::sub_specs flexible
array requires its counter, num_sub_specs, to be assigned before the
loop in nl80211_set_sar_specs(). Leave the final assignment after the
loop in place in case fewer ended up in the array.

Fixes: aa4ec06c455d ("wifi: cfg80211: use __counted_by where appropriate")
Signed-off-by: Kees Cook <kees@kernel.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://patch.msgid.link/20250721183125.work.183-kees@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4eb44821c70d..ec8265f2d568 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -16789,6 +16789,7 @@ static int nl80211_set_sar_specs(struct sk_buff *skb, struct genl_info *info)
 	if (!sar_spec)
 		return -ENOMEM;
 
+	sar_spec->num_sub_specs = specs;
 	sar_spec->type = type;
 	specs = 0;
 	nla_for_each_nested(spec_list, tb[NL80211_SAR_ATTR_SPECS], rem) {
-- 
2.39.5



