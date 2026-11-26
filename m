Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704488;
	b=zfjPdJvrCEZorrpnbCeEvT/EFRJdhXLyKoL2SwqFKFw0oOvdvJdV/Pj6l9IVn73wViEK
	 E7Y1hRe5Gxrk9ZiIJvquenizbvHtcTpWROv6CLmQG+0aUs9aS4PIxPaD6OXVJfRCMj6o1
	 X0W7SVpe1l/ARQw7ARn/RWNcQp5vknVBBOynYWFPDG0EtxCXmvkA3iQT91XZ7VUhnwssy
	 RiF8A8IU3u1UOxxSe7WlTn/uedxqVChGsHs7EeoTnmg2HCXGHVSbB+I8dtoCmDAy1aspm
	 Hhg7FlMrfR6nAzRwqCAR0kYAgFokDUcVGognRxKAMRJ73bwzgxe4YcUh+LEMbscqd9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704488;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rFCKDg25gxI7qUpo4Hw2vlddGdxf4ndWx0yJ2TnTXKM=;
	b=fU1Chkepwb1fj84mrWoylRZb4ZcQTrHRVw0wjCvNPMPX/dkmxyV4B8a4IOxGlkRKu6Cx
	 g8weidv+w49NF42xatdUv16mtM+pLv2eIHKeyHM1kUr35eXQMCvlo0W2ixrcDZ3+8EKjT
	 zpSgHbaBCb5bc9jAHS9uaV4c2BhwxMu97Q0yBObhTytqDGBtmNr18lPsX6GuJA9yoDWlc
	 lFpJONQ55zzPzKVmx9hSvCrvJ7tc09lde5RWeAUpWW+uZrfCYVx677X7HuOkKhc6Er1dE
	 keQdaOo3JsFwAvId2p0wcQTKVuQVirxaNs5YBLxEs7YReZeum2EmRROgg7fD1smYX/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P8jCXX0u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209BD606A33C;
	Thu, 26 Nov 2026 14:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P8jCXX0u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE46C1F000D1;
	Thu, 26 Nov 2026 14:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704487;
	bh=rFCKDg25gxI7qUpo4Hw2vlddGdxf4ndWx0yJ2TnTXKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P8jCXX0uF2KySSOKrlhXhN9zQaZfYk2DRwUfbFJ/e5K0DfoSrCDjo01QCqubFzkh6
	 J2/TdEqrdTXqQl7YvieF8Da0Smq5BM8tXEktQmDWQOs0EbWx+aIbWNL+Q5feh5ucuR
	 qqFQSw8yH1szypDuZEPkAi4KEoqKY33drsnOdc0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Chintamaneni <sidchintamaneni@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/265] fs: reject negative offsets for SEEK_DATA and SEEK_HOLE in default_llseek()
Date: Thu, 26 Nov 2026 15:37:07 +0100
Message-ID: <20261126143611.759582348@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1a450f569e80f..0411034a32b10 100644
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



