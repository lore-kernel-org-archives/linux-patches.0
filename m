Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2740218A95E;
	Mon, 24 Feb 2025 14:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407810; cv=none; b=YSuoBkuRGw6H14hN8G/EvFVwrzvRPkwgtSEJvBAfdEZPZrjHwaZwZJcIc9g3T5opm3yWwTyJX6P30QDKQi6tw9pUtf+YIe7KKpSnbPxsdg3pv767g5O2bz3UQFS5EhQJ7xSpu4I01gZ1qc38lOmYVpgbkXdVvxFgo2Bgtgvz1Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407810; c=relaxed/simple;
	bh=FSdU2QKLnTnrDNqPxMnB3ZEZBMTLbIj5PDkUo31bsMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPzi1X/7m8QO+cPWQML3OwsGf7ELb4b7FM5ZYTLX/nvGyQxkYtbB6v3oR2pVAOlO/ZfidonVgY5XA+XUbJHzyYoK5wT/mM/rCCivXI+LiybTYtnB2o36j7k3HPhmjzVFh/ldrVTRLJxzmQEhsHh3wCu/iVNjdtqKr36HoJuVxO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNJpLv8e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNJpLv8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0884C4CED6;
	Mon, 24 Feb 2025 14:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407809;
	bh=FSdU2QKLnTnrDNqPxMnB3ZEZBMTLbIj5PDkUo31bsMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QNJpLv8eoQakGpS7XKsJ4Ob1CKNIIrq3odN5GSpmzn++utljSmD0D12heqFI97bMD
	 L3HgHD79w60MnTYMQcmDQ1Oros79/bou1mtO2CErCb1wJi99bu40nmsuQALK+LX1QH
	 PukBLsl1BvcRDOdLer9Fa8LC+3WeekNjAf8rr5dE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xfs-stable@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 016/140] xfs: Use try_cmpxchg() in xlog_cil_insert_pcp_aggregate()
Date: Mon, 24 Feb 2025 15:33:35 +0100
Message-ID: <20250224142603.644672193@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uros Bizjak <ubizjak@gmail.com>

commit 20195d011c840b01fa91a85ebcd099ca95fbf8fc upstream.

Use !try_cmpxchg instead of cmpxchg (*ptr, old, new) != old in
xlog_cil_insert_pcp_aggregate().  x86 CMPXCHG instruction returns
success in ZF flag, so this change saves a compare after cmpxchg.

Also, try_cmpxchg implicitly assigns old *ptr value to "old" when
cmpxchg fails. There is no need to re-read the value in the loop.

Note that the value from *ptr should be read using READ_ONCE to
prevent the compiler from merging, refetching or reordering the read.

No functional change intended.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Reviewed-by: Christoph Hellwig <hch@infradead.org>
Cc: Chandan Babu R <chandan.babu@oracle.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_log_cil.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -156,7 +156,6 @@ xlog_cil_insert_pcp_aggregate(
 	struct xfs_cil		*cil,
 	struct xfs_cil_ctx	*ctx)
 {
-	struct xlog_cil_pcp	*cilpcp;
 	int			cpu;
 	int			count = 0;
 
@@ -171,13 +170,11 @@ xlog_cil_insert_pcp_aggregate(
 	 * structures that could have a nonzero space_used.
 	 */
 	for_each_cpu(cpu, &ctx->cil_pcpmask) {
-		int	old, prev;
+		struct xlog_cil_pcp	*cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
+		int			old = READ_ONCE(cilpcp->space_used);
 
-		cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
-		do {
-			old = cilpcp->space_used;
-			prev = cmpxchg(&cilpcp->space_used, old, 0);
-		} while (old != prev);
+		while (!try_cmpxchg(&cilpcp->space_used, &old, 0))
+			;
 		count += old;
 	}
 	atomic_add(count, &ctx->space_used);


