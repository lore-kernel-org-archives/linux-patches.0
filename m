Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CEB1F7574;
	Tue, 17 Dec 2024 17:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456125; cv=none; b=Itd0rxVTT7M/ETAxnC0DijIThWEx76ogn2Yrxs9v7oF37xOUvUb1bOwNdxcfENub/2RcxVN87qrblXgb65RKZpApza/BxNk8LsQ9jxy7TN1dFWt7HCfUITgO4YaV0iQ8nVGgf6xFER/GcVxUcRGuT2oWK38KP9MiSw/z5I7Ohjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456125; c=relaxed/simple;
	bh=XRD+xlUTndTdbeIhIBqF9v7cdn/7joRQCABBAhsfDWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AEGN9JkjPQurh82bohDDE6wupbu00DyKZo7ySUIJc+BWvNi3cugF/efB6j2Y409WVX40fWkH/IrdQrJdixraBYn1mZIEMToAsMc9J8u4tboh/hgoW0ARftWFg/d3S0p+ukWYOcn5+wSk8yAdfbKIB1xPj9ogu6m/lehCxWIfZfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ep5LZGtD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ep5LZGtD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DDEC4CED3;
	Tue, 17 Dec 2024 17:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456125;
	bh=XRD+xlUTndTdbeIhIBqF9v7cdn/7joRQCABBAhsfDWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ep5LZGtDOcyRzaDYhpacaWZl2N2+TEyLvuBUQAyr5t98O4OTUTUUGMoi0bAhG51Pg
	 Jk54YWA5+PlSItXW61woYYwlCXps5lsUUQWW4EhfSX+OZJXPseZ+L5OnGsetJcJGji
	 +nf6cp9nOblW2aRXviZsys2+n+GRLx1YkW3Ig0aY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Lin <benjamin-jw.lin@mediatek.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/109] wifi: mac80211: fix station NSS capability initialization order
Date: Tue, 17 Dec 2024 18:07:22 +0100
Message-ID: <20241217170534.966315982@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Lin <benjamin-jw.lin@mediatek.com>

[ Upstream commit 819e0f1e58e0ba3800cd9eb96b2a39e44e49df97 ]

Station's spatial streaming capability should be initialized before
handling VHT OMN, because the handling requires the capability information.

Fixes: a8bca3e9371d ("wifi: mac80211: track capability/opmode NSS separately")
Signed-off-by: Benjamin Lin <benjamin-jw.lin@mediatek.com>
Link: https://patch.msgid.link/20241118080722.9603-1-benjamin-jw.lin@mediatek.com
[rewrite subject]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f9395cd80051..a3c5d4d995db 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1879,6 +1879,8 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 						    params->eht_capa_len,
 						    link_sta);
 
+	ieee80211_sta_init_nss(link_sta);
+
 	if (params->opmode_notif_used) {
 		/* returned value is only needed for rc update, but the
 		 * rc isn't initialized here yet, so ignore it
@@ -1888,8 +1890,6 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 					      sband->band);
 	}
 
-	ieee80211_sta_init_nss(link_sta);
-
 	return 0;
 }
 
-- 
2.39.5



