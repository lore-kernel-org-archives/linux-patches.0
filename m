Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844E936A033;
	Wed, 30 Sep 2026 16:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784396; cv=none; b=POz1CTZETa64Ssej91eC+LAAOEsJ67Gp1M8/iIGa2hW3tZmH+wWR3jWvwNikaDgqkKbPxJyYgxWnWe7ny6i0F0Y7/5O0yHogUUHphWMdkFjHfwkOuwPwwA+FHMfsbIl9ePRG3vOWgh758QQ+eX3KCfQYt4JjvVTUMv1RbomRogw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784396; c=relaxed/simple;
	bh=kWEB2RPnwn8uIxkIBcANGmg7X2+Qyt/1/SFT5EJPTOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAuQrtns9s1bMvtZcsyGthnM3tGYuNglDxuxEgwhiV/600z538DRBV43q6VW7o6mx2Lp8bGtYlfIRuy13EMCGiTY2ek0L/hhOXEcmYZg3Q+LpS19WlU5I10ScMYt6Hz0LgtoY14kunJHLxvjN1cOb9Cws1qGTFcahj54gDvWrjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jVaLlbQx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jVaLlbQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172A11F0089C;
	Wed, 30 Sep 2026 16:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784391;
	bh=HN1AqhK42DA1sTSvGbclq8f0RSZpqJH6psf3m18dlSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jVaLlbQxAD8qjaN3LBz8aoEI3/wVc+BdOHlKPzSQLPVRbtk13Drl9FhBuv/KLTGlm
	 fhJ6RiJ6jgsyDUNsjzTTo9MabmdFHFbu5Aqd/7so4xPKkxzAYTOkBcwcE6mZ8YoNUS
	 gfgTdKB8srdrBolM1Dd0a6Rfef2XUQuqzd1j9OSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhengYuan Huang <gality369@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 139/982] fs/ntfs3: preserve non-DOS attribute bits in system.dos_attrib
Date: Wed, 30 Sep 2026 17:14:35 +0200
Message-ID: <20260930152419.804091470@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhengYuan Huang <gality369@gmail.com>

[ Upstream commit b1c1101067d9536bcb0fe023b96ee2dde5535959 ]

[BUG]
A corrupted ntfs3 image can hit a NULL function pointer call in
generic_perform_write() after toggling system.ntfs_attrib and then
overwriting system.dos_attrib on the same file.

BUG: kernel NULL pointer dereference, address: 0000000000000000
\#PF: supervisor instruction fetch in kernel mode
\#PF: error_code(0x0010) - not-present page
PGD bed5067 P4D bed5067 PUD 0
Oops: Oops: 0010 [#1] SMP KASAN NOPTI
RIP: 0010:0x0
Code: Unable to access opcode bytes at 0xffffffffffffffd6.
RSP: 0018:ffff88801025f988 EFLAGS: 00010246
Call Trace:
 generic_perform_write+0x409/0x8c0 mm/filemap.c:4255
 __generic_file_write_iter+0x1bb/0x200 mm/filemap.c:4372
 ntfs_file_write_iter+0xcd9/0x1c20 fs/ntfs3/file.c:1253
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x63b/0xf70 fs/read_write.c:686
 ksys_write+0x133/0x250 fs/read_write.c:738
 __do_sys_write fs/read_write.c:749 [inline]
 __se_sys_write fs/read_write.c:746 [inline]
 __x64_sys_write+0x77/0xc0 fs/read_write.c:746
 ...

[CAUSE]
system.ntfs_attrib updates ATTR_DATA flags via ni_new_attr_flags()
and switches i_mapping->a_ops to ntfs_aops_cmpr when
FILE_ATTRIBUTE_COMPRESSED is set. system.dos_attrib then overwrites
ni->std_fa from a one-byte DOS attribute value, clearing the compression
bit without updating ATTR_DATA or the mapping operations.

Old buffered writes use is_compressed(ni) to choose
__generic_file_write_iter(). That leaves generic_perform_write() calling
a NULL write_begin callback from ntfs_aops_cmpr.

[FIX]
Treat system.dos_attrib as a low-byte DOS attribute update and preserve the
existing non-DOS attribute bits in ni->std_fa. This keeps compressed and
sparse state consistent with ATTR_DATA and the mapping operations while
keeping the existing DOS attribute semantics intact.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/xattr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index 409f9545e9cd5..a235050e92098 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -874,7 +874,9 @@ static noinline int ntfs_setxattr(const struct xattr_handler *handler,
 	    !memcmp(name, SYSTEM_DOS_ATTRIB, sizeof(SYSTEM_DOS_ATTRIB))) {
 		if (sizeof(u8) != size)
 			goto out;
-		new_fa = cpu_to_le32(*(u8 *)value);
+		/* system.dos_attrib only covers the low DOS attribute byte. */
+		new_fa = (ni->std_fa & ~cpu_to_le32(0xff)) |
+			 cpu_to_le32(*(u8 *)value);
 		goto set_new_fa;
 	}
 
-- 
2.53.0



