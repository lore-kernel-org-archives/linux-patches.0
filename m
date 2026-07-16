Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D103932F1;
	Thu, 16 Jul 2026 13:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209717; cv=none; b=VeR2jywzi1kjDYctT48CGTFBsWIU664zCuR0knFCOlnFAi4WZAM3LPyIb/uB4WlRnWmluu9i8x7Md2+9daQVfASim9JRVCVzkqlrrQsboLJtR+KBhXEeai6rA7LgWnEF1EqP7ITTbBBwOnfCQUxLuDgamPb3yScj75L0eiH0tH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209717; c=relaxed/simple;
	bh=UOl7x58xUfuJbun52JL5l3T7kmHcsflDCfjya98mG0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2ZKMvbzH2VOvoFdHgUkDCXgqvlVrte7Qe7cgudR1wQ2v6iR5EQq3QcO5tS8kfVL3DA3tgUe2AcQooWx9xF3izaQ4w5vUK7tWXPQa2nTAxWfMyUJBLcyPgjkfR4cT8pCKSbWjHNu3Q2vx/OmBfTgyZYiQZ7NHKyNbbGLPg3GVCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YlcVvNRu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YlcVvNRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECD61F00A3E;
	Thu, 16 Jul 2026 13:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209710;
	bh=gptGWUYRZVt/KLk1mpC/DmNMjlm4IjMbd2+X/NeHhEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YlcVvNRu4HDLMu/cU2tdfE0e1b8qBYKlIHXmDDcgqcaTv80BsVCNlaXMpFgVYMG+K
	 hQwF4VJli3VSfFyfh6OVRmTHc+O4vURDqhNN525wF+EqjhqTAo/frn2jOgFa6BU3wc
	 WPa4jEt6IZyA39INJdhM4ArJY0z8FHEgYOJC6CsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.1 288/518] xfs: fix pointer arithmetic error on 32-bit systems
Date: Thu, 16 Jul 2026 15:29:16 +0200
Message-ID: <20260716133054.121632955@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 84eec3f7fc73144d1a230c9e8ad92721e37dcaab upstream.

The translation of the old XFS_BMBT_KEY_ADDR macro into a static
function is not correct on 32-bit systems because the sizeof() argument
went from being a xfs_bmbt_key_t (i.e. a struct) to a (struct
xfs_bmbt_key *) (i.e. a pointer to the same struct).  On 64-bit systems
this turns out ok because they are the same size, but on 32-bit systems
this is catastrophic because they are not the same size.  So far there
have been no complaints, most likely because the xfs developers urge
against running it on 32-bit systems.  But this needs fixing asap.

Cc: stable@vger.kernel.org # v6.12
Fixes: 79124b37400635 ("xfs: replace shouty XFS_BM{BT,DR} macros")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap_btree.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -89,7 +89,7 @@ xfs_bmbt_key_addr(
 {
 	return (struct xfs_bmbt_key *)
 		((char *)block + xfs_bmbt_block_len(mp) +
-		 (index - 1) * sizeof(struct xfs_bmbt_key *));
+		 (index - 1) * sizeof(struct xfs_bmbt_key));
 }
 
 static inline xfs_bmbt_ptr_t *


