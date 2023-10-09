Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C7018E05
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H5m2aDEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD43C433D9;
	Mon,  9 Oct 2023 13:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857098;
	bh=29+J4yeKJgHbt9jWocVrtge4slbNkv3Uusrcds9+1ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H5m2aDEblflbDylooWFQ+79X5bmcRCMFd3rH7/B8iQqx0Oou5OVM6EhrrOKSLhfW4
	 /+LXufYB24Y2R7xrl5xumqttH8U7UxNrqPpn8MWjRiPidLuCtZtHATxyH49Y+493eO
	 wWkjGKgL/FUlwcjgXVhggwVuKKnwbmy55OJ5h0QE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20H=C3=BChn?= <thomas.huehn@hs-nordhausen.de>,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 069/163] wifi: mac80211: fix mesh id corruption on 32 bit systems
Date: Mon,  9 Oct 2023 15:00:33 +0200
Message-ID: <20231009130125.955644247@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 6e48ebffc2db5419b3a51cfc509bde442252b356 ]

Since the changed field size was increased to u64, mesh_bss_info_changed
pulls invalid bits from the first 3 bytes of the mesh id, clears them, and
passes them on to ieee80211_link_info_change_notify, because
ifmsh->mbss_changed was not updated to match its size.
Fix this by turning into ifmsh->mbss_changed into an unsigned long array with
64 bit size.

Fixes: 15ddba5f4311 ("wifi: mac80211: consistently use u64 for BSS changes")
Reported-by: Thomas Hühn <thomas.huehn@hs-nordhausen.de>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20230913050134.53536-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h | 2 +-
 net/mac80211/mesh.c        | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 91633a0b723e0..f8cd94ba55ccc 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -676,7 +676,7 @@ struct ieee80211_if_mesh {
 	struct timer_list mesh_path_root_timer;
 
 	unsigned long wrkq_flags;
-	unsigned long mbss_changed;
+	unsigned long mbss_changed[64 / BITS_PER_LONG];
 
 	bool userspace_handles_dfs;
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index af8c5fc2db149..e31c312c124a1 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1175,7 +1175,7 @@ void ieee80211_mbss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 
 	/* if we race with running work, worst case this work becomes a noop */
 	for_each_set_bit(bit, &bits, sizeof(changed) * BITS_PER_BYTE)
-		set_bit(bit, &ifmsh->mbss_changed);
+		set_bit(bit, ifmsh->mbss_changed);
 	set_bit(MESH_WORK_MBSS_CHANGED, &ifmsh->wrkq_flags);
 	wiphy_work_queue(sdata->local->hw.wiphy, &sdata->work);
 }
@@ -1257,7 +1257,7 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 
 	/* clear any mesh work (for next join) we may have accrued */
 	ifmsh->wrkq_flags = 0;
-	ifmsh->mbss_changed = 0;
+	memset(ifmsh->mbss_changed, 0, sizeof(ifmsh->mbss_changed));
 
 	local->fif_other_bss--;
 	atomic_dec(&local->iff_allmultis);
@@ -1724,9 +1724,9 @@ static void mesh_bss_info_changed(struct ieee80211_sub_if_data *sdata)
 	u32 bit;
 	u64 changed = 0;
 
-	for_each_set_bit(bit, &ifmsh->mbss_changed,
+	for_each_set_bit(bit, ifmsh->mbss_changed,
 			 sizeof(changed) * BITS_PER_BYTE) {
-		clear_bit(bit, &ifmsh->mbss_changed);
+		clear_bit(bit, ifmsh->mbss_changed);
 		changed |= BIT(bit);
 	}
 
-- 
2.40.1



