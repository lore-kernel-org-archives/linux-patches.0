Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE2138F658;
	Thu, 17 Sep 2026 15:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660631; cv=none; b=NiER4WDsY0QDommgruYgltySFFBxqYAujgsTIrqQEzEl3YEMEUW4pxyh+NI+Bni/EmUtGEnpIT88dOooOolyuejGOPosJPAAt9w9BTZjZKZaR1/Ve/ejXxDra4k1xF+KVz276cljIt1zo74QPSPyclwFywZR+RkzCAgNzRrjp2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660631; c=relaxed/simple;
	bh=ItVKuJMxZhZ6l6iDzGDSE7R+eVhHFYTr70sRSuaAZpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W7dpDC93NTFa3Pz7mF94iv0wEO0hkrdmyPaqI3F3sjXJRtsqrLlrSmb9Hf4HXMqZxepsy/flUx7Fq62yR7ou4iG5umRf1QK9iMYftrasmShYbZjBWDy+ucAjnTsL7BVATdgNpeJLcJtwMJe7NPrY8gTaVs4LksAI1OO39hoVHPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kIt/R3op; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kIt/R3op"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439AA1F000FF;
	Thu, 17 Sep 2026 15:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660629;
	bh=ds2Oak8M7nN6UPKGN7kGlLuyUVRqg0d9Rpn49Z9Fb7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kIt/R3op1uvBNCHVHn5viOxcRdyqiyfutuVo3Q22bTtoTH5EBbL2sceUw8RwCcPMC
	 UEgtGuobV5/VLZbRhWwNokQqARodRhTcVGAETiZaa1LbZ8SoznqHaAqnsir0biVX1q
	 D7R8rQ4975dDFAh5KeAxkPVkP0ovlMEOlTc5fDpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Tia <floss@jetm.me>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 655/733] xfs: initialise error in xfs_defer_finish_one()
Date: Thu, 17 Sep 2026 16:16:03 +0100
Message-ID: <20260917151408.970528731@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Tia <javier@peridio.com>

commit 6176d21d7bd609632c5b7e87a3adb9be29ec1e72 upstream.

xfs_defer_finish_one() declares error without an initialiser and only
assigns it inside the loop over dfp->dfp_work.  When that list is empty
the loop body never runs, control falls through to the "Done with the
dfp, free it" path, and the function returns an indeterminate value.

An item-less pending item reaches this through xfs_defer_add_barrier(),
which xfs_reap_ag_blocks() uses on any CONFIG_XFS_ONLINE_REPAIR kernel.
xfs_defer_finish_noroll() treats any non-EAGAIN return as fatal, so a
non-zero stack value turns a successful barrier into a
SHUTDOWN_CORRUPT_INCORE in the middle of a repair.  Zero is the correct
result: reaching the free path means the item loop drained without a
non-zero error.

Fixes: 3f3cec031099 ("xfs: force small EFIs for reaping btree extents")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Tia <floss@jetm.me>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_defer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -583,7 +583,7 @@ xfs_defer_finish_one(
 	const struct xfs_defer_op_type	*ops = dfp->dfp_ops;
 	struct xfs_btree_cur		*state = NULL;
 	struct list_head		*li, *n;
-	int				error;
+	int				error = 0;
 
 	trace_xfs_defer_pending_finish(tp->t_mountp, dfp);
 


