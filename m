Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD0D3A2551;
	Sat, 17 Oct 2026 16:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253591; cv=none; b=d7WO9G4tpz6LKv0KoYA5KcQ3qAjvxE83mAdYtyo1vUfMg2AMgK4zPPlYMlCiaHTxwtovxTQUM3LP32AIBOcWFC5h1ZLdyQZjJzGL/kmlkHWWjcrl2EwmZu+1rpLVjf5RxK28IgOA1WmcOJb+WVXTFE/XRWGrQ1vdCtlojEv05e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253591; c=relaxed/simple;
	bh=qEArexgESgYCXUryHg6G6knuBPAoAn3Isf9xWvCbh9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WSP0jzaTKYtgiXyJDm887rFwlfm/sQfVuJ/hfOZ9yPdZ4ycjSN1ZKoG+w3byf5rzFBq+Dxo4tExSty8F2xiEqrpaDkob2DvdM4wjbEtf6cvUHNP3MAXkD0ycNCH2S614eIP6UxP6DPyI+vH0IUpp2j3Ju7LuqfgrooqU4nWPi60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uc3oq1Tl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uc3oq1Tl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9763D1F000C6;
	Sat, 17 Oct 2026 16:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253589;
	bh=3UPGvxxY8pJTKmLQqyk1+DM2jREqAiIJ5P5oLezf+iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uc3oq1TlP265cQrZXIQlMXXiv8lGcO/+EWeftNF0bNY3vj3oToRifkeeoh26rDevT
	 jC2oSupO602mmP5J7t4WrkjKbwhejtGo5akkWpB1cjs2KYhK8TMV1J2gwBOyhg10u+
	 09AGxJyfxrPvUFBoKtciy3UBlfkKbGs4o4TP63CM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+639af5aa411f2581ad38@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 169/869] wifi: mac80211: dont WARN for connections on invalid channels
Date: Sat, 17 Oct 2026 17:50:10 +0200
Message-ID: <20261017160041.383751119@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

[ Upstream commit 99067b58a408a384d2a45c105eb3dce980a862ce ]

It's not clear (to me) how exactly syzbot managed to hit this,
but it seems conceivable that e.g. regulatory changed and has
disabled a channel between scanning (channel is checked to be
usable by cfg80211_get_ies_channel_number) and connecting on
the channel later.

With one scenario that isn't covered elsewhere described above,
the warning isn't good, replace it with a (more informative)
error message.

Reported-by: syzbot+639af5aa411f2581ad38@syzkaller.appspotmail.com
Link: https://patch.msgid.link/20251202102511.5a8fb5184fa3.I961ee41b8f10538a54b8565dbf03ec1696e80e03@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4cde4792aede9..7fd8fbe3400d3 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -917,7 +917,10 @@ ieee80211_determine_chan_mode(struct ieee80211_sub_if_data *sdata,
 
 	while (!ieee80211_chandef_usable(sdata, &chanreq->oper,
 					 IEEE80211_CHAN_DISABLED)) {
-		if (WARN_ON(chanreq->oper.width == NL80211_CHAN_WIDTH_20_NOHT)) {
+		if (chanreq->oper.width == NL80211_CHAN_WIDTH_20_NOHT) {
+			link_id_info(sdata, link_id,
+				     "unusable channel (%d MHz) for connection\n",
+				     chanreq->oper.chan->center_freq);
 			ret = -EINVAL;
 			goto free;
 		}
-- 
2.53.0



