Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA591F75B4;
	Tue,  3 Dec 2024 14:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236489; cv=none; b=nIXwjAGoj502JeWQmoh0jvBoW/Gqp7tmyR1E974Yj2I2E4HbkH39j3zAaAzPEpEoO+DRhD4puIpBDgnDk9++fSCviRh7dETkF574iVpEJF/A9x/L1VdAKN8l+6elUr15JqsUUHsN3VEzuHjRophnxDvbwloCJ2smwBqsjZYaUF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236489; c=relaxed/simple;
	bh=Retbowbg0+PANAm9cBOd7SCIxotV6aPkXTCVN5SoVXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzHRM6a5xfmDcqU8/C0JuRsMIdhZrB4pj63W/ov5qGaCmllekRufSRRxxWBbS2btF2GY9XiQ6D5pTmsrG1xLM9UnPZ23IjmkWn3V1m0DScZ+CP6/Vtbzf03NnhnwWrHGht5yOX04PxoA70ckLTqFN45GAQ72q1Tzc8Yx4M3A0ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jIBxEvlr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jIBxEvlr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E51AC4CECF;
	Tue,  3 Dec 2024 14:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236489;
	bh=Retbowbg0+PANAm9cBOd7SCIxotV6aPkXTCVN5SoVXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jIBxEvlr3JMJcn13TC6asmP9QTTJvki/dqWInEJlBbd3YUjnX6hhLl5g4tShfIPfa
	 48y9Pah3mNYJZoMXwgQ4EAV5VjptIcc4NpH/n09EsT5CAB044KyrCJqIjSUjjLzed3
	 OjNYpqWWCVV1xC208BfCN6dhnzf77mwK+LiwwU1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugh Dickins <hughd@google.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeongjun Park <aha310510@gmail.com>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.19 009/138] mm: revert "mm: shmem: fix data-race in shmem_getattr()"
Date: Tue,  3 Dec 2024 15:30:38 +0100
Message-ID: <20241203141923.895517299@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit d1aa0c04294e29883d65eac6c2f72fe95cc7c049 upstream.

Revert d949d1d14fa2 ("mm: shmem: fix data-race in shmem_getattr()") as
suggested by Chuck [1].  It is causing deadlocks when accessing tmpfs over
NFS.

As Hugh commented, "added just to silence a syzbot sanitizer splat: added
where there has never been any practical problem".

Link: https://lkml.kernel.org/r/ZzdxKF39VEmXSSyN@tissot.1015granger.net [1]
Fixes: d949d1d14fa2 ("mm: shmem: fix data-race in shmem_getattr()")
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Jeongjun Park <aha310510@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1014,9 +1014,7 @@ static int shmem_getattr(const struct pa
 		shmem_recalc_inode(inode);
 		spin_unlock_irq(&info->lock);
 	}
-	inode_lock_shared(inode);
 	generic_fillattr(inode, stat);
-	inode_unlock_shared(inode);
 
 	if (is_huge_enabled(sb_info))
 		stat->blksize = HPAGE_PMD_SIZE;


