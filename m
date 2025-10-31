Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F66A34D387;
	Fri, 31 Oct 2025 14:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919328; cv=none; b=NZ0ebaJ7JbmUl6mTvQ0w1pQaYkd8r/n8jz9dUH+OTZTB1rVyKOiQCpsiy+ZsBblr5j6Q6/FJIWrx/2MQkHgk52ka8DCIwFJPxbF+rc9GYn03pTAlhn/Uy2vHrLOcxgvTdd2CI7KUVcjl5XK1lXzpQ9RwPsDvlVh0ou7IkGMk16w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919328; c=relaxed/simple;
	bh=E5KdH9/C2aD31kL7CtIGEW8AmY6i1k5ObAUrx7wDI1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d28/bJXYnxgJ6yB4bWGLBp4rE87OVVWBfDU7sEo9+bR5H2BKuIgedMFJzZj8PH3CZklJ3bC3reiSYCKGPMeHKfyzb9dCvZof+0Mm2nuMMx10aCHkh1MfRmvUmlCLQOS6jroifxARNiG2QWO+qjm+7Ky7VFHDL5SVR/0tphNWOAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4Y+dit7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4Y+dit7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5BF7C4CEE7;
	Fri, 31 Oct 2025 14:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919328;
	bh=E5KdH9/C2aD31kL7CtIGEW8AmY6i1k5ObAUrx7wDI1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4Y+dit7gMq5kknggXWPovCuwtI8QypOVCvywPNb3QGCp+Vgc8DIxO8X8G0b0XaR+
	 efvDB61yxRQAMSHirpCQkWWcfRPBP3mZEorGhzeOajSsRqKRdTMJV5QqUOyQoNwM+v
	 6HzRYC05w6Bf+i5twkHBVATuxRxaa6tr5kTz+jJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 14/32] btrfs: use smp_mb__after_atomic() when forcing COW in create_pending_snapshot()
Date: Fri, 31 Oct 2025 15:01:08 +0100
Message-ID: <20251031140042.765300126@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140042.387255981@linuxfoundation.org>
References: <20251031140042.387255981@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 45c222468d33202c07c41c113301a4b9c8451b8f ]

After setting the BTRFS_ROOT_FORCE_COW flag on the root we are doing a
full write barrier, smp_wmb(), but we don't need to, all we need is a
smp_mb__after_atomic().  The use of the smp_wmb() is from the old days
when we didn't use a bit and used instead an int field in the root to
signal if cow is forced. After the int field was changed to a bit in
the root's state (flags field), we forgot to update the memory barrier
in create_pending_snapshot() to smp_mb__after_atomic(), but we did the
change in commit_fs_roots() after clearing BTRFS_ROOT_FORCE_COW. That
happened in commit 27cdeb7096b8 ("Btrfs: use bitfield instead of integer
data type for the some variants in btrfs_root"). On the reader side, in
should_cow_block(), we also use the counterpart smp_mb__before_atomic()
which generates further confusion.

So change the smp_wmb() to smp_mb__after_atomic(). In fact we don't
even need any barrier at all since create_pending_snapshot() is called
in the critical section of a transaction commit and therefore no one
can concurrently join/attach the transaction, or start a new one, until
the transaction is unblocked. By the time someone starts a new transaction
and enters should_cow_block(), a lot of implicit memory barriers already
took place by having acquired several locks such as fs_info->trans_lock
and extent buffer locks on the root node at least. Nevertlheless, for
consistency use smp_mb__after_atomic() after setting the force cow bit
in create_pending_snapshot().

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/transaction.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 3989cb19cdae7..20add63421b3d 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1796,7 +1796,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	}
 	/* see comments in should_cow_block() */
 	set_bit(BTRFS_ROOT_FORCE_COW, &root->state);
-	smp_wmb();
+	smp_mb__after_atomic();
 
 	btrfs_set_root_node(new_root_item, tmp);
 	/* record when the snapshot was created in key.offset */
-- 
2.51.0



