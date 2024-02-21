Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D0C78B4F;
	Wed, 21 Feb 2024 14:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525010; cv=none; b=G4QeThDGRRVgTbskGrx+/KNwBIYb9A/ObZno/3u/H+Oe2hT9WpdDnYMxNL2EqoyQT2G5qi2OSZkUiAz34HOmwb82qNV7GNTJNeuZjE/7NHHETrnLTqjg9uDH1DSkdYTaAmZXKp5gYetYFzTue5RB4OfY5I6p5wUmh8nwRd4XqAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525010; c=relaxed/simple;
	bh=r8FvklVmNQaPT/IJ+VnGcI0YlU3i5FP7E6MquMhWLsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0gsFrD9nC02/Ski5Z/Qr3ejywW62bKxG1q5Y6/H0YYmeiS49HQXC9qZ04qGZr+uNz7MScJ7z1CZVURJjyKz/eTbZw3c5CjeIYsYhrnrJSfxvxReHGvd8V1bAToX5BYlMmOX6AsxZfBpROSk07ZuJX4l9f2wBNfE8VoH8ctw3BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SD/7EizS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SD/7EizS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58121C433F1;
	Wed, 21 Feb 2024 14:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525009;
	bh=r8FvklVmNQaPT/IJ+VnGcI0YlU3i5FP7E6MquMhWLsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SD/7EizSdaZcFau5b7nzJvf9JzHiZnvv62loo+QmTwKghghPT7s2yZwJ9DgXUwta+
	 B3StgSLSYlZnWKC0QD0fBaMn5kdJQx5wPTRy8wLTDo5FhZIB6wek+dImyr89RbLtM3
	 tqLDXTUkoCnorpCAeh5KhSI73pt635FkOKItS3Is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 032/267] afs: Hide silly-rename files from userspace
Date: Wed, 21 Feb 2024 14:06:13 +0100
Message-ID: <20240221125941.044302264@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 57e9d49c54528c49b8bffe6d99d782ea051ea534 ]

There appears to be a race between silly-rename files being created/removed
and various userspace tools iterating over the contents of a directory,
leading to such errors as:

	find: './kernel/.tmp_cpio_dir/include/dt-bindings/reset/.__afs2080': No such file or directory
	tar: ./include/linux/greybus/.__afs3C95: File removed before we read it

when building a kernel.

Fix afs_readdir() so that it doesn't return .__afsXXXX silly-rename files
to userspace.  This doesn't stop them being looked up directly by name as
we need to be able to look them up from within the kernel as part of the
silly-rename algorithm.

Fixes: 79ddbfa500b3 ("afs: Implement sillyrename for unlink and rename")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 43f5b972fcea..8bed9df09230 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -421,6 +421,14 @@ static int afs_dir_iterate_block(struct afs_vnode *dvnode,
 			continue;
 		}
 
+		/* Don't expose silly rename entries to userspace. */
+		if (nlen > 6 &&
+		    dire->u.name[0] == '.' &&
+		    ctx->actor != afs_lookup_filldir &&
+		    ctx->actor != afs_lookup_one_filldir &&
+		    memcmp(dire->u.name, ".__afs", 6) == 0)
+			continue;
+
 		/* found the next entry */
 		if (!dir_emit(ctx, dire->u.name, nlen,
 			      ntohl(dire->u.vnode),
-- 
2.43.0



