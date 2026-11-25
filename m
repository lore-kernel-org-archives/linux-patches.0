Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622052;
	b=AriIGLDSID1Z/htzaTClcX84krZbGnDUHiffUt9NmcOfG3VnK1kHjaw200Dpi6VTUG8J
	 FRJsxspe4rJow+/eR5/CjmPzj0VUu2VGwAyPUKRZDlCCxZn6G+mJUj7nyVZx1V8eyZJ0F
	 Pw9PGXmYYQHi9F3fKkHTaA6U4BTX9SrjCLQ3j4kIzXXmILMpK6bVPzFHVpmW1D/v4+e0M
	 zdU1YqLf0vbAuohQwtel2mS8bDcJNoVoUkpGnRYMC/lJlOEam3LJJf/mqPRGIW+vNfjce
	 Yan8j1hREdYXjndzhxVQsD/q21yr24I2tb5bGyGzLgoFWYpkxcRFvTJ9735EF1iXidQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622052;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/XP9P3A55H5o+Z/Rh5y74PFZrreMLPBUyubNonFYFTI=;
	b=EZj+vWcB3hB+2mQBl9fLCGmJEJMJoo3SrOotjJ2Py2Sh5syvNTc1TKCqDRhT22YvV2jI
	 lbiH4bDX9L2Lc6fiG6CRqE3ogTWrHk6v9CfaOtwBttqbLc1YSTbiy2hEVGUU46e0iZSLz
	 ATPKTRKsmT/AOPH6CwC3P40vNEK0OkiWSZ4mWwKpz0AOweYpTrbcfjPu8Qnwq2TC14FVY
	 IolbcBmwsE2X0wagJ9gfzziXYUXIe0rQisMc89Rhu5AmuOhzMfW6W5v3rz/siimQ4pOYp
	 12HtiUf5/vOXemiuoAItnLu882L5mv6TSLgNewKTm2XKzKPkb/XXNkbEZyEtIno5eoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tOXrb80n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A736606A31E;
	Wed, 25 Nov 2026 15:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tOXrb80n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDA61F000C6;
	Wed, 25 Nov 2026 15:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622052;
	bh=/XP9P3A55H5o+Z/Rh5y74PFZrreMLPBUyubNonFYFTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tOXrb80nNXNiKjg4vNQmhY6+b2VgQfXdncRo+SpEtHPqoDM893MYBAX/3loKUh4pg
	 C8zZenRm/Bd64Ozzb0is7hCMrK6Ehh227ieco1cN89WWN4dNp4HpBjFs9MlyACQrgM
	 02w5O3KFAyB4zBiTf2cRo2Qpgt1QkAG5yaVWtqwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luka Gejak <luka.gejak@linux.dev>,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 416/990] wifi: mac80211: abort chanswitch when leaving an IBSS
Date: Wed, 25 Nov 2026 15:29:43 +0100
Message-ID: <20261125143831.843805437@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

[ Upstream commit 12f97c692dcbce088554a5530c79c55174ccee1a ]

ieee80211_ibss_disconnect() leaves CSA active, as ieee80211_stop_mesh()
did until commit ac7472a24bd4 ("wifi: mac80211: abort chanswitch when
leaving a mesh"). An IBSS left during its countdown and joined again
refuses every new channel switch with -EBUSY.

Abort the channel switch the same way.

Fixes: cd7760e62c2a ("mac80211: add support for CSA in IBSS mode")
Reported-by: Luka Gejak <luka.gejak@linux.dev>
Closes: https://lore.kernel.org/linux-wireless/796598480d47c5bf474d11828769e864b8209558@linux.dev/
Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
Link: https://patch.msgid.link/20261025193615.1123718-1-mehmet.fide@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ibss.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 4dc748a667a72..c7348e7db4f16 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -676,6 +676,10 @@ static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
 	ifibss->state = IEEE80211_IBSS_MLME_SEARCH;
 
 	netif_carrier_off(sdata->dev);
+
+	sdata->vif.bss_conf.csa_active = false;
+	ieee80211_vif_unblock_queues_csa(sdata);
+
 	if (!sta_info_flush(sdata, -1))
 		synchronize_net();
 
-- 
2.53.0



