Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591031;
	b=K2WeXOYrOLicCXZ+cLn6gFoy4neibQTdRkQ7+VJ5vejEVarvUI5I5EbIHewlhOUD7aic
	 oiNnxdocw8Lq+WEyThPu0DD7ZtN5R2uOV88tuziOd55x6igLeF+uiUIG9r9poB10bslUm
	 2j5bLJhcTSSd28NHTClkgs+k3HyfHa48oc693/tFw65i+QqH1AJFpjGf4haQjfEB7KoGM
	 If4e3MyVq/aTIMRrQZJ0CLeHAsMGj6xxRyvXIMKiHZEijrsMDoCxg5Ym9Tjuy0gWItHAK
	 PBhS9Ss+whRJgmgaXK4irrPsCQ0SZpBJ10+7nLLBU7hxKbuIr7/ZQYHhXacLgkN+77w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591031;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gUZFtZdymd3/Dd4Rz1aqsX2+kAimf8fYtgMDU2sBHjM=;
	b=ri9qxz5YGju3Xae3JGdy2CPxoaT7SAV0LpnxGpGlj21EeplKWeyfSWJuL5p/CKajz5vC
	 xgvBy2aS9fOXVHyamSJX0+UGI26rj9pd+wsxPG/0bUeS0fYRdEONEL+23uFq4PXX9wNOi
	 s5bM4sG6lXsXYcpKJrYWAWotODME1GVPsvM/J+kzU1naH0e+fTzCJrudslYl8NbUyCqxL
	 y1xBRdbcsgHZxKl8TA2y9HFV2a4DrCXqzkM6R3Bcl314YQuWz9SB1FQ+2UqYeDWmXj9y0
	 5CkmmGFrniPK13cH5d/02SSzjlamkcPxNZp5GL4IgiN3X083myXmdz99E2QhbcGO/oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="F6/0UxyN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367CF606A8A6;
	Fri, 13 Nov 2026 17:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F6/0UxyN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0921F000C6;
	Fri, 13 Nov 2026 17:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591030;
	bh=gUZFtZdymd3/Dd4Rz1aqsX2+kAimf8fYtgMDU2sBHjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F6/0UxyNJmkfBRa8qS9fT9dR6rEU5i6vobt/iyf9p28ZDL/ZGEYDb+Dv9mO++2sgx
	 Oyx8Gnf6Y8LZAjbwCAjaIDw6uyZLc4fNONqeIe3Qe2Gv+o101gCMokEYFb89krJ6ud
	 0sT65YXiKm1VTV5grhHF/XEjI3oyQgYbIl2V8SGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diego Oliva <diego@bynar.io>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 152/670] smb: client: fix OOB read in the SMB_FIND_FILE_UNIX name scan
Date: Fri, 13 Nov 2026 10:45:16 -0500
Message-ID: <20261113153817.163854918@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 449e8dbc98309..55b4171cec09e 100644
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



