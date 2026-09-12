Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9372D0C94;
	Sat, 12 Sep 2026 14:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222019; cv=none; b=ePnkd49y8CgX+AmELHyYOpWrnLkL4rmohQPdY1XCfX81oS6rUvGpTCsYG56k46e4keQEyNfKA99sdnbY31KvZ6vRjY84R7qK88ugF/PY1LD/aJ1wWbouteWpDA3uIVpytHtJUk+CacdHMuJHn2cwEeDZSYpqLM24jIir5o9ki00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222019; c=relaxed/simple;
	bh=WPHcO5Rb12Jr55fu6/9hlmbBeU24R0ltZUfZTxzlKRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWEk/1IkGQMa6XDLoXjJPmK5tmwJrociKGzuDcY5+VKsms1RhsooY+ZX74e2VP6G4GkC3DdbwfzW4qA2YKX90kGu+xBrWagD/ppmDL0XGSEOYF4Od4eT7EmA8J3dr7f2TrgWTL+Afi5J4O/DIjilo6PpJSVt3dTBxbc7OFzbjUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRiDdh8/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRiDdh8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A4E1F000FF;
	Sat, 12 Sep 2026 14:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222017;
	bh=KaS5gHef/z9Vwyyh/bmpOY32PQxcXeHXnGnNAOuzppQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MRiDdh8/d8EbeOyTv4pmWLu5ygm7c+OkjKKd4Kyz9vS7+JTVC1D05g30r/IzpT5oq
	 3TGHePxso1aWcJ8pmGA+tYwCbCnbRW/sA/oIFAE2si4G6bq6sqoilSJr4kn6iGBVEM
	 pMqHiMG4wy8IdGz25llyJHbq+htVtK/QF9OOVQrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao-Qun Huang <alvinhuang0603@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.6 0502/1424] f2fs: reject overlapping move range after len expansion
Date: Sat, 12 Sep 2026 08:48:54 +0200
Message-ID: <20260912065618.532275871@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3018,8 +3018,6 @@ static int f2fs_move_file_range(struct f
 	if (src == dst) {
 		if (pos_in == pos_out)
 			return 0;
-		if (pos_out > pos_in && pos_out < pos_in + len)
-			return -EINVAL;
 	}
 
 	inode_lock(src);
@@ -3045,6 +3043,8 @@ static int f2fs_move_file_range(struct f
 		goto out_unlock;
 	if (len == 0)
 		olen = len = src->i_size - pos_in;
+	if (src == dst && pos_out > pos_in && pos_out < pos_in + len)
+		goto out_unlock;
 	if (pos_in + len == src->i_size)
 		len = ALIGN(src->i_size, F2FS_BLKSIZE) - pos_in;
 	if (len == 0) {


