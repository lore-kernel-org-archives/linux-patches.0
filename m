Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9338B23D2B1;
	Sat, 12 Sep 2026 13:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218547; cv=none; b=pZOe+FSl52fgS33jto6D1iwDV5Agt5Jau2ma0IqnJXublzyj//gEsBuocRdqbBnVEb0Jglth2TUP00iDsWXWEBH02pJszKGmM1uy6Fjw6u2VafpakHli4HtWR+ktrfNUwyld8uG51DzHap89cSc1Fc0glFb9ZqQ+wo7ZmB7csIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218547; c=relaxed/simple;
	bh=iXU/CxHbs8jWSlHdRsz/NH0QQTqk5+qeBDR9/8cnMC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FELxh3RAWO5nVngyMmW97nTIibg3bJiv+YNk2WNHV7sTSqOG8Pqm+L7h6Gx2roeMQPllw0WlYPJpk2N0RFCxgu35kwL6VA1ynJ3amcdUUw+MnL0iW2P33mse14HmYUjD/9SXVKZBVTAq7Ihs8xH/eElE/7dFcBPIuhjR6DNhwUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZBqZg2YH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBqZg2YH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CBA1F000FF;
	Sat, 12 Sep 2026 13:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218546;
	bh=3ttTicDbz8BvGsNXZtyKjZgt1D8JFj+b3y6xcJD+5k4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZBqZg2YHNRmZsb6QCE1WS+onZDjJ9nur0F7WGRipAVY6uK7PHBJ3jQcezQ09fxafY
	 0y3+rm4xjKluD9ccSPw/GbRQsg2SqJSpDAnx+SuBbkAjUS21sc0+sLawxHQ0+j1Dhw
	 XEA0qn3t1OAJTm0/uSbj8njP9LCXnH3+fSmaJwmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1168/1376] smb/server: fix invalid pointer dereference in ksmbd_stop_durable_scavenger()
Date: Sat, 12 Sep 2026 08:59:54 +0200
Message-ID: <20260912065633.583084045@linuxfoundation.org>
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

From: ZhangGuoDong <zhangguodong@kylinos.cn>

[ Upstream commit bef46b604732d83f8da29f782868de4d25bf972c ]

See the procedure below:

  ksmbd_launch_ksmbd_durable_scavenger
    durable_scavenger_running = true
    server_conf.dh_task = kthread_run() // fail, dh_task is an ERR_PTR()

  server_ctrl_handle_reset
    ksmbd_stop_durable_scavenger
    kthread_stop(server_conf.dh_task) // invalid pointer

Fixes: d484d621d40f ("ksmbd: add durable scavenger timer")
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs_cache.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 8b5f50ac61e2f..0b654021bec07 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1103,9 +1103,12 @@ void ksmbd_launch_ksmbd_durable_scavenger(void)
 
 	server_conf.dh_task = kthread_run(ksmbd_durable_scavenger,
 				     (void *)NULL, "ksmbd-durable-scavenger");
-	if (IS_ERR(server_conf.dh_task))
+	if (IS_ERR(server_conf.dh_task)) {
 		pr_err("cannot start conn thread, err : %ld\n",
 		       PTR_ERR(server_conf.dh_task));
+		server_conf.dh_task = NULL;
+		durable_scavenger_running = false;
+	}
 	mutex_unlock(&durable_scavenger_lock);
 }
 
-- 
2.53.0



