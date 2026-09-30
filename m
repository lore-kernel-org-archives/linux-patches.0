Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890014EF13C;
	Wed, 30 Sep 2026 17:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789767; cv=none; b=i0NTq6qXeU6mn0e5dFg0hMhW9nSxXpHh4OP7D1HcVfDplNZ4kQNl0K1691McKaLoNjoyFTDRm6u/HeXwSuhNfCj8cMuoh77sAbMtVR8hbdFrY6yQ+nkKSaaZg5EESDIrEY23ZDzXSiModyqnLJyk8Ybd2IDPVoo+mXObYq6FDfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789767; c=relaxed/simple;
	bh=r9TeEsDnpZ8fRcLEPuz0geEMV0B+4FUSaxdPm4oP1MI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9w+syCqnY+Sc2ocHycvKOvmSJJlmWAiYGoVFu7UssIUlJzf4PHEnVngFV81kQIHYfGhFe1AvzLwDCj2f6taHRzQy8/D1KMW0GeMLf8S0YcYuoKHMocjnkXCmT4ao6yJm3OOatePX/v+JANpNLBv3Mjo1OvrkVzC9M4Gm522bd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xTX4zvCv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xTX4zvCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E481C1F000FF;
	Wed, 30 Sep 2026 17:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789766;
	bh=nYknfj2aYt+PAERfa/tMRoa/nWqPrqNEi3veW6rDEHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xTX4zvCvtOiHBUSATOXM4VKINGdYqq/M5J2/nNw+wqQ9ogcAjFepRIRMrtHgn47hI
	 jrbkWEz7j0tVj0Nq/TLnObRWsDNExhLJ1928PrirbFJht9DUG5Ic3DOmqu2dOFsIki
	 bSotB+zwcbF1g9+v/Rw5VLJ1MOjT/a9Tj4tO24OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 548/877] xfs: fix attr fork block count checks in xrep_inode_blockcounts
Date: Wed, 30 Sep 2026 17:24:19 +0200
Message-ID: <20260930152426.465394905@linuxfoundation.org>
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

commit bb991b7f79dd34cc5f24db0f736bf75630c970e7 upstream.

LOLLM points out that a file has an attr fork, it will call
xchk_inode_count_blocks to set @ablocks to the number of fsblocks mapped
by the attr fork; but then it'll compare @blocks (aka the count of
fsblocks mapped by the data fork).  We already checked that and we never
do anything with @acount, so I think this is clearly a bug.  Fix the
comparison.

Cc: stable@vger.kernel.org # v6.8
Fixes: 2d295fe65776d1 ("xfs: repair inode records")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/inode_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1513,7 +1513,7 @@ xrep_inode_blockcounts(
 				&nextents, &acount);
 		if (error)
 			return error;
-		if (count >= sc->mp->m_sb.sb_dblocks)
+		if (acount >= sc->mp->m_sb.sb_dblocks)
 			return -EFSCORRUPTED;
 		error = xrep_ino_ensure_extent_count(sc, XFS_ATTR_FORK,
 				nextents);


