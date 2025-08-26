Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503B235208D;
	Tue, 26 Aug 2025 13:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216606; cv=none; b=QsbpGZmsG/1DfedSTFSD2ow7vIcmav/3+yYrupbKFe5nZ2NNS28Z0S3oefxVK5mcB8of2TsmBzo3LZwzhZyeJDqm2QV4QCLS1jKmZXuixkflz0VsPvFArMlYtzodXhqTh0tiaP7hA+ZcJFMcUlsQZWuNTesIosi125yOKLTAGiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216606; c=relaxed/simple;
	bh=9Q5iH8VzX2q+ISFCXxQN/lCHq0otVs/PbLayw1NdYJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWdwnqQ8+O3YMDCC+ocexn7fulpS8TJEkO/5RBjZcEW13/Ad3L+Z3oVusxCkazAC/0NmOQxClUeaFKDLWygp+xP4rgqjm+iOrNPElfKhh3j/BxoFvUE3RSpb4JX41eaT463xU663YbfHgbgMqF4Z+Nm2Uup9jbvHpjk99QtYnwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yaNoPkce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yaNoPkce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D74C113D0;
	Tue, 26 Aug 2025 13:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216606;
	bh=9Q5iH8VzX2q+ISFCXxQN/lCHq0otVs/PbLayw1NdYJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yaNoPkceudNSedJFpl5dSdApRdsB2ej3fxeFFDMHkVf+ZKiq2o7hDaW9UriHwhqIB
	 L1uf/EnQCJy/sgbtc8ooMjlVB2X3eQu0R2YozWmD0r0rhO4n9y3/GGlko6AEYQjCuu
	 jw9bO2J+qbkmyuIMbQLUBWCFW+PrjTJmpnYjl2N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Dilger <adilger@whamcloud.com>,
	Li Dongyang <dongyangli@ddn.com>,
	Alex Zhuravlev <bzzz@whamcloud.com>,
	Oleg Drokin <green@whamcloud.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 467/644] ext4: check fast symlink for ea_inode correctly
Date: Tue, 26 Aug 2025 13:09:18 +0200
Message-ID: <20250826110958.053810398@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


