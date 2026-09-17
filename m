Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE9F391842;
	Thu, 17 Sep 2026 16:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660883; cv=none; b=u3EQERctf4i3ucSkm5u1m5nc7TNB0rcHj7RJ5uvDpZDO0h9cNZG67QGZa1c2EvYlxXBDTZpWM5KBZ99/PRABDnIBfKKDytKNesda6uNW4t6rbOVEBjrzSn9ipjFsiZsH7l+Bs8fQLaC+ewD6Iv/COegSzKf2aiZydwJoC6xL6Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660883; c=relaxed/simple;
	bh=J/J+wENWgQM3ruzTTl3wXkIHoEbJAR+h/3swjO7RdhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sct9VmE+2c1L4Hj4mCfegW1SE2zkN3wNE7bXdQqQPT2XKVBSoB2RhT2NLJ50iaEfV31pGq4Lgn9Ld1lKDL4oqnVmbOquL6YULdRZ0xowXvq8hi8GgXH2WPuElbQZ9Y9liWTad4s0hqkmXbKMld5so+A2IgyMYqD+RWiW97pc5ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fppIFt8h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fppIFt8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301A61F000FF;
	Thu, 17 Sep 2026 16:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660882;
	bh=bXc/Ml402HDbQfnV5x2E1AW2VleImjoECUkRmnx0nUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fppIFt8htcz/ke8eyjX46rQvonpBJ2DKWq60roiHYnoRhjLQjh7pI9fZ59f5XNfX1
	 oiysHknaMyzbB6AUjw6UpjD1k1VEhQAgW/uFVY3jOeSTfuDnW1tcnyusJJiiUtMUaK
	 qgO9RBJgLu47Ol9pBP3p4UIjvHe46PujZ7XjauLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 708/733] f2fs: fix to reset all pinned status during fggc
Date: Thu, 17 Sep 2026 16:16:56 +0100
Message-ID: <20260917151410.523758208@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 2b8704b6a8b2896ccad1f5941d9a3e2c5031a470 ]

Otherwise, the pinned status may affect latter flow of fggc.

Cc: stable@kernel.org
Fixes: 9703d69d9d15 ("f2fs: support file pinning for zoned devices")
Cc: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/gc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -2183,6 +2183,9 @@ int f2fs_gc_range(struct f2fs_sb_info *s
 		do_garbage_collect(sbi, segno, &gc_list, FG_GC, true, false);
 		put_gc_inode(&gc_list);
 
+		/* reset all pinned status during fggc */
+		f2fs_unpin_all_sections(sbi, true);
+
 		if (!dry_run && get_valid_blocks(sbi, segno, true)) {
 			err = -EAGAIN;
 			goto next;


