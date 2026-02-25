Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2249B2C11CF;
	Wed, 25 Feb 2026 06:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002554; cv=none; b=hlQeB8zF93bg5kciwA159eNq1mBorA4AbMWn1rZioIUWrfm7wz9MsPZ9Y5CkUXkVmMK/EFO3u1plZqRfNdkp3BQ7uif3H4xrrk0gaBSQH6jS6+93ftbi3CG/dB2OBUl20blwAYgaCrGdIbbbqOiKDInDLRFTWzxwGuj5Y7ZJjLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002554; c=relaxed/simple;
	bh=MccGiM1Y3ooODc4bUXvkG7hKbNyuwhgRUrJr8O6+Vls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0jlW8R+qUXRZvtES2VDDlvzN46kivRsyLqNEEUNxzZdai7pwwKMjjp072GutNfgHsOWxI13iZA7Pd6axQ1r6dpFlVoMocdvjpaVDvywxbl5anqoeHHFqxFMxlGe0MxcsrEph+Vec5u2XD1HMrf+vMnH2/BT04hdDMFcZQ9NAcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nmTA4I/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmTA4I/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6A3C116D0;
	Wed, 25 Feb 2026 06:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002553;
	bh=MccGiM1Y3ooODc4bUXvkG7hKbNyuwhgRUrJr8O6+Vls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nmTA4I/5ua5iwzLmyW+O5p7zVVOh7MkXdTV3hDk5vF4of8Wc3Gi3hyV6Y3tqHuC+1
	 UO1cjoFkiM6L+NP3eT8JcWSt7logn9LjVuIt/fBitxuKySq52ImQcTweqdwzSMTLZ3
	 pa5M1XPXbticlcSuZYdookChOYIZTfIXsC1XZ4uM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 293/641] jfs: avoid -Wtautological-constant-out-of-range-compare warning
Date: Tue, 24 Feb 2026 17:20:19 -0800
Message-ID: <20260225012355.852572709@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



