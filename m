Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCB4CA6F;
	Sat, 12 Sep 2026 11:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211454; cv=none; b=rpVwbeP8gcS7PYd1tCPmVFZbU77LQ8nsyILPsa1WXFmmFOg5/I/k2IVF5vcmtFr3j/wYHE0tOm3XRtSmgdKC/9YDOLGM0i6Ko6dHcCHJqV3kiSqJGHO/4Rn+G6ZvsgBzFf7W93/85qIYDHL8gYMoUTMy2i6JAQLMhljTbtfl/iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211454; c=relaxed/simple;
	bh=ssXwNHo5v5OEaqoqRwK5AVFwt1k76IE67yxsKxHcWYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HEyYmRSX3q8/cu47rV+sjRX6YEwF3Y5EbRM/MpBXak/dCDomlHq8J9e0nT+S5r5o6Go/lp20eEt2VSfcPmLKxvw8kTel3sDKVw+xFtMSs2oNo2jeyc++2HJavnJcAjH3UC3RvA/NYk2t3lkd02VvoXeXhiFCpgs7VU9t8gaurpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NG8ovV19; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NG8ovV19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584CD1F000FF;
	Sat, 12 Sep 2026 11:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211453;
	bh=6XSLs3pS7YvivHjIpohdGY6fOgvynDTcsNn2Qpy0C0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NG8ovV19x3elnbr6B+hfNCzmH5UpIcVQMSV6Q2Ub8lU1I7VUm9/6prJbrrZ0chQhQ
	 /Cc+mGM0D6qRRfmzmLvWfSeCRYkuk9l3RV+oIOhRTB0PcWvCQrnBoy7TkKjJ7A+NVG
	 95WHFWmS8FT+/BeDxu32uu8a6Xu1p2XMibQYQRmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1232/1518] smb/server: fix invalid pointer dereference in ksmbd_stop_durable_scavenger()
Date: Sat, 12 Sep 2026 08:56:41 +0200
Message-ID: <20260912065651.375409370@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



