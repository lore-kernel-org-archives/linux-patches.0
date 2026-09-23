Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4191418379;
	Wed, 23 Sep 2026 14:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172968; cv=none; b=mGxb8fP2vS3Bxf9srP4X91txaBcvsveSz9uqr185MIc/kjGHaS4gIATzjYOnUvxket42/HvNZfIJmeBzpui1P6qf+oBSs/yivnpltAM9EgrJ4ij+v4bwy2S1TrAiTcHJBSJKR03zuVL+BJ9JaYeySJq7nN2sXG0FQy0YVwTBmZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172968; c=relaxed/simple;
	bh=QJEfTSPD7r/IujqPX7hGKoe+n/deb5WbSN9BeFmFLl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ayeu09xZlBENHDZTXK6SOkOL2c5JIfT5PjcarYt4OABgyczK899PiJt04wKEKchxTw7q2aM3pD0VlnogLAH4/OhTZxvGElEiMMLUUW9nqoCSiNUEzLSe/T3U3IT40MTtu2DfrEE1Tg9119IzqckCHTAX13EhUgZJAHAk1O00bVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHMl7aJm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHMl7aJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253361F000FF;
	Wed, 23 Sep 2026 14:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172966;
	bh=wyGv8S2N89HeFYMHsGF+nppn7kMYtZ6EHlnK/zMUF9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tHMl7aJm9U6l5P8i5Irke6eka6EKE+UJqlGambGh4nPo/w3MXu+kzHS5Gb3tOZrkv
	 MbOhZWRJq3d9Pr9gdC34Q0mes2f9tcuBe06Eg91OJVpVfmVK2iyJySSgA5ePAH26LL
	 mEkNLZnD7T8dTZlPkvBNIzMWrl8016iirtfqZnqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+582469b3a9ef5f13606b@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 085/438] wifi: mac80211: dont allow link changes when iface is down
Date: Wed, 23 Sep 2026 16:01:46 +0200
Message-ID: <20260923140646.985662009@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 370872d30349d81dec519e15ea2949fd63511cf7 ]

ieee80211_set_active_links() only checks that the interface is running in
the inner __ieee80211_set_active_links(), after drv_can_activate_links()
was already called, so using active_links on an interface that's down
triggers the check-sdata-in-driver warning.

Add the missing check in the debugfs file.

Assisted-by: LLM
Fixes: 3d9011029227 ("wifi: mac80211: implement link switching")
Reported-by: syzbot+582469b3a9ef5f13606b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=582469b3a9ef5f13606b
Link: https://patch.msgid.link/20260908122838.201719-16-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/debugfs_netdev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index f3c6a41e49119..8346d3eb11430 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -729,6 +729,9 @@ static ssize_t ieee80211_if_parse_active_links(struct ieee80211_sub_if_data *sda
 	if (kstrtou16(buf, 0, &active_links) || !active_links)
 		return -EINVAL;
 
+	if (!ieee80211_sdata_running(sdata))
+		return -ENETDOWN;
+
 	return ieee80211_set_active_links(&sdata->vif, active_links) ?: buflen;
 }
 IEEE80211_IF_FILE_RW(active_links);
-- 
2.53.0



