Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134C84F405C;
	Wed, 30 Sep 2026 17:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788253; cv=none; b=Aa7zTuCn9k2fkuu4bYm/WIqpIgKuOWyZs+Z2P8E242TzWZyhA6OfUN45AfofZblaGkjoepEkQ3KHHHHi+9irqzvRhPX8lcUmUVF9RJaZFeBnU+AV51+xSgUUcg5UWuuxzYJ/2pJnOAruW4xvIAm22uOT/HmxHj7ClbJp6/5pO+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788253; c=relaxed/simple;
	bh=fT1i8VolyTGFED9HhSi6EgWrfnKVMq5TZBri1PRIzM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/e0wu93XvxKe3N8AhL1etVAOqZJg+PopyGBYBfnOqjuoqD18+7R9rDvr+IcqsxVa06KBQwA27CyhN9rcKwH9GfuxfiHP8x03MdZmMrqW4fE7Xi3K/FG9D8S1D3s5bnDNc82hiueHF8B+BggfeU2ROQ7QeH9kZPeZJeS4p8uDQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IpFv5PVe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IpFv5PVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7A71F000FF;
	Wed, 30 Sep 2026 17:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788252;
	bh=kNN2+U/wS5i9NLptBGIbQJ2VFLhlgBCEvB4aYNef4aU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IpFv5PVerlVxdWm8vT/KYW2s9xx6WRPKQB02JbrWekqjBFWquYebWvVyKlqqfY81K
	 4UCel54lAP8anLqsBKxe35TEfXfv/JSGOUH/yVnIQFuQktB6kTqs/hsmjzlDn7jHl3
	 T8Ae53HF7u3vLBom4coqQTcmZawj1BCFjQ9TdziY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c3a167b5615df4ccd7fb@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/877] wifi: mac80211: dont start a ROC while scanning
Date: Wed, 30 Sep 2026 17:16:08 +0200
Message-ID: <20260930152415.975417172@linuxfoundation.org>
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
index 29fab7ae47b4c..0d9807526ecbd 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -462,6 +462,13 @@ static void __ieee80211_roc_work(struct ieee80211_local *local)
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



