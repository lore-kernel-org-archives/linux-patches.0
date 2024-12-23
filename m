Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4221C303E;
	Mon, 23 Dec 2024 16:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970847; cv=none; b=kSY7jl+hrUQ2ChiFdlyvR30OTrBYlQK22Fk/kD6AHoqD0LdACCn3Y3KnfYM7qPY0OnZ+Nu0THFomCIm4A/seS+cWmY2DeV+a8DjHK0zWiOGZNCJShcETqcpo5v9XK5HvTHzALOl9EnuYmraKYyJdx71m6QLWYQF78smPMkM4eek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970847; c=relaxed/simple;
	bh=Zh8iPR7bgn3xw5tDcFMWmr8dbMiq45XVXfX00ExTVuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TSO5lz21dh574o2bexV2LPOWqGCFdJZw1gAtk/tz5sRUACSz+1O8mf/HapSyYfnKAIaRVEg7co57AklKUFZrHQWPdmnV3NTqCWiDRDjs/ckty4id21X3K7N24XJeVTA6J640SQ7KUk+wf4DJEl8Vma0+EjY4mYptvtXOiOIOyOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O0tYmG2A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O0tYmG2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E64DC4CED6;
	Mon, 23 Dec 2024 16:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970847;
	bh=Zh8iPR7bgn3xw5tDcFMWmr8dbMiq45XVXfX00ExTVuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O0tYmG2A1AgnaLHvwTwZc42iSx2W9dJjMDwgAMln4RtO3txlaFfEr70+iXfJcBUnv
	 PMh3TOylnZdVSrrz6Z43IoRjS8dmD6K1KsBn7E5vMq2UloCCgoFGEWw4ajwZCcOCMz
	 cHE0qxKTYtwOP7T047cvOzkw/hzgM+qgyPXHDWHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 6.1 68/83] NFS/pnfs: Fix a live lock between recalled layouts and layoutget
Date: Mon, 23 Dec 2024 16:59:47 +0100
Message-ID: <20241223155356.256283059@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 62e2a47ceab8f3f7d2e3f0e03fdd1c5e0059fd8b upstream.

When the server is recalling a layout, we should ignore the count of
outstanding layoutget calls, since the server is expected to return
either NFS4ERR_RECALLCONFLICT or NFS4ERR_RETURNCONFLICT for as long as
the recall is outstanding.
Currently, we may end up livelocking, causing the layout to eventually
be forcibly revoked.

Fixes: bf0291dd2267 ("pNFS: Ensure LAYOUTGET and LAYOUTRETURN are properly serialised")
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/pnfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1196,7 +1196,7 @@ pnfs_prepare_layoutreturn(struct pnfs_la
 		enum pnfs_iomode *iomode)
 {
 	/* Serialise LAYOUTGET/LAYOUTRETURN */
-	if (atomic_read(&lo->plh_outstanding) != 0)
+	if (atomic_read(&lo->plh_outstanding) != 0 && lo->plh_return_seq == 0)
 		return false;
 	if (test_and_set_bit(NFS_LAYOUT_RETURN_LOCK, &lo->plh_flags))
 		return false;


