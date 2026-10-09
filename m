Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425C7274FDF;
	Fri,  9 Oct 2026 14:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557465; cv=none; b=WXxO0SlFdOTEhey/6JQZoj/YMbp0BNv3ATj5dgSfp/l0M5BKkCbdPLvSYrXTwc8RpqCdj2WpqcgnB/jmEZUl7G/YPfz7/liLjQRb7YT033WuS2NqyNPKv4/cvPr5whMYO9wXaH0dhPsnizJYdYTelGMklFpCADCNcr5pp7gjl8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557465; c=relaxed/simple;
	bh=EB0QQoP+neuP/fQRJxjDRS88I5pG+kmUVjE74K51mBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=biGLy/3rc0as5FGg6H9zFfPhyv61UjFeWkrXTjqCGAfdNkqo1H8mtUWTZbjoMRC+S9y0QVv7u3fgErZZm7xLqq/2ToBrmheUrU9VzXTzHfIFAd2Rnm4HUu2KteOvV7quuEKgULhVtkszNGsphbBnd5OO/8l+C9dJ4WasHmc3jy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hKzHjcYV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKzHjcYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A177F1F000FF;
	Fri,  9 Oct 2026 14:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557464;
	bh=x7JqIvWXd0QhYvwoDjYxiLB0VvO6kpW2bOpT0wnr1dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hKzHjcYV/SOjB2t2vV9Z0vpcuyk8oV9xqyC5P5bg3g9vpZVhh0b+ieFanjNbbwLI2
	 Nu25X7enphIqFRGm5bBBiNfnzOvzG9HM+5AIvGRwFnt7bROO2K72zLm1SBgjzkeVQB
	 6AQLDJME6cau5QFmHyGv+/l6s4+pkzHo4UmE5yPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.2 369/428] smb: client: split cifsFileInfo bitfields to avoid shared-byte RMW races
Date: Fri,  9 Oct 2026 16:11:46 +0200
Message-ID: <20261009140954.288367108@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Frank Sorenson <sorenson@redhat.com>

commit 19465a9aeb664f1d710d0d22c07c31bfb7c85446 upstream.

The invalidHandle, swapfile, oplock_break_cancelled, offload,
and status_file_deleted fields are stored in the same bitfield byte
in struct cifsFileInfo, but are updated in different code paths that
may run simultaneously, and are protected by different locks.  Since
bitfield assignments generate byte-level read-modify-write operations,
a modification to one flag can overwrite a concurrent modification to
another flag.

To avoid these races, convert these flags from a bitfield to
separate bool fields.

Closes: https://lore.kernel.org/r/7689764e-c0f6-4016-9557-b54cf4a3de4e@redhat.com
Fixes: 3bc303c254335 ("cifs: convert oplock breaks to use slow_work facility (try #4)")
Fixes: 4e8aea30f7751 ("smb3: enable swap on SMB3 mounts")
Fixes: ffceb7640cbfe ("smb: client: do not defer close open handles to deleted files")
Fixes: 173217bd73365 ("smb3: retrying on failed server close")
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsglob.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1450,11 +1450,11 @@ struct cifsFileInfo {
 	struct dentry *dentry;
 	struct tcon_link *tlink;
 	unsigned int f_flags;
-	bool invalidHandle:1;	/* file closed via session abend */
-	bool swapfile:1;
-	bool oplock_break_cancelled:1;
-	bool status_file_deleted:1; /* file has been deleted */
-	bool offload:1; /* offload final part of _put to a wq */
+	bool invalidHandle;	/* file closed via session abend */
+	bool swapfile;
+	bool oplock_break_cancelled;
+	bool status_file_deleted; /* file has been deleted */
+	bool offload; /* offload final part of _put to a wq */
 	__u16 oplock_epoch; /* epoch from the lease break */
 	__u32 oplock_level; /* oplock/lease level from the lease break */
 	int count;


