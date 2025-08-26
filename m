Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66451A5BBC;
	Tue, 26 Aug 2025 12:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213137; cv=none; b=Idfc/CjRLJISDwJHwQ0npGOtqd+hsps77P7rnwwescsiGygNDP14xG9IMfEvrTPqnGU6Af9pUVKUb6YCu8tVxWKOzlchIGYiHOUXO7XE2fjG45YUC1PIcBH0SjMFf/JXJ6aWW9VOuyLaW6Z45EXpz7Vq9Kbo2bwqy9F/WamXjBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213137; c=relaxed/simple;
	bh=tPJbIhB/0FUUDWpXX2Q4Ib0rIjAcHjH51E/VqPwokBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ubllqi//ppmFHXVr8fTSRbLaDh40wlnyxCXxLmE4mL3mwCi2Cgggq71U8mogKuODgwDaqzwX4fzflEfWvEzvyTEhEo07EaPHYhtgYxnQ1udtIZajHPvUUF6nERVoSQ7K4ubN/jLDSF+jmF4VvztP/ic5a8m92tidTx+yLORPaa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jo3Ld28u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jo3Ld28u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C078C4CEF1;
	Tue, 26 Aug 2025 12:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213137;
	bh=tPJbIhB/0FUUDWpXX2Q4Ib0rIjAcHjH51E/VqPwokBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jo3Ld28uR+mIlEhS5TDSOhnw4jd79s0VRAgN+zacnraXEbEIqYKKD6lQVdQU1a1a+
	 qU7D/TiUij3FIbGA0MAeoftJUyYmSlYh1ya6kFFJtN1/JfE3RfXfuS5vxR2EATUEvk
	 rK7Q9DbjzdzTJb0ZHn2VZjNr+wvjRqpFXctDkD4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+630f6d40b3ccabc8e96e@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 236/587] jfs: Regular file corruption check
Date: Tue, 26 Aug 2025 13:06:25 +0200
Message-ID: <20250826110958.937624776@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 2d04df8116426b6c7b9f8b9b371250f666a2a2fb ]

The reproducer builds a corrupted file on disk with a negative i_size value.
Add a check when opening this file to avoid subsequent operation failures.

Reported-by: syzbot+630f6d40b3ccabc8e96e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=630f6d40b3ccabc8e96e
Tested-by: syzbot+630f6d40b3ccabc8e96e@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/jfs/file.c b/fs/jfs/file.c
index 01b6912e60f8..742cadd1f37e 100644
--- a/fs/jfs/file.c
+++ b/fs/jfs/file.c
@@ -44,6 +44,9 @@ static int jfs_open(struct inode *inode, struct file *file)
 {
 	int rc;
 
+	if (S_ISREG(inode->i_mode) && inode->i_size < 0)
+		return -EIO;
+
 	if ((rc = dquot_file_open(inode, file)))
 		return rc;
 
-- 
2.39.5



