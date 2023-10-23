Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559FE14A81
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TqSAxD2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54296C433C7;
	Mon, 23 Oct 2023 11:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059088;
	bh=pfUyvO4f5u5GFCr7OhKuviU/DCEhxXcWwPH5Z4Ma8ZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TqSAxD2V0OkNulB3eu12PW8AIb5gTRy4K1EVOwvl/SFD2VGROfUMtezRgyGr4cKh3
	 KWzvkFkqph4tu/w0kinojFxL20tjGpiBDRVcq8v8nUXfm55khIXGKZN9iTObr63qrl
	 cIpsPG5hYPftgNMuVdhUryWpfsdhkvcVPqgPWmEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9fcea5ef6dc4dc72d334@syzkaller.appspotmail.com,
	Zeng Heng <zengheng4@huawei.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.5 032/241] fs/ntfs3: fix panic about slab-out-of-bounds caused by ntfs_list_ea()
Date: Mon, 23 Oct 2023 12:53:38 +0200
Message-ID: <20231023104834.709648568@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zeng Heng <zengheng4@huawei.com>

commit 8e7e27b2ee1e19c4040d4987e345f678a74c0aed upstream.

Here is a BUG report about linux-6.1 from syzbot, but it still remains
within upstream:

BUG: KASAN: slab-out-of-bounds in ntfs_list_ea fs/ntfs3/xattr.c:191 [inline]
BUG: KASAN: slab-out-of-bounds in ntfs_listxattr+0x401/0x570 fs/ntfs3/xattr.c:710
Read of size 1 at addr ffff888021acaf3d by task syz-executor128/3632

Call Trace:
 kasan_report+0x139/0x170 mm/kasan/report.c:495
 ntfs_list_ea fs/ntfs3/xattr.c:191 [inline]
 ntfs_listxattr+0x401/0x570 fs/ntfs3/xattr.c:710
 vfs_listxattr fs/xattr.c:457 [inline]
 listxattr+0x293/0x2d0 fs/xattr.c:804
 path_listxattr fs/xattr.c:828 [inline]
 __do_sys_llistxattr fs/xattr.c:846 [inline]

Before derefering field members of `ea` in unpacked_ea_size(), we need to
check whether the EA_FULL struct is located in access validate range.

Similarly, when derefering `ea->name` field member, we need to check
whethe the ea->name is located in access validate range, too.

Fixes: be71b5cba2e6 ("fs/ntfs3: Add attrib operations")
Reported-by: syzbot+9fcea5ef6dc4dc72d334@syzkaller.appspotmail.com
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
[almaz.alexandrovich@paragon-software.com: took the ret variable out of the loop block]
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/xattr.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -211,7 +211,8 @@ static ssize_t ntfs_list_ea(struct ntfs_
 	size = le32_to_cpu(info->size);
 
 	/* Enumerate all xattrs. */
-	for (ret = 0, off = 0; off < size; off += ea_size) {
+	ret = 0;
+	for (off = 0; off + sizeof(struct EA_FULL) < size; off += ea_size) {
 		ea = Add2Ptr(ea_all, off);
 		ea_size = unpacked_ea_size(ea);
 
@@ -219,6 +220,10 @@ static ssize_t ntfs_list_ea(struct ntfs_
 			break;
 
 		if (buffer) {
+			/* Check if we can use field ea->name */
+			if (off + ea_size > size)
+				break;
+
 			if (ret + ea->name_len + 1 > bytes_per_buffer) {
 				err = -ERANGE;
 				goto out;


