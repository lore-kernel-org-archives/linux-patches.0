Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0D2377A82;
	Thu, 20 Aug 2026 16:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244070; cv=none; b=L0CHRvOffVOZtvYFm2oyw3YXBbi7zyupZY73jLrNUF179ahLvI+41gYjdyhOEW9Deq4KOVScZtJIniRO9HjvQ0+KDNf3GWglghkxiHThRn0KsXEw5HD9uW3NpZqYU0+ZC1U24kh/ASAsLha3RrHYpJI8ma/65BnnC+sZC269FPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244070; c=relaxed/simple;
	bh=D5xSQkv3wGUsG4nq0kIfeIzQ9CITc9re5AqGv8CriLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWESZrr2EYbL5ZXUqdzle1NoUS6RfJwaLBS+smQzLFlAv6j06NN86/I8i8wOqZs0ysW7H2JWcjcW0gSJeQZrqQoTgGvqT2tP8Smb0GRuZR1OIL3EGnVxKWt4gZNaobJ5GBOEHkHsaLxo+ITBB1Crzm+J/JKhBw123YjHbN4vptY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ZXMBGad; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ZXMBGad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879B81F000E9;
	Thu, 20 Aug 2026 16:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244069;
	bh=zNrxZt07LkqrtyTbaL54VTUFopvtSrI7qxFla+BucsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ZXMBGadrZZIqNd79KTFeHZ9t8l8y1oQurTioNRpVlb8f4JQbV0aex39FQosVj0IF
	 gpNUZ73mKoeymF4USetN6l1avqvTF1XjXd6ZWp50dnF6xZ+CAYlIRc/nUE/ff10FSr
	 ozrKqY7NcFKEewleB07hFi7TWwWiaKxiVQc/chk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 5.10 040/235] xfs: check v5 superblock features early
Date: Thu, 20 Aug 2026 16:54:36 +0200
Message-ID: <20260820145217.647957676@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit eb6b2cc1fc8ad566d746d128a559989ff0bba5cc upstream.

When working on a new features that reuses the existing pad in the
superblock, I noticed that mounting such a file system on an old kernel
logs a rather confusing warning:

    XFS (vdc): Metadir superblock padding fields must be zero.

This is because we only validate the various feature fields in v5
superblocks after the common superblock validation helper is called.

Fix this by calling the feature validation first.

Fixes: eca383fcd63b ("xfs: refactor superblock verifiers")
Cc: <stable@vger.kernel.org> # v4.19
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_sb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -804,10 +804,10 @@ xfs_sb_read_verify(
 	 * because _verify_common checks the on-disk values.
 	 */
 	__xfs_sb_from_disk(&sb, dsb, false);
-	error = xfs_validate_sb_common(mp, bp, &sb);
+	error = xfs_validate_sb_read(mp, &sb);
 	if (error)
 		goto out_error;
-	error = xfs_validate_sb_read(mp, &sb);
+	error = xfs_validate_sb_common(mp, bp, &sb);
 
 out_error:
 	if (error == -EFSCORRUPTED || error == -EFSBADCRC)


