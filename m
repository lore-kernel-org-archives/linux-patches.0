Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE59618BC1D;
	Fri, 27 Sep 2024 12:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727439909; cv=none; b=BeXKXWkn7zv8EUVSu0nI00VAnI6MdwN0KQoHmjIUcpRmQmasA9kDFEMMVHlPPA7UfAOiC5B8awhON3mblmMh5iFM2QHbvpKCCaVXWrahqy8OMTAlASGLZEQ9qVBv/nkodESrZ+npxsXh0BBkUe6uJhINftUZl9LfcfcmL1BGE0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727439909; c=relaxed/simple;
	bh=swqgF9+8grrdxg5Eo77xXC0sbADPvA6WG8ji6knyl00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxtz+AgqswkBK+kuQ7djLeXVoDdVhDkg/ln2kTDTKd2u3KrI0/k9GgffKeZp7Xe1YWMhNFG0cVDTdb7Xw88GvGHZIBmHtaXBk7msB96yTHBUffScDUNBGAR8Y6crs6tyYXZJwpw/eLfuNfymXeWvgVP5IRKNmhlyvc6vZPXJhvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejBedf7Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejBedf7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C751C4CEC4;
	Fri, 27 Sep 2024 12:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727439908;
	bh=swqgF9+8grrdxg5Eo77xXC0sbADPvA6WG8ji6knyl00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ejBedf7QpTueB9W4DF/wVseYL7XpIlvjIOsnJKD113A9Nk8sFrJd6DmkKe/PNC5fO
	 oEhDJcPTBTVGLXSpHXMAsKIJ2IXYrSI0aeACZZDOb8CPgyTedAdA54z3eHggmgBmaA
	 M7ZtQ6UsCocj4/nCIWlVqaPf54pyORXmig5q3P7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 19/54] wifi: mac80211: free skb on error path in ieee80211_beacon_get_ap()
Date: Fri, 27 Sep 2024 14:23:11 +0200
Message-ID: <20240927121720.474343106@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 786c5be9ac29a39b6f37f1fdd2ea59d0fe35d525 ]

In 'ieee80211_beacon_get_ap()', free allocated skb in case of error
returned by 'ieee80211_beacon_protect()'. Compile tested only.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Link: https://patch.msgid.link/20240805142035.227847-1-dmantipov@yandex.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 46b02a6ae0a36..415e951e4138a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -5311,8 +5311,10 @@ ieee80211_beacon_get_ap(struct ieee80211_hw *hw,
 	if (beacon->tail)
 		skb_put_data(skb, beacon->tail, beacon->tail_len);
 
-	if (ieee80211_beacon_protect(skb, local, sdata, link) < 0)
+	if (ieee80211_beacon_protect(skb, local, sdata, link) < 0) {
+		dev_kfree_skb(skb);
 		return NULL;
+	}
 
 	ieee80211_beacon_get_finish(hw, vif, link, offs, beacon, skb,
 				    chanctx_conf, csa_off_base);
-- 
2.43.0



