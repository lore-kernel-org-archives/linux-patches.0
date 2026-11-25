Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619665;
	b=MKHmTIO+sEGLStzSOu6rvP0OXeL4UF7qngShOutZ2m3plT4B8sHNe/+RsjlYbupQE7k9
	 TNLU4uEZ9jd9yjDeZ0AgVrz9J/OJVA9mnhNKi4NftQ39g4YpESRoN44IaLez50agArRSa
	 aD2bJNk7Dh88PbFjXV5kIBOL6xBuIdmUxnh3aGPlOlGuOsBPnxLjQ2XCdOKHQlTpfYPaa
	 EvJAdBHrPioHWJ/DcD8DuEeAjyNpMRAtwsqd+vKqYvsPTmJiEJE+9QCIC2roSUy/mT7Mw
	 5VpB0DvrwIXQpL34nFcpt2w4iwxw6913iVXDefuOzPIyb9IlqaH/zjSpVTZmkpLIjrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619665;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tYkwyW+S7+R4ohhKBKJUNjzLX8D+nQUnr4RVHxbEGk4=;
	b=vF0Ydbl/1Hh9FTKEZxwpWYFdHMzKCELLCP3po92CLAQOltkJHszmMSPy7CWHLNt/u0U4
	 z2/A3PWxu8gQSnuCCdF3RQFy64XvdVzzH4OYIikEQuUwccMxT1DesAf0+ZdDUbKlhUzoD
	 OAN1yGH4EvqJyHNmAJKl9Llt1mzzI/8csOp0F7RlNwRMJ8SmWABnziLSLVzXqXDetJ1wo
	 Mj91oblu8lFJdSp6PCtWRy+zkGmWda8DGzsUC1/qIOZ0e6S+fFzqC1jFwBFRCJ0ax4ORt
	 0t3GfV5C30q6L/OzsqvlSfpwvqMa3qrYCc0EFB1q9+FTjl4PxbFx9BkfatIQO7aZRTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hlC2LTtg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719BF606A6B1;
	Wed, 25 Nov 2026 15:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hlC2LTtg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C11E1F000E0;
	Wed, 25 Nov 2026 15:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619665;
	bh=tYkwyW+S7+R4ohhKBKJUNjzLX8D+nQUnr4RVHxbEGk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hlC2LTtgxWy2CTM5smO8URVRa1XlDpaMzC5/PdMC84c1QAdre0Izlj/MsU14yX7SK
	 YnpaYKM9GNTyuj60VyxLdoOmRfAwyN1z7uMaEP7TLk7i6TAN0C2Ir6aXZu6cFXw35x
	 9qbB3MYX4mnsMW3Dv+I3qr4xe3eFEYMX9OOQxSDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 0670/1005] minix: dont read the inode block in minix_sync_inode_metadata()
Date: Wed, 25 Nov 2026 15:33:28 +0100
Message-ID: <20261125143837.446148369@linuxfoundation.org>
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

commit ccb8bbf93985d89f60d904386e27aad60f34dbbf upstream.

minix_sync_inode_metadata() looks the inode block up with
minix_V1_raw_inode() or minix_V2_raw_inode() which read it from disk if
it isn't cached. But a block that isn't cached is neither dirty nor
under writeback, so there's nothing to write or to wait for.

That read is also something we can't afford once inode eviction calls
->sync_inode_metadata() from reclaim. So look the block up with
sb_find_get_block_nonatomic() instead.

Cc: stable@vger.kernel.org # v7.3
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20261109-work-inode-metadata_writeback-v3-6-91ac6c024018@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/minix/inode.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 670179173645..756bef4dc832 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -702,24 +702,24 @@ static int minix_sync_inode_metadata(struct inode *inode,
 {
 	int err = 0;
 	struct buffer_head *bh;
-	void *raw_inode;
+	int block;
 
-	if (INODE_VERSION(inode) == MINIX_V1)
-		raw_inode = minix_V1_raw_inode(inode->i_sb, inode->i_ino, &bh);
-	else
-		raw_inode = minix_V2_raw_inode(inode->i_sb, inode->i_ino, &bh);
-	if (!raw_inode)
+	block = minix_inode_block(inode->i_sb, inode->i_ino);
+	if (!block)
 		return -EIO;
 	err = mmb_sync(&minix_i(inode)->i_metadata_bhs);
 	if (err)
-		goto out;
+		return err;
+	/* A block that isn't cached is neither dirty nor under writeback. */
+	bh = sb_find_get_block_nonatomic(inode->i_sb, block);
+	if (!bh)
+		return 0;
 	sync_dirty_buffer(bh);
 	if (buffer_write_io_error(bh)) {
 		printk("IO error syncing minix inode [%s:%08llx]\n",
 			inode->i_sb->s_id, inode->i_ino);
 		err = -EIO;
 	}
-out:
 	brelse(bh);
 	return err;
 }
-- 
2.56.1



