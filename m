Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350E73DB62E;
	Sat, 12 Sep 2026 09:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203971; cv=none; b=O7h1Rqj/SX/pHHeR4ud+mZSU+J02/9PBDLGcDe3bJNpVWSbW/32sJSzf7Zb3fWI8DADQOVcramYXUg9rxvwoCaFLtzag53uLohe4q8uG0hnpiU6FHtdsjftnNf4H+jsPjw7AiYp0zgUcjVO+I64IgI1j//ALfAfsWVPyGAUkaV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203971; c=relaxed/simple;
	bh=pUAZ7EGgeApC4CTsp/o7CiRTyU7sds1csOwvM6MmQd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nl5dZzCLZMPYNhxV8qvknZHALZ9Cv0jtCSzL2Ct8De0bGQhtdJIe6sSuGYXNWRZaXgJDbpJsrcavH01zx+ZrOBsjOK6YUkvA7bz59+DpnKmGOF6CvIPNvm469X8mN2edzviNiUYoxasbjMWjq0jdnP2TKkLm7cRItRX3xcjd5cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6AGhHTy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6AGhHTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0341F000FF;
	Sat, 12 Sep 2026 09:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203970;
	bh=9aulei0TkD5r186YJaAq9S0mXicDLdYmCYCPkkZ+tbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g6AGhHTyKb1nZAnw81emFWe+wjtDFl0xm3t/B0WZJIQu+KAE8WfUKDSv718TCDoxa
	 qHp64NJyb6FOnr5tZmuBxPigbiiE0Y5wDbF2PnW0RmIG9tjNf55RuABt+VyVHOQ5HY
	 sRCCzDUQwmk6JP9JHXXHz4y+8f+Ko2mrE+feeQDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1518/1815] smb/server: call ksmbd_proc_cleanup() on module init failure
Date: Sat, 12 Sep 2026 08:54:28 +0200
Message-ID: <20260912065724.638864240@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhangGuoDong <zhangguodong@kylinos.cn>

[ Upstream commit f43cbe3b58ce989ce420c3bc875d48e7754c8aba ]

When a later initializer fails, the unwind chain releases resources
created after procfs and then jumps directly to class_unregister().
Returning an error from module_init() leaves the proc tree and its
per-CPU counters allocated.

Fixes: b38f99c1217a ("ksmbd: add procfs interface for runtime monitoring and statistics")
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/server.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index a67ecd765e5d2..c629a33bfa4a8 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -619,11 +619,11 @@ static int __init ksmbd_server_init(void)
 
 	ret = server_conf_init();
 	if (ret)
-		goto err_unregister;
+		goto err_proc_cleanup;
 
 	ret = ksmbd_work_pool_init();
 	if (ret)
-		goto err_unregister;
+		goto err_proc_cleanup;
 
 	ret = ksmbd_init_file_cache();
 	if (ret)
@@ -669,6 +669,8 @@ static int __init ksmbd_server_init(void)
 	ksmbd_exit_file_cache();
 err_destroy_work_pools:
 	ksmbd_work_pool_destroy();
+err_proc_cleanup:
+	ksmbd_proc_cleanup();
 err_unregister:
 	class_unregister(&ksmbd_control_class);
 
-- 
2.53.0



