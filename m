Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29121C6AB;
	Mon,  4 Mar 2024 21:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589317; cv=none; b=O7uCXng8pgap/ettFxcM0eaDoker0vmepfPNBvzMSfC7UqjLja4r/eXElg1K7WgiRqarJDMLztDHZY+tv+HobDLdw8Nak0CRMsKy3DfuevgOIH4pKzM1tif7x3k2Sn2QTkIoA2xaGiOQMIOVU61N979WolZ0zovNN8iIQ7mjySg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589317; c=relaxed/simple;
	bh=LdSnXUHuHlc/u/1RDPYxXsUtvu6a8T274QmDedL2/78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zs+AMliHMxNrK3PG1gvvqgXjnUAf3Yn52ajyUCkTs1S3EXpjtxVa3d2/UnBKhgE6SSC+pOPGKE1P97DBWVf82FQK+oKBgrFckIC1e8p+27MlWr6jKDnE/r7kYwhyfo3OfkP5FBQgBoEIsuaA/GPSOxb0ak9IhwQIwztGXCn2Sk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0XbEbHL6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0XbEbHL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882D7C433C7;
	Mon,  4 Mar 2024 21:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589316;
	bh=LdSnXUHuHlc/u/1RDPYxXsUtvu6a8T274QmDedL2/78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0XbEbHL6rox9DhE+iANKhKleDahQyWN36xhKdeupKu3j0oVUdoJywA74IT7p2d4JL
	 fqdUrAYQnzG0z2t5nyWoMYMyqU2vqXeBEkzla3WH9JM6kxrArRO2Cq9abFkbl4fzSb
	 hgvhVdUFbzcH99Zrkr0qTITNgvKfxFKsKWgYIeRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Markus Suvanto <markus.suvanto@gmail.com>,
	linux-afs@lists.infradead.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 45/84] afs: Fix endless loop in directory parsing
Date: Mon,  4 Mar 2024 21:24:18 +0000
Message-ID: <20240304211543.839458004@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 5f7a07646655fb4108da527565dcdc80124b14c4 ]

If a directory has a block with only ".__afsXXXX" files in it (from
uncompleted silly-rename), these .__afsXXXX files are skipped but without
advancing the file position in the dir_context.  This leads to
afs_dir_iterate() repeating the block again and again.

Fix this by making the code that skips the .__afsXXXX file also manually
advance the file position.

The symptoms are a soft lookup:

        watchdog: BUG: soft lockup - CPU#3 stuck for 52s! [check:5737]
        ...
        RIP: 0010:afs_dir_iterate_block+0x39/0x1fd
        ...
         ? watchdog_timer_fn+0x1a6/0x213
        ...
         ? asm_sysvec_apic_timer_interrupt+0x16/0x20
         ? afs_dir_iterate_block+0x39/0x1fd
         afs_dir_iterate+0x10a/0x148
         afs_readdir+0x30/0x4a
         iterate_dir+0x93/0xd3
         __do_sys_getdents64+0x6b/0xd4

This is almost certainly the actual fix for:

        https://bugzilla.kernel.org/show_bug.cgi?id=218496

Fixes: 57e9d49c5452 ("afs: Hide silly-rename files from userspace")
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/786185.1708694102@warthog.procyon.org.uk
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Markus Suvanto <markus.suvanto@gmail.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 106426de50279..c4e22e9f7a666 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -497,8 +497,10 @@ static int afs_dir_iterate_block(struct afs_vnode *dvnode,
 		    dire->u.name[0] == '.' &&
 		    ctx->actor != afs_lookup_filldir &&
 		    ctx->actor != afs_lookup_one_filldir &&
-		    memcmp(dire->u.name, ".__afs", 6) == 0)
+		    memcmp(dire->u.name, ".__afs", 6) == 0) {
+			ctx->pos = blkoff + next * sizeof(union afs_xdr_dirent);
 			continue;
+		}
 
 		/* found the next entry */
 		if (!dir_emit(ctx, dire->u.name, nlen,
-- 
2.43.0



