Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2092FC88B;
	Fri, 21 Nov 2025 13:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733201; cv=none; b=t+r0Nxk/3uOqDkmtfR0zZem/QBxiw4p9MTWuo81CHkgSAEC+uPsDB+kyOp9wwA09mq75Jj6258lFfONi8RruhvEIBI06Ve8/1DXEVOCu3rnVQ2RWup/Qkiq2CLWiKpGPkEh+eH7NT1qxL8sd88PkCq80qJZ3uZLTqASruoGucXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733201; c=relaxed/simple;
	bh=WD1DQk1FVpkP7L1p+GRmko+ZdJba9X/CICgG/9p4TfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDurO6ARqTnIwtqEkfdqEA76Zv5l0VQJAGE8vjazyXoaTjXVb4u8Q83xAaWhIVchUekuKxlH+Reh9BqNKfODnCR/E97x/09b4Wwfa562u5N+7/tDco4TpEFgRXCFEKUBNONwXY4DzNOV1/SvQJvg2kpj6orDPntbUvus/u4qFQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HzcbvYOP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HzcbvYOP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75A2C4CEF1;
	Fri, 21 Nov 2025 13:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733201;
	bh=WD1DQk1FVpkP7L1p+GRmko+ZdJba9X/CICgG/9p4TfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HzcbvYOPtLUkOcDh3CcKyVCeDeroFkB6qOzP0QDrageCPepIs+EIeVnz7fU8Cy/DS
	 HEQBt+AD5kSp6bkL9oWlAgo0+K7t0CH8D74v0idrE1VNK0lTn/3Lj7MygfYgQyoMg9
	 EZNk1iPvXIAEuiH5WrHKTM7IcYLPWwrqG9d5TmWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Willi <martin@strongswan.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 353/529] wifi: mac80211_hwsim: Limit destroy_on_close radio removal to netgroup
Date: Fri, 21 Nov 2025 14:10:52 +0100
Message-ID: <20251121130243.590536667@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f5f48f7e6d26e..1214e7dcc8124 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -6189,14 +6189,15 @@ static struct genl_family hwsim_genl_family __ro_after_init = {
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
@@ -6221,7 +6222,7 @@ static int mac80211_hwsim_netlink_notify(struct notifier_block *nb,
 	if (state != NETLINK_URELEASE)
 		return NOTIFY_DONE;
 
-	remove_user_radios(notify->portid);
+	remove_user_radios(notify->portid, hwsim_net_get_netgroup(notify->net));
 
 	if (notify->portid == hwsim_net_get_wmediumd(notify->net)) {
 		printk(KERN_INFO "mac80211_hwsim: wmediumd released netlink"
-- 
2.51.0



