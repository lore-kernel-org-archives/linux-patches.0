Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C54F37186A;
	Wed, 30 Sep 2026 18:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794397; cv=none; b=Trb3bOJVCtABDbcpZ/PS6LsBH/uTm1msu0WzypZz5ed/tdC9UMIr8dC6APLh+wN6AaqPiRd1WZP3Pozc6lo8nU7ZvQQoORGv7+IJ+9PijC/fpbZligh+6+S/lfv5gEFCYj4LbjbGJnoWv1McvYO8xW42PWoLYpaC5H0TTjd9DQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794397; c=relaxed/simple;
	bh=Yp2V/upiyiW4C6WLvGCqVAn/tYXmRWuwJ5rc8UU1mFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKXHbTqOBUa5BjyfF8n2nE/x5Nb7iqZh903iw5U/8XEMMaLMFrp+6hpI95b4/TPdPHReTbbYouk7gI/EgQhOT90QyVXbr7w6hgKeocIa0ByRsxXOloVfp388+K7AZOjPG2mXdErus0Dcga5XpRrKkj7QhiT7BsJLoA2VNNPTvQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZzZE/3s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZzZE/3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7894F1F000FF;
	Wed, 30 Sep 2026 18:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794396;
	bh=jp/2udzVCe46JYO96PWBHkK1KXW6qYMi/XtffDp5RJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QZzZE/3s0yMUoYactafG/+P/L5AXb6eMeN0NiPQ24KcfxntUN+4UceJpbOQlinapV
	 x8apeuyoSc4mFFP5MEoiIexj8g6ObrCvBBr9x+YXAbCrZSpBbUwaHVMIIXBFompYH2
	 HemKH5wPejSYyeJk8o86YZq+Y80nEDWDNODYDUWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhengYuan Huang <gality369@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0158/1193] fs/ntfs3: preserve non-DOS attribute bits in system.dos_attrib
Date: Wed, 30 Sep 2026 17:14:02 +0200
Message-ID: <20260930152437.711418008@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8b5162df85517..30d5b8b53974d 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -853,7 +853,9 @@ static noinline int ntfs_setxattr(const struct xattr_handler *handler,
 	if (!strcmp(name, SYSTEM_DOS_ATTRIB)) {
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



