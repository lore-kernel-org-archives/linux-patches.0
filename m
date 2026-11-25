Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621508;
	b=VbsIw9xrWf+D3NEg8o6vUioCfAkvHB7L1DFzAxwN8XRruNEgGplMxSl7jLpx4AEMDvHI
	 w+ClKzNxMxbDRNSERYTWPY3LvNcYTfAhWHiWLItfJP+nvChWK5hmRW5oAVQGKfm4rK8hW
	 8+0jdfdvgs7mT5QPZM4Xmiz471+3TTedLos4N/bR8OSKs74AVZszLbciuSAt73MX+fzTS
	 kyuyUv8cHDYahWAUispWaFl7BWKDIfkQxQYVY1nsdtZp0DJ2ZRmDG1KHI/8F3eA3cuCHI
	 7EEcaenViwb0t4bX3GOUxE9OsKZ9qBaG+ZEEDXGZi0jZTv/EJu+zmt8cxuJfAdbLZ7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621508;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5sd3yGWHCp4Gq1Ou98+roC3EaWGhgO4mDLtigFXRBr8=;
	b=N5/fd9484jv2xG342YGUe23S368p/kRxTIOmL5Vp9sCofFaR0bCjwsAcd1jmuPfpTh7V
	 gsf56EJRW6jKt7cwcK4y+25nZhhS/QfAwcXjT6hr5eQNZFYNXdD2SEqQtUhkHcijBGgzL
	 pH52IxDLk4Ho310Uf2Z74/DSCekyBqIvrKprGG4i5jTcCtF7R6SlL1OmGvSkfs38huC2e
	 V5GlLU7t+Aoixf3EsCWpWQmtTz+EYIkesTEHIGEGoGnN9HAEuE+RPGuKV9fpzFeN9QWfG
	 HM03MhwSAUYW+eoLyL7/KlMnVx/CH2W7l6pypy3joRbbjM81z1QdpSTmAzL7quAU3+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RBuN4VBg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C4B606A326;
	Wed, 25 Nov 2026 15:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RBuN4VBg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 698781F000C0;
	Wed, 25 Nov 2026 15:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621508;
	bh=5sd3yGWHCp4Gq1Ou98+roC3EaWGhgO4mDLtigFXRBr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RBuN4VBgrDKGZvxF9E2CHfiGsasUCz4/ee9fymFrMAUDDxoYzGPONgFXD/5j+h1TB
	 /SR+prXkeYL8hrk5LVw08rkrj6FmoBKiWohfcb6iEjJt7pgP8tSufmXAcqTEsaAx2Y
	 g0YlDLgZtjNdwxPnP7u5yrFJGUvzeheqyhqshi7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 210/990] ext2: only flush DIRSYNC directories on every change
Date: Wed, 25 Nov 2026 15:26:17 +0100
Message-ID: <20261125143827.009723958@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 3f57fc2c49ed05ccfc56e4dc9eda41be95925bbd ]

Every change of an ext2 directory is written to disk before the system call
returns, whether the directory is DIRSYNC or not: its pages with
filemap_write_and_wait() and its inode with sync_inode_metadata().

Writes which reach the device for 2000 files, and 200 directories, in a
directory without DIRSYNC, with the flusher turned off:

            create   rename   unlink   mkdir
    before    4000     8000     4000     800
    after        0        0        0       0

In a directory with chattr +D the numbers are those of "before", before and
after.

commit bc943f4872a7 ("ext2: Don't flush page immediately for DIRSYNC
directories") moved the flush from ext2_commit_chunk() to the new
ext2_handle_dirsync().  The IS_DIRSYNC() check which was around it didn't
move along.

Fix by putting the check into ext2_handle_dirsync().

Fixes: bc943f4872a7 ("ext2: Don't flush page immediately for DIRSYNC directories")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261027-b4-ext2-dirsync-v1-1-3dcd012d518d@toxicpanda.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext2/dir.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index b07b3b369710c..3143983f31284 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -441,6 +441,9 @@ static int ext2_handle_dirsync(struct inode *dir)
 {
 	int err;
 
+	if (!IS_DIRSYNC(dir))
+		return 0;
+
 	err = filemap_write_and_wait(dir->i_mapping);
 	if (!err)
 		err = sync_inode_metadata(dir, 1);
-- 
2.53.0



