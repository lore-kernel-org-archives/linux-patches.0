Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964A544AB7B;
	Tue, 21 Jul 2026 22:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671444; cv=none; b=uuSGsSDGk5x0154zLZuxAIgVKBzLM+Feuwx/AYLT4ZciQ+v2Z+uIPo/lk7FzLZ/c58rE6dGN+GPvmGSiATgfMy+wyeeF4ZoEgnqbHxgAAT3bBg0yooMH03aK7weFUAwVAfHhXI6J13SXLrp8DC1Eghb8eTw0Hyb01BMtviCxQI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671444; c=relaxed/simple;
	bh=XAnWLeDdCIatrd1hsYKr0r5G02ADjGL42zkVCYCban0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYWWXB7u1SXeutuECYLIO9gfSEmjIOt/2wa2iRFXtQejD3yUqHp8tgS7ZeOl9tqxGuD3w8rNMpNcVnDS7utbZEPZOqSYtkyqpCZxrIhSRYmvpS8qI8EEzz4bg1zmK0kAonLizZrBUEoluFtRgRw9Rs7VuJfLFRP3L8UG4rAuWB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQwgySIS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQwgySIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81B71F000E9;
	Tue, 21 Jul 2026 22:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671443;
	bh=QzxcKXZJquo+H18xqE+GJvVtPUsYmUqnfEaQrzGpHRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQwgySISW1aNxs1wEFfgMVsli5Kq8j5anPZ5ZDsYEms62Wko31odRk9HlMVDrgaal
	 AgHelPpDY608bC+6UUrk4c3q5BhpQOZsNB91jG90xCr1iAMJmK1edP7WrwGTz+XMzA
	 f2xwSnvBJ/qRTLWDVcwaDsDeLGM5SrhAuQsrDLM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Tejun Heo <tj@kernel.org>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 247/843] sysfs: clamp show() return value in sysfs_kf_read()
Date: Tue, 21 Jul 2026 17:18:02 +0200
Message-ID: <20260721152411.573886846@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fd55a4a04d6df0..5a741ac108d3a8 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -117,6 +117,10 @@ static ssize_t sysfs_kf_read(struct kernfs_open_file *of, char *buf,
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



