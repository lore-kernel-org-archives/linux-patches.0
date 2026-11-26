Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705204;
	b=NkdI/cCoiOXICSdXvv6GSVRMezgnWYZjpmXQQn1r8lMYpWux1+CcaEYhCwHKhxapFJEc
	 lqjQwuEYbNvO9ObjWoT6Br4UBqbrvKNDTkAePp7uHbjLmxcEqrI/4ImZEVRIUhxKZf6WH
	 gbLJYhaiwkCBMtnljjy8ArnetLOe85KQIo2H3IP33dYRfRbRAI8/uvXjPMan26eHPyDIs
	 RlLlShv9W0bzNhHeBCLjnLHS0gyt5eIntXYmN1J2aY7/A6X2gsqHeLT1QiiNk7+EPQRyG
	 jlIbCgVePHTeT1/TVeRDIZ9EPi+N8d/GwlzcuaW82gcTWfJQ7AIBOJKOuxbTGEbaTFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705204;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4gyXlwd/zrlccYLePB5N5AudxEWtiaN8UPPz+Ym/atQ=;
	b=LfrlWEQEqWfkaZ1R+z0go+OA8oCwhlu36f3/Fycj35Ko0dkzoq+2jbZ63FFdCR/YpA/u
	 P47htM25dzvo1or7sS+4ISXNaq9icMXzCPAhJo257mQx9Xd4VPGZKH0hP0razN0D1EbB0
	 KBs1BvtOg5JZJs20Fo1kG3eGo20va6MKGtbgJIClDheW+cHXUJg+z/UVjg4U2g08cVkBZ
	 UKfoJEXlLy8l7hgI4c98WySrXwCfnlTw79bnQoCVm99kh6q5PwthWifeT2y4xlGuNOzlR
	 bkN2Y84NmRFtqUb7heQhJwQC/D8rGKlZy9yF05eeAA/qty/FeWlTRkkz7lq0EdAQUUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0J/5uEnn";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BA1606A32E;
	Thu, 26 Nov 2026 15:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0J/5uEnn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B631F000C6;
	Thu, 26 Nov 2026 15:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705203;
	bh=4gyXlwd/zrlccYLePB5N5AudxEWtiaN8UPPz+Ym/atQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0J/5uEnn09OwQGGxzUxtn29s6/umsjx82QY9NH+7wsWMKgmjo4LYBSUACo4Hxb1/V
	 jEeSpiBvMapxNPE97Aw0HXx/YP0kz4RpSNnd1yK+wiKL2N0gBhfeVLjem9ak/H8HIq
	 Dzwh9McTXOFzlTfMptVWULFSLWEJzRhRggCpTKDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Chintamaneni <sidchintamaneni@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/319] fs: reject negative offsets for SEEK_DATA and SEEK_HOLE in default_llseek()
Date: Thu, 26 Nov 2026 15:38:05 +0100
Message-ID: <20261126144009.386971888@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>

[ Upstream commit 7a5783cfac71b3c12e7fb1c2894dd4538d57d513 ]

In default_llseek(), the range checks for SEEK_DATA and SEEK_HOLE compare
the signed loff_t offset directly against inode->i_size:

	if (offset >= inode->i_size) {
		retval = -ENXIO;
		goto out;
	}

When a negative offset is supplied to SEEK_HOLE (e.g. lseek(fd, -10,
SEEK_HOLE) on a sysctl file in /proc/sys), the signed comparison evaluates
to false and execution proceeds to:

	offset = inode->i_size;

This overwrites the negative offset with a non-negative value before the
final `if (offset >= 0 || unsigned_offsets(file))` check, causing
default_llseek() to update file->f_pos and return inode->i_size instead of
failing with -ENXIO. Similarly, for SEEK_DATA on a file with
FOP_UNSIGNED_OFFSET, a negative offset bypasses the range check and
succeeds via unsigned_offsets(file).

Read the inode size once via i_size_read(inode) after acquiring the inode
lock and compare (unsigned long long)offset >= eof for both SEEK_DATA and
SEEK_HOLE, matching must_set_pos().

Fixes: 982d816581ee ("fs: add SEEK_HOLE and SEEK_DATA flags")
Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Link: https://patch.msgid.link/20261101060049.81441-2-sidchintamaneni@gmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/read_write.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 8bcba645fdf6c..87862c1273954 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -237,13 +237,15 @@ loff_t default_llseek(struct file *file, loff_t offset, int whence)
 {
 	struct inode *inode = file_inode(file);
 	loff_t retval;
+	loff_t eof;
 
 	retval = inode_lock_killable(inode);
 	if (retval)
 		return retval;
+	eof = i_size_read(inode);
 	switch (whence) {
 		case SEEK_END:
-			offset += i_size_read(inode);
+			offset += eof;
 			break;
 		case SEEK_CUR:
 			if (offset == 0) {
@@ -258,7 +260,7 @@ loff_t default_llseek(struct file *file, loff_t offset, int whence)
 			 * long as offset isn't at the end of the file then the
 			 * offset is data.
 			 */
-			if (offset >= inode->i_size) {
+			if ((unsigned long long)offset >= eof) {
 				retval = -ENXIO;
 				goto out;
 			}
@@ -269,11 +271,11 @@ loff_t default_llseek(struct file *file, loff_t offset, int whence)
 			 * as long as offset isn't i_size or larger, return
 			 * i_size.
 			 */
-			if (offset >= inode->i_size) {
+			if ((unsigned long long)offset >= eof) {
 				retval = -ENXIO;
 				goto out;
 			}
-			offset = inode->i_size;
+			offset = eof;
 			break;
 	}
 	retval = -EINVAL;
-- 
2.53.0



