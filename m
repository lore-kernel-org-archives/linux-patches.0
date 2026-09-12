Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F893DB31A;
	Sat, 12 Sep 2026 11:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214065; cv=none; b=Gtq1LUrgDMRR7j5KUJ7Vde1dKEK5GHhMCLsS9ouK7097TNnkuoYUEIoqTRziMlNL9z6hROzqENVVRskW5Jb+MJ0VbGuTD6PmChKGpKk8tF10GnnwjqBZFPHCPnQ0eonp5cvjlEf9xoEF/V1GP3NMtuSnW6BrCU+agCYJNioEq5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214065; c=relaxed/simple;
	bh=l05utgodRzsXTvNxJ3dXG/0QWp6nva1etPLXCc0yJxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MR7aeLYfoCaIYu0/6An4BZG/TzmeCw/N/uv0MJNZxYR7wGhZzf7pN6PC/rhknWAVwd0jPU0gx2u1eVVldUzgOf9HvG1xEOAAemn/Hb3Vgzuc13va7oAvNTv9ivodk+cp3z50wI5UIs25geMqd5NcpHJiPeNNqo7uFFiyBWln574=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQUTGzo0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQUTGzo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3461F000FF;
	Sat, 12 Sep 2026 11:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214060;
	bh=HRYUPWUMvDFQC48+fzkGer9QL3fg9m7StUfGQ0isxfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SQUTGzo0hR0K24IFG1Qe682tXPudDWkW+905iSYqRaytiC7KZqWxhpQD9+LngQJc8
	 qZwhe5i/BWm59KG47FYG7WWn5QaE8yVYurQ3zSEtuA9+uGZ7YxkkbF6D54ql87Sxv2
	 omjHl2ogfGJiir73ufG3c8s50NsJiNcqZSuzaiHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao-Qun Huang <alvinhuang0603@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.12 0249/1376] f2fs: reject overlapping move range after len expansion
Date: Sat, 12 Sep 2026 08:44:35 +0200
Message-ID: <20260912065613.091551900@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao-Qun Huang <alvinhuang0603@gmail.com>

commit 28c1ef094e7c86977d9bf570dc0362fc54e36437 upstream.

F2FS_IOC_MOVE_RANGE treats a zero length as a request to move data
from pos_in to EOF. However, the same-file overlap check runs before
that expansion, so a request with len == 0 bypasses the overlap
rejection added for same-file moves.

For example, with a four-block file, moving from block 0 to block 1
with len == 0 is accepted by the old check because pos_in + len is
still pos_in at that point. The code then expands len to cover the
rest of the file and calls __exchange_data_block() on overlapping
source and destination ranges in the same inode, which is the
data-corruption case the overlap check was meant to reject.

Move the overlap check after the source range has been validated and
len == 0 has been expanded, so it sees the effective length. This is a
no-op for non-zero len (the value is unchanged there) and keeps the
existing early return for identical positions.

Fixes: d95fd91c1ac1 ("f2fs: exclude special cases for f2fs_move_file_range")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Hao-Qun Huang <alvinhuang0603@gmail.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3053,8 +3053,6 @@ static int f2fs_move_file_range(struct f
 	if (src == dst) {
 		if (pos_in == pos_out)
 			return 0;
-		if (pos_out > pos_in && pos_out < pos_in + len)
-			return -EINVAL;
 	}
 
 	inode_lock(src);
@@ -3080,6 +3078,8 @@ static int f2fs_move_file_range(struct f
 		goto out_unlock;
 	if (len == 0)
 		olen = len = src->i_size - pos_in;
+	if (src == dst && pos_out > pos_in && pos_out < pos_in + len)
+		goto out_unlock;
 	if (pos_in + len == src->i_size)
 		len = ALIGN(src->i_size, F2FS_BLKSIZE) - pos_in;
 	if (len == 0) {


