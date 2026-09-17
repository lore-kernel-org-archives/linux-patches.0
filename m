Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C144F93A9;
	Thu, 17 Sep 2026 16:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664242; cv=none; b=a/D1eWullg/SuVectW1ZaDhCECWa+eh8hKs41blgyW7Ncd0Xzb0emqbKTGf1JFdTwHuKyOoyrAn/faqa5/LouldGaNV+rAiKJF2CemuxjzE62sGjzZ6jUM0nPZLvUYvIgWn3Rq9EANuzMpzZOVOpWfWbntEJdTdK089h/yAhBkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664242; c=relaxed/simple;
	bh=lVxk9M3IwWAkjl7vDkqyPEuiX617H19F6YQ2BHaaTPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmWmloHEZjz86K3uy+jrUvvE/p0TCevLtHdif3ZnYdZGDvPGqC4KYzYblr7CMrEA84982rCRw/qnjfiMJgUBkQ82iKe53qESZGvzdeRI0TFZxQWY1QAzBOIFpYTyK4CtbluG/M0XjclpCBAV68mohxOlzY3UV9i/iRL0oetqWrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PZvbbild; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZvbbild"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0001F000FF;
	Thu, 17 Sep 2026 16:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664240;
	bh=NB9S1PGto+/furi3D1HXTIcV5m2nTYfZPihoJm4c7BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PZvbbildg6jHjoyLENnItDRAZ2Soc2WHbKSrQ0D/YyG6BmaSzR0JOoboP1SDxGnpV
	 7qrMukjcr3C1h3SwY3tDfMU7EOTOsH3EQeHXyisgpDmYYA42DIYLhuKDfOWfT/ysmh
	 sYmmRtl6GPLyjW1KUNTYoaAZz+6ErRS18Dfxb3cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0307/1250] wifi: iwlwifi: mld: dont WARN on WoWLAN suspend w/o netdetect
Date: Thu, 17 Sep 2026 16:01:42 +0100
Message-ID: <20260917151600.431039663@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

[ Upstream commit 301b0dfa9db3f1e204de95e803bbd88fbd878c7c ]

Clearly, from a user perspective, it must be valid to configure
WoWLAN and then suspend while not connected to a network. Since
mac80211 doesn't distinguish these cases and simply calls the
driver to suspend whenever WoWLAN is configured, the driver has
to cleanly handle the case where it's called for WoWLAN, it's
not connected but there's also no netdetect configured.

Remove the WARN_ON() and keep returning 1 to disconnect and
then suspend.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260527230313.19720967372b.Iff30814510a26f9f609f98eeea3111c50c1afb31@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/d3.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/d3.c b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
index dd85be94433cc..0cb7bfcd6420e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
@@ -1943,8 +1943,11 @@ int iwl_mld_wowlan_suspend(struct iwl_mld *mld, struct cfg80211_wowlan *wowlan)
 
 	if (!bss_vif->cfg.assoc) {
 		int ret;
-		/* If we're not associated, this must be netdetect */
-		if (WARN_ON(!wowlan->nd_config))
+		/*
+		 * If not associated we can only do netdetect, if
+		 * that's not enabled then just suspend normally.
+		 */
+		if (!wowlan->nd_config)
 			return 1;
 
 		ret = iwl_mld_netdetect_config(mld, bss_vif, wowlan);
-- 
2.53.0



