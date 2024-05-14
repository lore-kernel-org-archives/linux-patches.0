Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DAA12FB00;
	Tue, 14 May 2024 11:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686769; cv=none; b=PjbLwf9aOQ8mc5bMG1abWkmvWUuuSKrCxmE1kqfHw90mnePp+yzVJW/+wGKys4vswAl/cZcacTH+yHmz56g0ketyTzoRl3NjjK278xSOB2t4VtM+caewD+q13T2G+qI4/IValqyWmYpMbHebMNL9BSJQNxJZY1LdE2fY0aO3CfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686769; c=relaxed/simple;
	bh=CJkk4txtha12BjPWDJt9ko7kJEofZi8zk1IN7otSZ3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzQhuYFyvDmTyuPFcQZTQJ7jtgphme5OkCCPN4izzzJZcfzGBeaelO4HDpoFu7AofTQ5cXLAs+vdUEZUNEDum0XMfxUiaUFasw/VqBpUQWiqGi9g/fi+qfNqugbQHUP6nLQjIKXI9/rCYz9BENyZLwhu3wXAvffn4mF6xmGSPxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RfmgUOwf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RfmgUOwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E710C2BD10;
	Tue, 14 May 2024 11:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686768;
	bh=CJkk4txtha12BjPWDJt9ko7kJEofZi8zk1IN7otSZ3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RfmgUOwfXpDtWKUeFdZC8GWfLeSAiSVucJ7ysiQHIKZFhlki4sOSJHvKAU/buSI1r
	 pbvqdlt0YK6YEWJ3CKtS5UiT4M4eBhPSWmMe4nP6y3aQI4bqmO+Ni7Hz/Xj5cQyxaj
	 kDE8xhdKOCSYkt8MDuXtsIXGwr45Sw5VH7+l0P9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 03/63] wifi: nl80211: dont free NULL coalescing rule
Date: Tue, 14 May 2024 12:19:24 +0200
Message-ID: <20240514100948.141530423@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index df2989c35fd86..15f28203445cb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11492,6 +11492,8 @@ static int nl80211_set_coalesce(struct sk_buff *skb, struct genl_info *info)
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



