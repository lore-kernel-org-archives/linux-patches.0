Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CA623D7FF;
	Wed, 30 Sep 2026 18:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793450; cv=none; b=Q7TxXBYdpGLR2dySd/wenpzlhsnUho6z9eVxs6thqrpFSbcXgLfyX5zq58Z/Fhqw+V5XSunpqgt3fjRsLQvukIILTrUVxwH7Bdexmgkb/+3e8wfvxnVj9Zgtb+u8VFCFyzfFf42GXbdDMB8Coatd6kqiEeAG8i3Rhmkr3G+9STI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793450; c=relaxed/simple;
	bh=X487LUrTLF1ZlwZ7Wden1v/U4IYJF5J4BcKjpkYcQbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8oK6zAzjX4yzpGb7h5qELRqet+uYZeY3vgg+uDO2fGv2QLjrqk6x9Xf2GM35aLNjY3h1hSxMxy6qk6NLqQvMCzBr+yVZvX+8o+0y5iqRJAcwHQUCu84OF7ESJk230C/2jxD9qUhRno1wXQFzGSf6YacI7eRhOFWoLUB+LO+nbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XPcWzRAK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XPcWzRAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC99A1F000FF;
	Wed, 30 Sep 2026 18:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793449;
	bh=mAYvr2AkxPKmgwSozXHwJ28vNqFBFPBE5SjpAuyRaV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XPcWzRAKHJoaIvtWJInzC3A5TDzCiOJb47cKES6MTX0uAxnXfjobUZHEwRLlYEYMe
	 xiB+wYcBENn0eRdUAErWvX/8jVTBGfKuntDfKFOeYESLtlRCVVzKqlmEBLBfd98Qpn
	 OWCl1/YNDExaFrfWXUImpeU0MZlp8wzfAvDX1Gdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	"Patrick Lu (Anthropic)" <perf.patrick.lu@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 222/395] writeback: bound cleanup_offline_cgwb() rescans by rotating scanned inodes
Date: Wed, 30 Sep 2026 17:28:04 +0200
Message-ID: <20260930152345.476824352@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Patrick Lu (Anthropic) <perf.patrick.lu@gmail.com>

commit f6988c90671e83db79df1b7b9d6fdb0e5947fd84 upstream.

cleanup_offline_cgwb() prepares at most WB_MAX_INODES_PER_ISW inodes
per call and is called again until the dying wb is drained, but every
call walks wb->b_attached and then wb->b_dirty_time from the same end.
Inodes already prepared (they stay on the list with I_WB_SWITCH set
until the switch worker runs) and inodes that cannot be switched
(I_FREEING, I_WILL_FREE, !SB_ACTIVE, DAX, already on the target wb)
stay where they are, so each pass rescans a growing run of them under
wb->list_lock and a full drain is quadratic in the number of inodes on
the list. With ~17M inodes attached to one dying cgwb we saw this end
in soft lockups, with CPUs reported stuck for 21-48s.

Walk both lists from the oldest end and move every scanned inode to
the newest end, so the next pass starts where the previous one stopped
and the drain becomes linear. b_attached is unordered, so nobody sees
the reorder there. b_dirty_time is ordered by dirtied_when, but the
oldest unscanned inode stays at the end move_expired_inodes() picks
from, sync takes the whole list regardless of order, and prepared
inodes leave the list as soon as the switch work runs and get a new
dirtied_time_when on the new wb anyway, so the only inodes left out of
order are the ones that can never switch (DAX), and only on the dying
wb.

Fixes: c22d70a162d3 ("writeback, cgroup: release dying cgwbs by switching attached inodes")
Cc: stable@vger.kernel.org
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Patrick Lu (Anthropic) <perf.patrick.lu@gmail.com>
Link: https://patch.msgid.link/20260911-wb-cgwb-rotate-v2-1-a9ab253a1295@gmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fs-writeback.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -693,19 +693,34 @@ static bool isw_prepare_wbs_switch(struc
 				   struct inode_switch_wbs_context *isw,
 				   struct list_head *list, int *nr)
 {
-	struct inode *inode;
+	struct inode *inode, *tmp;
+	LIST_HEAD(scanned);
+	bool full = false;
+
+	/*
+	 * Walk from the oldest end and move scanned inodes to the newest
+	 * end, so the next scan resumes at unscanned inodes instead of
+	 * re-walking an ever-growing run of prepared and skipped ones.
+	 * For b_dirty_time this keeps the oldest unscanned inode at the
+	 * end move_expired_inodes() picks from; b_attached is unordered.
+	 */
+	list_for_each_entry_safe_reverse(inode, tmp, list, i_io_list) {
+		list_move(&inode->i_io_list, &scanned);
 
-	list_for_each_entry(inode, list, i_io_list) {
 		if (!inode_prepare_wbs_switch(inode, new_wb))
 			continue;
 
 		isw->inodes[*nr] = inode;
 		(*nr)++;
 
-		if (*nr >= WB_MAX_INODES_PER_ISW - 1)
-			return true;
+		if (*nr >= WB_MAX_INODES_PER_ISW - 1) {
+			full = true;
+			break;
+		}
 	}
-	return false;
+	list_splice(&scanned, list);
+
+	return full;
 }
 
 /**


