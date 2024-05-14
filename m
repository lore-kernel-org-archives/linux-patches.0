Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D30136673;
	Tue, 14 May 2024 11:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686993; cv=none; b=Dg/CiPK3X2qoeah0HV32i+7ZTMc4y43NxghJerjHTbjubGiY3naVbQoXLW7mK1lWnqzb+bH8WStsBG0hR5RUOURFb4kq+O5hap+hSVNcpn7cxdV/MzWBT3leE8Fg78SKHnBLdns0hWly7DZrTnq/FTYKZTjYQzYSYaLc3ClRKuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686993; c=relaxed/simple;
	bh=oy9a9W+2A0RX+2LRviCxiOlev49SUnhVEXoGPgjI98E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I4ijI1HQcPUw9WTs+pK6poLxqagI6Smr1Bq9rel0XcaDk44dC14vIPJwAmqIW/W2ePB1tlDXIecLgYfyVVkw+icl+CJeJydOrF2cjXOQQ/0oLNbE8zeHnJnnacqS8GODykCXTZnDHCsWPLH3QNJoCior3jSK3+C6J/19WtvvjUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i0TJx2Lk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i0TJx2Lk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94161C32782;
	Tue, 14 May 2024 11:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686993;
	bh=oy9a9W+2A0RX+2LRviCxiOlev49SUnhVEXoGPgjI98E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i0TJx2LkVtwh45CHngnZ+D9VIJelG9blJ0mEyAhXqD/eThTHr3BheIt1kax3CQKc8
	 ICJo8HIqr60PZAshRtLEg0FdBYcJ57b4BTTzV0DByEI898k/NT0uTj81xKqWnNgrrp
	 4PHLpzOHJyLoiM9j+FuZ8OyZfAkYPLL4Unk1QFBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/84] wifi: nl80211: dont free NULL coalescing rule
Date: Tue, 14 May 2024 12:19:14 +0200
Message-ID: <20240514100951.820058416@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index c698fc458f5f9..0d15dd68565cb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -12023,6 +12023,8 @@ static int nl80211_set_coalesce(struct sk_buff *skb, struct genl_info *info)
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



