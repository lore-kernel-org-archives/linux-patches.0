Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090F52FDC5C;
	Tue, 26 Aug 2025 14:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218021; cv=none; b=l7Ixwea/IrjWrRsD/CZo2JqszFCA6xoNTYU4lSgxFIjwczwSPCaYdEFlvTBEmpiC8aAtw+UR4HPPSEVwnbBOmbmcgOVSL4UhQ8nOZCSXCJ+R+rEJXYgSL+1UhneQcWw5qIJ+sbTB8qMwV5LZNb/7S6n5FjMx3faQrqeu1yE47h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218021; c=relaxed/simple;
	bh=aRHoPkLuIux3zLwh04/17rxVWr3E/XOHuZ3242kXus8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m97qh88llV3Vekdpqq9tC3bnLNuy/f18hVMJykbhukdYO8k9Hkxcufxz+a+xId1k0Lpj3k3Jb3hCB7YIZo4ebmOYJAsiFS3DTayohy9tBfgesXZBfm+N9KZ0PwOPYFkpxpBd8IJkhkWPrkNWhiQXHqkpn12WXSjaoKvFBXYtNTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNvKIjXE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNvKIjXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39774C4CEF1;
	Tue, 26 Aug 2025 14:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218020;
	bh=aRHoPkLuIux3zLwh04/17rxVWr3E/XOHuZ3242kXus8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fNvKIjXECr6/0e0v7+NiYHFpxHn+xniL/H8Wg1HKQNVfPbMInYnsgVOBDHzSUOIGt
	 5v1PmGg1AZ9M5GRyv58VVIPoTkn1EfkFRtq+AQUHGDbZJzAyFeR3uPQCrmccBKqNHc
	 AoNGc2mzAunFFbvmJONS4LmpK5xmJ91XhxFjDSEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Dilger <adilger@whamcloud.com>,
	Li Dongyang <dongyangli@ddn.com>,
	Alex Zhuravlev <bzzz@whamcloud.com>,
	Oleg Drokin <green@whamcloud.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 363/523] ext4: check fast symlink for ea_inode correctly
Date: Tue, 26 Aug 2025 13:09:33 +0200
Message-ID: <20250826110933.423733008@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Dilger <adilger@dilger.ca>

commit b4cc4a4077268522e3d0d34de4b2dc144e2330fa upstream.

The check for a fast symlink in the presence of only an
external xattr inode is incorrect.  If a fast symlink does
not have an xattr block (i_file_acl == 0), but does have
an external xattr inode that increases inode i_blocks, then
the check for a fast symlink will incorrectly fail and
__ext4_iget()->ext4_ind_check_inode() will report the inode
is corrupt when it "validates" i_data[] on the next read:

    # ln -s foo /mnt/tmp/bar
    # setfattr -h -n trusted.test \
               -v "$(yes | head -n 4000)" /mnt/tmp/bar
    # umount /mnt/tmp
    # mount /mnt/tmp
    # ls -l /mnt/tmp
    ls: cannot access '/mnt/tmp/bar': Structure needs cleaning
    total 4
     ? l?????????? ? ?    ?        ?            ? bar
    # dmesg | tail -1
    EXT4-fs error (device dm-8): __ext4_iget:5098:
        inode #24578: block 7303014: comm ls: invalid block

(note that "block 7303014" = 0x6f6f66 = "foo" in LE order).

ext4_inode_is_fast_symlink() should check the superblock
EXT4_FEATURE_INCOMPAT_EA_INODE feature flag, not the inode
EXT4_EA_INODE_FL, since the latter is only set on the xattr
inode itself, and not on the inode that uses this xattr.

Cc: stable@vger.kernel.org
Fixes: fc82228a5e38 ("ext4: support fast symlinks from ext3 file systems")
Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
Reviewed-by: Li Dongyang <dongyangli@ddn.com>
Reviewed-by: Alex Zhuravlev <bzzz@whamcloud.com>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Reviewed-on: https://review.whamcloud.com/59879
Lustre-bug-id: https://jira.whamcloud.com/browse/LU-19121
Link: https://patch.msgid.link/20250717063709.757077-1-adilger@dilger.ca
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -148,7 +148,7 @@ static int ext4_meta_trans_blocks(struct
  */
 int ext4_inode_is_fast_symlink(struct inode *inode)
 {
-	if (!(EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL)) {
+	if (!ext4_has_feature_ea_inode(inode->i_sb)) {
 		int ea_blocks = EXT4_I(inode)->i_file_acl ?
 				EXT4_CLUSTER_SIZE(inode->i_sb) >> 9 : 0;
 


