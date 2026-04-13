Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B9530BBAE;
	Mon, 13 Apr 2026 16:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097787; cv=none; b=rSk+Lg/1gzlt59LI33Pm5lX6rHUGhPgYbdHUSFAjljlb1aUdNxEW1MA0GvsuZ97QirQ4JBBPqmG8stVzqqbmljzjRCV9RwnrwiU7dsQCdq8RmXIHNeDdRshn+H0GIqhXAEcDSgnvOXgjGCpoLH6WAWkK8KKbndLQL9B8jC53928=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097787; c=relaxed/simple;
	bh=0Ux1agx9akHpptxy8fjQXfynG9xDpMMDBH8XuDlbsEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6xszZ/I9jPBTOK+lMchcLkWVZ6cc+WF2ZtInIhnCrCeRnCKrBvqTuGFk3IN/E1CUZaf6aAioZrTN1tIW7tMeh2Gs/Nv9vmXiyzOCEl7vVV4R5jW4YrXRDNoxb7PLi2dx9nQyuG5HiYxCZ9q7d2ZTqHXG652oHEJvprmnWlE1ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ID2zlL8Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ID2zlL8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE3EC2BCAF;
	Mon, 13 Apr 2026 16:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097787;
	bh=0Ux1agx9akHpptxy8fjQXfynG9xDpMMDBH8XuDlbsEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ID2zlL8ZryH8obaLbLXAVz9IijKWldmVKn/EQYTLXVocUIQKTwbaES2fTsP0BmagT
	 UHJlCAUrApMxtGSOpBV/EHQIR4WkicWL74u6VsYf9e2nGfR+UI0YTmXyYy/n3jOUB+
	 YbZAk5oeBUpaaKAFAfTOk8SmKETMXpR+wcK8tlS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 273/570] wifi: mac80211: fix NULL deref in mesh_matches_local()
Date: Mon, 13 Apr 2026 17:56:44 +0200
Message-ID: <20260413155840.710468809@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit c73bb9a2d33bf81f6eecaa0f474b6c6dbe9855bd ]

mesh_matches_local() unconditionally dereferences ie->mesh_config to
compare mesh configuration parameters. When called from
mesh_rx_csa_frame(), the parsed action-frame elements may not contain a
Mesh Configuration IE, leaving ie->mesh_config NULL and triggering a
kernel NULL pointer dereference.

The other two callers are already safe:
  - ieee80211_mesh_rx_bcn_presp() checks !elems->mesh_config before
    calling mesh_matches_local()
  - mesh_plink_get_event() is only reached through
    mesh_process_plink_frame(), which checks !elems->mesh_config, too

mesh_rx_csa_frame() is the only caller that passes raw parsed elements
to mesh_matches_local() without guarding mesh_config. An adjacent
attacker can exploit this by sending a crafted CSA action frame that
includes a valid Mesh ID IE but omits the Mesh Configuration IE,
crashing the kernel.

The captured crash log:

Oops: general protection fault, probably for non-canonical address ...
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
Workqueue: events_unbound cfg80211_wiphy_work
[...]
Call Trace:
 <TASK>
 ? __pfx_mesh_matches_local (net/mac80211/mesh.c:65)
 ieee80211_mesh_rx_queued_mgmt (net/mac80211/mesh.c:1686)
 [...]
 ieee80211_iface_work (net/mac80211/iface.c:1754 net/mac80211/iface.c:1802)
 [...]
 cfg80211_wiphy_work (net/wireless/core.c:426)
 process_one_work (net/kernel/workqueue.c:3280)
 ? assign_work (net/kernel/workqueue.c:1219)
 worker_thread (net/kernel/workqueue.c:3352)
 ? __pfx_worker_thread (net/kernel/workqueue.c:3385)
 kthread (net/kernel/kthread.c:436)
 [...]
 ret_from_fork_asm (net/arch/x86/entry/entry_64.S:255)
 </TASK>

This patch adds a NULL check for ie->mesh_config at the top of
mesh_matches_local() to return false early when the Mesh Configuration
IE is absent.

Fixes: 2e3c8736820b ("mac80211: support functions for mesh")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Link: https://patch.msgid.link/20260318034244.2595020-1-xmei5@asu.edu
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index e75f53f08b611..167b0625b1a17 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -75,6 +75,9 @@ bool mesh_matches_local(struct ieee80211_sub_if_data *sdata,
 	 *   - MDA enabled
 	 * - Power management control on fc
 	 */
+	if (!ie->mesh_config)
+		return false;
+
 	if (!(ifmsh->mesh_id_len == ie->mesh_id_len &&
 	     memcmp(ifmsh->mesh_id, ie->mesh_id, ie->mesh_id_len) == 0 &&
 	     (ifmsh->mesh_pp_id == ie->mesh_config->meshconf_psel) &&
-- 
2.51.0



