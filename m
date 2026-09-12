Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E045D35F602;
	Sat, 12 Sep 2026 09:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204179; cv=none; b=Pd74BxOYcqYJ9snScD0BSF8TL7uCXiqMTCtCwmm2GrTrKRJv5rYDnTf4DoDm7MyHzd+n8BNKhzsNpikZVAdpc8/hmmj6AJIPBsBuJ9HVLvHpgg5MbrV7OfL/3c6oJNJdwBiQYkrsoY5tz6ycUJD4PdehEKay1gfetPTCEeNplnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204179; c=relaxed/simple;
	bh=JaU31ehF0o8P640/YhDocKUaD0RbzVnKTJ/U/qB2PiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/pYH1SSZ5VI54knebdqZfZTL/Y6enbMs+pRrVJNIyPihHEfLjakVMG+nZMDo+Fc/LKz972wF8Wdxeyrs+dSpDwRN0GamDcHpt4Bnp7oK6v18akUATR5GubnO9gAm3KD4MSymMztFPD9UPNjYaHxvtA/0AUw4hgblxuxxbvGi2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=srVaU8td; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="srVaU8td"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1F11F000FF;
	Sat, 12 Sep 2026 09:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204177;
	bh=r2b0nj/xPi9z7wghjG/Hv2c0ZvFq1MKxnfvRRUEyS/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=srVaU8tdzQL5wx5QjppbJqUkW5PmxaI4uAqvc2I62InZFysoT75aeKKl2JYOyB4Qn
	 DF2ONh70UTvTcYDCJkZy56EZDZBpCqSN4lojh7H1450E7JTUzoc2eP1S3UGIgpeqWz
	 tfmNoIyROsEIJx/g3/S7LJ7Ey6gFZBEUeG9ALM/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1516/1815] smb/server: fix invalid pointer dereference in ksmbd_stop_durable_scavenger()
Date: Sat, 12 Sep 2026 08:54:26 +0200
Message-ID: <20260912065724.590779526@linuxfoundation.org>
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
index 0efef8c8176c2..460684624678f 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1499,9 +1499,12 @@ void ksmbd_launch_ksmbd_durable_scavenger(void)
 
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



