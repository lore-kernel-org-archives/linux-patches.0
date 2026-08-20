Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D353C34F27B;
	Thu, 20 Aug 2026 15:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238392; cv=none; b=BCSJVUrpiLCzgkYzISMk54klu6NRIhExh04BmHpM1tWTK5jWA1/bP09BfDb2UzpzG8tAs7kyXqD9Kwr86LXJRyjPLE/O7NcWE+8aslhMaDq96Ch1gtrKHnuSlut/sLK4maaXikZUPihxVO4qGGA3q/VC/A5dLlBfJPEB/6nVkiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238392; c=relaxed/simple;
	bh=gM4Cnwub3B8hI/jrDAoLqQpBtuiUzS3A35dZwZIGmm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qgKFFeRjEd9fG+6I/y8gF2D5KVTMlECuwEKSlHD9FpJeyfOPhhJ40EizpxcjvkdMH1kJldK9lPWK7pV+8cEyAHrz4gpPESNFuiJQgOvxOQP5YimYw+1z+5RIDmhsfnLNUbttxAF4GAyynyIzKxIbCQavqrBa6q2LnXFW34Zmkuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nSGfQzg0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nSGfQzg0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D612D1F000E9;
	Thu, 20 Aug 2026 15:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238390;
	bh=+N6d3jwmK4dp9xveZ29gHKu2bq1kKA8bGXD8qt2lIkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nSGfQzg076au92iyDBEzc/+mtdmgyMbYEV3Gdriiv7Nv6XIds3DVONgKP4ICDzxdZ
	 3VM+logPcWn3n9HQjWqpePuBPgiIDQSgci9bU0CrlRWymtaWyyCUv1crJ4SKRH60c2
	 R8BPYrH19ycxZU4nrOrHbX1+2Po0ENK3LjkifbHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.1 130/228] xfs: check cowextsize in xrep_inode_cowextsize
Date: Thu, 20 Aug 2026 16:54:32 +0200
Message-ID: <20260820145248.563459938@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

commit 270ffcd9b0a46254fbf3079d0e3341db7d7ec0e6 upstream.

LOLLM points out that the function that corrects cowextsize should check
i_cowextsize, not i_extsize.

Cc: stable@vger.kernel.org # v6.14
Fixes: a9600db96f74af ("xfs: detect and repair misaligned rtinherit directory cowextsize hints")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/inode_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1956,7 +1956,7 @@ xrep_inode_cowextsize(
 	/* Fix misaligned CoW extent size hints on a directory. */
 	if ((sc->ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
 	    (sc->ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) &&
-	    sc->ip->i_extsize % sc->mp->m_sb.sb_rextsize > 0) {
+	    xfs_extlen_to_rtxmod(sc->mp, sc->ip->i_cowextsize) > 0) {
 		sc->ip->i_cowextsize = 0;
 		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
 	}


