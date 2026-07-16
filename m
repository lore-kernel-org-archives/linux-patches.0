Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B8442FCB2;
	Thu, 16 Jul 2026 14:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212140; cv=none; b=gIDHuObDqzV2OVbkahtaXLKpr/9pLeJjXuUY2Z6oMa2SffB952L7L2/SVdwojLSK5Xy/Cktl3Z6LjaGD1tXRMIJEPq/K9WsdLvDamvdZ7aTE03MxNm1VoX+I5D9dIDMnIR/avqCXR+Ph/b6ehN4L9GmgfyKA7EplqoG1lGiUtVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212140; c=relaxed/simple;
	bh=M4ez87YxzLRE7zHrukx9luiEHlwGjhj+Xark0UGuatI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUmk7PMrHCgtCY5Jfeb1qB0xCvuEHm3qxlXdKbC1tCXfv7bmopaHN8z8yUHjkSnECPq13XquVmfa4eubLcXkjoQnx9OUYogU3woWFN+nvddQQdBigUQvye041/ijNtCVOO1U+pK+1gSVMhmX/cl2p3UmF0FIy6On73Ospbav14Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j766vbS7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j766vbS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D76C1F00ACF;
	Thu, 16 Jul 2026 14:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212139;
	bh=B1juZfZSYkFteGnKyOY1bgFM5Bbw2HgRr16RzQ3s770=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j766vbS7//rIclz+IV8mdHYSFSe4BQN3PdWhCk+g1/bH/MjZsQkkowvga9DtiNXs0
	 yFVC9NIZOBtQmAxtAJ9B/9o90PkoegRd9pfecOA/yYYmZ8hWegQ+WJvexB13qhdTnw
	 a3vXDxMHra3qfSS650HaWRBweXf7dgD/2Dp2WoYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 214/349] xfs: fix pointer arithmetic error on 32-bit systems
Date: Thu, 16 Jul 2026 15:32:28 +0200
Message-ID: <20260716133038.153318170@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


