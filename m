Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828946;
	b=rM/McTlLvEih6iaAR7Hm3Ah3mXSMvCicByXtZ0/oCifrlwuVVEfv0obxgy7bSmlT48ez
	 /mjX8utuy4ub6zy5Dx4+fp+d+CKelo5GRVAC7ybLatiiuzNdOESJQ+bg05H6ymIf7R7cY
	 PpQ/9UGp8ZLKmO4uTCtuPxqgn9aEt0jLBRtXbYk/Ne6ymwR3XpOKaidvTot42XmXPLD3W
	 kDOb1V/2LNjk2WcjVQtCd/wmNWeBxT70Z+79Eb2c1F5xC8nWUgNQYe7R7uQl6pFWAw7+y
	 u+V6Rf2+n1/HqqFTzKbww3Yl9UcDEFiKFdqCHI/CS0IqWr/jGSC5w6SMaxHUO/HKvwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KSgVqSzDGZNwGpGSespELfvu1VQ6kUxFlqCe9IOx9b8=;
	b=sdiEueeSajtQA6EHYiSK+IZmQ6nDHzwUIg2+nIOThUs+diTDpBGvmFTuCCcQwbWrFbuO
	 b8F2g2Ewkd+zIXBppzjSYiLrN4N5YFn9BJr4sxKVgPSsKwhes0rz013CblVg006sOpNIi
	 RosqM+YoMATr/kvB/7JImboBOPvixA+MtFj5gaqZsilsRA2pZJih/sAYbsGRIr3kHjZJQ
	 3QyrHgV4oSCMXOzGHQ3bmfAIbQui2XOK8lpvtcfmccb+GcPW+bko3cTZgbf4I21aCRyNe
	 smxPcerzzYW5LkNNg5Y8IPauIi36pqvZJ3L19hSl9aGz6gqVdAp6moOnGf9Th+7Dt3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mII/d3/u";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A11607872B;
	Wed,  4 Nov 2026 21:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mII/d3/u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3991F00919;
	Wed,  4 Nov 2026 21:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828946;
	bh=KSgVqSzDGZNwGpGSespELfvu1VQ6kUxFlqCe9IOx9b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mII/d3/uFgR14FNSoFpUXKllcQsMJlBxJEoakaXKNTTNJtxzHW5kNE6ONPmJCdHK/
	 JuTryYMnBFpy9/lUhVBvGnsDBTyCYgHTKzEfifjjsiuq+FENWFsu5uuOPvgg9UCGU0
	 9WhIOsgfTWEpTf0SkUwBE8KQ5li+4Hdg75afNZlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hch@lst.de,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 307/547] xfs: actually lock the metafile reservation when adjusting after repair
Date: Wed,  4 Nov 2026 16:08:11 -0500
Message-ID: <20261104211046.933087060@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit e53c620b3670fc0c162b5f768a10a3a17d0c04f6 upstream.

LOLLM reported that xrep_reset_metafile_resv performs unlocked loads
and stores to the metadata file space reservation counters and thus can
race with other threads.  Fix this by taking the lock.

Cc: hch@lst.de
Cc: stable@vger.kernel.org # v6.15
Fixes: 1df8d75030b787 ("xfs: make metabtree reservations global")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/repair.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1377,12 +1377,14 @@ xrep_reset_metafile_resv(
 {
 	struct xfs_mount	*mp = sc->mp;
 	int64_t			delta;
-	int			error;
+	int			error = 0;
+
+	mutex_lock(&mp->m_metafile_resv_lock);
 
 	delta = mp->m_metafile_resv_used + mp->m_metafile_resv_avail -
 		mp->m_metafile_resv_target;
 	if (delta == 0)
-		return 0;
+		goto out_resv_lock;
 
 	/*
 	 * Too many blocks have been reserved, transfer some from the incore
@@ -1398,7 +1400,7 @@ xrep_reset_metafile_resv(
 			mp->m_metafile_resv_avail -= give_back;
 		}
 
-		return 0;
+		goto out_resv_lock;
 	}
 
 	/*
@@ -1412,14 +1414,18 @@ xrep_reset_metafile_resv(
 		if (delta == 0) {
 			xfs_warn(sc->mp,
 "Insufficient free space to reset metabtree reservation after repair.");
-			return 0;
+			error = 0;
+			goto out_resv_lock;
 		}
 		error = xfs_dec_fdblocks(mp, delta, true);
 	}
 	if (error)
-		return error;
+		goto out_resv_lock;
 
 	xfs_mod_sb_delalloc(mp, delta);
 	mp->m_metafile_resv_avail += delta;
-	return 0;
+
+out_resv_lock:
+	mutex_unlock(&mp->m_metafile_resv_lock);
+	return error;
 }


