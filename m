Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAB4348862;
	Tue, 16 Dec 2025 11:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885138; cv=none; b=kq6pa6c9cKdDqYjONuJkAc9gdp7hNVZ9dSn5+Q5pkBrnO8lcbT36gGEJPb2mgqk45h28elT8dhNReBAMymMv4Mv7ohszUMJAasBXZcNMgEQnlbooACwGlGEkjk8sc0QFMA7Fjq4kqSv/+sqfmRctN6CwQbqDpBcLve6yvP+m63w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885138; c=relaxed/simple;
	bh=/Kjk4TLMsfyVzcOvsUoD4XI+GgVouy4cyEn+M73BAeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QvYOQJT3xZn4aqTWFKuciYcKmf9p5sGYnlK0qHgCh5CV8ArtncPCalXrD3khicajhvkU+u9YbZtMrX8f6TLfrW3A0Mc9hCtv4XnGX+x2Ew3HPcAk8JUJucQAEVCxAFbEeGKdjVK7qXJx0sFl68lm3J7aBjnhMijAnhem6vFsyuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJkMq023; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJkMq023"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40AFC4CEF5;
	Tue, 16 Dec 2025 11:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885138;
	bh=/Kjk4TLMsfyVzcOvsUoD4XI+GgVouy4cyEn+M73BAeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJkMq023d/LkWIC6Y5imdsyayC2eu45Rsx+UXA58/W7+uHv3rL9yDSl9nFvxYZy7o
	 mQlL2iDj3C5Tx68WRn04fL3uQjHBa7ynHEUxSimCjBPhvagBr96xzyG+0SMz3TLTrc
	 JOllt5tJpSWze9CKlE4dXdyvOogKVyCNzI4WlknU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+332bd4e9d148f11a87dc@syzkaller.appspotmail.com,
	Sidharth Seela <sidharthseela@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 049/507] ntfs3: Fix uninit buffer allocated by __getname()
Date: Tue, 16 Dec 2025 12:08:10 +0100
Message-ID: <20251216111347.320635789@linuxfoundation.org>
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

From: Sidharth Seela <sidharthseela@gmail.com>

[ Upstream commit 9948dcb2f7b5a1bf8e8710eafaf6016e00be3ad6 ]

Fix uninit errors caused after buffer allocation given to 'de'; by
initializing the buffer with zeroes. The fix was found by using KMSAN.

Reported-by: syzbot+332bd4e9d148f11a87dc@syzkaller.appspotmail.com
Fixes: 78ab59fee07f2 ("fs/ntfs3: Rework file operations")
Signed-off-by: Sidharth Seela <sidharthseela@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index b08b009121653..cf7e869fdc40c 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1717,6 +1717,7 @@ int ntfs_link_inode(struct inode *inode, struct dentry *dentry)
 	de = __getname();
 	if (!de)
 		return -ENOMEM;
+	memset(de, 0, PATH_MAX);
 
 	/* Mark rw ntfs as dirty. It will be cleared at umount. */
 	ntfs_set_state(sbi, NTFS_DIRTY_DIRTY);
-- 
2.51.0



