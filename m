Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6392D31619A;
	Mon, 13 Apr 2026 16:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098980; cv=none; b=W1UpLBa2D7R52+goBUBNJVnXJ2/Ed8EO6W3bM4kdOBQu2WoNO2dqrREDtaMMFHUexvzoYOpKz0Ft/qiG3UYs792GLCkhDAvFDF+B1iw9Sv+3jQJGFEYMCh2Kv8GvTxBELcmZMbE4cEg/1azqb84F8fSCubv9LWMiOw6dZ9H63XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098980; c=relaxed/simple;
	bh=IDdryD1XZp6f9ea7/eSgTeoSbTGpbav8toYeMIExyYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYOhLj8tEg+sKFlWjewGyI7wH9EaHE0ZRP5CCp7GDyqtJVOjaCrOxtoCQhtTk2OJv9hW5VKdd2vvO2Afw+mrLxG+FnB3QBF9awPsSu/aLEf6w03O9YRwfysxQdms8MPJFVG5q+AMqxBB5eZfndyenQnv4+w6pTJkhOUvY+S076Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bC89HMT7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bC89HMT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD15C2BCAF;
	Mon, 13 Apr 2026 16:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098980;
	bh=IDdryD1XZp6f9ea7/eSgTeoSbTGpbav8toYeMIExyYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bC89HMT7sQKGyvb6gBBbrAWZDN7PbDS/4bGXjnzYr3pxIrLUujVVlzMqGBnxpSrhX
	 X3hlEIj2MgPtk2QCiGlY2QWvSiVLzdQ2oI7FRuU9LLBKDrUdQRtVUhHU39CvxuFPG/
	 caOpgqxD1yKGGxYZ0QCxoVD6IJjtOypkSLwjmYCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vahagn Vardanian <vahagn@redrays.io>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 163/491] wifi: mac80211: fix NULL pointer dereference in mesh_rx_csa_frame()
Date: Mon, 13 Apr 2026 17:56:48 +0200
Message-ID: <20260413155825.141029426@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vahagn Vardanian <vahagn@redrays.io>

[ Upstream commit 017c1792525064a723971f0216e6ef86a8c7af11 ]

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
[ adapted pointer access elems-> to stack struct elems, and replaced goto free with return ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/mesh.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1435,6 +1435,9 @@ static void mesh_rx_csa_frame(struct iee
 	if (!mesh_matches_local(sdata, &elems))
 		return;
 
+	if (!elems.mesh_chansw_params_ie)
+		return;
+
 	ifmsh->chsw_ttl = elems.mesh_chansw_params_ie->mesh_ttl;
 	if (!--ifmsh->chsw_ttl)
 		fwd_csa = false;


