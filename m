Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94ADE344DB5;
	Thu, 12 Mar 2026 20:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346873; cv=none; b=KSNbOFhL67YxQMyxN9VZBu8nnPUVwDMLtJjSRPWsvOFVvBn9PfsGVDO7Ubpqe8y2zTIgJCWjDBPOEEd4kdrbkfrbGYV89p4Q94vgXDjtGg3YS5U6nhs9ttPEeJGHlike0xfpXvXrSdLvHKxHzgpvhDBrx9wH4dFnmGJvg90n/9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346873; c=relaxed/simple;
	bh=NYAF01Rw0Dtyip0mgkKqCLHSMsGhGKsYOq8mqI9hHco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYh1mmXKIvkgKVwOCEgWieEjzQ7VDfmn9UFhR9LoMq9F9bJ25qE81XxLcJGwLswvBFnsqXPzEKK3tAmV6WXWTJI/i0cvJVhMVeInBq070hJH0mH4zsWfMMBE7/VfwVOYbGVJUCZhW9BCsxGj/gej4YH4Slg8UY8SnYek71Rg4n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IbMe9buB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IbMe9buB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03913C4CEF7;
	Thu, 12 Mar 2026 20:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346873;
	bh=NYAF01Rw0Dtyip0mgkKqCLHSMsGhGKsYOq8mqI9hHco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IbMe9buBegO1cBr6iCeEjPsXMa0PSnQdUEO6ddzruEfeEM6KxXDfE2PkB4RGXPW3I
	 UvMgM05AWqfYPc2A6rJAeVuBCL16K8AsgkCHj/n+bZoi4NsLQ9SDWenBWkY9R+ex/z
	 yavYZEehEqd7JAFccLeJF08hwlYljMME/qvMFhTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vahagn Vardanian <vahagn@redrays.io>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 147/265] wifi: mac80211: fix NULL pointer dereference in mesh_rx_csa_frame()
Date: Thu, 12 Mar 2026 21:08:54 +0100
Message-ID: <20260312201023.569980750@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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
 net/mac80211/mesh.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1631,6 +1631,9 @@ static void mesh_rx_csa_frame(struct iee
 	if (!mesh_matches_local(sdata, elems))
 		goto free;
 
+	if (!elems->mesh_chansw_params_ie)
+		goto free;
+
 	ifmsh->chsw_ttl = elems->mesh_chansw_params_ie->mesh_ttl;
 	if (!--ifmsh->chsw_ttl)
 		fwd_csa = false;


