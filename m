Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3743AFB11;
	Wed, 30 Sep 2026 16:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785958; cv=none; b=nlrSMPzwTTp25BAPcN0Ss4leOJbzazHIGTXu8vbYNMcKG2CtMbs9WsroRpP16TOoh50DG8+u3hPK7wuQHJ+OUEOVuDi9pZbVjV4zRSnoO88572HgZmN/+zQrx2MK6X5rgndk2Do1l9zbgMA2q6Au7jNYqu7Ch2iCQ3ZvfeIIQmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785958; c=relaxed/simple;
	bh=k1BCEW52ZFI37lpD6drrDWywBm+7qwmqWo1KVzOvrXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9IBs+n6nON13k5YPTQUqWPm1MjKnRNd4jNhU0gzvcwRdskpdVmhyDV17+qwzTr+4yROTDqZ0IeKgTSAO+phprCClXUXn2JHGGzI6nrEL+YWe1HMVsymT79rDYg1iFY21iKwCVLCoDVVXptucp88SQPQCq4CdH31583hfNNiINA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iU0+jzzS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iU0+jzzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EADA21F000FF;
	Wed, 30 Sep 2026 16:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785957;
	bh=lAazn9WUYo6Wu9nmMXa7OYdK4JncrSKE7OCnw8DLBaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iU0+jzzSC4vqgcPTVDtdJAr3/I0alVNs4qj6YwtGt3IBYBENyyEDq2IhyG1g8SXRk
	 jc2YhnaIAse2r6fdjylBDiZDVJczi21zs6xoXa31DBdDTcPCbJ58+KqjxKauuCbDtd
	 IPJtn65Hk4WR30B7DriHnSxlYpwuEG8V6XyG/rpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1c8c45017f784e646b47@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 637/982] wifi: mac80211: dont access the TSF of a down interface
Date: Wed, 30 Sep 2026 17:22:53 +0200
Message-ID: <20260930152430.451286054@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6b4b5e0a19570..cb82b7966d374 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -519,6 +519,9 @@ static ssize_t ieee80211_if_fmt_tsf(
 	struct ieee80211_local *local = sdata->local;
 	u64 tsf;
 
+	if (!ieee80211_sdata_running((struct ieee80211_sub_if_data *)sdata))
+		return -ENETDOWN;
+
 	tsf = drv_get_tsf(local, (struct ieee80211_sub_if_data *)sdata);
 
 	return scnprintf(buf, buflen, "0x%016llx\n", (unsigned long long) tsf);
@@ -532,6 +535,9 @@ static ssize_t ieee80211_if_parse_tsf(
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



