Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F5DBA3F;
	Mon,  1 Apr 2024 16:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990789; cv=none; b=j6BpEmE6k1EzyfS3qV8QQkmLBoDqLX0oYaFp/sCyeBAIwJFy59oDQJ6CxHIWkKOs/rZ9x+3EJ0ndvw2542vTPirUpv8cJbJ0Lu2C4G1JHS+e+gKdSD0YXyXV8HDbT8/Qqui3Ww3uraCyo+aJHqm+HiSd4zuYKljh/m7YqpI3nYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990789; c=relaxed/simple;
	bh=YZDZhhIF07EP+Wx1/vlvEl/lK0mCE27DiiEPjo1gOQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFekB+REdQfKgXCK+gt85RYm8QvIXySrdCwWv/HDb5gOPtgpTZcdH50c1hWxqjHuRFRXrCZrtBamz3ZNh7vgacN+oMxHsHTqUk8NVpCNszrSnLFGx6yo3YKtgUf45fM8GEqaFtrizz3laSbJbIPbZaY09SXq8VCxkYZEv5gHhDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cPTjtw71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cPTjtw71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6488BC433A6;
	Mon,  1 Apr 2024 16:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990788;
	bh=YZDZhhIF07EP+Wx1/vlvEl/lK0mCE27DiiEPjo1gOQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cPTjtw71uba9JU3SbKK7B95fLM0IJ7hwUQtNfHsZ/JtVzdGVJ7Ry0RvuE+vOQKnLu
	 ck1TqeA0ncXVy2vTYxcaHk3IO/dYGCw7BiXqW9BELoXAwhZtfkhCL0rRTbnW+EcceG
	 6SOrTmIcw/32pPU/+fb5v9+xu3RLmdiB+i2lPsdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio SJ Musumeci <trapexit@spawn.link>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/272] fuse: fix root lookup with nonzero generation
Date: Mon,  1 Apr 2024 17:44:17 +0200
Message-ID: <20240401152532.647589578@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 68ca1b49e430f6534d0774a94147a823e3b8b26e ]

The root inode has a fixed nodeid and generation (1, 0).

Prior to the commit 15db16837a35 ("fuse: fix illegal access to inode with
reused nodeid") generation number on lookup was ignored.  After this commit
lookup with the wrong generation number resulted in the inode being
unhashed.  This is correct for non-root inodes, but replacing the root
inode is wrong and results in weird behavior.

Fix by reverting to the old behavior if ignoring the generation for the
root inode, but issuing a warning in dmesg.

Reported-by: Antonio SJ Musumeci <trapexit@spawn.link>
Closes: https://lore.kernel.org/all/CAOQ4uxhek5ytdN8Yz2tNEOg5ea4NkBb4nk0FGPjPk_9nz-VG3g@mail.gmail.com/
Fixes: 15db16837a35 ("fuse: fix illegal access to inode with reused nodeid")
Cc: <stable@vger.kernel.org> # v5.14
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dir.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 5e408e7ec4c6b..936a24b646cef 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -399,6 +399,10 @@ int fuse_lookup_name(struct super_block *sb, u64 nodeid, const struct qstr *name
 		goto out_put_forget;
 	if (fuse_invalid_attr(&outarg->attr))
 		goto out_put_forget;
+	if (outarg->nodeid == FUSE_ROOT_ID && outarg->generation != 0) {
+		pr_warn_once("root generation should be zero\n");
+		outarg->generation = 0;
+	}
 
 	*inode = fuse_iget(sb, outarg->nodeid, outarg->generation,
 			   &outarg->attr, entry_attr_timeout(outarg),
-- 
2.43.0



