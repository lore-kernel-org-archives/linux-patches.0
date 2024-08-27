Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56EB73466;
	Tue, 27 Aug 2024 15:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771538; cv=none; b=oF7yeOn1jjaI1zRryQJ5vEkA6v79+eL9Jf4nv4S3MIJf0m4swJ1XO54zvr2QJ4U7UPGGcJ1pU38Trky4MXLABzKHzTkOAXROlqiWltLwWH5vbYVLZT7pFBLG+oYgwBjjstx+LyNAz8Utbs693+4XGrvkiOFxgKDmu5GpIyQp7Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771538; c=relaxed/simple;
	bh=KT7CYcECZnpXz1OKnXwNlsf/YaNbmvpBUeoTsMTJf8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VhUWrACDlptGPpsk87J6YxhIPOGy4vZc+tBvlImrqkiEdj/I6yCtlyG2BFtwKaPd6Ut6cIDWVWZIQ9Ky7HNCroKvF7OYEAFIjAGVkLlnji+eztgcovSpDzPlD065egRLJ/6wjECrbzUc9CknQ2NuftpbfHnZs5VvyiJCda1B0MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K851oKy+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K851oKy+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2728CC4DDFE;
	Tue, 27 Aug 2024 15:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771538;
	bh=KT7CYcECZnpXz1OKnXwNlsf/YaNbmvpBUeoTsMTJf8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K851oKy+DC/KBmk801KWbz9OaouLyAsMuwIT82qyY7JUmwHYQk6NsNBAJqhulQ1cy
	 7jUf0HvFlmMWzyyt0Sv2ZsCwukAzLYPXJwIQqOj5/BrMosqpCTfm5c59vRtUR//q71
	 J/9Tgu7i4M8Zqw48KoQar8MdwRJY34KD9xxLanVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Ruibin <11162571@vivo.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 218/273] thermal/debugfs: Fix the NULL vs IS_ERR() confusion in debugfs_create_dir()
Date: Tue, 27 Aug 2024 16:39:02 +0200
Message-ID: <20240827143841.703822818@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Ruibin <11162571@vivo.com>

[ Upstream commit 57df60e1f981fa8c288a49012a4bbb02ae0ecdbc ]

The debugfs_create_dir() return value is never NULL, it is either a
valid pointer or an error one.

Use IS_ERR() to check it.

Fixes: 7ef01f228c9f ("thermal/debugfs: Add thermal debugfs information for mitigation episodes")
Fixes: 755113d76786 ("thermal/debugfs: Add thermal cooling device debugfs information")
Signed-off-by: Yang Ruibin <11162571@vivo.com>
Link: https://patch.msgid.link/20240821075934.12145-1-11162571@vivo.com
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/thermal_debugfs.c b/drivers/thermal/thermal_debugfs.c
index 9424472291570..6d55f5fc4ca0f 100644
--- a/drivers/thermal/thermal_debugfs.c
+++ b/drivers/thermal/thermal_debugfs.c
@@ -178,11 +178,11 @@ struct thermal_debugfs {
 void thermal_debug_init(void)
 {
 	d_root = debugfs_create_dir("thermal", NULL);
-	if (!d_root)
+	if (IS_ERR(d_root))
 		return;
 
 	d_cdev = debugfs_create_dir("cooling_devices", d_root);
-	if (!d_cdev)
+	if (IS_ERR(d_cdev))
 		return;
 
 	d_tz = debugfs_create_dir("thermal_zones", d_root);
@@ -202,7 +202,7 @@ static struct thermal_debugfs *thermal_debugfs_add_id(struct dentry *d, int id)
 	snprintf(ids, IDSLENGTH, "%d", id);
 
 	thermal_dbg->d_top = debugfs_create_dir(ids, d);
-	if (!thermal_dbg->d_top) {
+	if (IS_ERR(thermal_dbg->d_top)) {
 		kfree(thermal_dbg);
 		return NULL;
 	}
-- 
2.43.0



