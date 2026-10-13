Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA093B9DA7;
	Tue, 13 Oct 2026 12:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895771; cv=none; b=rikxqmHHHqmTsz6e5GGjdy5r1RyvKJdhB64NXLD0BEMBMVvt8EI2atkeDn1l/s9KONeQSvCwIauqo68JcMaSHUtVH2qnNK3cLfGRqkWCEhLgUtljbcBESwHr+V/F7PO5cfgkQ6pgA/6732USVxjNm+EDP+nmlNq8VHl4ul4SXKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895771; c=relaxed/simple;
	bh=/JoQLAdkC9kM/2PF+6c74QVsmGdFjQufsSzm4NKSA9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mRT0fVuBc+q+7cs/6hqKrEYska2t+aQO1NNmhCnNr5Mub6H0XldOS+Xgvlra9bEPMq+wBxtHg90d3WUa28z2sbj6L9DlQnXCEIxKZPGjVjBtNz0XoYme3ANpC9MEXaaXIhP29mByxKRWcfxqH7e8+sObiGElisa8kZuZ+G3Ok2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KiMg6G88; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KiMg6G88"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4261F000FF;
	Tue, 13 Oct 2026 12:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895770;
	bh=hkZ+uxCThIC71IqtKpUZHTNfin4E9qHSB9SW/YQ6MMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KiMg6G884n6qcvhbLStRXQBL0hMA7VSD/IlJ+48CvygAoBrn/GUs3Eh/fCmtp9YYF
	 n0v+QTbdf0A7RrcomXZRmJYfTMooC8vsnN/fSLAG+ccXrh8H2qrpwl8xVhd0AHlWDs
	 nZFPjDtR3cLdgHBV0iNY4AHB/TcM+bmPAZFqZIQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 387/497] ice: fix metadata_dst refcount handling on representor teardown
Date: Tue, 13 Oct 2026 13:39:14 +0200
Message-ID: <20261013112917.080435681@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

commit 58858b8f14803a7eeac297b3ce20f3b21bf2ff66 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_eswitch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -94,7 +94,7 @@ ice_eswitch_release_repr(struct ice_pf *
 		return;
 
 	ice_vsi_update_security(vsi, ice_vsi_ctx_set_antispoof);
-	metadata_dst_free(repr->dst);
+	dst_release(&repr->dst->dst);
 	repr->dst = NULL;
 	ice_fltr_add_mac_and_broadcast(vsi, repr->parent_mac,
 				       ICE_FWD_TO_VSI);


