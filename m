Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE2424A066;
	Tue, 26 Aug 2025 13:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214651; cv=none; b=u5U962L4ungTz3iu3qmmn5X07SgEmb6u/d/ULNla3opqNJ/uKTmi397VfAG7YJ84rJSFxYojr3ZH6VZ7PoOxdQiHT2IpgSTrmZKjUclxcSFgARtrn0fJRMzFjR7hI00wj6pyuIkRkKCT4iZnzbvKoH9lwinvgiaCguQkuLfEz6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214651; c=relaxed/simple;
	bh=J9nzJCqI6+pPpZniKhjHUswECYoU9SDpNosCkAAfrto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGE2t+bI7RaF7G4NvrHZFV1jKWq2bBHfmkeU1VDLmOp4FH+BHEpUqaV4yVkQfyw9otYF0mzCiznDbchw6zXIhDP/UWaGwNRjJte/9ta0amW1JlVzSvO9394knc5iZqm4pzjL8Nw9tApR7tt6NkR15sZKmKMG1kmJSdpn83OOTjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AV4gT56t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AV4gT56t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DFF3C4CEF1;
	Tue, 26 Aug 2025 13:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214651;
	bh=J9nzJCqI6+pPpZniKhjHUswECYoU9SDpNosCkAAfrto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AV4gT56tA106oRPgi91/+u1FmqL2SW6fCIJ6iHTOueD43P6S2QYWi+C1rk/58kqA6
	 zfoPZuwjQXHn/gKqKAGAr5vB5PKJpCx+07amTQ7dp9pZIBR77/C0HhuNtn7Q18VToi
	 5lp/tI/765+rsL6BfATwEq4u9arW8iJkVuoDQDEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+630f6d40b3ccabc8e96e@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 187/482] jfs: Regular file corruption check
Date: Tue, 26 Aug 2025 13:07:20 +0200
Message-ID: <20250826110935.424730020@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 332dc9ac47a9..ae8df3d11663 100644
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



