Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D97D4F4049;
	Wed, 30 Sep 2026 18:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793680; cv=none; b=XTZSVQbyTCRI3KNPVoSue/OhKjYoYmkZYKpTRH3TCdYrw7D9DjbDX16QYFyeVgh5Am7SVlhg5luRoBfwckU8RvLjkRRL0W486KyHFJec4DjYTvG9BAIiMX3yfGkV7lQfYUfHfz6cbnG0ollnK30hGgAayIsrSZG0NfOvQUkIHW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793680; c=relaxed/simple;
	bh=3AhWN5xqJKNpkaJVYOiTj7DhZJTRoiax27T5+9Hdalk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMSfyHUmE/ZV96XPiDflI30swJkiQcwteL68pHUSGJBGz74KzhK4NA4suU1bZZUaxm4YvclqKqfZATHtysjwBqu7HEBah3rYAeY5ZOrTWiaYWgKBb879eTH6pxNNTbo/WIz8R/x4DLCHt9Iv10zYUwCzouX+4mdksKZb3s/eoBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qlvOLwNx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qlvOLwNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13211F000FF;
	Wed, 30 Sep 2026 18:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793679;
	bh=1Apj4a4G5Ah5Q64TtiktMVAKsss22j/ykw8aKuRT+nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qlvOLwNxOCa+kR1ibIpliKLcfhd9Wh8ZV5wdOCFyN7q8a3b8w9j+/SmWAii4P1y6X
	 dh3yRximABTgWc4v8MvMd9OOuZXTzAcMpuPytkWkEL3WVSAqnZFa4gFud0EmDtREek
	 7tcVLau3RdwDvP+z1L6FT1UvN5iP3bcpPCK/v+5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 340/395] xfs: check di_forkoff correctly in scrub
Date: Wed, 30 Sep 2026 17:30:02 +0200
Message-ID: <20260930152348.045102879@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit e9193f2f1ce32d02b9230094ffdbfab715ab6137 upstream.

The di_forkoff check in xchk_dinode is incorrect, according to LOLLM.
XFS_DFORK_BOFF returns a byte count relative to the start of the literal
area, not the start of the inode.  Therefore, this check won't flag
di_forkoff values that are larger than the literal area but not the
inode size itself.  Fix this check; sadly the old APTR code was correct.

Cc: stable@vger.kernel.org # v6.8
Fixes: 6b5d917780219d ("xfs: dont cast to char * for XFS_DFORK_*PTR macros")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -607,7 +607,7 @@ xchk_dinode(
 	}
 
 	/* di_forkoff */
-	if (XFS_DFORK_BOFF(dip) >= mp->m_sb.sb_inodesize)
+	if (dip->di_forkoff >= (XFS_LITINO(mp) >> 3))
 		xchk_ino_set_corrupt(sc, ino);
 	if (naextents != 0 && dip->di_forkoff == 0)
 		xchk_ino_set_corrupt(sc, ino);


