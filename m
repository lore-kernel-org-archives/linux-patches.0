Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F978473C9F;
	Fri,  7 Aug 2026 15:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117270; cv=none; b=Phlp5FKLd8Q/VYl2xi+IAUYQMRmk65mhbQqAMs3VNjvFFdC82rkAaq6KNrcRQgwxrtuBscs8TRnFKdiOfDbb7U1XVu9RJN/khYd1sX8u/6f8Yywbikokk1CbW+acimvMi9wDOWJuiOs6gB6pI8xB9wQVlmc8h6E1CS7gAbj8v1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117270; c=relaxed/simple;
	bh=5VqKy/GRlfIz0mTPpnl508cHjcTsSeQ5oAJ1Na0bah4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D65HRGhcR2vyUSB6ag8udenuj6KUjpESd3X4hz+zuWbxYSPDnfj0lTZ8ROwmlWjjJRSXknWc9I2mJy11JDVEcehfI8xF5i+s4wKw68W0elugBk4ZwiIe6CUdximxTbsruMSae+Fdh11cXUmsIVPXd5SXswb48Pf9q0H8BFL6QMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZOmqspQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZOmqspQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741081F000E9;
	Fri,  7 Aug 2026 15:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117268;
	bh=KYGOpcxhTusdPo4zGmadtsqKyJWf03G4Riyj4LIQ8F4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bZOmqspQLtKFrEV5b3ZGa9U4EhTcJtPRrZavOG+PyEaH5B2qtq+Bi+4tnqB3jma+f
	 aNiL5IvWshSRAYIi/YBl7o1oVq42WMvsX8lf+N8j4EoAsZGzn1zr36Bon39QHG60HI
	 BdZr3EaiPUnIEjjeVzownrj9Fs0RJR/ZUESYbvV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 214/438] ocfs2: fix boundary check in ocfs2_check_dir_entry() to use buffer offset
Date: Fri,  7 Aug 2026 16:36:50 +0200
Message-ID: <20260807143432.573206296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

commit df8ce7ab48d01ac4f247599b35f0506d95ff57e1 upstream.

Commit 390ac56cf0f6 ("ocfs2: add boundary check to
ocfs2_check_dir_entry()") added an out-of-bounds guard using the
caller-supplied 'offset' argument:

	if (offset > size - OCFS2_DIR_REC_LEN(1))
		return 0;

However, 'offset' and 'size' are not measured against the same base for
all callers.  In the block-based lookup path, ocfs2_find_entry_el() passes
'offset' as an absolute offset into the whole directory:

	i = ocfs2_search_dirblock(bh, dir, name, namelen,
				  block << sb->s_blocksize_bits,
				  bh->b_data, sb->s_blocksize, res_dir);

while 'size' is a single block size (sb->s_blocksize).  For any directory
entry located in the second or later block, 'offset' is >=
sb->s_blocksize, so the guard rejects every such entry even though it is
perfectly valid and lies entirely within its block buffer.

This makes mounting fail for filesystems whose system directory spans more
than one block, e.g.  a volume formatted with a small block size:

  mkfs.ocfs2 -b 512 -C 4096 -N 2 -T datafiles --fs-features=usrquota,grpquota

  ocfs2_check_dir_entry:314 ERROR: directory entry (#18: offset=512) too close to end or out-of-bounds
  ocfs2_init_local_system_inodes:496 ERROR: status=-22, sysfile=12, slot=0
  ocfs2_mount_volume:1757 ERROR: status = -22

The dirent's position within the buffer being validated is ((char *)de -
buf), which is what the rest of the function already uses (via
next_offset) and what must be bounds-checked against 'size'.  Compute that
buffer-relative offset and use it for the guard.  The subtraction is
reordered to size - buf_offset < OCFS2_DIR_REC_LEN(1) to avoid an unsigned
underflow when size is smaller than the minimal record length.

Link: https://lore.kernel.org/20260710040512.3310736-1-joseph.qi@linux.alibaba.com
Fixes: 390ac56cf0f6 ("ocfs2: add boundary check to ocfs2_check_dir_entry()")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Dmitry Antipov <dmantipov@yandex.ru>
Tested-by: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/dir.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -302,10 +302,11 @@ static int ocfs2_check_dir_entry(struct
 				 unsigned long offset)
 {
 	const char *error_msg = NULL;
+	unsigned long buf_offset = (char *)de - buf;
 	unsigned long next_offset;
 	int rlen;
 
-	if (offset > size - OCFS2_DIR_REC_LEN(1)) {
+	if (buf_offset > size || size - buf_offset < OCFS2_DIR_REC_LEN(1)) {
 		/* Dirent is (maybe partially) beyond the buffer
 		 * boundaries so touching 'de' members is unsafe.
 		 */
@@ -316,7 +317,7 @@ static int ocfs2_check_dir_entry(struct
 	}
 
 	rlen = le16_to_cpu(de->rec_len);
-	next_offset = ((char *) de - buf) + rlen;
+	next_offset = buf_offset + rlen;
 
 	if (unlikely(rlen < OCFS2_DIR_REC_LEN(1)))
 		error_msg = "rec_len is smaller than minimal";


