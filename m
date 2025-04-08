Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2246B266EFC;
	Tue,  8 Apr 2025 11:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110767; cv=none; b=c8Zrl/UXgztgBOvxlmUnLRZg39INdAEFKuEhgZNRPfRXFJ3GQw8y7rHyLTiWwPHHw8UtuStDqcqFJkGTe2UHO2A/Zyf0Y+ULNyZEm9kvQRmvVNNSmiPIVLdxC6iiIJLK4NjybLIRo64QUpeNW15UmkDeBXFQ3+cxqez/N7g3/q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110767; c=relaxed/simple;
	bh=TfUXL1WwqXKI1UV4j97Xv30GLK3Z/8ZeJdA5Mnz1uRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pw9EyV9KYMZljpWHH0854CHR9M1Sr1YvtHBuj+6dfigAmBou2KqEdKCKvawu90dBIrNVDCOaBI+fv/mmgR7LVGFRkpvxMg6voM6z4RKt1eAKotc7oSKN4eLZvXXUX7YAZ4UqA4PGAiMNoOxqP4ofXNWGW7qJH9QUmWvSd5Gtxyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KveNBGRb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KveNBGRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B56C4CEE5;
	Tue,  8 Apr 2025 11:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110767;
	bh=TfUXL1WwqXKI1UV4j97Xv30GLK3Z/8ZeJdA5Mnz1uRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KveNBGRbTUi2SryOWLSggM9q+7rnB0YLMz0lG5J9Z2m7ESMr0gY0QNf86XLYBxDIj
	 8KJOMhmSkSVV/0AIo9S2ZCd7qEJ1L0zSkzvHA/IIbOUGD6i88dZKySnaSxFGa7zVZu
	 UOoM768EjUELmB5C5wPoUacnYdNiQd8if4reAMoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 169/731] gfs2: skip if we cannot defer delete
Date: Tue,  8 Apr 2025 12:41:06 +0200
Message-ID: <20250408104918.208010413@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 41a8e04c94b868023986ec35ca06756e31e1e229 ]

In gfs2_evict_inode(), in the unlikely case that we cannot defer
deleting the inode, it is not safe to fall back to deleting the inode;
the only valid choice we have is to skip the delete.

In addition, in evict_should_delete(), if we cannot lock the inode glock
exclusively, we are in a bad enough state that skipping the delete is
likely a better choice than trying to recover from the failure later.

Fixes: c5b7a2400edc ("gfs2: Only defer deletes when we have an iopen glock")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index ff8fdc6134ff5..0e6ad7bf32be8 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1339,7 +1339,7 @@ static enum evict_behavior evict_should_delete(struct inode *inode,
 	/* Must not read inode block until block type has been verified */
 	ret = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, GL_SKIP, gh);
 	if (unlikely(ret))
-		return EVICT_SHOULD_DEFER_DELETE;
+		return EVICT_SHOULD_SKIP_DELETE;
 
 	if (gfs2_inode_already_deleted(ip->i_gl, ip->i_no_formal_ino))
 		return EVICT_SHOULD_SKIP_DELETE;
@@ -1498,7 +1498,7 @@ static void gfs2_evict_inode(struct inode *inode)
 				gfs2_glock_put(io_gl);
 			goto out;
 		}
-		behavior = EVICT_SHOULD_DELETE;
+		behavior = EVICT_SHOULD_SKIP_DELETE;
 	}
 	if (behavior == EVICT_SHOULD_DELETE)
 		ret = evict_unlinked_inode(inode);
-- 
2.39.5



