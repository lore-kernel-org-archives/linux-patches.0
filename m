Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC531E7C16;
	Mon, 21 Oct 2024 10:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507328; cv=none; b=O2Czl/OJnzHKPe5OtKSphStd+rzSKf5TYrew/wiByVoX/GNWzQhRwGwwTIW6E3Gu27zFH42Vm51Gy6Z1V42QCFRfLqft4L5CckQ1TEWfZ8tId+yU6siqyeDnYNwcN49axTwKquDdbJnrOxSWi8xYZMAa2j2/QMUhn0glrgB5N/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507328; c=relaxed/simple;
	bh=CEFVc1ZGLai6UqD4P1a+KIjKcI5FEppdf1GTzE4rQmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=modlw9dqZwzK6FkM+vnX4HW5BCkur8wGQDTPY7QXIVBWdJDtXxAAkZW0vXy7e6Cqid/VBqHlm9Aya8NkQ5PPAN9fOecQQxaK8bjj5f5POAvl0i0Aw03I80UMyK2dlCUPCF4w+4AJsj0yDqg/y1i7sjmZAZbAA2lhYWiAU6jpD5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jt2Wcs8I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jt2Wcs8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7ECC4CEC3;
	Mon, 21 Oct 2024 10:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507327;
	bh=CEFVc1ZGLai6UqD4P1a+KIjKcI5FEppdf1GTzE4rQmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jt2Wcs8IX5ijX3wDIiAJfeBvMttAPzRr61l0Q/1+Q6twj1Mi+VljCdzd7eo7Qbi5k
	 QUUpWdUoAaq2gQimMsof69QFSacRdD6cYXYM2TQCZ89U9UbBuayI+cP6KOvgm+KiD8
	 e4+8m5RpwxVy5OFrejOvFx+TlLjUDlQdTZKLiO5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 6.1 23/91] udf: Handle error when expanding directory
Date: Mon, 21 Oct 2024 12:24:37 +0200
Message-ID: <20241021102250.726859951@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit 33e9a53cd9f099b138578f8e1a3d60775ff8cbba ]

When there is an error when adding extent to the directory to expand it,
make sure to propagate the error up properly. This is not expected to
happen currently but let's make the code more futureproof.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/namei.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -192,8 +192,13 @@ static struct buffer_head *udf_expand_di
 	epos.bh = NULL;
 	epos.block = iinfo->i_location;
 	epos.offset = udf_file_entry_alloc_offset(inode);
-	udf_add_aext(inode, &epos, &eloc, inode->i_size, 0);
+	ret = udf_add_aext(inode, &epos, &eloc, inode->i_size, 0);
 	brelse(epos.bh);
+	if (ret < 0) {
+		*err = ret;
+		udf_free_blocks(inode->i_sb, inode, &eloc, 0, 1);
+		return NULL;
+	}
 	mark_inode_dirty(inode);
 
 	/* Now fixup tags in moved directory entries */


