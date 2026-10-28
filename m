Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210769;
	b=PzYwFMZdqGycHN/MhklY3uoXfmboMwNT8OIGTUhUQtoy5Hzjuzh0BRczGpC7N32z4/Sl
	 6bzrgyNlMN1OjKgVa5soFp/VUbRhvp1idiM+YXCZT8GoYxBD5VUbpuoMgB99WmPQqDN+9
	 JH0A/UFu2EPbyomGCavFd3ceq2LxjFoYhCHEficabPy9Zz5Xw45IMN4kDHYxW0OlaH8F8
	 QcJnALgSXMIaftLaTZk2DN0BTHyWB/q43GxW3oVy+/dOx57wOUA9RH9eW0Efi8/hWpp9b
	 hIUQmmX1lfP0JMulS7OTnNpET2tyTrCnlwGfmU/hizXg/KU1wi4+C6qre+/cLjw5poA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5W+DxxflY88qNWP42JACFeGRqnzRtfJuTymnqCRrsEc=;
	b=V9fiCsQYNDH9l4KJGFnPRvV5sGMNzScpPRXXOGz9Dn64GH/cqLOAV0q/Sc8VL5VDGLLa
	 7QG04/eBukkSyLiwrFOlNn/RHKUoVSxon1wYHuJ/WphS5IDgX3M7WXoyYOsgcw/Oexehr
	 VvDClpfK/lovynvQWrEIfn3yVeofrQTdNJ9TjjRm51i4g9UsGCWJ73gquZpmlu7d1WiLC
	 +hAQG66w3+N0XgVC0ZVfYToeLHzmsLJgzbpx+Yvyc+UyLiYCXHPKvqQidYOi9yI+5cgXW
	 HmUlzyA4JwXC2F6bncYSYdSc0hj9snyHIYbipLoxcYk66tRJZYVhI4A54xWYp4ekiQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b7bxNWxY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED960606A31E;
	Wed, 28 Oct 2026 18:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b7bxNWxY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4982E1F01825;
	Wed, 28 Oct 2026 18:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210768;
	bh=5W+DxxflY88qNWP42JACFeGRqnzRtfJuTymnqCRrsEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b7bxNWxYZnzrKHBRj32h9zb7foorg0mA42CLX5tQMuyuQW+AvHcbYjsRgCdLhunE0
	 qDR1dah78d7rFgMX5379BiJfQLQhji7idvuHSzqtdtIYnjvqBoHXXfSU6Sml3Mw2Aa
	 nwrGDodrZxXECRd4sW9oDopLYFcDZ18ksa/8D5sI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 143/571] wifi: cfg80211: avoid double free if updating BSS fails
Date: Wed, 28 Oct 2026 17:54:50 +0100
Message-ID: <20261028170011.408356051@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit acc44cbd7727115f9381c35c2898b1b5af665ec8 ]

cfg80211_update_known_bss will always consume the passed IEs. As such,
cfg80211_update_assoc_bss_entry also needs to always set the pointers to
NULL so that no double free can occur.

Note that hitting this would probably require being connected to a
hidden BSS which is then doing a channel switch while also switching to
be not hidden anymore at the same time.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20231220133549.8891edb28d51.Id09c5145363e990ff5237decd58296302e2d53c8@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 5063f43cceda7..375ffdbae1d8b 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2756,10 +2756,9 @@ void cfg80211_update_assoc_bss_entry(struct wireless_dev *wdev,
 
 	if (new) {
 		/* to save time, update IEs for transmitting bss only */
-		if (cfg80211_update_known_bss(rdev, cbss, new, false)) {
-			new->pub.proberesp_ies = NULL;
-			new->pub.beacon_ies = NULL;
-		}
+		cfg80211_update_known_bss(rdev, cbss, new, false);
+		new->pub.proberesp_ies = NULL;
+		new->pub.beacon_ies = NULL;
 
 		list_for_each_entry_safe(nontrans_bss, tmp,
 					 &new->pub.nontrans_list,
-- 
2.53.0



