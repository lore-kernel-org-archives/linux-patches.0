Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06AAF18DB2A;
	Wed, 25 Feb 2026 01:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983245; cv=none; b=ZMMvEc4oEMqN7OmTD0RZgbBBbs7tUuxjhWdU1zi8V5Y+cixj3F8+HWUgcOV2uzpdMLf7yRGo6rx03oI4S0kCn29TW3D+OLZuK48cK1FmP9euCvKYo7d5cS4Fx4YrQ2hkpNV09wqNZAmf450z1tyGcA3MR5axmz60ELZCc6AMoe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983245; c=relaxed/simple;
	bh=F04mM+yveI+io+D/sUZCpIPLjHl/y7gIp58pDJ7aQPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDO+fTnQ1CoAASkZKqBTwdri8nB3G53C7/WYqEf3EaGT73DK7Q9eZE1SepuUSg1tyD79Pi3kM8rrpwbfq3gL8qEGeOmIOy4M0V3CNey8CcXXJFAuzkn23i9EZfr+4mIQeJrMI4aOMC8xOuu+stGFzyQGgBCRBlPgZ+F4dw3vnZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mQN1KpND; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQN1KpND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A31C116D0;
	Wed, 25 Feb 2026 01:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983244;
	bh=F04mM+yveI+io+D/sUZCpIPLjHl/y7gIp58pDJ7aQPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mQN1KpNDGQfYYOg97TOArFuKfuGkXSN+l+FOKEQQTzvnATx7P/T3o3zmyRePiOlKe
	 +uGGoJk/W7GXfHfQ+wTEGPQyujXc041Ydrt3vDOLv5JQKnyeU4+FpV2XcNDthhIzgI
	 hpVIu4+11gCKhDL1xjFZw2dr6GD4q31un7UKFlR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 385/781] jfs: avoid -Wtautological-constant-out-of-range-compare warning
Date: Tue, 24 Feb 2026 17:18:14 -0800
Message-ID: <20260225012409.138952079@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 7833570dae833028337bb53b7f389825b910c100 ]

A recent change for the range check started triggering a clang warning:

fs/jfs/jfs_dtree.c:2906:31: error: result of comparison of constant 128 with expression of type 's8' (aka 'signed char') is always false [-Werror,-Wtautological-constant-out-of-range-compare]
 2906 |                         if (stbl[i] < 0 || stbl[i] >= DTPAGEMAXSLOT) {
      |                                            ~~~~~~~ ^  ~~~~~~~~~~~~~
fs/jfs/jfs_dtree.c:3111:30: error: result of comparison of constant 128 with expression of type 's8' (aka 'signed char') is always false [-Werror,-Wtautological-constant-out-of-range-compare]
 3111 |                 if (stbl[0] < 0 || stbl[0] >= DTPAGEMAXSLOT) {
      |                                    ~~~~~~~ ^  ~~~~~~~~~~~~~

Both the old and the new check were useless, but the previous version
apparently did not lead to the warning.

Remove the extraneous range check for simplicity.

Fixes: cafc6679824a ("jfs: replace hardcoded magic number with DTPAGEMAXSLOT constant")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dtree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index 0ab83bb7bbdf9..9ab3f2fc61d17 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -2903,7 +2903,7 @@ int jfs_readdir(struct file *file, struct dir_context *ctx)
 		stbl = DT_GETSTBL(p);
 
 		for (i = index; i < p->header.nextindex; i++) {
-			if (stbl[i] < 0 || stbl[i] >= DTPAGEMAXSLOT) {
+			if (stbl[i] < 0) {
 				jfs_err("JFS: Invalid stbl[%d] = %d for inode %ld, block = %lld",
 					i, stbl[i], (long)ip->i_ino, (long long)bn);
 				free_page(dirent_buf);
@@ -3108,7 +3108,7 @@ static int dtReadFirst(struct inode *ip, struct btstack * btstack)
 		/* get the leftmost entry */
 		stbl = DT_GETSTBL(p);
 
-		if (stbl[0] < 0 || stbl[0] >= DTPAGEMAXSLOT) {
+		if (stbl[0] < 0) {
 			DT_PUTPAGE(mp);
 			jfs_error(ip->i_sb, "stbl[0] out of bound\n");
 			return -EIO;
-- 
2.51.0



