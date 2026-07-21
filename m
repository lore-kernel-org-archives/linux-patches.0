Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D913EEAC7;
	Tue, 21 Jul 2026 19:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661620; cv=none; b=BNg7ElkbTWWW/AdrsuRiqFSLNnFHrYt+f6SQ5DLXCFjX6ZwrIia01L9S19ESK6ArorpZk4y/x8Dn3LvXTd0JlQUTy6qN+0/ySPC14REVqqQHmbv3VpStBEJ9sqRA116oYvq+TwUjDOkYILqQotkj9XxoTjmSfyP6U/ZdtU+z+Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661620; c=relaxed/simple;
	bh=twEqCyPRisVu+84AuEQVSxA3QG+v9OP4R1+75quBvt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abZfzInsq9KhtRXW+Uh0ChclxuRgP1nOw52YNw3MqJTHD0uluBtIs5c7TLt5Z7+gJpvtrP5MYUwvshvamFWJkV12htwaWZOTWxM6+1M5tscqWTEk8ptcym5063B/JyKpFKaZjy/bDGSIsxrZzvsKw5eW40WoXeE5mdvr6TYLm3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KkstqI0L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KkstqI0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DC61F000E9;
	Tue, 21 Jul 2026 19:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661619;
	bh=UAbpgd5MHd0MmL45vnuSxPZX2zs2508quwVJowArV5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KkstqI0Lc8g2gXh12ijiAxvslWZOlD4px9WPAs5gsTYoO81nI+Ztamw4fyXnblnZ4
	 N9a0Sk0x3EcvKENfRRKMbe74mZg9xCQoW+JeaNIlH4DSENDmXCARe+yQEmJijRURuO
	 IR8RKyqtN7HipDZoYhNBFzaI0HIqFTCFpTsK+8C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Tejun Heo <tj@kernel.org>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0133/1276] sysfs: clamp show() return value in sysfs_kf_read()
Date: Tue, 21 Jul 2026 17:09:36 +0200
Message-ID: <20260721152449.078379568@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 454257f6d124a92342dcbb7710c03dd6ef96c731 ]

sysfs_kf_seq_show() defends against buggy show() callbacks that return
larger than PAGE_SIZE by clamping the value and printing a warning.
sysfs_kf_read(), the prealloc variant, has no such defense.

The only current in-tree user of __ATTR_PREALLOC is drivers/md/md.c,
whose show() callbacks are well-behaved, so this is hardening against
future drivers doing foolish things and out-of-tree code doing even more
foolish things.

Cc: NeilBrown <neil@brown.name>
Cc: Tejun Heo <tj@kernel.org>
Fixes: 2b75869bba67 ("sysfs/kernfs: allow attributes to request write buffer be pre-allocated.")
Assisted-by: gregkh_clanker_t1000
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patch.msgid.link/2026052000-drove-unicycle-d61b@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/sysfs/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index d1995e2d6c943a..c76a8b81102bf9 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -114,6 +114,10 @@ static ssize_t sysfs_kf_read(struct kernfs_open_file *of, char *buf,
 	len = ops->show(kobj, of->kn->priv, buf);
 	if (len < 0)
 		return len;
+	if (len >= (ssize_t)PAGE_SIZE) {
+		printk("fill_read_buffer: %pS returned bad count\n", ops->show);
+		len = PAGE_SIZE - 1;
+	}
 	if (pos) {
 		if (len <= pos)
 			return 0;
-- 
2.53.0



