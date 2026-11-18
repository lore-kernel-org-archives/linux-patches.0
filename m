Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037028;
	b=h7QWVJ7GZ78AZNYDCIHhuXXgPbaRFjJGlz5N8JwdM42t90pLgAl+S/SLt170Aba6Y180
	 j4tiv2KSZ3Zaprvahbc8uYzaVl65GDid2bLG8wM3N7x89m58hfd+t9nwSVWMbNOMDupw2
	 gVloUYuHzyZrXUo+ppO/0VTapCX1DBoaFOMiG6HLtsChp06JY9BAu6G6r9b0D86QFUCrZ
	 ojDKJnuocUZC5Y6FZk4RX6KbyHZsNwXRlS8et+rw85NrqNEK5FEvWCx5TIdTxglBqMW0q
	 66uMwuYXuygoVZddswrvmKnrYM5a4D58USdv0DItWkhmpU2bEKkTG1F3jTTZvsoZOAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037028;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=50M5cD5OaeqnimxgMyPN6P+m4ZMCCcx2pHvD4uMUpcg=;
	b=Pdf5dsrbH8klR2gNd24FiYOEFcUlh7XQ+69v3NgQ06goULAaciVzFMlR8V+fbLpGpQRu
	 RzIfDVNB+Z0ugnAuVcG9pallGL8OvqKAjmKJJIS3Qa4CFAmJg9EUrRLvFFA53eJQ4HKp6
	 8KMlQnq3tSCyXpWwBLGL3J1odGfRgWbkH/7HQf2FnvobiHxWBXcs1DO2ySXZumx+F7CNA
	 r833G8rNKkZc0/SdBEUS5l1Hzskk4jlNiZfwu3pkNjnXbrmlD7jl7FiiFrjou+sNpZya7
	 ZqH8kWRTlsd1A09y4QcXg033tdR6U/ACrPQXbeJZyhpn2usU8QfUerhmMI1X9bdiKuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xOu/CBsq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88595606A31C;
	Wed, 18 Nov 2026 21:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xOu/CBsq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA351F000C4;
	Wed, 18 Nov 2026 21:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037028;
	bh=50M5cD5OaeqnimxgMyPN6P+m4ZMCCcx2pHvD4uMUpcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xOu/CBsqhq11ts4L+CgwxQ5tIQAyj1BDANd8mbOxCfYoc7Vme23m4Gp2CHPzmaY3z
	 HPpFocu0a9dxL1S93J5AmQnOsyUBbVnFxHq1geDoPAep9IIqF8hO1MEUNlHYWBsSfI
	 Rsxpsd+X5goc0ciHXShQGvzHy9cmz7/ChCn6exXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyeontae Lee <wonju345@naver.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1268/3318] fs/ntfs3: bound CreateAttribute asize against record_size in do_action
Date: Wed, 18 Nov 2026 15:31:30 +0100
Message-ID: <20261118150358.261147165@linuxfoundation.org>
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

From: Hyeontae Lee <wonju345@naver.com>

[ Upstream commit fb0f0ef7b5a6bc761b372ce00764d4b6e0b91a47 ]

In do_action()'s CreateAttribute case (fslog.c:3286), attr2 points into
the on-disk log record and asize = le32_to_cpu(attr2->size) is therefore
attacker-controlled on mount.  The guard bounds asize only against the
log record itself,

	Add2Ptr(attr2, asize) > Add2Ptr(lrh, rec_len)

where rec_len is the client data length, and separately bounds dlen
against the MFT record.  Nothing bounds asize against record_size, but
all three writes that follow are into rec, a kmalloc(sbi->record_size)
buffer allocated by mi_init() (record.c:105):

	memmove(Add2Ptr(attr, asize), attr, used - roff);
	memcpy(attr, attr2, asize);
	rec->used = cpu_to_le32(used + asize);

With record_size 0x400, roff 0x38, used 0x160 and asize 0x800 the memcpy
writes 2048 bytes at rec + 0x38, 0x438 bytes past the allocation, and
rec->used is left at 0x960.  dlen is 0x18 here, so the existing
dlen check passes: dlen bounds nothing about the size of the copy.

The equivalent non-replay path already refuses this.  mi_insert_attr()
performs the same insert and starts with (record.c:488):

	if (used + asize > sbi->record_size)
		return NULL;

Apply the same bound, spelled as a subtraction to match the neighbouring
clause.  used <= record_size holds here because check_file_record()
validates it (fslog.c:2826) and is called on this record at fslog.c:3172;
roff <= used - 4 follows from check_if_attr() together with the ATTR_END
check at fslog.c:2844, so bounding used + asize bounds both copies.

The sibling WriteEndOfFileRecordSegment case does the equivalent check
against record_size at fslog.c:3277.

Reproduced by mounting a crafted image on v7.2-rc5 under KASAN:

  BUG: KASAN: slab-out-of-bounds in do_action.isra.0+0x41f6/0x83a0
  Write of size 2048 at addr ffff888005c74838 by task mount/69

  CPU: 0 UID: 0 PID: 69 Comm: mount Not tainted 7.2.0-rc5-00300-g8ba098e6b6ff #2
  Call Trace:
   kasan_report+0xce/0x100
   kasan_check_range+0x105/0x1b0
   __asan_memcpy+0x3c/0x60
   do_action.isra.0+0x41f6/0x83a0
   log_replay+0x920a/0xd300
   ntfs_loadlog_and_replay+0x3ef/0x510
   ntfs_fill_super+0x1d23/0x4550
   get_tree_bdev_flags+0x2ef/0x550
   vfs_get_tree+0x82/0x2f0
   fc_mount+0x10/0x1b0
   path_mount+0x517/0x1df0
   __x64_sys_mount+0x20b/0x270
   do_syscall_64+0xf9/0x540
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

  Allocated by task 69:
   __kasan_kmalloc+0x8f/0xa0
   __kmalloc_noprof+0x1b4/0x460
   mi_init+0x81/0x110
   mi_get+0x6a/0x220
   do_action.isra.0+0x1db4/0x83a0
   log_replay+0x920a/0xd300
   ntfs_loadlog_and_replay+0x3ef/0x510
   ntfs_fill_super+0x1d23/0x4550

  The buggy address belongs to the object at ffff888005c74800
   which belongs to the cache kmalloc-1k of size 1024
  The buggy address is located 56 bytes inside of
   allocated 1024-byte region [ffff888005c74800, ffff888005c74c00)

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Hyeontae Lee <wonju345@naver.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index 7c26fc591e2fa..f793b5b10c718 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -3304,10 +3304,15 @@ static int do_action(struct ntfs_log *log, struct OPEN_ATTR_ENRTY *oe,
 		asize = le32_to_cpu(attr2->size);
 		used = le32_to_cpu(rec->used);
 
+		/*
+		 * attr2->size is taken from the log record and is bounded only
+		 * by the log record length, not by the MFT record.  Refuse an
+		 * attribute that does not fit, as mi_insert_attr() does.
+		 */
 		if (!check_if_attr(rec, lrh) || dlen < SIZEOF_RESIDENT ||
 		    !IS_ALIGNED(asize, 8) ||
 		    Add2Ptr(attr2, asize) > Add2Ptr(lrh, rec_len) ||
-		    dlen > record_size - used) {
+		    dlen > record_size - used || asize > record_size - used) {
 			goto dirty_vol;
 		}
 
-- 
2.53.0



