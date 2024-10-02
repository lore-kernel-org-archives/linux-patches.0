Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6231D0796;
	Wed,  2 Oct 2024 13:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876421; cv=none; b=KUj0f1xsJOOdmNGALBPCA25CoyICzQHxweRzfssva9/oAvcXnYvL+NVYnWVIA0r9ppwU3oC+e72Qj/rckeZ1876Eo7lIX/yzpTF2PnOwfCcd3hAm9xBP5wVgf0U1EmsKg06riTwSsMR5mo+CHPaXqNwtoqpEEPQEtMikPJflRDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876421; c=relaxed/simple;
	bh=eD+nae8/+XBtuaPLJNtHafcE/ea/HlDvaIL53W/TR04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOkEwGuQ7N0SCEQPml+p24bwRTstMRpIy9B9J4pJ/0R+oMNTsZl5VmFpjSZ0vbC36tMImtCTYH5wqyiD8q450/iPiq52vKqAyvu0gJP72ZYkxY8708RvTbykgPQN2vofwkudtrRN/ECIr6oigrao8KT/m3EL/LoD0EaVG722/Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zT+BeMGN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zT+BeMGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45EE8C4CEC5;
	Wed,  2 Oct 2024 13:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876421;
	bh=eD+nae8/+XBtuaPLJNtHafcE/ea/HlDvaIL53W/TR04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zT+BeMGNfNDkSmTt0Eh+IJhM5NzGGGr/7AGiFLb8PIneZk5YXCGaJsu1W2E6T3sXl
	 +CTdTTZPeLZjyYaRPJ6XPwhTRiEmgmYi7LCtLt/cDCDdaaz+2IpF7Xg7b9JZlc/PSC
	 5/96g2r1I3JuOuvKe2NmyW0HGYaqSawVu7q2Sdds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 439/695] f2fs: atomic: fix to truncate pagecache before on-disk metadata truncation
Date: Wed,  2 Oct 2024 14:57:17 +0200
Message-ID: <20241002125839.983286128@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit ebd3309aec6271c4616573b0cb83ea25e623070a ]

We should always truncate pagecache while truncating on-disk data.

Fixes: a46bebd502fe ("f2fs: synchronize atomic write aborts")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index e178e3ebde04e..5558a75f29b79 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2184,6 +2184,10 @@ static int f2fs_ioc_start_atomic_write(struct file *filp, bool truncate)
 		F2FS_I(fi->cow_inode)->atomic_inode = inode;
 	} else {
 		/* Reuse the already created COW inode */
+		f2fs_bug_on(sbi, get_dirty_pages(fi->cow_inode));
+
+		invalidate_mapping_pages(fi->cow_inode->i_mapping, 0, -1);
+
 		ret = f2fs_do_truncate_blocks(fi->cow_inode, 0, true);
 		if (ret) {
 			f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
-- 
2.43.0



