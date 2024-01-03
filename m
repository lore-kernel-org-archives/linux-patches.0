Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743D21BDFB;
	Wed,  3 Jan 2024 17:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yT/fH086"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF1EC433C8;
	Wed,  3 Jan 2024 17:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301977;
	bh=+1tkok2SteLYX+UySW/Fv9wJFzMaunLK1znomRKTji8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yT/fH086b+IfjSgYxuqjdJI8ETyZDW7VDm6279AGqRHCQXvxzJmhc3KC6zlWrsnIY
	 HhimQ9pLGKh0t29m+E51BAqg7z3qpFjnVHNZcI2hI/ftGHYdMJfQdkeL3bEHbtQ8Pq
	 ojF6hMBMC954NWCeP3tgE/nEnp+mkNunggNILGpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 11/49] ksmbd: release interim response after sending status pending response
Date: Wed,  3 Jan 2024 17:55:31 +0100
Message-ID: <20240103164836.749850826@linuxfoundation.org>
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

[ Upstream commit 2a3f7857ec742e212d6cee7fbbf7b0e2ae7f5161 ]

Add missing release async id and delete interim response entry after
sending status pending response. This only cause when smb2 lease is enable.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/ksmbd_work.c | 3 +++
 fs/smb/server/oplock.c     | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/ksmbd_work.c b/fs/smb/server/ksmbd_work.c
index 2510b9f3c8c14..d7c676c151e20 100644
--- a/fs/smb/server/ksmbd_work.c
+++ b/fs/smb/server/ksmbd_work.c
@@ -56,6 +56,9 @@ void ksmbd_free_work_struct(struct ksmbd_work *work)
 	kfree(work->tr_buf);
 	kvfree(work->request_buf);
 	kfree(work->iov);
+	if (!list_empty(&work->interim_entry))
+		list_del(&work->interim_entry);
+
 	if (work->async_id)
 		ksmbd_release_id(&work->conn->async_ida, work->async_id);
 	kmem_cache_free(work_cache, work);
diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 9bc0103720f57..50c68beb71d6c 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -833,7 +833,8 @@ static int smb2_lease_break_noti(struct oplock_info *opinfo)
 					     interim_entry);
 			setup_async_work(in_work, NULL, NULL);
 			smb2_send_interim_resp(in_work, STATUS_PENDING);
-			list_del(&in_work->interim_entry);
+			list_del_init(&in_work->interim_entry);
+			release_async_work(in_work);
 		}
 		INIT_WORK(&work->work, __smb2_lease_break_noti);
 		ksmbd_queue_work(work);
-- 
2.43.0



