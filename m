Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1C51BDF1;
	Wed,  3 Jan 2024 17:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="liJGq7H3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA74C433C7;
	Wed,  3 Jan 2024 17:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301996;
	bh=7rSU44KfVMzft8HDi2OpPcVaL6WQutqqSgxvfUtz3Tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=liJGq7H361PTooEc8XHQAulLDruREUHeSyGy8Y6gKtQ77PIUK0STVYhqUMSqA4Cte
	 KHgvSBYUsfEYIF2f6bAjE0p8Ky857iVE/MBqLgRXUC43xIGhjwKjLIJrPMxHoEHsDE
	 fe1RQuLKnhaPjVGzN4zED1M1uRkG/wJOxa3Gg/rU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 02/49] ksmbd: reorganize ksmbd_iov_pin_rsp()
Date: Wed,  3 Jan 2024 17:55:22 +0100
Message-ID: <20240103164835.326998351@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 1819a904299942b309f687cc0f08b123500aa178 ]

If ksmbd_iov_pin_rsp fail, io vertor should be rollback.
This patch moves memory allocations to before setting the io vector
to avoid rollbacks.

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/ksmbd_work.c | 43 +++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/fs/smb/server/ksmbd_work.c b/fs/smb/server/ksmbd_work.c
index 51def3ca74c01..a2ed441e837ae 100644
--- a/fs/smb/server/ksmbd_work.c
+++ b/fs/smb/server/ksmbd_work.c
@@ -95,11 +95,28 @@ bool ksmbd_queue_work(struct ksmbd_work *work)
 	return queue_work(ksmbd_wq, &work->work);
 }
 
-static int ksmbd_realloc_iov_pin(struct ksmbd_work *work, void *ib,
-				 unsigned int ib_len)
+static inline void __ksmbd_iov_pin(struct ksmbd_work *work, void *ib,
+				   unsigned int ib_len)
 {
+	work->iov[++work->iov_idx].iov_base = ib;
+	work->iov[work->iov_idx].iov_len = ib_len;
+	work->iov_cnt++;
+}
+
+static int __ksmbd_iov_pin_rsp(struct ksmbd_work *work, void *ib, int len,
+			       void *aux_buf, unsigned int aux_size)
+{
+	struct aux_read *ar;
+	int need_iov_cnt = 1;
 
-	if (work->iov_alloc_cnt <= work->iov_cnt) {
+	if (aux_size) {
+		need_iov_cnt++;
+		ar = kmalloc(sizeof(struct aux_read), GFP_KERNEL);
+		if (!ar)
+			return -ENOMEM;
+	}
+
+	if (work->iov_alloc_cnt < work->iov_cnt + need_iov_cnt) {
 		struct kvec *new;
 
 		work->iov_alloc_cnt += 4;
@@ -111,16 +128,6 @@ static int ksmbd_realloc_iov_pin(struct ksmbd_work *work, void *ib,
 		work->iov = new;
 	}
 
-	work->iov[++work->iov_idx].iov_base = ib;
-	work->iov[work->iov_idx].iov_len = ib_len;
-	work->iov_cnt++;
-
-	return 0;
-}
-
-static int __ksmbd_iov_pin_rsp(struct ksmbd_work *work, void *ib, int len,
-			       void *aux_buf, unsigned int aux_size)
-{
 	/* Plus rfc_length size on first iov */
 	if (!work->iov_idx) {
 		work->iov[work->iov_idx].iov_base = work->response_buf;
@@ -129,19 +136,13 @@ static int __ksmbd_iov_pin_rsp(struct ksmbd_work *work, void *ib, int len,
 		work->iov_cnt++;
 	}
 
-	ksmbd_realloc_iov_pin(work, ib, len);
+	__ksmbd_iov_pin(work, ib, len);
 	inc_rfc1001_len(work->iov[0].iov_base, len);
 
 	if (aux_size) {
-		struct aux_read *ar;
-
-		ksmbd_realloc_iov_pin(work, aux_buf, aux_size);
+		__ksmbd_iov_pin(work, aux_buf, aux_size);
 		inc_rfc1001_len(work->iov[0].iov_base, aux_size);
 
-		ar = kmalloc(sizeof(struct aux_read), GFP_KERNEL);
-		if (!ar)
-			return -ENOMEM;
-
 		ar->buf = aux_buf;
 		list_add(&ar->entry, &work->aux_read_list);
 	}
-- 
2.43.0



