Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AD57FBB2;
	Mon,  8 Apr 2024 14:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584871; cv=none; b=KQB0qUtSZqoGDkbldVJyEXvtUe21Ivwtk05YqBTxKJb1Xg2YPZK08SGo6KFiY6Zz3s4JWRs5zn6n9xqHb/km0ddxQ1PhzqxMwZtopA3LDd+TbcU0zDqD5eph1/3KXI1yPXenQPBcgZgvy5EFzfAnnV6M89KnWUg6TGnisphHwhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584871; c=relaxed/simple;
	bh=GgjYMMV9B64e8sQsv1HvJaYi1SlQ44/hAHHs70StKGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOkne7LmRhmTP8CekSST7oCykwdFi2bs/XZJg7vezZkI+9gIEAx6rD7wk4M5nTzWKH1g73hcErhJpp3ipFdH4cL96nB6tvoB12zAp/YArCHEM6kydAUYvpWM7VIK39kzNbvZcIMGuemHYjAdeF56tl0lDPFVvXH+ye6/MU2p6DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ynZUJmm/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ynZUJmm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B4EC433C7;
	Mon,  8 Apr 2024 14:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584870;
	bh=GgjYMMV9B64e8sQsv1HvJaYi1SlQ44/hAHHs70StKGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ynZUJmm/d0DS7Zqyr3U4kwZSzeVRBgvggRUHhstzzjO2fJX1XjJd+obLqPiA5mCQw
	 2I0VM3X9N75nXjKCJkxyipyTZdVTz2TFr9d3tyzcnQ4NooZ2zs83QhgJIRx8qILjdz
	 vutB/TrQd6cZTQCeFIU6dZGkGLElMIJlIqLhvqYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 555/690] nfsd: dont call locks_release_private() twice concurrently
Date: Mon,  8 Apr 2024 14:57:01 +0200
Message-ID: <20240408125419.719976126@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
---
 fs/nfsd/nfs4state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 0f1ece95bd642..ccc235a8bc1b4 100644
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



