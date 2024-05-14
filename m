Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5E753370;
	Tue, 14 May 2024 10:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682513; cv=none; b=kccNtmgYaKyRlVygfabgBYrq1sOgC3wqympefblEYeJV/141FpLu+6p2bKB8wHUuOcD1xBf4cYxUCj4jxMB3Uu/0C0IWMptJV80YOx2FT2kBEs/VEYrNLa5dbQ9HKWfPJnXCmm6czbU9AfYVFPZWPgm7EiMDMzp+OOgq6T5MYyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682513; c=relaxed/simple;
	bh=jwfZb6m8bD/mvEumnU+IVxX63AifYsWl9Ect2+wjoRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjCAU//Omi/yJKaLxuq4T+GqKo5ZqG0mkrzax2pbh2WnJ7qoPW9Qtfk/NuCSR7jr7QUbo9s4ysbVYKjBUZe/azVjJsX6187pz5zdQznCa5VV7WQM7apkoZa8+K8u33dmAafWWTxAuiBOMKLAoNnmyY61nbazgqJcwyg9/FVc1m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b56fvDlt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b56fvDlt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51EE9C2BD10;
	Tue, 14 May 2024 10:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682513;
	bh=jwfZb6m8bD/mvEumnU+IVxX63AifYsWl9Ect2+wjoRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b56fvDltmfyOMgEtpVh7Io+GysVMZZJgxmPcUMM4syZJO+Bq+WhNfM/H/2P12/PEZ
	 Ss794h2ZPh75DBmrzVoiV5qoy0ZN6ab6MlY5sipSkUqM3VNSYLizYMCE6ZWsQliYON
	 Jha/qBuCGL4FpfZY4JklyLQ12NIVi2ULjAzNj36I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 043/336] ice: ensure the copied buf is NUL terminated
Date: Tue, 14 May 2024 12:14:07 +0200
Message-ID: <20240514101040.234750157@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bui Quang Minh <minhquangbui99@gmail.com>

[ Upstream commit 666854ea9cad844f75a068f32812a2d78004914a ]

Currently, we allocate a count-sized kernel buffer and copy count bytes
from userspace to that buffer. Later, we use sscanf on this buffer but we
don't ensure that the string is terminated inside the buffer, this can lead
to OOB read when using sscanf. Fix this issue by using memdup_user_nul
instead of memdup_user.

Fixes: 96a9a9341cda ("ice: configure FW logging")
Fixes: 73671c3162c8 ("ice: enable FW logging")
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
Link: https://lore.kernel.org/r/20240424-fix-oob-read-v2-1-f1f1b53a10f4@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_debugfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_debugfs.c b/drivers/net/ethernet/intel/ice/ice_debugfs.c
index c2bfba6b9ead6..66aa9759c8e7e 100644
--- a/drivers/net/ethernet/intel/ice/ice_debugfs.c
+++ b/drivers/net/ethernet/intel/ice/ice_debugfs.c
@@ -174,7 +174,7 @@ ice_debugfs_module_write(struct file *filp, const char __user *buf,
 	if (*ppos != 0 || count > 8)
 		return -EINVAL;
 
-	cmd_buf = memdup_user(buf, count);
+	cmd_buf = memdup_user_nul(buf, count);
 	if (IS_ERR(cmd_buf))
 		return PTR_ERR(cmd_buf);
 
@@ -260,7 +260,7 @@ ice_debugfs_nr_messages_write(struct file *filp, const char __user *buf,
 	if (*ppos != 0 || count > 4)
 		return -EINVAL;
 
-	cmd_buf = memdup_user(buf, count);
+	cmd_buf = memdup_user_nul(buf, count);
 	if (IS_ERR(cmd_buf))
 		return PTR_ERR(cmd_buf);
 
@@ -335,7 +335,7 @@ ice_debugfs_enable_write(struct file *filp, const char __user *buf,
 	if (*ppos != 0 || count > 2)
 		return -EINVAL;
 
-	cmd_buf = memdup_user(buf, count);
+	cmd_buf = memdup_user_nul(buf, count);
 	if (IS_ERR(cmd_buf))
 		return PTR_ERR(cmd_buf);
 
@@ -431,7 +431,7 @@ ice_debugfs_log_size_write(struct file *filp, const char __user *buf,
 	if (*ppos != 0 || count > 5)
 		return -EINVAL;
 
-	cmd_buf = memdup_user(buf, count);
+	cmd_buf = memdup_user_nul(buf, count);
 	if (IS_ERR(cmd_buf))
 		return PTR_ERR(cmd_buf);
 
-- 
2.43.0



