Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EF63E022B;
	Wed, 30 Sep 2026 19:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795996; cv=none; b=KsTlHH9SmROqEbwTcBuaHJSl6wFQYjbE7I6kOlqD5HyoA5hqF+f+ABJvi2RSfVj4AzmdsZgODM+JVgsebZveY+2QzLnrUx8ZW0lOTxNRuwuGbOt6g/uQbEZUARSfbkeMnpQt4wdx7FkAiuJ658ONbJuerJ2NT9beZYTTXKB1wtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795996; c=relaxed/simple;
	bh=ahhQ3Y/23kxj2bYVgSiDRp+n9OmqijYgngRhbAYATVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4ik61aJ5bAhLyvfORVo7smvdzeQwb7R/3gauqp9Rnb82SrvzNY8wFDaEGXiAHPOD6sysU5LhdXUH0w4RXpkVUtIJID+aqr3W8RLa6uiOkHmU5HJWFga/be14kneY/aMa8pRuKb2YgxY6OOpKhfuZpknRqKxtn4XLw3N7D2hDP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cqMfkbly; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cqMfkbly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007441F000FF;
	Wed, 30 Sep 2026 19:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795995;
	bh=/4x3gnCfmzuBEuL8Ut5Z1H2hpMmKAu/RozKrFUMRPQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cqMfkblyUbXbH0FqTUJVTGt2GlVUqC5ExKCwkiEme/iHF3p45q7AjLJK6jBPjhQLj
	 riiaVq4fE7bNNRG2FQ1HCEa3hH1gIFXyzUV9K500ibx7XebfWRCN3O1lEyxA/VFEvn
	 Qj7+3prsWQB/0PZdVaNSIJG9YssHhU7TAeFypEUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+dc6f4dce0d707900cdea@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0755/1193] wifi: cfg80211: dont filter by BSS type when removing stale entries
Date: Wed, 30 Sep 2026 17:23:59 +0200
Message-ID: <20260930152451.027874560@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit b377e1000d963e7182a987082b4b06580bd7ac84 ]

When an assoc AP switches to a channel that already has a BSS entry,
cfg80211_update_assoc_bss_entry() removes that entry before rehashing
the real one, since the two would otherwise collide in the BSS rbtree.

The lookup for that entry also required it to match the connection's BSS
type, so an entry advertising e.g. the IBSS capability bit was left in
place, and the following cfg80211_rehash_bss() then ran into it:

  WARN_ON(!cmp)

Changing the type shouldn't really happen, but can be triggered by a
rogue AP/device, so drop the check and remove any entries matching
the comparison.

Assisted-by: LLM
Fixes: 0afd425b1b64 ("cfg80211: fix duplicated scan entries after channel switch")
Reported-by: syzbot+dc6f4dce0d707900cdea@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=dc6f4dce0d707900cdea
Link: https://patch.msgid.link/20260904165614.1f05dae1c546.Ib52d57b57caa912efee020f9d4a033a5160617ce@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 0c0fed4774e26..0766367bda6cf 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -3151,11 +3151,6 @@ void cfg80211_update_assoc_bss_entry(struct wireless_dev *wdev,
 	cbss->pub.channel = chan;
 
 	list_for_each_entry(bss, &rdev->bss_list, list) {
-		if (!cfg80211_bss_type_match(bss->pub.capability,
-					     bss->pub.channel->band,
-					     wdev->conn_bss_type))
-			continue;
-
 		if (bss == cbss)
 			continue;
 
-- 
2.53.0



