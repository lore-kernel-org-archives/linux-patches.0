Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050375;
	b=1Qi8eH7MQFlKLJltkIeM+w41AO3XNu2N83I2TCpzMTCPqFxj/P4nadXakNwSKIt3sSd2
	 YeHJ5IJc7QhGikCO7YsJsVvHJy2mwqnZHG97Z3wg7yxxitMloNddax4BBGXVWSAi0/lBH
	 S247rzo39igM7AW9rJXHrvXapg9Wzsm2TF7U4R/TgividwSfN/BP+lWMJNG+UufLn53nd
	 Iy7A7sbLeeu5n/n2hL83+GfQ/5i6xAVbR2m+lJovILukE/VPf2VlySmz/UL+8E5/Q/D43
	 94XuZ/LExN1MIVwpAJHTY29ouZCtbc/Wuk1yYoA+O378py0AW2UG/JdL1igqSK9PPVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=++uAjjWObD6pPTJ2DMW5qVNwBHyPDGqKjgHlsQahV9I=;
	b=p/eM7vsJ2RvHznyHNMQYdzYRXm7ZujJzRJiBcalO9wVuC6UGOf4An3JN2EI4fZYHVQmH
	 GEL3Kb4lt1af12HFZ44lbcecC/ReVchmY9eMzFOrsh4uXOm68hpJD175OeAUN3443NAzZ
	 bLNGyikjmjkChp0nCKiZ0mOMFK+KP7jOzA+qpOBhjSCndcGX993uTzdEttxQAzwCY8ALZ
	 4vm6WE9/Ts1nX8xu9Q+9XBQmFsH3ozor7l8uF22gC6fWQaFwkiJVTBx8AEYAI7dyfNrC0
	 KwX9YxKxxwEbOdZJJpnXl6sd48iyxReh41r8kg+LOxtdNTagXYGmVv69oiTg85q321g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JuVrniIA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CCF606A32F;
	Thu, 19 Nov 2026 01:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JuVrniIA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5343E1F000C5;
	Thu, 19 Nov 2026 01:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050375;
	bh=++uAjjWObD6pPTJ2DMW5qVNwBHyPDGqKjgHlsQahV9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JuVrniIAWUpooKgrlic0mvFiC6qcpRXTNx8032ci0Aar3l2JpYCP5QUCOS788YV1D
	 ctUkNTSg2in7AeUu8ckPeju+ayZCh3Hohudm3T1cmguiWJ8juTUMPKFgYDsDA2XRrE
	 dczrDHP8qEGT96pt7XRSZssD3QkQcLfrgU9W0ojY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2668/2857] ocfs2: reserve xattr value tree metadata only once
Date: Wed, 18 Nov 2026 16:01:42 +0100
Message-ID: <20261118150337.641720121@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit 5365f1f417b36627f825aacf9844ae24b671b525 ]

ocfs2_calc_xattr_set_need() asks for the new value's extent tree twice
when it replaces an inline value smaller than a value root with one large
enough to be stored outside.  The "stored outside" branch reserves the
tree and then falls through to meta_guess instead of going out:

        if (!ocfs2_xattr_is_local(xe)) {
                ...
                xv = (struct ocfs2_xattr_value_root *)
                     (base + name_offset + name_len);
                value_size = OCFS2_XATTR_ROOT_SIZE;
        } else
                xv = &def_xv.xv;

        if (old_clusters >= new_clusters) {
                ...
                goto out;
        } else {
                meta_add += ocfs2_extend_meta_needed(&xv->xr_list);
                ...
                if (value_size >= OCFS2_XATTR_ROOT_SIZE)
                        goto out;
        }

On the fall-through xv is def_xv, so what gets added here is the two
blocks ocfs2_extend_meta_needed() wants for an empty value root -- and
both sides of meta_guess reserve that same tree again.  The create side
has done so since commit 3ed2be719eb9 ("ocfs2: allow for more than one
data extent when creating xattr"), which ported this reservation to the
create case without noticing it was already on the way in, and the
existing-block side since commit 0cdc7dde00ec ("ocfs2: fix missing
metadata reservation for large xattrs").  Both were chasing the same
RESTART_META failure in ocfs2_xattr_extend_allocation(), for xattr create
and then for xattr update.

ocfs2_init_xattr_set_ctxt() hands the total straight to
ocfs2_reserve_new_metadata_blocks(), so the surplus is two blocks held for
the whole transaction.  A setxattr that would otherwise fit can come back
-ENOSPC on a filesystem whose metadata allocator is nearly exhausted.

Move the reservation into the branch that stops there, leaving meta_guess
as the only place that reserves for a value tree the fall through is about
to create.  The paths that do go out keep reserving against the value root
they already have, which for an external old value is the on-disk one and
so can legitimately ask for more than two blocks.

Both sides of meta_guess have to come out even on their own now that the
copy covering for them is gone.  The existing-block side only started
reserving the value tree in the commit this one is tagged against.  The
create side has reserved the tree since 3ed2be719eb9, but only the tree:
the block ocfs2_create_xattr_block() claims came out of the same two, and
on the fall-through it was the duplicate removed here that made up the
difference.  So "ocfs2: reserve metadata for a new xattr block and its
value tree" has to land first -- without it the create side reserves 2
where 3 are needed and the value tree is back to RESTART_META.  That one
fixes a shortfall of its own on the path that reaches meta_guess directly,
where there was never a duplicate to cover it, so it is worth taking
alone; this patch is not.

Link: https://lore.kernel.org/20261010113454.1420939-4-joseph.qi@linux.alibaba.com
Fixes: 0cdc7dde00ec ("ocfs2: fix missing metadata reservation for large xattrs")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/xattr.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index d45c87d20fd36..6ecf0c3c24552 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3203,12 +3203,21 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 			credits += ocfs2_remove_extent_credits(inode->i_sb);
 			goto out;
 		} else {
-			meta_add += ocfs2_extend_meta_needed(&xv->xr_list);
 			clusters_add += new_clusters - old_clusters;
 			credits += ocfs2_calc_extend_credits(inode->i_sb,
 							     &xv->xr_list);
-			if (value_size >= OCFS2_XATTR_ROOT_SIZE)
+			/*
+			 * The old value occupies at least as much room as a
+			 * value root, whether it sat outside or inline, so the
+			 * new root fits where it was and no new xattr block or
+			 * bucket is needed -- only the metadata to extend the
+			 * tree hanging off it.  A smaller one is replaced
+			 * outright, which meta_guess below reserves for.
+			 */
+			if (value_size >= OCFS2_XATTR_ROOT_SIZE) {
+				meta_add += ocfs2_extend_meta_needed(&xv->xr_list);
 				goto out;
+			}
 		}
 	} else {
 		/*
@@ -3260,6 +3269,10 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 		 * Reserve metadata for the new xattr's value extent tree.
 		 * The not_found path above adds credits for this tree but
 		 * omits meta_add, leaving meta_ac NULL for large values.
+		 *
+		 * This is all of meta_ac on this side beyond the xattr tree
+		 * above: no xattr block is allocated here, and a new bucket or
+		 * index block is paid for out of data_ac.
 		 */
 		if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE)
 			meta_add += ocfs2_extend_meta_needed(&def_xv.xv.xr_list);
-- 
2.53.0



