Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035046;
	b=lYaKk5putdAcukhZ4bmisKHVCbliRGm7MlZkeVFWEdQNPQvBhqj3sopjDRIVsBtmErLH
	 ANyMQD7Aa5kXioTi7+FXTJCh4VZD/EHLrjTzLqRU58FdkyLShkTLFTXpSAWnj7awzJgPv
	 2zQYVFNMhuR9jd71OLrlLaIo1gZVh+Kbty1Fq3AkCw6L2VvS3/06H8T+yBh/PhNSIPQ9/
	 +egrGQYUZW4ZfEkPpR2oew0bZhLkmlFaAydUOzP5QI2pz56OfrxvroAeAsJ0jFoF/A30T
	 edlkZkgrUQGOcJgVBr1xPdWiHFnG2/3hudSqqlUkRQyE7/7DlmJ4h6JH6u8GvYwrZfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HWHjXIoVPy2SZ/dbjH8QBlguCj90sR1tf4EEnpt3e70=;
	b=vo12qeSyd3p/ZBfqcylMofygoAGpr3oZj3O4ntGpPyY6pVGUl+spxKnpKSwjeSq51ciu
	 7L7nO0w9fX1TAqM9vTdmBZBOMYpChhxOHxNlSN5HDqy16886pT5spdTQct82jGwX1sgpr
	 XlAJIkWd6Tminh7PIzXaF7hEUg6qqnKAUXXe5O0SstO5lnbh8W6r7p9wmS/bDSPk8uUlE
	 IEv4YlKtXEMwPHeg0XfJ/wU+XJ1hUDy9fXGAec/5eyWz70f0Rd8oa77i3CY1uJdsVOlH9
	 6y+yCtC5jvVen370Bik6r0F6yTiBN58UF91q704Y2rDlBlomJL4XcOu30zcEheEQaiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JLipXEo4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BFC606A31C;
	Wed, 18 Nov 2026 20:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JLipXEo4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B151F000C4;
	Wed, 18 Nov 2026 20:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035046;
	bh=HWHjXIoVPy2SZ/dbjH8QBlguCj90sR1tf4EEnpt3e70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JLipXEo4iH6a6stouRelAwZBtRbkc/zHkCnCvvWb06IG/2UJlIFhBB6ObrsOSfzxP
	 F2+LnYbOwGbgSlEa2nTIQIjI7qZy2v6K7IqrTrHSY1n6i8Nwr3N9ucA9MBw2b2l8eF
	 +uDFPxzhs9KE0lNAwsDkzrKPMuAIHtwD3CYfbgqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diego Oliva <diego@bynar.io>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.6 0584/3318] smb: client: fix use-after-free infoleak via the readdir resume name
Date: Wed, 18 Nov 2026 15:20:06 +0100
Message-ID: <20261118150335.069205391@linuxfoundation.org>
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

commit 59131dd72f62b198fc9ea1489ad9d3573154f684 upstream.

CIFSFindNext() copies the resume name that cifs_save_resume_key()
recorded from the last entry of the previous response into its request;
psrch_inf->presume_name points into the response buffer that entry came
from, and nothing ever clears it. find_cifs_entry() records a new
name only from a response with a usable last entry, and cifs_readdir()
only from an entry it walks to, so a response that carries no entries
and leaves last_entry NULL, because CIFSFindFirst() or CIFSFindNext()
rejected LastNameOffset, refreshes neither and presume_name keeps
pointing into the previous response. That buffer has already been
released: by CIFSFindNext() before it installs the new response, or by
find_cifs_entry() when it rewinds the search, which does not drop the
name either and can then fail in initiate_cifs_search() before a new
response replaces it. The next CIFSFindNext() then copies up to
PATH_MAX - 1 bytes of the resume name out of the released buffer into
its request and sends them to the server: a use-after-free read
that leaks kernel memory to a malicious or compromised server, which
can provoke it with a single FindNext response that carries no entries
and a LastNameOffset above CIFSMaxBufSize, which is all the existing
check rejects.

With KASAN enabled, a server that answers a listing that way gives:

 CIFS: VFS: ignoring corrupt resume name
 ==================================================================
 BUG: KASAN: slab-use-after-free in CIFSFindNext+0x8ca/0x14c0
 Read of size 4080 at addr ffff88807c823f98 by task ls/83

 CPU: 0 UID: 0 PID: 83 Comm: ls Tainted: G    B               7.3.0-rc4-00457-gf14572c203d5 #69 PREEMPT(lazy)
 Tainted: [B]=BAD_PAGE
 Call Trace:
  <TASK>
  kasan_report+0xdf/0x1a0
  kasan_check_range+0x10f/0x1e0
  __asan_memcpy+0x23/0x60
  CIFSFindNext+0x8ca/0x14c0
  cifs_readdir+0xf51/0x29c0
  iterate_dir+0x1c0/0x570
  __x64_sys_getdents64+0x133/0x270
  do_syscall_64+0x109/0x5d0
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
  </TASK>

 Allocated by task 83 on cpu 1 at 13.497119s:
  cifs_buf_get+0x36/0x90
  smb_init+0x4f/0x110
  CIFSFindNext+0xf7/0x14c0
  cifs_readdir+0xf51/0x29c0

 Freed by task 83 on cpu 0 at 13.584018s:
  cifs_buf_release+0x41/0x80
  CIFSFindNext+0xfce/0x14c0
  cifs_readdir+0xf51/0x29c0

 The buggy address is located 16280 bytes inside of
  freed 16588-byte region [ffff88807c820000, ffff88807c8240cc)
 ==================================================================

The same memcpy() first reads past the end of that object while it is
still live, a slab-out-of-bounds read that the following patches
bound; that is the taint the report above carries.

SMB1 is not negotiated by default; reaching this code requires an
explicit vers=1.0 mount.

Clear presume_name and resume_name_len whenever a new response is
installed and when the rewind path releases the search buffer, so that
the name never outlives the buffer it points into, and reset
resume_key with them, since it was taken from the same entry and would
otherwise be sent with an empty name. A response without a usable
last entry then continues the search with an empty resume name rather
than a stale one; CIFSFindNext() skips the copy of a zero-length name
so that it never runs on the NULL pointer.

The next patch in the series leaves last_entry NULL for a response
that carries no entries, and bounds LastNameOffset against the
received response rather than against CIFSMaxBufSize. Responses that
are given a last entry today then take the path fixed here, so that
patch must not be applied without this one.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: b77d753c413e ("[CIFS] Check that last search entry resume key is valid")
Cc: stable@vger.kernel.org
Assisted-by: Bynario AI
Signed-off-by: Diego Oliva <diego@bynar.io>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifssmb.c |   11 ++++++++++-
 fs/smb/client/readdir.c |    3 +++
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -4095,6 +4095,9 @@ findFirstRetry:
 	psrch_inf->entries_in_buffer = le16_to_cpu(parms->SearchCount);
 	psrch_inf->index_of_last_entry = 2 /* skip . and .. */ +
 		psrch_inf->entries_in_buffer;
+	psrch_inf->presume_name = NULL;
+	psrch_inf->resume_name_len = 0;
+	psrch_inf->resume_key = 0;
 	lnoff = le16_to_cpu(parms->LastNameOffset);
 	if (CIFSMaxBufSize < lnoff) {
 		cifs_dbg(VFS, "ignoring corrupt resume name\n");
@@ -4158,7 +4161,10 @@ int CIFSFindNext(const unsigned int xid,
 	name_len = psrch_inf->resume_name_len;
 	params += name_len;
 	if (name_len < PATH_MAX) {
-		memcpy(pSMB->ResumeFileName, psrch_inf->presume_name, name_len);
+		if (name_len) {
+			memcpy(pSMB->ResumeFileName,
+			       psrch_inf->presume_name, name_len);
+		}
 		byte_count += name_len;
 		/* 14 byte parm len above enough for 2 byte null terminator */
 		pSMB->ResumeFileName[name_len] = 0;
@@ -4213,6 +4219,9 @@ int CIFSFindNext(const unsigned int xid,
 	psrch_inf->endOfSearch = !!parms->EndofSearch;
 	psrch_inf->entries_in_buffer = le16_to_cpu(parms->SearchCount);
 	psrch_inf->index_of_last_entry += psrch_inf->entries_in_buffer;
+	psrch_inf->presume_name = NULL;
+	psrch_inf->resume_name_len = 0;
+	psrch_inf->resume_key = 0;
 	lnoff = le16_to_cpu(parms->LastNameOffset);
 	if (CIFSMaxBufSize < lnoff) {
 		cifs_dbg(VFS, "ignoring corrupt resume name\n");
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -748,6 +748,9 @@ find_cifs_entry(const unsigned int xid,
 			cfile->srch_inf.ntwrk_buf_start = NULL;
 			cfile->srch_inf.srch_entries_start = NULL;
 			cfile->srch_inf.last_entry = NULL;
+			cfile->srch_inf.presume_name = NULL;
+			cfile->srch_inf.resume_name_len = 0;
+			cfile->srch_inf.resume_key = 0;
 		}
 		rc = initiate_cifs_search(xid, file, full_path);
 		if (rc) {


