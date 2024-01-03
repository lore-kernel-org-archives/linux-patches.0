Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D652A1BDFB;
	Wed,  3 Jan 2024 17:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bP3H/e31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D34C433C8;
	Wed,  3 Jan 2024 17:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704302020;
	bh=9cP8oIGuFO+183kGZp8bD2g4rBDZkwymgnvv1NejaDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bP3H/e31YJ9fDaCwcK+XCOSLkeZKcjvbQM5LM2v97FgrQaq8NVQRkdfuXeZaa0kYF
	 bdYl1EzvuzJ1V0kVLoCnxqkB4R/qI1vo4sz2TVvduwQw0JEeFoR7irk9DTWvS4zn+C
	 Z18PGz/oHnWandTS61c844sGoWF4XuCkpU9R/8GY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Zongmin Zhou <zhouzongmin@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 08/49] ksmbd: prevent memory leak on error return
Date: Wed,  3 Jan 2024 17:55:28 +0100
Message-ID: <20240103164836.239995488@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164834.970234661@linuxfoundation.org>
References: <20240103164834.970234661@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zongmin Zhou <zhouzongmin@kylinos.cn>

[ Upstream commit 90044481e7cca6cb3125b3906544954a25f1309f ]

When allocated memory for 'new' failed,just return
will cause memory leak of 'ar'.

Fixes: 1819a9042999 ("ksmbd: reorganize ksmbd_iov_pin_rsp()")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202311031837.H3yo7JVl-lkp@intel.com/
Signed-off-by: Zongmin Zhou<zhouzongmin@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/ksmbd_work.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/ksmbd_work.c b/fs/smb/server/ksmbd_work.c
index a2ed441e837ae..2510b9f3c8c14 100644
--- a/fs/smb/server/ksmbd_work.c
+++ b/fs/smb/server/ksmbd_work.c
@@ -106,7 +106,7 @@ static inline void __ksmbd_iov_pin(struct ksmbd_work *work, void *ib,
 static int __ksmbd_iov_pin_rsp(struct ksmbd_work *work, void *ib, int len,
 			       void *aux_buf, unsigned int aux_size)
 {
-	struct aux_read *ar;
+	struct aux_read *ar = NULL;
 	int need_iov_cnt = 1;
 
 	if (aux_size) {
@@ -123,8 +123,11 @@ static int __ksmbd_iov_pin_rsp(struct ksmbd_work *work, void *ib, int len,
 		new = krealloc(work->iov,
 			       sizeof(struct kvec) * work->iov_alloc_cnt,
 			       GFP_KERNEL | __GFP_ZERO);
-		if (!new)
+		if (!new) {
+			kfree(ar);
+			work->iov_alloc_cnt -= 4;
 			return -ENOMEM;
+		}
 		work->iov = new;
 	}
 
-- 
2.43.0



