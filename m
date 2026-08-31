Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF1046D2A6;
	Mon, 31 Aug 2026 13:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184064; cv=none; b=WT9z1ZGNe/cRcs7DxVdAQ4CiFQPL+BbcHdC3izO4HuODOkYf/FjWZpNCAyS18+mB9GneWSV6LAKUhkgdu58Id25u3Zi6iulaoFGMwVTtEmF0CqqaHnugS9hxUpa546yy3/rUt6hTTqSc8NmfoIKsJy7JmMtgHYcUt/Y8WDUzLSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184064; c=relaxed/simple;
	bh=W+Yq8ZQ/nJweSw9b5Atgjobj75Z9kX9bc+be0OzCvjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtn3JRda9cWPfyFw2geVIrDM/OhVOQyOlsfncFjEh/IH2/d6FwPkkDBRLS6Pltor1tRWt63P/Y4FHyVER0V0mBbQ1D28azRRhW3CrayAl/QtgZMlNPXY2bup93u9IWN4lr09C2WZXPmAenKSOoeWdNsPuvAUmcJ6LjztvOM4sFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jy8lhl5A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jy8lhl5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2711F00A3E;
	Mon, 31 Aug 2026 13:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184062;
	bh=HlOnZQO2ezpAB+tJV6yfW/mJkdAFCbCD+7igJ/IxIak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jy8lhl5AzDaZR4EPgbSHSXAmh32v3554I0/WeljPy0IfUqtsg10ucrQocJrZtG1Ub
	 5id4qpdjkYn48nNF/yfyP1v712L/ns4HjOF8uEvLE4WNhXdGsLFnctnCVPt1/A6WaW
	 i5vaL+a0PqsmqVpOCcKaAoIk5/IuuaavnDmMbPNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 60/83] vxlan: keep the last remote linked during FDB flush
Date: Mon, 31 Aug 2026 15:34:36 +0200
Message-ID: <20260831133402.591074043@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

commit d5d4a7b538b52db63927773a8905fcd9f78a42e2 upstream.

A non-nexthop FDB entry is expected to have at least one remote while it
remains reachable through the FDB hash table. A filtered bulk flush
violates this invariant when every remote matches: It unlinks the last
remote in vxlan_fdb_dst_destroy() and only afterwards tells vxlan_flush()
to destroy the parent FDB entry.

An RCU reader can find the parent during this interval.
first_remote_rcu() then applies list_entry_rcu() to the empty list head,
producing an invalid remote pointer that the receive learning path can
read from and write to.

When a matching remote is the sole remaining remote, leave it linked and
ask the caller to destroy the entire FDB entry. vxlan_fdb_destroy() keeps
the remote attached while sending the deletion notification and removing
the parent from the lookup structures.

Fixes: c499fccb71cb ("vxlan: vxlan_core: Support FDB flushing by destination VNI")
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Co-developed-by: David Lee <david.lee@trailofbits.com>
Signed-off-by: David Lee <david.lee@trailofbits.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260810144115.821654-1-david.lee@trailofbits.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan/vxlan_core.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -3060,18 +3060,19 @@ vxlan_fdb_flush_match_remotes(struct vxl
 			      const struct vxlan_fdb_flush_desc *desc,
 			      bool *p_destroy_fdb)
 {
-	bool remotes_flushed = false;
 	struct vxlan_rdst *rd, *tmp;
 
 	list_for_each_entry_safe(rd, tmp, &f->remotes, list) {
 		if (!vxlan_fdb_flush_remote_matches(desc, rd))
 			continue;
 
+		if (list_is_singular(&f->remotes)) {
+			*p_destroy_fdb = true;
+			return;
+		}
+
 		vxlan_fdb_dst_destroy(vxlan, f, rd, true);
-		remotes_flushed = true;
 	}
-
-	*p_destroy_fdb = remotes_flushed && list_empty(&f->remotes);
 }
 
 /* Purge the forwarding table */


