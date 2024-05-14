Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C4353E30;
	Tue, 14 May 2024 10:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682098; cv=none; b=pI7OUl8Xy/UZ4KsJbm6prdft/+mKx6kB59zXUDsj20z5Wp6xMvDNry4mAdsIWGg3/0QjgMuSCUpxNYJ59FNp1KOIp6RWAXiYyWYrPWjrH7irjIgOF6XLFPyLhuLQhY5sMh4YYs4b5QWWTLFohB8OlmkjJ1ZK3pjVEl0UhlQR/L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682098; c=relaxed/simple;
	bh=lBq7R5JrrTom4T+Jfq2ZPQSqgkaQmhCwsKzR1Po0mC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H24rQc0fHlItbX0vpSLVmatRZQ9aLdiZWwQzrxPFmNYFuXGR3XOSdyHOzghqjThMvPQBh+nApTn5r+cSfyM+vvdAf5cJOfvQVirf+UTwkKjpfVIjlg3IcQCc9uLm8dJ6gRLFSx9eS5ZOnTx577o7zHauWchI9dR72bDEXbhD6Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJn1UP/G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJn1UP/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCDAC2BD10;
	Tue, 14 May 2024 10:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682097;
	bh=lBq7R5JrrTom4T+Jfq2ZPQSqgkaQmhCwsKzR1Po0mC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cJn1UP/GUMYN0l2RjheqdOX9rFIfvJQ1qoIt4NSUyDOqJPbUqSX9fRQpnUCttm+7M
	 UWCS2NPB4Vz/0FqX3m+lyyD6Ipo98o2DgTJAEylM1ytCJIG1gGkYY5/IoBJRFi/qgj
	 NmqVG/VGLJ5hyn1XOxc8LDE1VTV4Q9LRESbu0gpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 003/336] wifi: nl80211: dont free NULL coalescing rule
Date: Tue, 14 May 2024 12:13:27 +0200
Message-ID: <20240514101038.729825655@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index bd54a928bab41..daac83aa8988e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14092,6 +14092,8 @@ static int nl80211_set_coalesce(struct sk_buff *skb, struct genl_info *info)
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



