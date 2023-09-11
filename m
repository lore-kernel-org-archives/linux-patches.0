Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD15011721
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC96C433C8;
	Mon, 11 Sep 2023 14:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442647;
	bh=D1b2nTQTAYDX+QYMXp+MdxoF9yrU6h6lTx4RUifODzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MDMSqFpMTblL2uDJmGWUvyoQAm7HS8u1dG5t7HSro1MgLQjZI/BIeAQGw+fTMuzs6
	 MOGpiJa5Zi6+Kj0xt/iJbcBTwpIV2ExkxsWkh5QVljT18Lkmug8WKi3VvT+1J6QABy
	 hmXRza2gr5wymI909fIZELN8rPNa3EdsVUv3e7ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ahelenia=20Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 099/737] splice: fsnotify_access(fd)/fsnotify_modify(fd) in vmsplice
Date: Mon, 11 Sep 2023 15:39:18 +0200
Message-ID: <20230911134653.277007397@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>

[ Upstream commit 7f0f1ea069e52d5a16921abd59377a7da6c25149 ]

Same logic applies here: this can fill up the pipe and pollers that rely
on getting IN_MODIFY notifications never wake up.

Fixes: 983652c69199 ("splice: report related fsnotify events")
Link: https://lore.kernel.org/linux-fsdevel/jbyihkyk5dtaohdwjyivambb2gffyjs3dodpofafnkkunxq7bu@jngkdxx65pux/t/#u
Link: https://bugs.debian.org/1039488
Signed-off-by: Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>
Acked-by: Jan Kara <jack@suse.cz>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Message-Id: <8d9ad5acb9c5c1dd2376a2ff5da6ac3183115389.1688393619.git.nabijaczleweli@nabijaczleweli.xyz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/splice.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/splice.c b/fs/splice.c
index 90abe551acb78..c08eb445a1d20 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1346,6 +1346,9 @@ static long vmsplice_to_user(struct file *file, struct iov_iter *iter,
 		pipe_unlock(pipe);
 	}
 
+	if (ret > 0)
+		fsnotify_access(file);
+
 	return ret;
 }
 
@@ -1375,8 +1378,10 @@ static long vmsplice_to_pipe(struct file *file, struct iov_iter *iter,
 	if (!ret)
 		ret = iter_to_pipe(iter, pipe, buf_flag);
 	pipe_unlock(pipe);
-	if (ret > 0)
+	if (ret > 0) {
 		wakeup_pipe_readers(pipe);
+		fsnotify_modify(file);
+	}
 	return ret;
 }
 
-- 
2.40.1



