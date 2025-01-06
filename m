Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4851DE3AB;
	Mon,  6 Jan 2025 15:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177486; cv=none; b=fKidLeB3tt9PFHkAqtmSkc1b1rhV5HD6HVw+r9k8FkbySWWo8M1JYIOi+RuFcnZ3ipOe5UL0pB7TQzhP30czgUq4c0hjPwHiKyge2oFf/+lBTUxe4kLFoWoA6piJOUNcH8RaoqfGRUtS1YMXMNMY8IJzGQf5PBXy4L8ZDtg1Cl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177486; c=relaxed/simple;
	bh=sifCx0nxEPa4n8WjSBtjFp53f0dn8XqnP0TcsGDC7TE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxZr1zAwspFLvsEPvi3zPFF0d/obW3blqbZHpLuRq9Rzhxkhq1uvYA1xY2AuHKv00nGivTF0X7xq30QfQVRdKZy/yEMTJ7SLjMTHsYKtp0/YxFoXYtRaAfafGVZxWu5zgPaDI//yRRElBwzVy1mLHVTwANsrCqKixbA1jTJivRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IejBlxK3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IejBlxK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425C9C4CED2;
	Mon,  6 Jan 2025 15:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177486;
	bh=sifCx0nxEPa4n8WjSBtjFp53f0dn8XqnP0TcsGDC7TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IejBlxK3M32LrDzUWA3RMeM4thTZdi11jctuxDx71xkQIMU23Lr3fYfzy+koPw70n
	 i6RCrvLEjaRhaEJE2nhu+T57be6s93pKpBirLTwezenlkfQBgnCdLsO2GCVZnlB4TT
	 G23meDiGXMQf2rRMpB60S9mqcxQN2Nc0vNEs70Po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Issam Hamdi <ih@simonwunderlich.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 178/222] wifi: mac80211: fix mbss changed flags corruption on 32 bit systems
Date: Mon,  6 Jan 2025 16:16:22 +0100
Message-ID: <20250106151157.505647364@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Issam Hamdi <ih@simonwunderlich.de>

[ Upstream commit 49dba1ded8dd5a6a12748631403240b2ab245c34 ]

On 32-bit systems, the size of an unsigned long is 4 bytes,
while a u64 is 8 bytes. Therefore, when using
or_each_set_bit(bit, &bits, sizeof(changed) * BITS_PER_BYTE),
the code is incorrectly searching for a bit in a 32-bit
variable that is expected to be 64 bits in size,
leading to incorrect bit finding.

Solution: Ensure that the size of the bits variable is correctly
adjusted for each architecture.

 Call Trace:
  ? show_regs+0x54/0x58
  ? __warn+0x6b/0xd4
  ? ieee80211_link_info_change_notify+0xcc/0xd4 [mac80211]
  ? report_bug+0x113/0x150
  ? exc_overflow+0x30/0x30
  ? handle_bug+0x27/0x44
  ? exc_invalid_op+0x18/0x50
  ? handle_exception+0xf6/0xf6
  ? exc_overflow+0x30/0x30
  ? ieee80211_link_info_change_notify+0xcc/0xd4 [mac80211]
  ? exc_overflow+0x30/0x30
  ? ieee80211_link_info_change_notify+0xcc/0xd4 [mac80211]
  ? ieee80211_mesh_work+0xff/0x260 [mac80211]
  ? cfg80211_wiphy_work+0x72/0x98 [cfg80211]
  ? process_one_work+0xf1/0x1fc
  ? worker_thread+0x2c0/0x3b4
  ? kthread+0xc7/0xf0
  ? mod_delayed_work_on+0x4c/0x4c
  ? kthread_complete_and_exit+0x14/0x14
  ? ret_from_fork+0x24/0x38
  ? kthread_complete_and_exit+0x14/0x14
  ? ret_from_fork_asm+0xf/0x14
  ? entry_INT80_32+0xf0/0xf0

Signed-off-by: Issam Hamdi <ih@simonwunderlich.de>
Link: https://patch.msgid.link/20241125162920.2711462-1-ih@simonwunderlich.de
[restore no-op path for no changes]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 25223184d6e5..a5e7edd2f2d1 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1173,14 +1173,14 @@ void ieee80211_mbss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 				       u64 changed)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	unsigned long bits = changed;
+	unsigned long bits[] = { BITMAP_FROM_U64(changed) };
 	u32 bit;
 
-	if (!bits)
+	if (!changed)
 		return;
 
 	/* if we race with running work, worst case this work becomes a noop */
-	for_each_set_bit(bit, &bits, sizeof(changed) * BITS_PER_BYTE)
+	for_each_set_bit(bit, bits, sizeof(changed) * BITS_PER_BYTE)
 		set_bit(bit, ifmsh->mbss_changed);
 	set_bit(MESH_WORK_MBSS_CHANGED, &ifmsh->wrkq_flags);
 	wiphy_work_queue(sdata->local->hw.wiphy, &sdata->work);
-- 
2.39.5



