Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B95720CCE4;
	Tue, 17 Jun 2025 16:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176680; cv=none; b=YXgKlZhemhB56eGhEF2Qo9iASv8zKeeSlWvPZWPOmmsMw82/fnrHCtB1cSux0jDbN9JSLBGV/edCQvB+BMT50CwFraSQZfqEIO4H7l4J5i3ScDhclb/9TJBXB2WCwi2pnWxJNAm4QNnkurdGKrjcI1MjVY6X9mhLeDYwi/zmlL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176680; c=relaxed/simple;
	bh=gqsGsbqBP40m91G3wvVh9uvMgfDyEx1In/8d+g14I08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQ5krcZ6m1rfIh470GdUi4M7iGyd6N9WhZVYiGkNGdjkkbH3NcYvn0u+9aGgaXBOBfd0S5wxiUaF/4suJXQoyieUoPm9EmAZVHPhrkR50Jsw1oaTcDQpcMA2v9Clmig9W1X+lQdsWVR9H7QM4Ox4T+QJY3UAK5QJjVtiwku9Ga0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pk18M+wy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pk18M+wy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8697C4CEE3;
	Tue, 17 Jun 2025 16:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176680;
	bh=gqsGsbqBP40m91G3wvVh9uvMgfDyEx1In/8d+g14I08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pk18M+wyPaE9Tn+8MJJrKjgv9TEySPF+YGlzv3HF3jU+cKV8siOnKBnMz+GYjGONN
	 lmU8S70YPEcg90sz+ZxLBzys+C0guybU86yKqaoimtAwkb8bDvL5Vcr8U7QBGBzbtJ
	 rfso31B71YXxjlhP7x3VuG2dbmcFED941kIxVgSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 253/512] nilfs2: add pointer check for nilfs_direct_propagate()
Date: Tue, 17 Jun 2025 17:23:39 +0200
Message-ID: <20250617152429.852412009@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit f43f02429295486059605997bc43803527d69791 ]

Patch series "nilfs2: improve sanity checks in dirty state propagation".

This fixes one missed check for block mapping anomalies and one improper
return of an error code during a preparation step for log writing, thereby
improving checking for filesystem corruption on writeback.

This patch (of 2):

In nilfs_direct_propagate(), the printer get from nilfs_direct_get_ptr()
need to be checked to ensure it is not an invalid pointer.

If the pointer value obtained by nilfs_direct_get_ptr() is
NILFS_BMAP_INVALID_PTR, means that the metadata (in this case, i_bmap in
the nilfs_inode_info struct) that should point to the data block at the
buffer head of the argument is corrupted and the data block is orphaned,
meaning that the file system has lost consistency.

Add a value check and return -EINVAL when it is an invalid pointer.

Link: https://lkml.kernel.org/r/20250428173808.6452-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20250428173808.6452-2-konishi.ryusuke@gmail.com
Fixes: 36a580eb489f ("nilfs2: direct block mapping")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/direct.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index 893ab36824cc2..2d8dc6b35b547 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -273,6 +273,9 @@ static int nilfs_direct_propagate(struct nilfs_bmap *bmap,
 	dat = nilfs_bmap_get_dat(bmap);
 	key = nilfs_bmap_data_get_key(bmap, bh);
 	ptr = nilfs_direct_get_ptr(bmap, key);
+	if (ptr == NILFS_BMAP_INVALID_PTR)
+		return -EINVAL;
+
 	if (!buffer_nilfs_volatile(bh)) {
 		oldreq.pr_entry_nr = ptr;
 		newreq.pr_entry_nr = ptr;
-- 
2.39.5



