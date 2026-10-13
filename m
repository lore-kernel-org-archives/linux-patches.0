Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565534F402A;
	Tue, 13 Oct 2026 11:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892620; cv=none; b=sCDEDKoq+oKpnatQsmBUk+J8CSfdNL9OLRxdUogM7AhZ45rfU/Al90SB74z0scUdRFH7BcBZfjox+sCzKD5XV5koObmQUQ1f0AGTttJibYSFn5pG0wNQK6mM+qDprIHHMhIu03uQTsR0VUah3vc8IF89eKH4mirAaPeYcCh5rNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892620; c=relaxed/simple;
	bh=lStveaiUaACDkCa2aHLIPkBfzoLY+392U6quDeXgIlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UALDGYt0v+tsgwJdRoGCXkgxy7KLDm7taw1ZmiAr4AQysAV56fto0Jd6GxcS3oSXEQ+D45Fq9XgC2/5gTP7GyTt1s+3PlLsCg40ZTq77V+L9L9ZAewMSfLIUCQ2MTLvi1oXRZrJyUGKQVAIAKgq/i8cHDfas47Rx94xFEyMaxGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vkNF0s6p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vkNF0s6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7EA1F00893;
	Tue, 13 Oct 2026 11:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892618;
	bh=Mu6GAEZOuKpXsEuNNGAk+0QdmYBVuAsXps28vy3uaJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vkNF0s6pnT3/SoYDM1k3YuAQ/lZZ7ArdDlKlZa8V3oqO76PkUaKlTkrmQgy/kXa3D
	 0y9uw75yaAL5pXpsu8TfLvcmI2mdC9jGYqjVxRp0GvkF+3u/P97AkP5DUzEJlp+zKt
	 l5pjMbcGgB7HiwKChsmL+tW/O2XcvA8TEzLE8os4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Ma <aaron.ma@canonical.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 234/281] wifi: mt76: mt7925: restore the legacy BSS after MLO teardown
Date: Tue, 13 Oct 2026 13:39:10 +0200
Message-ID: <20261013112900.827732793@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Aaron Ma <aaron.ma@canonical.com>

[ Upstream commit 8f9e5807671ee97cacf1957f4a09e43f4f1017a9 ]

Removing the last link of an MLD interface leaves the firmware with the
MLD BSS and DEV entry: the removal loop skips the deflink, and the
hweight16(mvif->valid_links) fallback reads the stale pre-update
valid_links, which is still non-zero. The entry keeps the per-link MAC
address, so every subsequent legacy association fails authentication
until the interface is removed or the module is reloaded.

Remove the deflink BSS and add it back as a legacy BSS on the transition
to zero links.

Fixes: 69acd6d910b0 ("wifi: mt76: mt7925: add mt7925_change_vif_links")
Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Link: https://patch.msgid.link/20260826043658.2255553-1-aaron.ma@canonical.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 9f080da13341b..e6e5c26307a11 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -2220,6 +2220,18 @@ mt7925_change_vif_links(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	mvif->valid_links = new_links;
 
+	/* Restore the legacy BSS after disabling MLO */
+	if (old_links && !new_links) {
+		mt792x_mac_link_bss_remove(dev, &mvif->bss_conf,
+					   &mvif->sta.deflink);
+		err = mt7925_mac_link_bss_add(dev, &vif->bss_conf,
+					      &mvif->sta.deflink);
+		if (err < 0) {
+			mt792x_mutex_release(dev);
+			return err;
+		}
+	}
+
 	mt792x_mutex_release(dev);
 
 	return 0;
-- 
2.53.0



