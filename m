Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106CC547074;
	Wed, 30 Sep 2026 17:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787991; cv=none; b=kmQ+Z5AdiWaOA19nVaB1BVALNUnS9F+2UiLn0NJsyF38vRJIpIaDmcDnNhQx1HLdRgZbXlUtc4xo/jvv9Dwf/ImOj0d21YBGNWJ2QfCQQwzcaSKV+MFZIFOny0anjs06u3spJLG6V4ZpEK4pI+5DIwqhQdFi3AOJzI+8s15MJhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787991; c=relaxed/simple;
	bh=BOiiKggib+sF8GH93vTX1u0lFokBJuzeYrFvji8RdX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q4bW32kGpS7aj+qxmrW+uVwNojqL585Gs/xJXTVY2b6lD+mXQ00P5yhozQ6TrMnqm3KnWIc6zhwKnif0el4mgO7P7V2IpXNgYFTfMDDqaxl0ZGO215HtvLq5oc2UAsODxEbNelRZLAm6dhtVwd8vn61dcK2yhyGYcXQTRVtB3Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3aORWqI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3aORWqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679931F000FF;
	Wed, 30 Sep 2026 17:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787990;
	bh=1XPPQb0OCiNPH46wywAelR+G4DKdsCj0q2LX7EG+is8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R3aORWqIyT4HuMOPJDi6vhcWCB6Z4RaHVxUs7hTSPYxbdeEBGx7JkbvCdIvd5M9KQ
	 ZKxbMtJrZh8Pfk2H/ewc7reYyXopplXXJFHYoQuNsyXNgjy/+3wlUBr0ELW917hFHL
	 rSxTwl16CjxZISIgNHh03ws3Co3il3xCL8rEvoe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 424/457] xfs: check di_forkoff correctly in scrub
Date: Wed, 30 Sep 2026 17:28:49 +0200
Message-ID: <20260930152355.137710826@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


