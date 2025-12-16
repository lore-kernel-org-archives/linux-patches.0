Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBAB35502D;
	Tue, 16 Dec 2025 11:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885875; cv=none; b=GPY/0HBXRq8rKFfia5bG46iQGitEwl2GPDUtPd5KO9K3+9TUbZ4DSHk0sIoQvx+5ouIa7GuFkT9CdABGYq23oGE/rpg0FbOT8kClf9XvuvQQzT6e6Zrt3NKIlglkjy+5lL8vEcCt2AfHJQoSH/cb5BQX+hPgtfRTI2kaTphgeZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885875; c=relaxed/simple;
	bh=uADJGnFwm4U1ILEpgzR+7E7mdLRp6OA0BWPFfh7ZlQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqid6g7li2VM7EhpDUTT/BOdl0+Z3Mh40SR2s5t/cMb2j23AlgIXduYNO4c9ZUUS/zLwOIt2yy2nW1kUJfFinSN1Cn2JbqqGi4oBL295SPX0bBCP5AO/6guuXnv+IqeOWah4P9v8zguCv4qyTzPn03W9UmYp6/wKpNDdt0ZtHl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJuAox3G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJuAox3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17CCC4CEF1;
	Tue, 16 Dec 2025 11:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885875;
	bh=uADJGnFwm4U1ILEpgzR+7E7mdLRp6OA0BWPFfh7ZlQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJuAox3Gdhnoz4pKHDV9XlKTYqUpUUprO2uZenHvxdbW9/lGGfnuFVdSIn+70mT74
	 MIorKCqHgSPbza5WR84IKzMurEue1gZCtMu72dlxYURF5iw0v0xN01xeZ1sJ+oSsD6
	 znqbdB9N2jFTorrEe2WTElv/FzlPtJhEvu2H5xBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3932ccb896e06f7414c9@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 270/507] fs/ntfs3: Prevent memory leaks in add sub record
Date: Tue, 16 Dec 2025 12:11:51 +0100
Message-ID: <20251216111355.267606897@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit ccc4e86d1c24260c18ae94541198c3711c140da6 ]

If a rb node with the same ino already exists in the rb tree, the newly
alloced mft_inode in ni_add_subrecord() will not have its memory cleaned
up, which leads to the memory leak issue reported by syzbot.

The best option to avoid this issue is to put the newly alloced mft node
when a rb node with the same ino already exists in the rb tree and return
the rb node found in the rb tree to the parent layer.

syzbot reported:
BUG: memory leak
unreferenced object 0xffff888110bef280 (size 128):
  backtrace (crc 126a088f):
    ni_add_subrecord+0x31/0x180 fs/ntfs3/frecord.c:317
    ntfs_look_free_mft+0xf0/0x790 fs/ntfs3/fsntfs.c:715

BUG: memory leak
unreferenced object 0xffff888109093400 (size 1024):
  backtrace (crc 7197c55e):
    mi_init+0x2b/0x50 fs/ntfs3/record.c:105
    mi_format_new+0x40/0x220 fs/ntfs3/record.c:422

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Reported-by: syzbot+3932ccb896e06f7414c9@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index a557e3ec0d4c4..e5a005d216f31 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -325,8 +325,10 @@ bool ni_add_subrecord(struct ntfs_inode *ni, CLST rno, struct mft_inode **mi)
 
 	mi_get_ref(&ni->mi, &m->mrec->parent_ref);
 
-	ni_add_mi(ni, m);
-	*mi = m;
+	*mi = ni_ins_mi(ni, &ni->mi_tree, m->rno, &m->node);
+	if (*mi != m)
+		mi_put(m);
+
 	return true;
 }
 
-- 
2.51.0



