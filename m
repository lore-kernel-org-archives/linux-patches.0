Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831677;
	b=efScSbn2LJcQ5PFCZf22iJGuZwoSKMGUgcksR/fYvkuhjmd2A9MYq3Xr4Dwg4zLKSnaV
	 Mb5bCjQoAgGikkDeZ59J8pZvn9yDT5EDoB6OOa/oc4Fmu78NB/PxjDcLCj3GAqf46xPUj
	 wqCMOwBZz3Xiq2QSApBccdjUgoHH44G5nsqYgc93Dh3LwtRmeNo2qKvDP+FKVZnZmnPuw
	 IfYfvj/n4d8EYc3I4REYaf+UVucj5dgVHIn2xVMhZBB9PfESZC2nwDziriQ0jrR55T/1c
	 sEIAQ4WrxMFWSL3ta9rkXvYJcHCe4avZR3sHVhdq6t9F3jByLa2Z1/45JBRgpOq4jYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831677;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=If22/FJZ8nGz0lATdStbKZhqrCxK8bfh7d0aTbokU1w=;
	b=tGT40g/I5p92tTdVR4yowjPwHEnzxK8+3oKVPm+QElybg3NJ+iLFP2Wu9tdMRuH1LWLD
	 cm8LDA5nsKJbH6FEW3r5JpBX9ik3gktWGyDDMUt4aXnO9CXpcyWuc6TjEwoO7GIKy1ZY4
	 TWfRH8JlKnJEaNV6xe2oIiV6xzW1MxP+tfXrT9TZNpska3Siv0VF2Vb294WaMcvfgwCBE
	 xqRh79n2DE/D5u6qtVrwqRDiTJjAk/uQ5xbKuQSlgq0tFYDL7MoebdVACw0HBIxVF1baq
	 pT7WKtGJYi8rXQSRZ7fDRTeToFxPYg91mHXAOZQSygI6r4+sDpuj7qLZoxBAYvx3WHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pfGGJntw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5C9606A33A;
	Wed,  4 Nov 2026 22:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pfGGJntw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E081F00919;
	Wed,  4 Nov 2026 22:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831676;
	bh=If22/FJZ8nGz0lATdStbKZhqrCxK8bfh7d0aTbokU1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pfGGJntwMAkn2+YH8b1qWql4IHw0wY2RPqRn8OpGqM7VuZ72lKIBLQuhGKjqNcL7C
	 jO3sdJKid8dW8cbZBdXkEj7RkJXQjINWN3FR1IakcJu6iET9y/eTeyUw+4GakGY6gD
	 OxffrweXkpSNr4FKDM2kq2JQA21HJjCOB2Ncw7/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0849/1005] xfs: dont queue rmap update twice when reaping a fork
Date: Wed,  4 Nov 2026 16:09:42 -0500
Message-ID: <20261104211107.085539377@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 219ff8a734d8438e24eb346a847c9b1ad9b7ab5d upstream.

LOLLM noticed that xrep_reap_bmapi_iter calls xfs_bmap_unmap_extent and
xfs_rmap_unmap_extent to remove a mapping from a file fork and its
reverse mapping.  However, xfs_bmap_del_extent_real also queues a
deferred rmap removal log item, which means that we incorrectly queue
two rmap removal operations.  Fix that by removing the extra call and
updating the comment to mention this subtlety that I forgot, having
written the code. :P

Cc: stable@vger.kernel.org # v6.10
Fixes: 5befb047b9f4de ("xfs: add the ability to reap entire inode forks")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/reap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -1480,12 +1480,12 @@ xrep_reap_bmapi_iter(
 		/*
 		 * t0: Schedule removal of the mapping from the fork.  We use
 		 * deferred log intents in this function to control the exact
-		 * sequence of metadata updates.
+		 * sequence of metadata updates.  The BUI queues a RUI to
+		 * remove the reverse mapping.
 		 */
 		xfs_bmap_unmap_extent(sc->tp, rs->ip, rs->whichfork, imap);
 		xfs_trans_mod_dquot_byino(sc->tp, rs->ip, XFS_TRANS_DQ_BCOUNT,
 				-(int64_t)imap->br_blockcount);
-		xfs_rmap_unmap_extent(sc->tp, rs->ip, rs->whichfork, imap);
 		return 0;
 	}
 


