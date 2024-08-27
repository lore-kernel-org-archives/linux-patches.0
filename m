Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281EF1C68A6;
	Tue, 27 Aug 2024 15:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771986; cv=none; b=LQnuiFocbZfTbUz8t4EmaVA0ogAAzVhDSy9snU7iKei6KuqWcHKV6YdKZFUXUJnb0jkvekDwQyB7vVM534EbMPjL8qDksCYWWzTFn+TBMUcQk04d+HPRddD95Y2IChWuBjnxlfacJShtYN+vdtmKp50MErwvLRuQY7JuqLCpfLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771986; c=relaxed/simple;
	bh=fag7Wkf2pDKMJkJegEgDpMjSjdqX0LhXt+02/F8ZDPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbNh6a6D4uquX001Z/us+YVBRXcjVh72x7SYuZ1XRbzQEvI/CsYlaN5Um2cNiwXdL93BSK4lgSO0oouuRhXsM4TF3vntwAkX3mr0i/HMcXtDxMu73ZM0QY6Lxk88A15n/gFJjbQ48oWXJUjPeqTZyv/r8RTqg4XWOSXsqCRhWcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yo58n7aH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yo58n7aH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8497BC4AF68;
	Tue, 27 Aug 2024 15:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771986;
	bh=fag7Wkf2pDKMJkJegEgDpMjSjdqX0LhXt+02/F8ZDPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yo58n7aHaJS3j7QapDZS8M48zXtFoYsLJW+1pU6djSYYT3Ljxd57NLGz7nROjB2X8
	 D352qjYi1TQbEc5Vcz52a1BfHN7rwCyZP6sNCMHyKaSVTbCQ1mTbeDqC/gDhAaO5Yq
	 aufu/wHxDKqdB73vurrjkyIUA+oTuXPD6iaEMCHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+61be3359d2ee3467e7e4@syzkaller.appspotmail.com,
	Pei Li <peili.dev@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/321] jfs: Fix shift-out-of-bounds in dbDiscardAG
Date: Tue, 27 Aug 2024 16:36:28 +0200
Message-ID: <20240827143841.287064665@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Pei Li <peili.dev@gmail.com>

[ Upstream commit 7063b80268e2593e58bee8a8d709c2f3ff93e2f2 ]

When searching for the next smaller log2 block, BLKSTOL2() returned 0,
causing shift exponent -1 to be negative.

This patch fixes the issue by exiting the loop directly when negative
shift is found.

Reported-by: syzbot+61be3359d2ee3467e7e4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=61be3359d2ee3467e7e4
Signed-off-by: Pei Li <peili.dev@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 8d064c9e9605d..7a3f4f62c34bc 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -1626,6 +1626,8 @@ s64 dbDiscardAG(struct inode *ip, int agno, s64 minlen)
 		} else if (rc == -ENOSPC) {
 			/* search for next smaller log2 block */
 			l2nb = BLKSTOL2(nblocks) - 1;
+			if (unlikely(l2nb < 0))
+				break;
 			nblocks = 1LL << l2nb;
 		} else {
 			/* Trim any already allocated blocks */
-- 
2.43.0



