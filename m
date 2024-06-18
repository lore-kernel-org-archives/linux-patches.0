Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0349A12D74D;
	Tue, 18 Jun 2024 13:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716804; cv=none; b=qDV1KJCoJN86Oxb7oJ3EE3TDfeRG0hrm0xKiAJP3Nt4i75rEsJ6F+dG23FtRVTmdZTb2qFERgnBhdhrMsaqBoSliXnNxg43EIACXamkVjiZUnJ1UK5+0m9KlLxJjYfTukqHQsrijkYVKJDM5VuQb8Pjy5cuUfoisKvC3ew/qKOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716804; c=relaxed/simple;
	bh=+bSJAwebK9FVFUMhy22+YIxOnqe1XtchqYb+QsCw3Ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eabBox/a0CbrnlVEQTVApBvefM+qUZV4o9xQXgKwNqiPoifCW0wATdpe4blFLRn+oJRqkEpwd8hlBMXCrN1e/JpiYLclSIt/WX9PNyDQjSsOQSBckS+jES0UKaNr1NaQ506+tHDafswOYrMOoA040POE85DER0cHdCzky51XS5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHmnUEdE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHmnUEdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE4EC3277B;
	Tue, 18 Jun 2024 13:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716803;
	bh=+bSJAwebK9FVFUMhy22+YIxOnqe1XtchqYb+QsCw3Ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IHmnUEdEhMpkf5/xS0b2mYke30MV1eTduP0zAhAaZUVSLGXguzZapkTNPK4zdupg/
	 m+PVyjsGmLelesfFIAgPtgUuqDyrbr5dv48DKMhrStuPEZ3VVXlgOEhweGIGdFyNNA
	 8V1/O/ZEcceU18BDVhoUBMg79cgs0VjCzH5NhKz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 769/770] nfsd: dont call locks_release_private() twice concurrently
Date: Tue, 18 Jun 2024 14:40:22 +0200
Message-ID: <20240618123436.956887110@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 05eda6e75773592760285e10ac86c56d683be17f ]

It is possible for free_blocked_lock() to be called twice concurrently,
once from nfsd4_lock() and once from nfsd4_release_lockowner() calling
remove_blocked_locks().  This is why a kref was added.

It is perfectly safe for locks_delete_block() and kref_put() to be
called in parallel as they use locking or atomicity respectively as
protection.  However locks_release_private() has no locking.  It is
safe for it to be called twice sequentially, but not concurrently.

This patch moves that call from free_blocked_lock() where it could race
with itself, to free_nbl() where it cannot.  This will slightly delay
the freeing of private info or release of the owner - but not by much.
It is arguably more natural for this freeing to happen in free_nbl()
where the structure itself is freed.

This bug was found by code inspection - it has not been seen in practice.

Fixes: 47446d74f170 ("nfsd4: add refcount for nfsd4_blocked_lock")
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 165acd8138abe..228560f3fd0e0 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -318,6 +318,7 @@ free_nbl(struct kref *kref)
 	struct nfsd4_blocked_lock *nbl;
 
 	nbl = container_of(kref, struct nfsd4_blocked_lock, nbl_kref);
+	locks_release_private(&nbl->nbl_lock);
 	kfree(nbl);
 }
 
@@ -325,7 +326,6 @@ static void
 free_blocked_lock(struct nfsd4_blocked_lock *nbl)
 {
 	locks_delete_block(&nbl->nbl_lock);
-	locks_release_private(&nbl->nbl_lock);
 	kref_put(&nbl->nbl_kref, free_nbl);
 }
 
-- 
2.43.0



