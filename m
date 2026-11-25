Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619900;
	b=3kFYPOSLJv/z3/c5BYHNlz9b/qnsGyzfw5PZwiep4DwHgZjrhgA5SajW6h62WhDaOjmC
	 i28jPhcwM48xVZETCfm59wl7GdKh9NL+zPL0XQmpIcllfH8h55lNYEXAptjlex8ZZbffG
	 7TB1TFDrKYrTDwSRmkUGDnn+gN6SQKeRVE5LUhGS7oHjmTvJS3aK1zk3U+XK65+zxYrdY
	 DkNL1IleePJ/CJ5hGmxJB3FneFJm9RNHOHDIH5TwDfKdzoL2H8rhFlBAcQI8EEJ70Qu3D
	 d6wr8jtCmJqFD0zLh+otdTlmc4ggadPrjzrwftsuumCPNW9+RUlwIG/1L2Ksd7BNecQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619900;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ao+9z2RNVE+D26inig4GSVdDX2Yz2u60a3y/Cw1+4vE=;
	b=U4Ays4DYroPJg9+7G0Qxq7E/l+MeRj3yIWaqNZsitQU0pQVOPDuo+ySfn86vEB3F84e3
	 oBim6JAZbZ5IGL/c+Frppayx6U03eFJXvabMEO4W8FcuRQ2SqiUUflY06T9wy8fnswhz+
	 d81vMgPUaj5w0/CMa8bx9PtkwRVdsAJaSzokFrzy0VLvZC/SjM3El38cxeB1jkOcm0jUT
	 q1Y8XR5fiQcqPmvDH+LzWTZsdf9310sxhLVxqTxAyJeA6OQTZ2Cgf5hdgZ6NH47trB5Ps
	 l++suRiwhVAVPlfWJQU5wHb5qDtURlBr1pAWEgI+MGjHBTxBo/7BNoohBR8W22w/Ocg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e5WRjdqV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0800B606A323;
	Wed, 25 Nov 2026 15:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e5WRjdqV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA9C1F000CF;
	Wed, 25 Nov 2026 15:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619899;
	bh=ao+9z2RNVE+D26inig4GSVdDX2Yz2u60a3y/Cw1+4vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e5WRjdqVrLUzBFaZQquNF9nvS+KQaePKhQ6TozChxn/yGGAL8OoORPotywhlXPb4E
	 1QiU/sl3pVeeeK6RupOsuJJ9zFk/z24ON0TEWpdoZjquZFt2XqxLM89rpubJHOaIe8
	 GTKK+4dkKL0gXp/k0IYGJjTs7ODwGu9O7stiHLXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 0698/1005] ext2: dont read the inode block in ext2_sync_inode_metadata()
Date: Wed, 25 Nov 2026 15:33:56 +0100
Message-ID: <20261125143838.106534541@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit c2e595a57aba6aa166053776969f31cc510b3e71 upstream.

ext2_sync_inode_metadata() looks the inode block up with
ext2_get_inode() which reads it from disk if it isn't cached. But a
block that isn't cached is neither dirty nor under writeback, so there's
nothing to write or to wait for.

That read is also something we can't afford once inode eviction calls
->sync_inode_metadata() from reclaim. So look the block up with
sb_find_get_block_nonatomic() instead, the way fat_sync_inode_metadata()
already does.

Cc: stable@vger.kernel.org # v7.3
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20261109-work-inode-metadata_writeback-v3-2-91ac6c024018@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext2/inode.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1578,19 +1578,22 @@ int ext2_write_inode(struct inode *inode
 int ext2_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
 {
 	struct buffer_head *bh;
-	struct ext2_inode *raw_inode = ext2_get_inode(inode->i_sb, inode->i_ino,
-						      &bh);
+	unsigned long block, offset;
 	int err = 0;
 
-	if (IS_ERR(raw_inode))
+	if (ext2_inode_block(inode->i_sb, inode->i_ino, &block, &offset))
 		return -EIO;
 	err = mmb_sync(&EXT2_I(inode)->i_metadata_bhs);
 	if (err) {
 		ext2_error(inode->i_sb, __func__,
 			"Error syncing inode metadata ino=%lu\n",
 			(unsigned long)inode->i_ino);
-		goto out;
+		return err;
 	}
+	/* A block that isn't cached is neither dirty nor under writeback. */
+	bh = sb_find_get_block_nonatomic(inode->i_sb, block);
+	if (!bh)
+		return 0;
 	sync_dirty_buffer(bh);
 	if (buffer_write_io_error(bh)) {
 		ext2_error(inode->i_sb, __func__,
@@ -1598,7 +1601,6 @@ int ext2_sync_inode_metadata(struct inod
 			(unsigned long)inode->i_ino);
 		err = -EIO;
 	}
-out:
 	brelse(bh);
 	return err;
 }


