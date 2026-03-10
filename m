Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C996A386425;
	Tue, 10 Mar 2026 11:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141132; cv=none; b=VJKXiQ/ME7x4NzhMHXjRrxRzYBEghHc/mp4baT/U/i0MdrBdfDYG0Pvj0eOFjaVCd7Cul2sZEdrFEMM9+art5xiqtbUIv7yVQ6MXMcKiCJTRntcgto1xUHXHWhkD1/Cti0IOkKOHgOkJMLEfcFE/FSuJhpqk5U+D9XXcmDADo2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141132; c=relaxed/simple;
	bh=D8D3pqt99RmAK6jYygHQ7lk041fH9kZgBj0u0ctuROo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnSRHRBWgMXcEZqvQcztvaP91Z3MLdhQS/h0Q/xoPlJyMQuncpLrfPmS2QgbC6jVG2suSv1Wn+zwOLz5RdEzxZToZu27+0c2oemTxZjjUG/32BN8VKGKHkIOYgZmd0TOISqNntpOZXefydQ2MqxQlZMtwL66t6eEH2WRsJcPcSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F+3LyFbB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F+3LyFbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241A3C19423;
	Tue, 10 Mar 2026 11:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141132;
	bh=D8D3pqt99RmAK6jYygHQ7lk041fH9kZgBj0u0ctuROo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F+3LyFbBiZRtDEUm1UvqrdQxDPGKAnrkGWz48H1Et0ZVKiwan40CUATElnc0J+c7i
	 FonH6k7HMlOVgNqm8uL3N62KF/osyLtadjJvjqVaa8KUEKoz+BBPhrFk6E+EcJVFig
	 dk17dBr+X0q7VDX235uMCNrKlCu8/KORyo4XSmT6dC89/WoohQUQYz/DuPZ65HJT7P
	 W1Qtr21XT4tfBhOXKiAC+Z4K+T7CG1wsw4U7xiy90lg0pzhivSSV9uwA57W9s2dSgP
	 +zTgkoMuTB0wlnpzT9+MlcI5aGrHa3KeKVEld2ruqSAyKSsRjpc+F0qAKC3WkSL9pm
	 2loEvhvVQiIgA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vahagn Vardanian <vahagn@redrays.io>,
	Johannes Berg <johannes.berg@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 136/311] wifi: mac80211: fix NULL pointer dereference in mesh_rx_csa_frame()
Date: Tue, 10 Mar 2026 07:03:03 -0400
Message-ID: <3e62b0bb0078423fa3a9610ef5a2819d9f49a519.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Vahagn Vardanian <vahagn@redrays.io>

commit 017c1792525064a723971f0216e6ef86a8c7af11 upstream.

In mesh_rx_csa_frame(), elems->mesh_chansw_params_ie is dereferenced
at lines 1638 and 1642 without a prior NULL check:

    ifmsh->chsw_ttl = elems->mesh_chansw_params_ie->mesh_ttl;
    ...
    pre_value = le16_to_cpu(elems->mesh_chansw_params_ie->mesh_pre_value);

The mesh_matches_local() check above only validates the Mesh ID,
Mesh Configuration, and Supported Rates IEs.  It does not verify the
presence of the Mesh Channel Switch Parameters IE (element ID 118).
When a received CSA action frame omits that IE, ieee802_11_parse_elems()
leaves elems->mesh_chansw_params_ie as NULL, and the unconditional
dereference causes a kernel NULL pointer dereference.

A remote mesh peer with an established peer link (PLINK_ESTAB) can
trigger this by sending a crafted SPECTRUM_MGMT/CHL_SWITCH action frame
that includes a matching Mesh ID and Mesh Configuration IE but omits the
Mesh Channel Switch Parameters IE.  No authentication beyond the default
open mesh peering is required.

Crash confirmed on kernel 6.17.0-5-generic via mac80211_hwsim:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  Oops: Oops: 0000 [#1] SMP NOPTI
  RIP: 0010:ieee80211_mesh_rx_queued_mgmt+0x143/0x2a0 [mac80211]
  CR2: 0000000000000000

Fix by adding a NULL check for mesh_chansw_params_ie after
mesh_matches_local() returns, consistent with how other optional IEs
are guarded throughout the mesh code.

The bug has been present since v3.13 (released 2014-01-19).

Fixes: 8f2535b92d68 ("mac80211: process the CSA frame for mesh accordingly")
Cc: stable@vger.kernel.org
Signed-off-by: Vahagn Vardanian <vahagn@redrays.io>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/mesh.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 68901f1def0dd..129e814abe764 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1636,6 +1636,9 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 	if (!mesh_matches_local(sdata, elems))
 		goto free;
 
+	if (!elems->mesh_chansw_params_ie)
+		goto free;
+
 	ifmsh->chsw_ttl = elems->mesh_chansw_params_ie->mesh_ttl;
 	if (!--ifmsh->chsw_ttl)
 		fwd_csa = false;
-- 
2.51.0

