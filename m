Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EE31EB5A;
	Mon,  4 Mar 2024 21:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587738; cv=none; b=FlsNZ9s2Zl+6mrqiAMvTacKakAYqs1+U0O3rTa5vh5kAdJdEdgQMpEf/tSiDTZr6gYk1PJGtzU23tEhWe/BigyAnEmRhM1sN2OUChXMg5ypCpsDkxGTpaqPl8F4r6I10a/c9aXIesbF3HMYTIoej6x1xejgoly2A6hDE6Gf6j64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587738; c=relaxed/simple;
	bh=aAKTNP07e6KzFB01Lr/nH7Fw4UaUbOa0p05b2K+HBQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUQ049CbT1/LEgntn8qan4nIdTqQkcGWBJBJX8dyZka6KRmoL1ZVwtTs082eO9pwqFM7rPVbQ7wTgV+HjxlW982ikP/dB+OmZ/rfa+AVyGkWvntzA1hf7HP6sVmk9tq6fIZdztVu7DNMJ68X1rmagQ3wgrWvpkkws2zqdJ588Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p4cQ8sG2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p4cQ8sG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999F3C433C7;
	Mon,  4 Mar 2024 21:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587737;
	bh=aAKTNP07e6KzFB01Lr/nH7Fw4UaUbOa0p05b2K+HBQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p4cQ8sG2F/mT8gdDMS0he+eImDU8FGj9ORrNtNEZyXUi53a/+8G0ImscT8zphYBIL
	 8J2kF7ekaZ6BoA4ePwhIFvMl5AlIGz6dEVnZBYFtQ+djkmxdYJk6fo70WIiAkhOXbn
	 w01mSzIwfjp0My47k82rSkQM4uy3O/zYyi2rNXd4=
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
Subject: [PATCH 6.7 063/162] afs: Fix endless loop in directory parsing
Date: Mon,  4 Mar 2024 21:22:08 +0000
Message-ID: <20240304211553.864946802@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 9140780be5a43..c097da6e9c5b2 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -479,8 +479,10 @@ static int afs_dir_iterate_block(struct afs_vnode *dvnode,
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



