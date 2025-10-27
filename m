Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D043324B3E;
	Mon, 27 Oct 2025 18:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590708; cv=none; b=blz1xJ13HAOv2Ui7eYvb/WpKv+0gPma3/+WaUwgjImLRGP5SVp7wL5pd+dW0SYZP+bxmWQ4kEfShEQd+Atku/Mzssokn8CEaOp3eeRwjmTLX4JJn0SM3ABInVIbENXfCXURaCsoNRy1hV8GKYhG5YUqQSO2aj/MH6oWjQNL9OpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590708; c=relaxed/simple;
	bh=bVASHqVP1tj+GTGHxqHzdPdb+VfVIPQwquhKKeh6WBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6KPY3DxbKMNtw9UB6dNFKv0X4zf624Q/aZTjishWFoAzD4gXNxVHIMEMVNam5H+MqrZeI6mcQ14kP5snKFmaDY6gH5hFJy26MqLHGxi7evW329d8/euAikwJTVJcUfB+ooFum5B2n6gyQGJZfvzRaAVkcBT9W58NrqBUAjRwSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pnB9asSX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pnB9asSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76699C113D0;
	Mon, 27 Oct 2025 18:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590705;
	bh=bVASHqVP1tj+GTGHxqHzdPdb+VfVIPQwquhKKeh6WBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pnB9asSXWxfaiZhC/aSurjj/dXEGMPCVnP9yl+IbsIkIH7Y9rY44nFeVKDR0HcNFS
	 fEdMsUMP4XsRrrxtEFog1T8uqfLOi5Hd7DrorX3VgubPOxLU2gLFAJhOaao6HQF6yX
	 8NtflhSbHg3qW/PR9DbBDyJKVJM85dTyoEMXfohc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Nicolas Pitre <nico@fluxnic.net>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 147/224] cramfs: Verify inode mode when loading from disk
Date: Mon, 27 Oct 2025 19:34:53 +0100
Message-ID: <20251027183512.904888894@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 7f9d34b0a7cb93d678ee7207f0634dbf79e47fe5 ]

The inode mode loaded from corrupted disk can be invalid. Do like what
commit 0a9e74051313 ("isofs: Verify inode mode when loading from disk")
does.

Reported-by: syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=895c23f6917da440ed0d
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Link: https://lore.kernel.org/429b3ef1-13de-4310-9a8e-c2dc9a36234a@I-love.SAKURA.ne.jp
Acked-by: Nicolas Pitre <nico@fluxnic.net>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cramfs/inode.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index 2f04024c3588e..82c45ca453216 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -117,9 +117,18 @@ static struct inode *get_cramfs_inode(struct super_block *sb,
 		inode_nohighmem(inode);
 		inode->i_data.a_ops = &cramfs_aops;
 		break;
-	default:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFIFO:
+	case S_IFSOCK:
 		init_special_inode(inode, cramfs_inode->mode,
 				old_decode_dev(cramfs_inode->size));
+		break;
+	default:
+		printk(KERN_DEBUG "CRAMFS: Invalid file type 0%04o for inode %lu.\n",
+		       inode->i_mode, inode->i_ino);
+		iget_failed(inode);
+		return ERR_PTR(-EIO);
 	}
 
 	inode->i_mode = cramfs_inode->mode;
-- 
2.51.0



