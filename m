Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B311258A;
	Tue, 26 Aug 2025 13:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216437; cv=none; b=MacQ9F2bbL2k94UcMhwpAFDdCdbyb9bovv2bRKtqYJTz56JtMqi1hTy017x4SnHGthviNAO++hrHSZj6CmsTNLbtqB1//7lPU9t/VwWw5wK05+0N/Prc/yy1WoqpkLi4oruWMQgQHKTB+JRLjTdEnmyFh/cLwfQirv9k3CNJGBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216437; c=relaxed/simple;
	bh=Y/9VjIpaAvV6bQmgdgmyYDdtffqIAizN+RPnj1kE4mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fd9wk2hdTFic/qxjMPquFNnjBYcUCQzjMPi3YnM7qt29cWVgrSOc4itHAe0MdsrvaEklBngqG/ZWs/zw9v97g3sWJPuQl1PYlAEelZnwvQcSmcUYWrUo0UJlZIeM2LqiE1Wop6AE3o7mlX+iWUxW2+P8keUqzJL9n8XVTgbsFg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UmJD3Bt1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UmJD3Bt1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2E1C4CEF1;
	Tue, 26 Aug 2025 13:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216437;
	bh=Y/9VjIpaAvV6bQmgdgmyYDdtffqIAizN+RPnj1kE4mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UmJD3Bt1qMcF5mEo2tD/h+67KN36xyFhYiDAPxTZWM1zmEvweqsD18LtMwSCbdgCA
	 kbhlYCO19EKzMfsd+TYgNyhMMwXeIFZ66U5K9XO+V+sOTy6uQB18TPtT4OXmRUJFm0
	 aPpfdrF+/rJJdriu8mVA/zUz6VJ/4e7i+aQQjxVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+630f6d40b3ccabc8e96e@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 394/644] jfs: Regular file corruption check
Date: Tue, 26 Aug 2025 13:08:05 +0200
Message-ID: <20250826110956.212674820@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1d732fd223d4..5c28883eee4e 100644
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



