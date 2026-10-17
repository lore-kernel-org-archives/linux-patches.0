Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD90336CE19;
	Sat, 17 Oct 2026 17:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257558; cv=none; b=CfqrDLLwiq7O7CLKQ4IVoM6yI+/KHz5zYRCPul24Wim9E1XwvqpPfVEg4Oqwpi8mdGRREt7A4Eiv+WAuMhNAFqX00UE2efmTKrpVXjbPrjJYIFlVmf010voNxLq057TP39NP91SCq8IYKfA4rSU3rWSX8+BAj+qbnntfhNgsuws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257558; c=relaxed/simple;
	bh=Khhohx0qTgYQFTSVQ/PDNuNXydQJx+P18Rag/qIBY4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLbUmbYcntV4dbeopsTs/GypPpG4L0g8xe53hx7EcqW0gvGq6ReF/vFBXi0gq4dHuIUvXZqH4pmXOUIfgQ7u/jvunggI1/wszYfh0S8nyQ8YbYRHZ4Lk3kowQr84sdOG1UssZuo8lDTVypVKRAh0CpB0K6vwXQ4QLXjRLljK5oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vsOExG1A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vsOExG1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B2D1F000C4;
	Sat, 17 Oct 2026 17:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257556;
	bh=Be67ijNDpG+pTo09I6SmIFOLH6uXx8fF21l0LUCWu1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vsOExG1AaIhZG6JLrtQOA3M5fILgEHmxtO6dMizYNSpAgRnrE5hH2A/iJiHYUwIhN
	 1maz2qC/lh02VYor/oQ+Fo6YddhJzy0op3ZBdzTX5dCVPGXZ3R8iHZ1gBzzCgll6sS
	 3mmY+Q9ei8B07jrGn/pIm3/i6mIDm/lSNg/z8Oz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0570/1674] ice: fix metadata_dst refcount handling on representor teardown
Date: Sat, 17 Oct 2026 17:47:22 +0200
Message-ID: <20261017160445.724238504@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit 58858b8f14803a7eeac297b3ce20f3b21bf2ff66 ]

ice_eswitch_release_repr() uses metadata_dst_free() to release the
representor's metadata_dst.  metadata_dst_free() directly frees the
underlying memory without checking the dst_entry refcount.

When ice_eswitch_port_start_xmit() processes a packet, it takes a
reference via dst_hold() and attaches the metadata_dst to the skb.
If the representor is torn down while packets are still queued on
the lower device (e.g. in a qdisc), the metadata_dst is freed while
references are still held.

Use dst_release() instead, which correctly decrements the refcount
and only frees the object when all references are dropped.  The dst
subsystem already handles metadata_dst cleanup in dst_destroy() when
DST_METADATA is set.

Other drivers sharing this pattern (nfp, airoha, bnxt) already use
dst_release() for their metadata_dst lifecycle.

Fixes: f5396b8a663f7 ("ice: switchdev slow path")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260928230429.495442-5-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Adapted repr->dst access to vf->repr->dst in ice_eswitch_release_reprs(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_eswitch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index e7f1e53314d76..528ca4be2b648 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -207,7 +207,7 @@ ice_eswitch_release_reprs(struct ice_pf *pf, struct ice_vsi *ctrl_vsi)
 			continue;
 
 		ice_vsi_update_security(vsi, ice_vsi_ctx_set_antispoof);
-		metadata_dst_free(vf->repr->dst);
+		dst_release(&vf->repr->dst->dst);
 		vf->repr->dst = NULL;
 		ice_eswitch_del_vf_sp_rule(vf);
 		ice_fltr_add_mac_and_broadcast(vsi, vf->hw_lan_addr,
-- 
2.53.0



