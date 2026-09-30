Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C914FE2E6;
	Wed, 30 Sep 2026 18:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791923; cv=none; b=PAW8w2H3MLrF7F/XnTlDqzSlIYMXea/kk2fYJqQ4hWy7Wos/7wtoAmOE4Iz6vjr85o8UipUyn3zg4qAQAMedWzgIjOUNyykfjsEklux4HcRQKvFE+Uq2OdYX4A2Dvu0yeh3FgZlrVJaRVcTItK6zgPsX4LrLCDubS7rgj3pZbNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791923; c=relaxed/simple;
	bh=iGmUSj58KiK2qpqmjl14zmQ84PFoxJqEAYP4BTbWKTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0MxyWBrffpfL7/5pt2MhMEarzrQqGu+mjnbh7Ww4Kt4udQaEwJYuKvCjfyNjIZL0mU90Lwwa1HRMeiTdoxaCbsfrfJ1784ZB/jPxe+SCgMsq3M6yNvY95H0/MKmokykjyX5aeNRPPYJ8qxVLWOFFVA1Fp/ucnZzsiqxy1uI4y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GrktETRK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GrktETRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1F91F000FF;
	Wed, 30 Sep 2026 18:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791922;
	bh=OANlbN5VXHWfWOd4Rwkoi3KzRh60pCAKgpCSnapXAAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GrktETRK+H2gv9JrZP+KniqnvvdU2I7TqA/dgqpYNem6KBL8lh/lxE64bNQ9k76ht
	 +WG+xWeYfAySs+uQJWRqplh9u28+9h7HoU9M6WK62GLBfRLBTIQD+xEA5KWR692j2b
	 2maactKee0pK2y/YPHml7lQrc3MQ1ZA90PvXDey8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+dc6f4dce0d707900cdea@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 474/752] wifi: cfg80211: dont filter by BSS type when removing stale entries
Date: Wed, 30 Sep 2026 17:25:44 +0200
Message-ID: <20260930152408.530774330@linuxfoundation.org>
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
index de1e89f471a17..5063f43cceda7 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2745,11 +2745,6 @@ void cfg80211_update_assoc_bss_entry(struct wireless_dev *wdev,
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



