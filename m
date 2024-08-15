Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4358A19DF5F;
	Thu, 15 Aug 2024 14:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730645; cv=none; b=l4XCisLTJZ9nbnw861z6UZO8UuYvrw1+F0vg7fI3UVsKpGVYhvb2yuq/uHI/QIEUtp5OolD/l1FlUu8VRa8JE6sYnhQoOXj+UrDc3u0EPUq35Zjeesny++hhTq07sVjTUeY9myzf/6x430fmd5JNwVvywJMWIIVQpgU/CFj6GxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730645; c=relaxed/simple;
	bh=3QJ5XFc2jSgWVwWINsxZRlU/3T0NkZfsws9SJoM93wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSLofZiThqnowckM0gJyZc+lUHNtXFV68gXh99hUzHHvkAzTba3ZDglqy/yqOHApY+fm+sWGxIRA6KsrHTMtjakeNHN8kFlof6VdqqgqwwvMn2rR2PP/Jmx0wdpS0GTY9JjDq3WdvUQZNKq7gbEOcoEKXI+FUH3GZ0BEcr7mZdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xoWLvbPR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xoWLvbPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3944C32786;
	Thu, 15 Aug 2024 14:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730645;
	bh=3QJ5XFc2jSgWVwWINsxZRlU/3T0NkZfsws9SJoM93wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xoWLvbPR5yW6SadIeSsnmzvHMdY/TYtj5zAle/Ffhqu/leC4naMBinrE6eZlBY1FP
	 YOJ1LIUtWYAQ7OmUNDKkTG6tosw7sQoeb3wTjvii1FuQDZl2t0GzRCD1gHpSS1bGBV
	 091UReRlr3OtrkPr7JHuEQHUY1eIJ9YDkeKU0rK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	syzbot+19013115c9786bfd0c4e@syzkaller.appspotmail.com,
	Vincenzo Mezzela <vincenzo.mezzela@gmail.com>
Subject: [PATCH 5.15 473/484] wifi: mac80211: check basic rates validity
Date: Thu, 15 Aug 2024 15:25:31 +0200
Message-ID: <20240815131959.747094574@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit ce04abc3fcc62cd5640af981ebfd7c4dc3bded28 upstream.

When userspace sets basic rates, it might send us some rates
list that's empty or consists of invalid values only. We're
currently ignoring invalid values and then may end up with a
rates bitmap that's empty, which later results in a warning.

Reject the call if there were no valid rates.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reported-by: syzbot+19013115c9786bfd0c4e@syzkaller.appspotmail.com
Tested-by: syzbot+19013115c9786bfd0c4e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=19013115c9786bfd0c4e
Signed-off-by: Vincenzo Mezzela <vincenzo.mezzela@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/cfg.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2339,6 +2339,17 @@ static int ieee80211_change_bss(struct w
 	if (!sband)
 		return -EINVAL;
 
+	if (params->basic_rates) {
+		if (!ieee80211_parse_bitrates(&sdata->vif.bss_conf.chandef,
+					      wiphy->bands[sband->band],
+					      params->basic_rates,
+					      params->basic_rates_len,
+					      &sdata->vif.bss_conf.basic_rates))
+			return -EINVAL;
+		changed |= BSS_CHANGED_BASIC_RATES;
+		ieee80211_check_rate_mask(sdata);
+	}
+
 	if (params->use_cts_prot >= 0) {
 		sdata->vif.bss_conf.use_cts_prot = params->use_cts_prot;
 		changed |= BSS_CHANGED_ERP_CTS_PROT;
@@ -2362,16 +2373,6 @@ static int ieee80211_change_bss(struct w
 		changed |= BSS_CHANGED_ERP_SLOT;
 	}
 
-	if (params->basic_rates) {
-		ieee80211_parse_bitrates(&sdata->vif.bss_conf.chandef,
-					 wiphy->bands[sband->band],
-					 params->basic_rates,
-					 params->basic_rates_len,
-					 &sdata->vif.bss_conf.basic_rates);
-		changed |= BSS_CHANGED_BASIC_RATES;
-		ieee80211_check_rate_mask(sdata);
-	}
-
 	if (params->ap_isolate >= 0) {
 		if (params->ap_isolate)
 			sdata->flags |= IEEE80211_SDATA_DONT_BRIDGE_PACKETS;


