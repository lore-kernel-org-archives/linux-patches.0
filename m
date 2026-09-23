Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C452E3769F9;
	Wed, 23 Sep 2026 14:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172973; cv=none; b=WVelRiiBQuDS/AnBGZrkNMqqoU4f9ysXscx/2OKRsFxTpG33wImODRDn0+IUIxpqLKLLs/7dWTmatWXxz6Y6hV+h2tVsimxI/YG8F0Zhmym0H+NzVY5jX1d4tEU9YnBsK3P55wv4EZ8rqtmP8ZBszTAWQ8RyNy/LUyRNGN4q9sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172973; c=relaxed/simple;
	bh=4udDrJCSyeRjzmHbWXfO7/clEY+GebRy0TqYhJNJ/RE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ib51VQHJSd4eLQkyy9WCHmSGyVd8malaEQ1GNDNctzqcrnC0RufKG0OIJvNvSMonA5j8jGDn0/hmLstnRl5LX8EXdHa/s7AgeQbAni1GsNMtjxYmz1Dnr2gMiRi+fxNoJpN+g/L9x53VP+1VYwmLJqhNDwQUlF69xUXTRwvi+lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1TMP7O2g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1TMP7O2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287AF1F000FF;
	Wed, 23 Sep 2026 14:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172972;
	bh=9p2g9f0fVdaLtpu1ou0wkhXADQiKlWKRl2g+I+UrSRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1TMP7O2g4hAERp8JR8JzHUhSdY3io57901my3skFIUIXSHVMjUE6YzNpeIWymj53M
	 8y4aV9ObEMkFK/wDuQ4nDus+wmDfhuHHTtqa8BwUD9f3YG1ZBH2XWCYLFpP1pSFDZc
	 A36+EGoRT20ZuvYgF1lpSv8V0bdAPe2RzWCvNR0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1c8c45017f784e646b47@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 087/438] wifi: mac80211: dont access the TSF of a down interface
Date: Wed, 23 Sep 2026 16:01:48 +0200
Message-ID: <20260923140647.037363119@linuxfoundation.org>
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
index 8346d3eb11430..6aba224936708 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -657,6 +657,9 @@ static ssize_t ieee80211_if_fmt_tsf(
 	struct ieee80211_local *local = sdata->local;
 	u64 tsf;
 
+	if (!ieee80211_sdata_running((struct ieee80211_sub_if_data *)sdata))
+		return -ENETDOWN;
+
 	tsf = drv_get_tsf(local, (struct ieee80211_sub_if_data *)sdata);
 
 	return scnprintf(buf, buflen, "0x%016llx\n", (unsigned long long) tsf);
@@ -670,6 +673,9 @@ static ssize_t ieee80211_if_parse_tsf(
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



