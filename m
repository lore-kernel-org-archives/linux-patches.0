Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D0D15E83
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QueFsJ8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C63DC433C9;
	Mon, 23 Oct 2023 11:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061025;
	bh=xEhCAEr6jJgCjKQ1qme+sF6v5f9Ti5pT9G8Qmqhq0Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QueFsJ8Duy086Nvl4btaRgv9Uhm8SVf6wsGmlyz05X5nWBTVMpRMSH0qIfemMBnTZ
	 0JPihSeQnwj6wjoepz0PihDQiz7xttsM/T/g44WbzcLzNjB0BNMKkJbqVgRJe1M5d3
	 9NK9BAnwXAKEAJV3H7IbaWaPMtYighi1D7mHj7HA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9fcea5ef6dc4dc72d334@syzkaller.appspotmail.com,
	Zeng Heng <zengheng4@huawei.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.15 020/137] fs/ntfs3: fix panic about slab-out-of-bounds caused by ntfs_list_ea()
Date: Mon, 23 Oct 2023 12:56:17 +0200
Message-ID: <20231023104821.634601879@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
References: <20231023104820.849461819@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -209,7 +209,8 @@ static ssize_t ntfs_list_ea(struct ntfs_
 	size = le32_to_cpu(info->size);
 
 	/* Enumerate all xattrs. */
-	for (ret = 0, off = 0; off < size; off += ea_size) {
+	ret = 0;
+	for (off = 0; off + sizeof(struct EA_FULL) < size; off += ea_size) {
 		ea = Add2Ptr(ea_all, off);
 		ea_size = unpacked_ea_size(ea);
 
@@ -217,6 +218,10 @@ static ssize_t ntfs_list_ea(struct ntfs_
 			break;
 
 		if (buffer) {
+			/* Check if we can use field ea->name */
+			if (off + ea_size > size)
+				break;
+
 			if (ret + ea->name_len + 1 > bytes_per_buffer) {
 				err = -ERANGE;
 				goto out;


