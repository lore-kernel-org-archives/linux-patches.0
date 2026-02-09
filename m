Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F002437756C;
	Mon,  9 Feb 2026 14:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647297; cv=none; b=C9OR/Pvi2P1RkVyAhR3sbWPD5w+Sv9ElMOVREQH3PGZkrnXtgG4nDoeVdv+ucxd90TkSRKT2lyc/f5r8ptEX9k4TY9Qfl1XctKb6woUx6ZzGRlD36xp7qseKLSpi4le8lX/tdMd+v6vfwvDOQqH8xY4FzAjUIl7Owwk651IVq3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647297; c=relaxed/simple;
	bh=bEsXjFMbW5d0ZLNy88vDGfayerq5iDQNsFbyEzW882o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBQ0kbukTRR15joKqQ/eF/nfPRmc2h/Fqs7Z5WDKQevR7dnF5qcik/Qe8ltxOksPl+suWbs0F4xCRFFzSyQkbtwJSriCIyu4kA1Yo4C2qdCMemJtUebdfV17raG4ROIyowQ6+RI9Aqy7Rx497r0kVP8tk76zTBSH8EFD93B09G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3uDX/IY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3uDX/IY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C3AC116C6;
	Mon,  9 Feb 2026 14:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647296;
	bh=bEsXjFMbW5d0ZLNy88vDGfayerq5iDQNsFbyEzW882o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3uDX/IYQXxuRTG2DxcqDeQ5yIlcWkizvjecu3MS3mS24737ovrj+XmDRI+/llaai
	 VZj3kywrwwiFbIUJJO6zhOtuKeCYYX/3WiOGVMYJJPfz+R7o+QpErRjnPk0WymW3xz
	 iYTw04ASFn6T2PCLzcEFmuwFlHSyp5wutO3Oywn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+639af5aa411f2581ad38@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 050/175] wifi: mac80211: dont WARN for connections on invalid channels
Date: Mon,  9 Feb 2026 15:22:03 +0100
Message-ID: <20260209142322.270651867@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index dca47a533392a..8ba199cd38c0f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1126,7 +1126,10 @@ ieee80211_determine_chan_mode(struct ieee80211_sub_if_data *sdata,
 
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
2.51.0



