Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470E9214A84;
	Sat, 12 Sep 2026 12:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216353; cv=none; b=FMkhVa2DNKKkl4uhK06KEsiGePF06RAU8cDYtezlqS1qeVaYTFvIV+VNcQ0P/EcUtZ4fok+8I4LPYCk2j/mI9MU0BDazhBJLuUi4SqnrU7OcRUqzVx6XPFoeF/JKWiBaZecI3yRYpfHMtBUp09P6bi9AXFq3x0PAr7gpa3A3xYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216353; c=relaxed/simple;
	bh=HDrtCgUxrWlLopiH3tV49xLRR7xE6ODyCr4VPQJ3yME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ulMUWzLKSjOwqC+7pYQyQBd9aJzClbu6VaPc4r2rb55kM6bjYTmc2sN900T9y3GtxgxLJAf1im8ZfCwgN31aoyJmSxlB7ScbLId/S5hPalHH4CEsut7FRONC1dLOPJ7nMtLFvUkGN36rtiyTttgfjDeyDdk5/YLZ1CAkuxAJfHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zCBI3VZA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zCBI3VZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006591F000FF;
	Sat, 12 Sep 2026 12:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216352;
	bh=dzHna9Hbg92RBRWKEqUdCiaFK6VUDNesBwidyFBF6bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zCBI3VZAEnbzj9a7iFbLrSBIhEMKZzPkAH50AQooKFeo2wNDSeDNQGZgPKnfOlCb0
	 v6RwMnWyiMpWSIOL3SwrhaTi3PbQeeOzS4JMCnuEN4ZvSqFIWF8O+tXV1NxNBjBzwA
	 EKtRx1BxfAZz7+2bUpJ8iS46CX4+LzSO53IOuJHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cae54346a70bbceeff2c@syzkaller.appspotmail.com,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0719/1376] nilfs2: fix infinite loop in nilfs_clean_segments()
Date: Sat, 12 Sep 2026 08:52:25 +0200
Message-ID: <20260912065623.566444227@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Crofts <joshua.crofts1@gmail.com>

[ Upstream commit ce5a5ad1a8330a2fcfdd9ec2ab341be739e89a18 ]

syzbot reported a hung task in nilfs_transaction_begin(). This occurs
because the cleaner ioctl falls into an infinite loop if
nilfs_segctor_construct() repeatedly returns -EROFS (e.g. the device
is remounted as read-only after an I/O error).

Currently in nilfs_clean_segments(), if err is non-zero, it logs the
error and sleeps but doesn't abort when it encounters a terminal error
like -EROFS. This causes the thread to loop forever.

Fix this by breaking out of the loop if nilfs_segctor_construct()
returns -EROFS. This matches the behaviour in
nilfs_segctor_write_out(), which also handles -EROFS.

Reported-by: syzbot+cae54346a70bbceeff2c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cae54346a70bbceeff2c
Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
Assisted-by: gemini:gemini-3.1-pro
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/segment.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 657a72f941b90..c598c2a4262a1 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2580,6 +2580,10 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 			break;
 
 		nilfs_warn(sb, "error %d cleaning segments", err);
+
+		if (unlikely(err == -EROFS))
+			goto out_unlock;
+
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(sci->sc_interval);
 	}
-- 
2.53.0



