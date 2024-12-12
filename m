Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF29322331C;
	Thu, 12 Dec 2024 17:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023341; cv=none; b=XZs64ghhjHlQlOX8RZN4pyAPgkhxdAeKPEp8OkpRLhJmpPfwebokM1sCrOyg3Zxy+5apvYiRqgsXwmH/RRg7mjVmyld8mIySZITJhWcKwzrM19vOesDVTOvwy3XaK7vm7V7EaJZIW8M8HM5SZvbwPJA6GNhVIdMz8fmfyS/aikI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023341; c=relaxed/simple;
	bh=rnnJz8i6AYDzY6hphUFjH3s+x25r9WsiCQBP1/AX1PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jf551TZ1VMsosDLwP0WYtfpH+4+0L60AaNU0L7HbbXrag0Rtp0W4M3/4xiuND86Iwr0mtS9OqGBEXzYns5o1LjGq4DahhAWUe9NdGAICxFL6vVVRcQTE2sQ10xBPuAHUbVMp6SMIg9Y/CpjCWmu3WMamRkmE+OKLMU/iPEiAzhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnFemHKe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnFemHKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788E6C4CECE;
	Thu, 12 Dec 2024 17:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023340;
	bh=rnnJz8i6AYDzY6hphUFjH3s+x25r9WsiCQBP1/AX1PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AnFemHKeqJR8MR8RfvkJL8+zQplEynqfQs7HzxW5mAytYVetLuQfecgDqli+U1DSO
	 1iWoQTBszFokTRU4YgF5XqVHNMzXQEKFJrQ+bGf/67pj4E/OnSU9xxXFCDDCn2vY72
	 htu0ZfiHJBbON3HNMHE7dNijogwweDsQ8S1ZNb4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+412dea214d8baa3f7483@syzkaller.appspotmail.com,
	Nihar Chaithanya <niharchaithanya@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 502/565] jfs: add a check to prevent array-index-out-of-bounds in dbAdjTree
Date: Thu, 12 Dec 2024 16:01:37 +0100
Message-ID: <20241212144331.607827076@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Nihar Chaithanya <niharchaithanya@gmail.com>

[ Upstream commit a174706ba4dad895c40b1d2277bade16dfacdcd9 ]

When the value of lp is 0 at the beginning of the for loop, it will
become negative in the next assignment and we should bail out.

Reported-by: syzbot+412dea214d8baa3f7483@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=412dea214d8baa3f7483
Tested-by: syzbot+412dea214d8baa3f7483@syzkaller.appspotmail.com
Signed-off-by: Nihar Chaithanya <niharchaithanya@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 7486c79a5058b..e6cbe4c982c58 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -2957,6 +2957,9 @@ static void dbAdjTree(dmtree_t *tp, int leafno, int newval, bool is_ctl)
 	/* bubble the new value up the tree as required.
 	 */
 	for (k = 0; k < le32_to_cpu(tp->dmt_height); k++) {
+		if (lp == 0)
+			break;
+
 		/* get the index of the first leaf of the 4 leaf
 		 * group containing the specified leaf (leafno).
 		 */
-- 
2.43.0



