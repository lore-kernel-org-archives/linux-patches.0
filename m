Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F1B4756B6;
	Mon, 31 Aug 2026 13:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184362; cv=none; b=AfqbeTRgH9A1LBYhMLSk86peoGtR40FN/NSaUUQt/YxAD+JJ4rK/dGUVyGKBY2D6SqZWt/CcL380ok+0EmWOw36nrgIi5+XKRtkAUjthGeuycfHPoZoDe5cfpcn+G3t3oOzO++wdNxs4xeMkXnAom7xGjL++n8DXXk6IlIuR2zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184362; c=relaxed/simple;
	bh=74jQJ0Av16aMFpxD0fFn93hqwebY6mu4Fmmy1eRyj8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPa9HgGRyE5UYIwZcA3TLHrv4uJVLIe1Whn1x7SL0G9YDOS/XIpxWwOwT4IJDirV2JfmDLJqxi2AbImNyQfwGpRwzsT2WdSJtmsOBD6roBTbyOdXBqggDKsxpkcjsldnZX4Zty4Os41jRfiLRsispNof/tVBQ967uOkJr0s9/A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bf7SCAaS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bf7SCAaS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01DF1F00A3F;
	Mon, 31 Aug 2026 13:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184360;
	bh=8XeYfe2jViKI9uffq0HTFNAywDCfrFUwQk3+wCi90+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bf7SCAaSRsMJRr/lMtcLqbDLu1rEpJvczM8NSDEQTls7rscz7qfdouL91ojY09fRn
	 ZUaEjPL0RwoHWTMpv4GW5FhnRK63jfe5+TBPeV/FqId4u6RSwUv/Wnekye8AvkpQDi
	 6551ySoNeZjoUnL4iguzkZwG72C/iHSnN3e98mQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 80/99] vxlan: keep the last remote linked during FDB flush
Date: Mon, 31 Aug 2026 15:34:49 +0200
Message-ID: <20260831133403.881210488@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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
@@ -3062,18 +3062,19 @@ vxlan_fdb_flush_match_remotes(struct vxl
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


