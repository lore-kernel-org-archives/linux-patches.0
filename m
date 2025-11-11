Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3063E33F36B;
	Tue, 11 Nov 2025 01:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825012; cv=none; b=oSg6bSMGDQu7RrfESgJpoBgi+uihFqboDmDzkZ/gMPm37lXRdzop7RrhQxXFPAi8e5F7jkjHiC9eSvLKjeNsRjOoWNHy/Iqax88YWFCdznjoonskljuwMnT4H2GVi3jsbZ8nwfh1NOlzCRWEsy8j01gQuVl4xO6YU06jQUeFmYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825012; c=relaxed/simple;
	bh=SxikVSKjoNf3wXNZVuGSc4cCOqNtSevYdqFrP9jNVWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pkq1b4GWBimGxR8df1D/cda1Fq01OmG6hOIPWNwHKrZ6J1CqNrVTRnUiUb5zIBkHZ+I8eVrdC6OedaUFI1rsm5kEU+XYTT0mbauHXGdpwPhiW/wlqr2EcBxkPMY5kJvm/4nhhOwngSvB9jJDEBwehDKf3Kp1qjuDvxzVRx96dmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yYIefKAC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yYIefKAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3AF6C16AAE;
	Tue, 11 Nov 2025 01:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825012;
	bh=SxikVSKjoNf3wXNZVuGSc4cCOqNtSevYdqFrP9jNVWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yYIefKACe48LqUkf8u0RRN+kewDT0OX93raP7wolGFxMFpsRT5mW1U0gV4TPJ5yFt
	 UmTqGsHEpyZro/ICAuN4QIpxt7mc7/sW/SpNI+SPsGP5GxHy3S2VaQG7eNcvxTGOXN
	 up35zJs3StDpj+u+icSgHL4/lDDmd+0MEpERpnIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Willi <martin@strongswan.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 533/565] wifi: mac80211_hwsim: Limit destroy_on_close radio removal to netgroup
Date: Tue, 11 Nov 2025 09:46:29 +0900
Message-ID: <20251111004538.961974166@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Martin Willi <martin@strongswan.org>

[ Upstream commit c74619e7602e88a0239cd4999571dd31081e9adf ]

hwsim radios marked destroy_on_close are removed when the Netlink socket
that created them is closed. As the portid is not unique across network
namespaces, closing a socket in one namespace may remove radios in another
if it has the destroy_on_close flag set.

Instead of matching the network namespace, match the netgroup of the radio
to limit radio removal to those that have been created by the closing
Netlink socket. The netgroup of a radio identifies the network namespace
it was created in, and matching on it removes a destroy_on_close radio
even if it has been moved to another namespace.

Fixes: 100cb9ff40e0 ("mac80211_hwsim: Allow managing radios from non-initial namespaces")
Signed-off-by: Martin Willi <martin@strongswan.org>
Link: https://patch.msgid.link/20251103082436.30483-1-martin@strongswan.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/virtual/mac80211_hwsim.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim.c b/drivers/net/wireless/virtual/mac80211_hwsim.c
index 6fcc21f596ea7..8b4fd5fd11b0e 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -6411,14 +6411,15 @@ static struct genl_family hwsim_genl_family __ro_after_init = {
 	.n_mcgrps = ARRAY_SIZE(hwsim_mcgrps),
 };
 
-static void remove_user_radios(u32 portid)
+static void remove_user_radios(u32 portid, int netgroup)
 {
 	struct mac80211_hwsim_data *entry, *tmp;
 	LIST_HEAD(list);
 
 	spin_lock_bh(&hwsim_radio_lock);
 	list_for_each_entry_safe(entry, tmp, &hwsim_radios, list) {
-		if (entry->destroy_on_close && entry->portid == portid) {
+		if (entry->destroy_on_close && entry->portid == portid &&
+		    entry->netgroup == netgroup) {
 			list_move(&entry->list, &list);
 			rhashtable_remove_fast(&hwsim_radios_rht, &entry->rht,
 					       hwsim_rht_params);
@@ -6443,7 +6444,7 @@ static int mac80211_hwsim_netlink_notify(struct notifier_block *nb,
 	if (state != NETLINK_URELEASE)
 		return NOTIFY_DONE;
 
-	remove_user_radios(notify->portid);
+	remove_user_radios(notify->portid, hwsim_net_get_netgroup(notify->net));
 
 	if (notify->portid == hwsim_net_get_wmediumd(notify->net)) {
 		printk(KERN_INFO "mac80211_hwsim: wmediumd released netlink"
-- 
2.51.0



