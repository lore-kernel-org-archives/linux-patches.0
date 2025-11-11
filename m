Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C9B34D38E;
	Tue, 11 Nov 2025 01:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825405; cv=none; b=oYWS6pHSN8aZ6E27oDwBN/NhcpBOEdmV85GVmSiyy3jFOkk9TK/pAEzwCqu2agLiMWc/6Yk7YQQRA1Vylvd/fP6atetgRJ+qMioUg+2xaqFPComCn4kiq5DoNr9LwLKAnxVyg7e4nXHDzv51i2RFYk3krmwxH7jpoUT6Os5isgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825405; c=relaxed/simple;
	bh=nfwGKIvSiUuhpqrxzhwbIMpb0LaBhBLpRpqx9P1gTIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bBjIkG9y7hx1t8Ppvw2bTomHx9P+io2PSze0tCJXIR7Q5EUiwWgSTZwoz/Trc5EGBtunK8iHhR+i2HR9wpIZ9ffcs69cc6pjuXbHSqxrQjmpQoKMzJG39T9mWcvS5Oss7kDo6gpNfFS1ArS1HpL+GtdLmnIz3mtCmwPin30uq9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XiU1Wa9D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XiU1Wa9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F27C16AAE;
	Tue, 11 Nov 2025 01:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825405;
	bh=nfwGKIvSiUuhpqrxzhwbIMpb0LaBhBLpRpqx9P1gTIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XiU1Wa9Du/a6AErNKZyAGFg7Ghz01NGjzv+CXqMG2gPScdjfTfmuEAByKC/en4RJH
	 iiUxpG7UfMlrZI8S+cxHffGAOYY2SR9zAiSSIG9e7t9V7C+k4E1TwWZ/RVpsFgnCmx
	 SniQK93XBLqTIRpiY1ofKuQfp8b1J5GwsnWn7jsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Willi <martin@strongswan.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 787/849] wifi: mac80211_hwsim: Limit destroy_on_close radio removal to netgroup
Date: Tue, 11 Nov 2025 09:45:57 +0900
Message-ID: <20251111004555.463417077@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 3789d46d56149..0555a6bb3620e 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -6453,14 +6453,15 @@ static struct genl_family hwsim_genl_family __ro_after_init = {
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
@@ -6485,7 +6486,7 @@ static int mac80211_hwsim_netlink_notify(struct notifier_block *nb,
 	if (state != NETLINK_URELEASE)
 		return NOTIFY_DONE;
 
-	remove_user_radios(notify->portid);
+	remove_user_radios(notify->portid, hwsim_net_get_netgroup(notify->net));
 
 	if (notify->portid == hwsim_net_get_wmediumd(notify->net)) {
 		printk(KERN_INFO "mac80211_hwsim: wmediumd released netlink"
-- 
2.51.0



