Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9469B12F59D;
	Tue, 14 May 2024 11:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686763; cv=none; b=Tb1dJQkTLk7ZUuHEwmSMvqXruhniF7CAb3FZaFstfAQD2+szO/ur45+l/Ke1cPgDBYow4R9If8TcrswkxOjFiiA68zdC9VQKcv+WM/gLtjr2RLl8bF2LoY0L3cCpJa3E1wG5jWDuF2YUKVToKXj5lfQjGithBgnJGas9hpDPAzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686763; c=relaxed/simple;
	bh=Q/zBasQwvcVtjakgwyHpi8oLauqGBN4eerJ3Z4S+v/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYdV4NtK0WFfL5//UYKeoSdnRmd6n5jCzP2jAvpUAJfaADzGoSbF7DKnAvX5gF5hBchSQJ2zWP1ZvHkBffXrUxv/R3Hk+CE8ziqF9zrpojAqVFMt8ddE9E9vuKmf1xzvTHU24z3f5CIAMxdQp7cbSGrx19pLekmDUg0dHSbA2IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ci4exsFG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ci4exsFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F3AC2BD10;
	Tue, 14 May 2024 11:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686763;
	bh=Q/zBasQwvcVtjakgwyHpi8oLauqGBN4eerJ3Z4S+v/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ci4exsFGmujkaiPGkQ/urbkehF2FhBPRPQ0TYmUbyBsnhF+FNMfN9rIbDby8W12v1
	 aa66/SF3L8dRpr5vaqkdzE5+6I9/kIoYl4sOITZ9RHowpanaUW+lJaBeGhyGU/Ir+n
	 N3eYz56XFsDxUP0RosyS0ThbtZqDjOAh+HAAthY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 14/63] bna: ensure the copied buf is NUL terminated
Date: Tue, 14 May 2024 12:19:35 +0200
Message-ID: <20240514100948.553071160@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bui Quang Minh <minhquangbui99@gmail.com>

[ Upstream commit 8c34096c7fdf272fd4c0c37fe411cd2e3ed0ee9f ]

Currently, we allocate a nbytes-sized kernel buffer and copy nbytes from
userspace to that buffer. Later, we use sscanf on this buffer but we don't
ensure that the string is terminated inside the buffer, this can lead to
OOB read when using sscanf. Fix this issue by using memdup_user_nul
instead of memdup_user.

Fixes: 7afc5dbde091 ("bna: Add debugfs interface.")
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
Link: https://lore.kernel.org/r/20240424-fix-oob-read-v2-2-f1f1b53a10f4@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/brocade/bna/bnad_debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bnad_debugfs.c b/drivers/net/ethernet/brocade/bna/bnad_debugfs.c
index 933799be0471b..d549fdb6bbe2e 100644
--- a/drivers/net/ethernet/brocade/bna/bnad_debugfs.c
+++ b/drivers/net/ethernet/brocade/bna/bnad_debugfs.c
@@ -320,7 +320,7 @@ bnad_debugfs_write_regrd(struct file *file, const char __user *buf,
 	void *kern_buf;
 
 	/* Copy the user space buf */
-	kern_buf = memdup_user(buf, nbytes);
+	kern_buf = memdup_user_nul(buf, nbytes);
 	if (IS_ERR(kern_buf))
 		return PTR_ERR(kern_buf);
 
@@ -380,7 +380,7 @@ bnad_debugfs_write_regwr(struct file *file, const char __user *buf,
 	void *kern_buf;
 
 	/* Copy the user space buf */
-	kern_buf = memdup_user(buf, nbytes);
+	kern_buf = memdup_user_nul(buf, nbytes);
 	if (IS_ERR(kern_buf))
 		return PTR_ERR(kern_buf);
 
-- 
2.43.0



