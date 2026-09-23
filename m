Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4482526ABD;
	Wed, 23 Sep 2026 14:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172815; cv=none; b=oZo4tSdJREyr8z5pKH49sChsVKIU3wmIgVP9DpcDpyzdyuTzrYs+VjU6wjBHZ8B1Wwo76Nei0upQnKTXuDKUbUm61piBIV30SQfdXyqg0I0SoUOXNFvdm79RPpeXPOZWPhSARBarsxniMc0Pz7JBTa/++i3DD+pfDAGWsGHvCCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172815; c=relaxed/simple;
	bh=6KiN5DwPAshIiHG05w66zpbaYONs5ifQeqqwmtgzZK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbHAJ9ZZ5g7cmJOWdYzX3nOapMgWMFeIXg96qahmQQcIvsaGcNfn9rKqF+Hw0wOdGNESAA7p9Wyj7TIFi7DrWeU6B91JubeFsqN8mS/SMZQ2ywsz4aUt1KnHkyXmvG6ZFvLNilQC6+PdMVK1vWBR8dRJ0v0dtSlsGsM/F/XHV4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vTOIcq5Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vTOIcq5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A6A1F000FF;
	Wed, 23 Sep 2026 14:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172814;
	bh=OSRtsDWZrSUKeq92QzJYut+N3c7n20TQcvjmR7nqdHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vTOIcq5Z2Yt1QEDxz3RIw2qTs3ZIC/QEZmXw1njA3vypIG21eLcr7aTENzWjAWZca
	 eCcEVa5V7324uAoTLDPgf0oPOGNqiPsI6ojTcAZ/TjZl/U8mtFtFuNKlYbbb3d8jXJ
	 Om2cg1JkSlSi7GBLedPde32hx7ZTuLiCBwD7D7RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c3a167b5615df4ccd7fb@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 069/438] wifi: mac80211: dont start a ROC while scanning
Date: Wed, 23 Sep 2026 16:01:30 +0200
Message-ID: <20260923140646.577240806@linuxfoundation.org>
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

[ Upstream commit 733f0fde95392ed5f61a4e36aee661ea8d0e8581 ]

The ROC work can be pending when a scan starts (which requires
ROC list to be empty, but that's possible), and then a new ROC
can be added to the list and the work will pick it up.

Avoid starting that ROC if a scan made it between things, as
otherwise we'll hit a warning later:

  WARNING: net/mac80211/offchannel.c:404 at ieee80211_start_next_roc+0x256/0x2d0
  Workqueue: events_unbound cfg80211_wiphy_work
  Call Trace:
   __ieee80211_scan_completed+0x4fd/0xe40 net/mac80211/scan.c:537
   ieee80211_scan_work+0x472/0x1ff0 net/mac80211/scan.c:1193
   cfg80211_wiphy_work+0x410/0x570 net/wireless/core.c:513

Assisted-by: LLM
Fixes: aaa016ccd5df ("mac80211: rewrite remain-on-channel logic")
Reported-by: syzbot+c3a167b5615df4ccd7fb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c3a167b5615df4ccd7fb
Link: https://patch.msgid.link/20260904165722.f9d5b150edd8.I61bc9de8c8d089096ad695213b9c85c7df38c3bd@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/offchannel.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 2bceb73717c66..6f8de5d4a20d3 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -460,6 +460,13 @@ static void __ieee80211_roc_work(struct ieee80211_local *local)
 		return;
 
 	if (!roc->started) {
+		/*
+		 * The work can be started by a previous ROC work, but a scan
+		 * can get between things; scan finish will retrigger us.
+		 */
+		if (local->scanning)
+			return;
+
 		WARN_ON(!local->emulate_chanctx);
 		_ieee80211_start_next_roc(local);
 	} else {
-- 
2.53.0



