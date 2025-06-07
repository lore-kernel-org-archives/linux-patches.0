Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798C215D1;
	Sat,  7 Jun 2025 10:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749291050; cv=none; b=QGNzzWTE50CevRL9qDpGR0BV7kFgxg+oqfY7jfjEdJPHSzY+mHjWBi51oWibfqNNBQPD90ORqVDsVltNv5EjaBsmG393MTKr+6CSfjcwX+3LSAxJx6hCUDlbixW8fF1q6ignwaiJ5O4fWXAOsmDtcUINQXwRaml7z3x+E3nmXKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749291050; c=relaxed/simple;
	bh=lcT4fGffdCcJ7YmEZ1lLJJe8ag3G0MDk/QEkovudG7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSILt53iKaB1hBwJiowtG3hG/6RQHWqqCGc9HFetxMZ3CozzoXuQOKTMD9P/eiJ9b68RfKJlMY/F3QBicMitzjN479on1xw3RFFG2PG3slLMnvqQ3rkS0d/K2aEBV75VGJ1cGnHEdFOwWXq8MKGOUPvlj8hNcEmxOR5dhJIP1Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nvptrB6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nvptrB6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED16BC4CEE4;
	Sat,  7 Jun 2025 10:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749291050;
	bh=lcT4fGffdCcJ7YmEZ1lLJJe8ag3G0MDk/QEkovudG7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nvptrB6geniC6SijQE9bVLeatbFdlgz8KRGTfL9BcEmJ6UNejrPwNXlGql36yJyEH
	 zD7qzQro1C60Hp2+FwEk7WzwbpJof+plCcf1dYZZYFTyYLYDMSRpd88zR667AqEOZm
	 DyzB6B61+FDKZT1XSt3c1p6qRr8fqHQ6Fii9GG/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6.15 18/34] bcachefs: Fix subvol to missing root repair
Date: Sat,  7 Jun 2025 12:07:59 +0200
Message-ID: <20250607100720.433460280@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100719.711372213@linuxfoundation.org>
References: <20250607100719.711372213@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kent.overstreet@linux.dev>

commit 29cc6fb7c068c773049d3bde14b939033893eff4 upstream.

We had a bug where the root inode of a subvolume was erronously deleted:
bch2_evict_inode() called bch2_inode_rm(), meaning the VFS inode's
i_nlink was somehow set to 0 when it shouldn't have - the inode in the
btree indicated it clearly was not unlinked.

This has been addressed with additional safety checks in
bch2_inode_rm() - pulling in the safety checks we already were doing
when deleting unlinked inodes in recovery - but the really disastrous
bug was in check_subvols(), which on finding a dangling subvol (subvol
with a missing root inode) would delete the subvolume.

I assume this bug dates from early check_directory_structure() code,
which originally handled subvolumes and normal paths - the idea being
that still live contents of the subvolume would get reattached
somewhere.

But that's incorrect, and disastrously so; deleting a subvolume triggers
deleting the snapshot ID it points to, deleting the entire contents.

The correct way to repair is to recreate the root inode if it's missing;
then any contents will get reattached under that subvolume's lost+found.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/bcachefs/subvolume.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/fs/bcachefs/subvolume.c
+++ b/fs/bcachefs/subvolume.c
@@ -6,6 +6,7 @@
 #include "errcode.h"
 #include "error.h"
 #include "fs.h"
+#include "inode.h"
 #include "recovery_passes.h"
 #include "snapshot.h"
 #include "subvolume.h"
@@ -113,10 +114,20 @@ static int check_subvol(struct btree_tra
 			     "subvolume %llu points to missing subvolume root %llu:%u",
 			     k.k->p.offset, le64_to_cpu(subvol.v->inode),
 			     le32_to_cpu(subvol.v->snapshot))) {
-			ret = bch2_subvolume_delete(trans, iter->pos.offset);
-			bch_err_msg(c, ret, "deleting subvolume %llu", iter->pos.offset);
-			ret = ret ?: -BCH_ERR_transaction_restart_nested;
-			goto err;
+			/*
+			 * Recreate - any contents that are still disconnected
+			 * will then get reattached under lost+found
+			 */
+			bch2_inode_init_early(c, &inode);
+			bch2_inode_init_late(&inode, bch2_current_time(c),
+					     0, 0, S_IFDIR|0700, 0, NULL);
+			inode.bi_inum			= le64_to_cpu(subvol.v->inode);
+			inode.bi_snapshot		= le32_to_cpu(subvol.v->snapshot);
+			inode.bi_subvol			= k.k->p.offset;
+			inode.bi_parent_subvol		= le32_to_cpu(subvol.v->fs_path_parent);
+			ret = __bch2_fsck_write_inode(trans, &inode);
+			if (ret)
+				goto err;
 		}
 	} else {
 		goto err;


