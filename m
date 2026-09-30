Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11AA4CC63A;
	Wed, 30 Sep 2026 18:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791934; cv=none; b=o3rRZTTWY3mWmKGsGqza0poDhXGD5ig9eNMzvU+zgB/YyO6u3O4cQIl1Dfs2XkFuIZ0BMdOAwBB+aQ7QnxYOF5+/llaYu6mn/PfUhE1sO+2Q8bWHp/Or845aIXx+E0shXtJygmP1AfvWM+VibYeorp6RV4ZdrHhRU4IGtJbgbc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791934; c=relaxed/simple;
	bh=8uIA4sVp+sFmLF646AkjKJ9PYkAphAzAfw/fAe4zxPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R715jHEXGc1DgsdNrz2/0ns4ld5fEKvkbQKb7kOVW+KJHaJS3S2z5RiCdsv8v8kYhxTgmTtTNpe+hL3nCK2IhAozKAv0CpxEOgPyAQNuqG1TEKE8RNVAMgW8Kqp0TCaz+/2plUUvFi7uqcn6hCzOE5SaIYs1PqkS/W2r5J0DT2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CagFv5fh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CagFv5fh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371EA1F000FF;
	Wed, 30 Sep 2026 18:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791933;
	bh=I0GRdSCIfMXz8ZY9TW+bMDkjUhmJKNAE5Ig4GM2awLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CagFv5fhAV5xYMMdATE+BZQGZMz2Ir7Gu7n8ZT8+zpmK3JcfK/1uw8f0pf7xEQoV7
	 1g2mDqtkyMFRdDOE6KBVT0rwWQ0IoiiN+k0Z43gJUW4CEYaegKng8aJabrY3gF8DHZ
	 BBrGzo3au9ZEknTbMsaUICiDQdkZglwNBXLxkMdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1c8c45017f784e646b47@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 478/752] wifi: mac80211: dont access the TSF of a down interface
Date: Wed, 30 Sep 2026 17:25:48 +0200
Message-ID: <20260930152408.614661757@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index db724fc10a5f6..dc582035288d5 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -549,6 +549,9 @@ static ssize_t ieee80211_if_fmt_tsf(
 	struct ieee80211_local *local = sdata->local;
 	u64 tsf;
 
+	if (!ieee80211_sdata_running((struct ieee80211_sub_if_data *)sdata))
+		return -ENETDOWN;
+
 	tsf = drv_get_tsf(local, (struct ieee80211_sub_if_data *)sdata);
 
 	return scnprintf(buf, buflen, "0x%016llx\n", (unsigned long long) tsf);
@@ -562,6 +565,9 @@ static ssize_t ieee80211_if_parse_tsf(
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



