Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC86D4BFE95;
	Wed, 30 Sep 2026 17:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788293; cv=none; b=G3Zjl+OQOtRWIzYZjZ9LlulODVGu9BezIL7asWu5Z1CzQlKG1HSF8QlJTDGuWbtYS6mTe560OBL1jgqPm22HZp4lKLitCFSs1Y/eExJLssJMhcD/8t1jFDVrs9QchpKrOA+piGgRobmExg6knf5g0Z0EL30+mNtc4BAM3tneYNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788293; c=relaxed/simple;
	bh=Qt/yVBTu5+ScM+dL820wQCR+U3sF4Y6Sa0vJs80vBzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8l4m942iQNImU5ls9SIvb0xYq5gb7ZriQwjy+4nFWPPalIoxeglQYqt0KNT5J2iYI/vmVGqwHO1FOs4DmKpQoKotoZO84ziG6nft7kdjEMfZdpKddZ/QzFJ6G0NpjBVYptoTrjaf9JSg7GYZuOH1f2p/UN78w5PJofIcCpw5+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RFHSTdTc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RFHSTdTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CCF1F00898;
	Wed, 30 Sep 2026 17:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788291;
	bh=RavK6+xwZsGHLTMdaET4Cpc6U+Mlc//WN8cWUnj9QaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RFHSTdTcHZzTckhgOwrKewuy1Xm1l2BGFYRbz8ZHkoddKG5v2rWbDmfQQFZpkX/+A
	 drn9UjqI6SPlPPT7GsAKSl0P2MbyZljh/KzHUuC7umnGdO9V7qiZfQ40dZcDRXZqro
	 QmFiWz2nhhYRgvnS5jRV9AR90C8O+/uKTcyCacgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1c8c45017f784e646b47@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/877] wifi: mac80211: dont access the TSF of a down interface
Date: Wed, 30 Sep 2026 17:16:25 +0200
Message-ID: <20260930152416.336369988@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 0b1de9feeb8651f7a3bb53ed7c9006e3b5298c01 ]

The tsf debugfs files call the driver even if the interface
isn't up, tgriggering check-sdata-in-driver warnings.

Reject the access in that case.

Assisted-by: LLM
Fixes: 37a41b4affa3 ("mac80211: add ieee80211_vif param to tsf functions")
Reported-by: syzbot+1c8c45017f784e646b47@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1c8c45017f784e646b47
Link: https://patch.msgid.link/20260908122838.201719-18-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/debugfs_netdev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index bb5812925d82e..d3519bbc4285f 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -659,6 +659,9 @@ static ssize_t ieee80211_if_fmt_tsf(
 	struct ieee80211_local *local = sdata->local;
 	u64 tsf;
 
+	if (!ieee80211_sdata_running((struct ieee80211_sub_if_data *)sdata))
+		return -ENETDOWN;
+
 	tsf = drv_get_tsf(local, (struct ieee80211_sub_if_data *)sdata);
 
 	return scnprintf(buf, buflen, "0x%016llx\n", (unsigned long long) tsf);
@@ -672,6 +675,9 @@ static ssize_t ieee80211_if_parse_tsf(
 	int ret;
 	int tsf_is_delta = 0;
 
+	if (!ieee80211_sdata_running(sdata))
+		return -ENETDOWN;
+
 	if (strncmp(buf, "reset", 5) == 0) {
 		if (local->ops->reset_tsf) {
 			drv_reset_tsf(local, sdata);
-- 
2.53.0



