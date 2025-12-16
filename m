Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D554361DB1;
	Tue, 16 Dec 2025 12:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887727; cv=none; b=n0Qx7sJI2U8kkk/UwE5bIPcbG89EkTzKw9MJF9dSZslqEJCf86vFW37/UwJmmLBKeF0iULpAp5xuzvSOdrnpO7UYZ56aDUGRMGkriIYnXNGMgTYyPiBiY1k0sTTQQyqxE6ddNWZh8d5lhGPPt49F/CoioQIuc98qyvPCufpu/9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887727; c=relaxed/simple;
	bh=Q3dPeIRW5uinqTR6k+ukb173R6QzaPYSqez3+r8QhNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okji/7XgJYXYo00CdbaQ5mRi81prXLq5Cr/TQ1eaocPnf60jzMirl8bEioDvcCYJwGjb1ucjtqoY36ArLcnQiI+sNNG5J4/tj9l7UUstbI7vYdNZ4FFQqnhL3W+2izDeGLLqvbOHynG85XgEJl9ZJYT3dwVz1iAi/fmdoYsO4oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SRl1G5re; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SRl1G5re"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7F4C4CEF1;
	Tue, 16 Dec 2025 12:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887727;
	bh=Q3dPeIRW5uinqTR6k+ukb173R6QzaPYSqez3+r8QhNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SRl1G5re3dVHP9UYX7+JUGnXUYKRDDkDoFu/BSjwPl2CMr1rZ1qNttg+ZR67ZLdN0
	 YZb2TK5aWZId3FUQotmsoOQXR1bMtRYR75DfpqQT8HaLjU9bOLISzY7Olc+TdOtlVK
	 6vJFta3uOHylfSFzyRtMa7Yf7YPtV65wsAnchUZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3932ccb896e06f7414c9@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 320/614] fs/ntfs3: Prevent memory leaks in add sub record
Date: Tue, 16 Dec 2025 12:11:27 +0100
Message-ID: <20251216111412.958621776@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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



