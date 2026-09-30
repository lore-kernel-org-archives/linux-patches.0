Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100C151DE12;
	Wed, 30 Sep 2026 17:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789651; cv=none; b=LpU7fXJ5RLtqOBn53JX9WAedpqj/dMV3akhDxZUIwzvPHjnl+i5swOaoJocK7iW2rvYapQDJj5Ab86jSXYy9vMvZ+2UEWjoTniNQKMiYxewO2imd/CnTHCuFQSuo6o8g4s9eNJ5frVoMmLup68iJyZoKWJE0TJ9UESG5JAeEai8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789651; c=relaxed/simple;
	bh=OnUFDsh5C/m3NnCwGG+48aCbgXu+FMKKg59ZG/aUh9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRqAMHD2npISYPo4bx2safZKZOM8G+XxpP4DVzYCQJMBqlqd6oat/zDOw7ID3ohF6iNA7Wc9zCwx6+Nid44uHGHjoJNo36Y0T2fDnF5krICn/UmMjEjOQfFO/RsKlHVgn8JmYl/SFl3H/J7nqoO/7M6OfjWwxtHb1vtZYm+wHgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vluQsgks; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vluQsgks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E5A1F00898;
	Wed, 30 Sep 2026 17:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789649;
	bh=09PH0iz2/F29ZRD0w15u3cx87pOQvQedXX8ncrmD+1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vluQsgkslTad7yt01+b7IF/X0tsTcX6Larea6o0tQYXMUNaj8zxNJblEidK5Gp6fA
	 wL4h/DKisZymA88ItZda2DEYX3DB48HtCMBJ43g0bVt5/HDEHhf4BHMu2qzT9fsuZ2
	 05cE4EnwmhGUAULSqfd+XSRE8cywWIDzzsZY4so8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 553/877] xfs: check di_forkoff correctly in scrub
Date: Wed, 30 Sep 2026 17:24:24 +0200
Message-ID: <20260930152426.575633473@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
@@ -560,7 +560,7 @@ xchk_dinode(
 	}
 
 	/* di_forkoff */
-	if (XFS_DFORK_BOFF(dip) >= mp->m_sb.sb_inodesize)
+	if (dip->di_forkoff >= (XFS_LITINO(mp) >> 3))
 		xchk_ino_set_corrupt(sc, ino);
 	if (naextents != 0 && dip->di_forkoff == 0)
 		xchk_ino_set_corrupt(sc, ino);


