Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B14E158D71;
	Mon, 29 Jan 2024 17:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548317; cv=none; b=oIK+7p3PojmZuOoFG/hqe/xd16u0qKfTsbMWnbo0wql8BmnNYoDew+CrR254+uxVZtoi3sXTh+GOZ0hRJ8MQHFaMk5eZMJvehhCOWAH9jiI5bMh6yOJAfzwDMWthfOXtLRXf3hgpSx8GBXy8h4YHoQXPaM6e2v194MjWqqzDBN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548317; c=relaxed/simple;
	bh=lZ4/N3dkZ3Kfc7so0Sh7sQjwOwNGxXxNC0UcUupv2eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8RJvWGk22sRfZ2VReHD6rsIwJ0rMmFz1b4EewX0v4nQVy7LgMHUFZqddgnGdlWSWiZlD3PyscFsuPJ6qR/Wx1+Mfa5pERmZMONlrwLvqdfsypwZM3KVripoYpYLtBjTzkklIX7ZGtyuobqACc+sUrMX5WViZf5iuDSxc32G0tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FUxIVuTr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FUxIVuTr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51EC9C43390;
	Mon, 29 Jan 2024 17:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548317;
	bh=lZ4/N3dkZ3Kfc7so0Sh7sQjwOwNGxXxNC0UcUupv2eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FUxIVuTruv/Myo8JSr1DIYSakvpP/9WWhFMJ2CA3WJNe2qByjK8tPaIq+Dq8/YEW0
	 L8FcQzaDKEdrtjDMJDqpdz0K4ZzcLlLR+XE9PjpAhMD/o0aVceNK42kld8EAZ4jPnP
	 o/C57IkAYsAAM3wKVVMbGwNkIOtPcgmDp7eTrZ0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/185] afs: Hide silly-rename files from userspace
Date: Mon, 29 Jan 2024 09:04:51 -0800
Message-ID: <20240129170001.522811291@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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
index 07dc4ec73520..cf811b77ee67 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -473,6 +473,14 @@ static int afs_dir_iterate_block(struct afs_vnode *dvnode,
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



