Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6192FD1C2;
	Tue, 12 Aug 2025 18:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024112; cv=none; b=rbNr4p51EwcfQuFvnrhmsF0BpynHcDoYEBHAlkA077GF0FxP/AjsaxyWu7ufucPff0AZfE29/iqDEHRA2iOKnhaUqJDhPFBmVBPZHrajKLiW0gsuu/Igsd9WzHAur36XOj1aIwqAE0jX7+XirxOYmczm0P86qAHFGbWG+zXzouc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024112; c=relaxed/simple;
	bh=EjO5Zv/UwXRzP111ArWzZJBKCS8EZ2rTSaTSRaIWCPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTZf9iEbths8apgEM1Jqg6JqXNKxyBk9jbQ1QOLcYhcwTCkZfDmhNRwjpFWcHBAtE3pSAwQJGiRpy51VgA8ibDfE4oI1CHMCprwPi0mOXJ0mW4PV9MfXlWTYPjzGLXCrb9tYOsiHRljEYzzP1hs/wx1LfF/nn3udOI4uX6oiBtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jH9ovED6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jH9ovED6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A4BC4CEF0;
	Tue, 12 Aug 2025 18:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024112;
	bh=EjO5Zv/UwXRzP111ArWzZJBKCS8EZ2rTSaTSRaIWCPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jH9ovED6plVPSQnQgZK8SfgwIq+Hn77yOe6mx8C0tGt9Boc+3/Sbmqtb3EajdXLwh
	 TpYbDfpuzSL+m+IcRl3yV64omQjnaYMeOd8dcpnUZmrHRBtogivJs3M2dlklUbTZmY
	 FqYUlRr3haUtixneK7PyC3QQhOeSd6aUXtYjCBDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 245/627] wifi: nl80211: Set num_sub_specs before looping through sub_specs
Date: Tue, 12 Aug 2025 19:29:00 +0200
Message-ID: <20250812173428.618319649@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 50202d170f3a..bcdccd7dea06 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -16932,6 +16932,7 @@ static int nl80211_set_sar_specs(struct sk_buff *skb, struct genl_info *info)
 	if (!sar_spec)
 		return -ENOMEM;
 
+	sar_spec->num_sub_specs = specs;
 	sar_spec->type = type;
 	specs = 0;
 	nla_for_each_nested(spec_list, tb[NL80211_SAR_ATTR_SPECS], rem) {
-- 
2.39.5



