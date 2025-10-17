Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD3E2F692A;
	Fri, 17 Oct 2025 15:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713457; cv=none; b=tezYr9Ejzt9eRFZsHRMHdjpH2HMa7VZ2Xmaf0+pywlpn00bcbC2oFKIuqSe43A10fkMGppa/czpzZFoy1q9qWxzYSBnm6wp/sRIPxeQ+wfnebiYjPt/O0aW1QUBYDy+oV5lFCw2JOXqE1zCGnYU9nAASWbhWwEUJ16RVbv7sYM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713457; c=relaxed/simple;
	bh=PQEZccgGy071jIsXefEyVtn2JibVLm4abhIWzg/FRfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AdrKJ6q0J1cofO8nSC9rORKaOurm5vaaexCOb7j6kIdYaLSzeh3MqRCy0MGlFiQdQXQk9BRJvjrYe/INaIwwY15dFNaZ1vpRIHGIqo7wr3QpQol6u0iGq61uVFi+34zTnyC2AYRC7Iyu0OikGc3xk1EGYSYh6b208fhd9aLHFq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/HDa13Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/HDa13Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12731C4CEF9;
	Fri, 17 Oct 2025 15:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713457;
	bh=PQEZccgGy071jIsXefEyVtn2JibVLm4abhIWzg/FRfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1/HDa13YIFVzc/Mw8tXGgb1zc0BEq5ZuJIWGadwoEx452dXcVjZ+TRiDoJ2wr9FKN
	 kzl0hPdg5LmVoNPkGm92dyqXFmV9cQC0uv6UT2AXd3mL/Ui6Vvbah0HVc5odxZKAgn
	 RgYD4dZK4MBohUnrldpmAF0a0esBKDdE2Oe2GQeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Nicolas Pitre <nico@fluxnic.net>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 165/168] cramfs: Verify inode mode when loading from disk
Date: Fri, 17 Oct 2025 16:54:04 +0200
Message-ID: <20251017145135.127436525@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6dae27d6f553f..9979187a4b3c5 100644
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



