Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052166;
	b=Z0hUkij1P5DoX0ZyJCHJZCJ/HcFSAEhSCD+33VU9s669PXtntT//8mPESSojDV75NKqX
	 Glkg+p51fNMX9wsQxIulCuBLUTvZyZfhdjSrqq5co166feCAVX+PDi/P9fj/W3QA6OYTg
	 njkh2DRFNpLe/aLQlJ1o0CliutjRk0gp+u8MUazyv5MfjwUZWs0kXWUHdehN/9FLe38Mz
	 XRTxW27Ox548kvVLIlI/r3u2F/J9Q0Q+JlYDiqH0NS78kDJWHtvXKEmUarJLWJ708+oSP
	 mqvw+o0qIIWsvly0w3UJOkonvA7nO1vK7CopWK0xvETdLGSyltmptU27HI4yA6Ezt9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052166;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n84PKhBZpZpOpR9WRmY67jq5FH94MSUxjU9C8PIITNY=;
	b=o6DBQYKMeHx2qSX9VSzDMr+WokyIPDawQCfMjXe9Sdfta3k1eBjayQZXN8VcRgg1IILh
	 dgZ84Im4qdESq0jDa3efzsoxGh9fGJbYgAsDN8ur1MYVrTc/yswl5CH4ka89vKvVDYXGz
	 piY0ZBCddH6PMQceE+NaNJJfGgJieSkS3rkKQQLVsjPbm508fnNz/URfhSbnAwoV9M2n7
	 v7jTrLQPO4kep+PDqC1/+PsXP9vkjRq2mstG0BYsmVPpjSJ3LQyFvuH6LF9SgHKDxxviZ
	 kiCs0RqrfTHC59B78zSnNWBSNhXyPBDoNDEYr82knyZpdnKuAsK/Sdf+kU/DTdFK1xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oHo5tSN0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762F9606A31C;
	Thu, 19 Nov 2026 01:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oHo5tSN0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF561F000C8;
	Thu, 19 Nov 2026 01:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052166;
	bh=n84PKhBZpZpOpR9WRmY67jq5FH94MSUxjU9C8PIITNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oHo5tSN05FCCH/F7Y4bAa7tqE+AQk6SJBjIUdKZleLjqMdxeqrnKv7j3bBfkVs1hT
	 FHPJapY0/dGR6WAJXbCbS9nr78TzwxAj8Fe+f73GLFSsDM0A+eHkpVnOQDPMyBMh+W
	 y9RKUnmRNhDVSP2FqdfirR2XPwh9FfZnlHIP4v+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diego Oliva <diego@bynar.io>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0420/2214] smb: client: fix OOB last_entry pointer from unbounded LastNameOffset
Date: Wed, 18 Nov 2026 15:34:56 +0100
Message-ID: <20261118150027.667203792@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Diego Oliva <diego@bynar.io>

[ Upstream commit 570c783a96f054dd3ac409a92772e9afb705d21c ]

CIFSFindFirst() and CIFSFindNext() locate the last entry of a
TRANS2_FIND_FIRST2 or TRANS2_FIND_NEXT2 response by adding the
LastNameOffset of the response parameters to the start of the data
area, and store the result in psrch_inf->last_entry. MS-CIFS 2.2.6.2.2
defines that offset as the offset of the entry's file name; the client
follows the reading of NT and Samba servers, which point it at the
entry. LastNameOffset is only checked against CIFSMaxBufSize, which
says nothing about the response actually received: validate_t2() lets
the data area start up to 1024 bytes into the buffer, and SendReceive()
copies at most CIFSMaxBufSize + MAX_CIFS_HDR_SIZE bytes of a response,
16468 by default, into a cifs_request allocation of CIFSMaxBufSize +
MAX_SMB2_HDR_SIZE bytes, 16588 by default. The pointer itself can
therefore be placed anywhere from the end of the received data to 820
bytes past the end of the allocation.

The read through that pointer is far larger than its displacement.
find_cifs_entry() hands last_entry to cifs_save_resume_key() after every
FindNext and after the FindFirst of a search rewind, and
cifs_fill_dirent() takes the length of the name from the entry itself: a
__le32 FileNameLength for most levels, a __u8 for
SMB_FIND_FILE_INFO_STANDARD, and for SMB_FIND_FILE_UNIX the result of a
scan for the terminating NUL over up to PATH_MAX + 1 UTF-16 units. The
name is recorded as the resume name of the search, and the next
CIFSFindNext() rejects only a recorded length of PATH_MAX or more before
copying the name into the ResumeFileName of its request and sending it
with the resume key taken from the same entry: up to 4 KiB of memory
from past the end of the allocation leaks to the server, and for
SMB_FIND_FILE_UNIX the NUL scan runs about twice as far before the
length is even known. The entry does not have to lie outside the
response for that either: a maximal response ends about 120 bytes before
the end of the allocation, so an entry in its last bytes with a name
just under PATH_MAX has nearly all of that name copied from past the
allocation.

It needs nothing unusual from the client: a FindNext response that
reports no entries and does not end the search makes find_cifs_entry()
send the next FindNext at once, carrying whatever was parsed at
LastNameOffset, and a search rewind can do the same after its
FindFirst. SMB1 is not negotiated by default: this takes a malicious
or compromised server, a mount of it with an explicit vers=1.0, which
CONFIG_CIFS_ALLOW_INSECURE_LEGACY (default y) permits, and a directory
listing on that mount.

With KASAN enabled, a response that places the last entry past the
buffer, with a large DataOffset and a LastNameOffset near the end of
its range, gives:

 ==================================================================
 BUG: KASAN: slab-out-of-bounds in cifs_save_resume_key.isra.0+0x7aa/0x7f0
 Read of size 4 at addr ffff88807b55c33b by task ls/83

 CPU: 1 UID: 0 PID: 83 Comm: ls Not tainted 7.3.0-rc4-00457-gf14572c203d5 #69 PREEMPT(lazy)
 Call Trace:
  <TASK>
  kasan_report+0xdf/0x1a0
  cifs_save_resume_key.isra.0+0x7aa/0x7f0
  cifs_readdir+0x1ed6/0x29c0
  iterate_dir+0x1c0/0x570
  __x64_sys_getdents64+0x133/0x270
  do_syscall_64+0x109/0x5d0
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
  </TASK>

 Allocated by task 83 on cpu 0 at 19.317556s:
  cifs_buf_get+0x36/0x90
  smb_init+0x4f/0x110
  CIFSFindNext+0xf7/0x14c0
  cifs_readdir+0xf51/0x29c0

 The buggy address belongs to the object at ffff88807b558000
  which belongs to the cache cifs_request of size 16588
 The buggy address is located 623 bytes to the right of
  allocated 16588-byte region [ffff88807b558000, ffff88807b55c0cc)
 ==================================================================

The four bytes read there are the FileNameLength of the entry, which
cifs_fill_dirent() takes before anything checks where the entry lies.

Ignore the last entry when it does not start inside the received
response or the response holds no entries; for a response without
entries, last_entry pointed into or past its empty data area and
cifs_save_resume_key() parsed whatever the buffer held there. The
entry is bounded by the response that was received, which is what the
buffer holds, rather than by the data area the response declares,
which a later patch checks against the received length. Record the
search handle before the last entry is examined, since a response
without a usable last entry still carries the handle that the search
is continued and closed with; leaving the assignment in the else
branch would drop the handle of every response without entries.

This bounds where the last entry starts, not how far it is parsed: an
entry that starts within the final bytes of the response still has
its fixed part read past the end of the received data and its name,
up to 4095 bytes, copied from past the end of the allocation, until
the following patch bounds the parse itself. A response without a
usable last entry continues the search with an empty resume name,
since the preceding patch, "smb: client: fix use-after-free infoleak
via the readdir resume name", drops the recorded name whenever a new
response is installed. This patch applies on top of that one and
relies on it: without it, every response rejected here would leave
the previous name in place, pointing into a buffer that has been
released.

A conforming server is not affected: the last entry lies inside the
data area of the response.

Fixes: 0752f1522a91 ("[CIFS] make sure we have the right resume info before calling CIFSFindNext")
Fixes: b77d753c413e ("[CIFS] Check that last search entry resume key is valid")
Cc: stable@vger.kernel.org
Assisted-by: Bynario AI
Signed-off-by: Diego Oliva <diego@bynar.io>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifssmb.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 6dc0b1793cbc7..685fdf7ecd070 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -4468,14 +4468,17 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 	psrch_inf->presume_name = NULL;
 	psrch_inf->resume_name_len = 0;
 	psrch_inf->resume_key = 0;
+	if (pnetfid)
+		*pnetfid = parms->SearchHandle;
 	lnoff = le16_to_cpu(parms->LastNameOffset);
-	if (CIFSMaxBufSize < lnoff) {
+	if (!psrch_inf->entries_in_buffer) {
+		psrch_inf->last_entry = NULL;
+	} else if (psrch_inf->srch_entries_start + lnoff >=
+		   psrch_inf->ntwrk_buf_start + bytes_returned) {
 		cifs_dbg(VFS, "ignoring corrupt resume name\n");
 		psrch_inf->last_entry = NULL;
 	} else {
 		psrch_inf->last_entry = psrch_inf->srch_entries_start + lnoff;
-		if (pnetfid)
-			*pnetfid = parms->SearchHandle;
 	}
 	return 0;
 }
@@ -4593,7 +4596,10 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 	psrch_inf->resume_name_len = 0;
 	psrch_inf->resume_key = 0;
 	lnoff = le16_to_cpu(parms->LastNameOffset);
-	if (CIFSMaxBufSize < lnoff) {
+	if (!psrch_inf->entries_in_buffer) {
+		psrch_inf->last_entry = NULL;
+	} else if (psrch_inf->srch_entries_start + lnoff >=
+		   psrch_inf->ntwrk_buf_start + bytes_returned) {
 		cifs_dbg(VFS, "ignoring corrupt resume name\n");
 		psrch_inf->last_entry = NULL;
 	} else {
-- 
2.53.0



