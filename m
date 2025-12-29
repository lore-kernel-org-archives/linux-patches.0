Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF79F3321C6;
	Mon, 29 Dec 2025 16:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025842; cv=none; b=Uo64Fv41umFL8zhn5b9Fv5ve6/VMYNRthpppCOPQDpfS1usWvWSgIMM7bMSs4RebjhMZaOsIAIrJnHhlf9sI5bmFDMQImYUXVQBn91HOHVVfw1yDHg1d2OG7Wxq16YMoz5GmrKepOnnlGfwIbFwjpwFWxncmLbiZ9zpQO+V7aPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025842; c=relaxed/simple;
	bh=KxfMAuiN4JMAKJAygFsC0A++LjmRjr/FXk7hsaffASY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CulBkyldnKy5OjRt9A296hHk+xnu3r+VRsTfy5OfNMvtdJjY7FADWGP3pAP4uhKdVBCL3U3uAjmSrcXpIJ8mtfm67rsUSjYe46i9chkSQlyS+CUu0x+8TtgIUZgyDJusqQUP8Q7WuX3+H9gx3v0XE8VpHlO36jjH56uXah0q/ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XHO4KTkB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHO4KTkB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A2BC4CEF7;
	Mon, 29 Dec 2025 16:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025842;
	bh=KxfMAuiN4JMAKJAygFsC0A++LjmRjr/FXk7hsaffASY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHO4KTkBMtmLsDMN4IjXMkEdoTQGWpoHKvokkjF2lre0b8XBHoCviKQlFQ8eHmSy8
	 m/GbpAon4E/n+TOZ0GHyDt+2Rpu2u4/s7H9LNwecoVB1IZGKoEewfeTuFBJjvGpb9m
	 7obndXzGv6laFd0u9OPZaQ/HCXqGPWv3E7IwgazE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 357/430] xfs: fix a UAF problem in xattr repair
Date: Mon, 29 Dec 2025 17:12:39 +0100
Message-ID: <20251229160737.466281974@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 5990fd756943836978ad184aac980e2b36ab7e01 upstream.

The xchk_setup_xattr_buf function can allocate a new value buffer, which
means that any reference to ab->value before the call could become a
dangling pointer.  Fix this by moving an assignment to after the buffer
setup.

Cc: stable@vger.kernel.org # v6.10
Fixes: e47dcf113ae348 ("xfs: repair extended attributes")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/attr_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -333,7 +333,6 @@ xrep_xattr_salvage_remote_attr(
 		.attr_filter		= ent->flags & XFS_ATTR_NSP_ONDISK_MASK,
 		.namelen		= rentry->namelen,
 		.name			= rentry->name,
-		.value			= ab->value,
 		.valuelen		= be32_to_cpu(rentry->valuelen),
 	};
 	unsigned int			namesize;
@@ -363,6 +362,7 @@ xrep_xattr_salvage_remote_attr(
 		error = -EDEADLOCK;
 	if (error)
 		return error;
+	args.value = ab->value;
 
 	/* Look up the remote value and stash it for reconstruction. */
 	error = xfs_attr3_leaf_getvalue(leaf_bp, &args);


