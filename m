Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D84145324;
	Wed, 19 Jun 2024 13:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803754; cv=none; b=Q1jhGeUugYxJLgEEsTwFj7rket04ZwwKNu31HSL8g27N5zBCAlsBSDggZKz8ERofx9ALYGYSdzgSh9nKz48Ozt6UrqFOlno+vIWDM2jG6t6VijP8rKBeo1oo1Tph3wf1uKvdCVLGa/3nQbW05N6cdrLzcjSc/ZPXTkL0bcOYlgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803754; c=relaxed/simple;
	bh=m0rjaMopze7iNiJEAmUXc+K+ViSN5U9xsjrk7EgRvn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hod19KGtCuXwUMn9LMfR//F3rF7b/1OsOMs2lZ6URkFtZ8cQws6wxFSXM5MWXWPfoeO5coEXMKtAYJgWB4wvCxsmmxVSblrIBNhjvPJHtxQ3x+/beoHVqy0DftCxzlXGT4t3NSgD5dYaUNcN8sMe2gyXof3m3VpWvmshOTplQpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2bxuiAHk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2bxuiAHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE5BC2BBFC;
	Wed, 19 Jun 2024 13:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803754;
	bh=m0rjaMopze7iNiJEAmUXc+K+ViSN5U9xsjrk7EgRvn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2bxuiAHkYDhn6E6r2X8xAdUpTy+CClTgLNSZrYS1oEHgM0eCZOTz2tTpM1K7zvzoc
	 Zo7JjXhBnyAmhda5ZZmLiA4ELQZWX8/P9acmSMHSfo/mvFEXC6ba9XNQWx7s8FmD7l
	 S6VanOOw8H/PDju8LflcftKtMLf+cR8zpCLjZWCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9dfe490c8176301c1d06@syzkaller.appspotmail.com,
	Dave Kleikamp <shaggy@kernel.org>
Subject: [PATCH 6.1 092/217] jfs: xattr: fix buffer overflow for invalid xattr
Date: Wed, 19 Jun 2024 14:55:35 +0200
Message-ID: <20240619125600.238767002@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 7c55b78818cfb732680c4a72ab270cc2d2ee3d0f upstream.

When an xattr size is not what is expected, it is printed out to the
kernel log in hex format as a form of debugging.  But when that xattr
size is bigger than the expected size, printing it out can cause an
access off the end of the buffer.

Fix this all up by properly restricting the size of the debug hex dump
in the kernel log.

Reported-by: syzbot+9dfe490c8176301c1d06@syzkaller.appspotmail.com
Cc: Dave Kleikamp <shaggy@kernel.org>
Link: https://lore.kernel.org/r/2024051433-slider-cloning-98f9@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jfs/xattr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/jfs/xattr.c
+++ b/fs/jfs/xattr.c
@@ -557,9 +557,11 @@ static int ea_get(struct inode *inode, s
 
       size_check:
 	if (EALIST_SIZE(ea_buf->xattr) != ea_size) {
+		int size = min_t(int, EALIST_SIZE(ea_buf->xattr), ea_size);
+
 		printk(KERN_ERR "ea_get: invalid extended attribute\n");
 		print_hex_dump(KERN_ERR, "", DUMP_PREFIX_ADDRESS, 16, 1,
-				     ea_buf->xattr, ea_size, 1);
+				     ea_buf->xattr, size, 1);
 		ea_release(inode, ea_buf);
 		rc = -EIO;
 		goto clean_up;


