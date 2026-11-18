Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037397;
	b=F97LA0Ih25tvBRJUQXIFlb7iy9TtTEnpcYsh06RkhgmZkhBaqldGDN1YWWWYPFvBHun4
	 UWP4chsfSG4yonsoySwKqrZ9jfsp4TluCUBcxu/FvI5k3QuSOQgaGTCNCqBPVBlRdQQpb
	 j3Py/HEhpgUNGkh/QXiJDROEEOzButcXIXInumdTclm9iMcOi27hAz6/xXztGyDZYQVWr
	 KSUWrLk6Lye5BXqhIBM2yvMgqke4JB+psrVHdTZeS2RZ5AcYhf4TNlyemh9bqRHxiNhAh
	 LNKsLWebCSwar+Nn56kGvKGsp1SoMZbMeShEREg0wlD3FPHBat7EaMKzMdobPzEHExw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6J4VE0LUrnWILkL2xbBVp0Z46+N+bTkRf78ln73axMg=;
	b=IFlztHeDhKcdC2+QlgumApGkTH8FtLyzNAVHmQKfB7GJs9rAVNpwVSX7ldXJ0LJBhj4x
	 1DW42rXSbr75e0GDefGRcWOP40hkj/DFrB/lcGJe1AtAAJSTx/CzzskmGhccuusY4xa2W
	 xGaO495+Pwy7xRRfAWVFHLnf5dKrTzDwiYNM7ac2ua4disonS1YhJ5JdM4G+oTA3z4K8o
	 X50L1wSNYmxYrND79xqkSJFNjQI9w09bqzplwDW3G9ew8V0B2NFzFLcs4QcZQ5qqkqzJX
	 8LbH8Ph6riSXxROR3Hz4c4kCQyNEIJEHHL8NS4QLC42/Gt8Cv0ehpBvT+S9HWqH1fyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a+794DBc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2327A606A32A;
	Wed, 18 Nov 2026 21:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a+794DBc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2CD1F000C4;
	Wed, 18 Nov 2026 21:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037397;
	bh=6J4VE0LUrnWILkL2xbBVp0Z46+N+bTkRf78ln73axMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a+794DBcg3aiLFxVeewNaEnRl9yylpBXS5lGzUz2QcYcNmordZxtrW5w0l0ZfccUD
	 IjKSQkYkcbznLVlFd1rhMWS/2U4MRhb3cLbjPIbPrj/DFpyHxr1djlL9PP8LkKETxG
	 RfXEHGRshPbftHESVOEkvquOW5UjKlnN7CgtagQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diego Oliva <diego@bynar.io>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1388/3318] smb: client: fix OOB read in the SMB_FIND_FILE_UNIX name scan
Date: Wed, 18 Nov 2026 15:33:30 +0100
Message-ID: <20261118150402.210473053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diego Oliva <diego@bynar.io>

[ Upstream commit fa0c2f082946917c3f07d2475c8ce73a8c96d0e2 ]

cifs_fill_dirent_unix() finds the length of an SMB_FIND_FILE_UNIX
entry name by scanning for its terminating NUL, over up to PATH_MAX + 1
UTF-16 units in cifs_unicode_bytelen() or PATH_MAX bytes in strnlen().
Neither scan knows where the response ends. cifs_fill_dirent() only
requires the fixed part of the entry to fit, so the name can start
exactly at the end of the received data, and a name that holds no
terminator is then scanned for 8194 bytes, or 4096 bytes without
unicode, past the end of the received data. SendReceive() copies at
most 16468 bytes into the 16588-byte cifs_request allocation, so for a
response of that length up to 8074 of the bytes scanned lie past the
end of the allocation. Before the preceding patches bounded where the
entry starts, the entry itself could start up to 820 bytes past the
end of the allocation at the default CIFSMaxBufSize, and its name 928
bytes past it, so all 8194 scanned bytes would lie outside.
cifs_fill_dirent() rejects the name afterwards because it extends past
the end of the response, so nothing of what was read is used, but the
out-of-bounds read itself remains.

SMB_FIND_FILE_UNIX is only used with SMB1 servers that offer the Unix
extensions; SMB1 is not negotiated by default and requires an explicit
vers=1.0 mount.

Before the preceding patches, an entry placed past the buffer left the
scan out of bounds from its first read. They bound where the entry
starts, but nothing bounds the scan, so a name that holds no
terminator still runs off the end of the allocation. Reproduced on
the unpatched tree with KASAN enabled, for an entry that starts
inside the response, which is the case the preceding patches leave
open:

 ==================================================================
 BUG: KASAN: slab-out-of-bounds in cifs_save_resume_key.isra.0+0x75c/0x7f0
 Read of size 2 at addr ffff88807ee640cc by task ls/84

 CPU: 0 UID: 0 PID: 84 Comm: ls Not tainted 7.3.0-rc4-00457-gf14572c203d5 #69 PREEMPT(lazy)
 Call Trace:
  <TASK>
  kasan_report+0xdf/0x1a0
  cifs_save_resume_key.isra.0+0x75c/0x7f0
  cifs_readdir+0x1ed6/0x29c0
  iterate_dir+0x1c0/0x570
  __x64_sys_getdents64+0x133/0x270
  do_syscall_64+0x109/0x5d0
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
  </TASK>

 Allocated by task 84 on cpu 1 at 15.751078s:
  cifs_buf_get+0x36/0x90
  smb_init+0x4f/0x110
  CIFSFindNext+0xf7/0x14c0
  cifs_readdir+0xf51/0x29c0

 The buggy address belongs to the object at ffff88807ee60000
  which belongs to the cache cifs_request of size 16588
 The buggy address is located 0 bytes to the right of
  allocated 16588-byte region [ffff88807ee60000, ffff88807ee640cc)
 ==================================================================

The two bytes read there are one UTF-16 unit of the scan, at the first
byte past the end of the object. The scan carries on from there,
reported again 2, 4 and 6 bytes to the right.

Pass the number of bytes that follow the fixed part of the entry to
cifs_fill_dirent_unix() and stop both scans there. A scan that reaches
the end of the response without finding a terminator now fails: it
returns a name that ends exactly at the end of the response and would
otherwise pass the bound, so cifs_fill_dirent() requires the position
of the terminator of an SMB_FIND_FILE_UNIX name to lie inside the
response as well. Accepting such a name truncated at the end of the
response would turn a malformed entry into a directory entry, or a
resume name, that no server sent. A name longer than the PATH_MAX cap
of the scans is still truncated there, as before, when the response
extends past the cap. The message cifs_unicode_bytelen() logs when it
finds no terminator now covers both limits.

This patch depends on "smb: client: fix OOB read of the resume name
sent in TRANS2_FIND_NEXT2", which adds the end argument of
cifs_fill_dirent() and the length it derives from it; the backport
note in that patch applies to this one as well.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: Bynario AI
Signed-off-by: Diego Oliva <diego@bynar.io>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/readdir.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 135cbd833e47b..5e77ed064f49c 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -454,17 +454,20 @@ initiate_cifs_search(const unsigned int xid, struct file *file,
 }
 
 /* return length of unicode string in bytes */
-static int cifs_unicode_bytelen(const char *str)
+static size_t cifs_unicode_bytelen(const char *str, size_t maxlen)
 {
-	int len;
 	const __le16 *ustr = (const __le16 *)str;
+	size_t len;
 
-	for (len = 0; len <= PATH_MAX; len++) {
+	maxlen = umin(PATH_MAX + 1, maxlen / sizeof(__le16));
+	for (len = 0; len < maxlen; len++) {
 		if (ustr[len] == 0)
-			return len << 1;
+			return len * sizeof(__le16);
 	}
-	cifs_dbg(FYI, "Unicode string longer than PATH_MAX found\n");
-	return len << 1;
+	len *= sizeof(__le16);
+	cifs_dbg(FYI, "%s: Unicode string not terminated within %zu bytes\n",
+		 __func__, len);
+	return len;
 }
 
 static char *nxt_dir_entry(char *old_entry, char *end_of_smb, int level)
@@ -530,13 +533,13 @@ static void cifs_fill_dirent_posix(struct cifs_dirent *de,
 }
 
 static void cifs_fill_dirent_unix(struct cifs_dirent *de,
-		const FILE_UNIX_INFO *info, bool is_unicode)
+		const FILE_UNIX_INFO *info, bool is_unicode, size_t maxlen)
 {
 	de->name = &info->FileName[0];
 	if (is_unicode)
-		de->namelen = cifs_unicode_bytelen(de->name);
+		de->namelen = cifs_unicode_bytelen(de->name, maxlen);
 	else
-		de->namelen = strnlen(de->name, PATH_MAX);
+		de->namelen = strnlen(de->name, min_t(size_t, maxlen, PATH_MAX));
 	de->resume_key = info->ResumeKey;
 	de->ino = le64_to_cpu(info->basic.UniqueId);
 }
@@ -587,6 +590,7 @@ static int cifs_fill_dirent(struct cifs_dirent *de, const void *info,
 			    const char *end, u16 level, bool is_unicode)
 {
 	size_t len = end > (const char *)info ? end - (const char *)info : 0;
+	size_t nul_len = 0;
 
 	memset(de, 0, sizeof(*de));
 
@@ -599,7 +603,9 @@ static int cifs_fill_dirent(struct cifs_dirent *de, const void *info,
 	case SMB_FIND_FILE_UNIX:
 		if (len < offsetof(FILE_UNIX_INFO, FileName))
 			goto too_short;
-		cifs_fill_dirent_unix(de, info, is_unicode);
+		cifs_fill_dirent_unix(de, info, is_unicode,
+				      len - offsetof(FILE_UNIX_INFO, FileName));
+		nul_len = is_unicode ? sizeof(__le16) : sizeof(__u8);
 		break;
 	case SMB_FIND_FILE_DIRECTORY_INFO:
 		if (len < offsetof(FILE_DIRECTORY_INFO, FileName))
@@ -632,7 +638,8 @@ static int cifs_fill_dirent(struct cifs_dirent *de, const void *info,
 	}
 
 	if (de->name &&
-	    (end < de->name || (size_t)(end - de->name) < de->namelen)) {
+	    (end < de->name ||
+	     (size_t)(end - de->name) < de->namelen + nul_len)) {
 		cifs_dbg(VFS, "%s: search entry name extends past end of SMB\n",
 			 __func__);
 		return -EINVAL;
-- 
2.53.0



