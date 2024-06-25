Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A98149C5E;
	Tue, 25 Jun 2024 09:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308471; cv=none; b=uKxS+TZWlCCla3CN/s+UqX29sOzj9FqNxpXMcm2WPeH3ibCxAscR91UypFyVBVA646Si0EI9MQTBqcrfWUPKbby4+2bT5Z6pNfVZXi6j9SJsf4OGf/GQu2kUPPxRJGXh/Ka0mSa5/vrk9d+OcxiOT7a7jwUTm13h+yuulL7STBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308471; c=relaxed/simple;
	bh=hoWduKCzMjV1jasqquvmfjRMFUjpqQ2Yh141gw6VLro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5oej7TBM+yLojbORIAGqE775V99H9+G40b2V65241L8cKzngkAsMcijAf15RDbbxW2/BzxvquZhoKUxsT3+KEXS0LWlByGy4FRXhun5xdWgt+CqlGI+Jh4N3Ot8sK6GXyaQcb6M/5sxCYkxg5OCTMDBDaDoI46B4pCy+IBiDL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NN/d1HKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NN/d1HKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7746C32781;
	Tue, 25 Jun 2024 09:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308471;
	bh=hoWduKCzMjV1jasqquvmfjRMFUjpqQ2Yh141gw6VLro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NN/d1HKqumk9ZK0PtxXCK6nM92Fonf4SiLXvyaz3O4xbaZXtI2iv1Q/EcjzK0P/Eg
	 5Wmsf3TeBP21uKAvS0ZwdfSlcUvGwcR/cZ1nJgfnSWGxAOKUjI/kUGICoUdOT4P3Md
	 nfJiaghvNx+LUOY1F4NVbH8QsbrZuhtVlXQs5Ksk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Remi Pommarel <repk@triplefau.lt>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 101/250] wifi: mac80211: Recalc offload when monitor stop
Date: Tue, 25 Jun 2024 11:30:59 +0200
Message-ID: <20240625085551.947002960@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Remi Pommarel <repk@triplefau.lt>

[ Upstream commit 7d09e17c0415fe6d946044c7e70bce31cda952ec ]

When a monitor interface is started, ieee80211_recalc_offload() is
called and 802.11 encapsulation offloading support get disabled so
monitor interface could get native wifi frames directly. But when
this interface is stopped there is no need to keep the 802.11
encpasulation offloading off.

This call ieee80211_recalc_offload() when monitor interface is stopped
so 802.11 encapsulation offloading gets re-activated if possible.

Fixes: 6aea26ce5a4c ("mac80211: rework tx encapsulation offload API")
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Link: https://msgid.link/840baab454f83718e6e16fd836ac597d924e85b9.1716048326.git.repk@triplefau.lt
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/iface.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index ef6b0fc82d022..d759ef2b88c24 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -686,6 +686,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 			ieee80211_del_virtual_monitor(local);
 
 		ieee80211_recalc_idle(local);
+		ieee80211_recalc_offload(local);
 
 		if (!(sdata->u.mntr.flags & MONITOR_FLAG_ACTIVE))
 			break;
-- 
2.43.0



