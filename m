Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A125247F77E;
	Thu, 20 Aug 2026 17:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787246985; cv=none; b=MoqnqRLdmqDa2MS1KvrKYmIG5Jql8YxGatDv+VCTI4VC9o3qGomzcrvQVQ+Cotkp3a2iNc0QCoCp+Ev0guxtlNjSTGhPYfX0JE9Edsgdt93Eo1LW8Ftw9JYfvNc1ofFlvwGpPUw6ElydgIuDx0PL+TSrD4W9Ojlslm0SCs4iD0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787246985; c=relaxed/simple;
	bh=uRqVJng8cii96dcvYGVbh86bksPry50ZRLEJl3XwLwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IGOoYIi4GvUEa57BdxdwP7dFWioYQsZrx8SVuEa6QuyekpsU3uyg4rK8NbVD4LwBK3uT9caHdook34tVsrmZ/KXbt3wNgsHqbjeccr0gl3uOie9Bd3jMjVjmZaL6b9g3QGr+KQTH9Tgl6cpj8cGcHKsW2kgqD/m5RzwK8SISVX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0CYkjdeg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0CYkjdeg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84FE1F000E9;
	Thu, 20 Aug 2026 17:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787246984;
	bh=Y6s/EfmUgZKIgkVQXp6wVncehGs0wlTlve8s16tsLnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0CYkjdegXpEEQJWq8/sXipB9erYAUhYu5a/fkdIyaST4y/dhCr1dET9CyGsuz/Oyr
	 qoMM/GH3v0TIOUu7YZlzmeeDddc+LiAh5f/LqII2stDQO0wYNvUGiJRI8udWmQwMnD
	 89+BxfhL1bbsUMp5QYtQtiD7M2VccxnyukfPuCDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 110/220] xfs: check v5 superblock features early
Date: Thu, 20 Aug 2026 16:55:00 +0200
Message-ID: <20260820145226.783155380@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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
@@ -891,10 +891,10 @@ xfs_sb_read_verify(
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


