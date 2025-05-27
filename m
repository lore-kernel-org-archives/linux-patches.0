Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0A31D63EF;
	Tue, 27 May 2025 17:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367860; cv=none; b=VlBlr5nXSM9z1ufC5qIAyqZ/pSeH7ChWBU4PlnT3ZiToO2Us4HU1XCbH4I3E+cSRyMAWqJB59hXxRf+tgdxOYhdeZZqaDr4NJKZVpLiGt/BSqEUIVdjm0hhfLSZM+aYvOC45rejmrTnPZRNCQ+Zvbkg740Yf7lt5vE8yOpH3RzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367860; c=relaxed/simple;
	bh=UGhgClPjKSIxLRB0Eq2XPP8PbdO2wEWIfCjaoY+Vjn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cz4FA8ZAOifHaVTC9YJioWcahUBfMPibEfPtmMJ2oxfCeEuzb4m6q21S1sjN6glY3jiGaQpmzGpuaTQShk+lLZR7E+GUNe/CJrxU2lSlv2UMIitPvgl1qU1/AuW94ziaaS1y3uESrqdsHrrA3H0CZE74tmktXzF3v2M5Rrn7zOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HMrbmRNg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HMrbmRNg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D744C4CEE9;
	Tue, 27 May 2025 17:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367855;
	bh=UGhgClPjKSIxLRB0Eq2XPP8PbdO2wEWIfCjaoY+Vjn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HMrbmRNgGJj7iEaiJ5FiTnMvDa9Zn7Q85cGhaic6IVHaYMmo6fyLeujycO/mZpgnd
	 vv7+AMrFPeSjJrTYIKpvh5Scl9yztHNjltnf1c0erN8Zzn62Azphz2SY89AyAWlkaX
	 3TB/beoEDSC44NDhyefCm1eGv9WAkRkjyCmw3Fj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 521/783] wifi: mac80211: dont unconditionally call drv_mgd_complete_tx()
Date: Tue, 27 May 2025 18:25:18 +0200
Message-ID: <20250527162534.367738840@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 1798271b3604b902d45033ec569f2bf77e94ecc2 ]

We might not have called drv_mgd_prepare_tx(), so only call
drv_mgd_complete_tx() under the same conditions.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250205110958.e091fc39a351.Ie6a3cdca070612a0aa4b3c6914ab9ed602d1f456@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f92cbbc32a9e5..3bd1c4eeae52f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3832,7 +3832,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	if (tx)
 		ieee80211_flush_queues(local, sdata, false);
 
-	drv_mgd_complete_tx(sdata->local, sdata, &info);
+	if (tx || frame_buf)
+		drv_mgd_complete_tx(sdata->local, sdata, &info);
 
 	/* clear AP addr only after building the needed mgmt frames */
 	eth_zero_addr(sdata->deflink.u.mgd.bssid);
-- 
2.39.5



