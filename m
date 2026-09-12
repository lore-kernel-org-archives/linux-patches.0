Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E5D412276;
	Sat, 12 Sep 2026 11:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212908; cv=none; b=osmT7p/ysrQ4zn5yjcAK1sMP2kBGluiHezXqPcEgBVjaQoFXz1Wfx7Om8w6nxjEAV82/1iz/lzOeWy3f3e6DVyL6GMT2n9VtTNyfZLRuZmCAUPHu+vTPKhqpe4lT5U0Ec0UmOmKU/ukHYZJFYidcnmRETQ06458R2KmnhbbSdto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212908; c=relaxed/simple;
	bh=DdlKP9wBitxfwVOnnhP+uP4hOSN9LNuhchjA3gZTVEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3mh8UD6vZ0REftLPcAEDPm2Ukyt546YQUIdQZ4tXvwmCSnhMQIM7yN8PqW0PrqZhPwLfncmjnJsKZgcMoR973DZzswz3ONJTxK//SRUz+66LDJzxTPYqNsuZVRpaJsC+CFgCYTt1Vvwo7XjQL/w5uhlgOEVl7jw3eQU9GFiY9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pi618gyr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pi618gyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA8F1F0089C;
	Sat, 12 Sep 2026 11:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212906;
	bh=w2YLQPq4YwYBoeWlCDakGMCsT7BhA1xC5VqhJJuOlMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pi618gyrgOhIX+NjwNHg9gZp8zRbZqsueIdQ3pyI/FpywGtfjWB9Givoq0LYcmBlV
	 +D7o0X/JDX7JQY2IZgx++ZzcMaEmKfDPUm8/i/hLD+uDWMnKQmXwTuYKBAqaj87JHL
	 P5WGR6WjJPalaWS1/7Fgy5ZCCyYO31wpFhmParMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sun Jian <sun.jian.kdev@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Youngjae Kwon <yjkwon0026@snu.ac.kr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0014/1376] fsnotify: inotify: pass mark connector to fsnotify_recalc_mask()
Date: Sat, 12 Sep 2026 08:40:40 +0200
Message-ID: <20260912065607.867316079@linuxfoundation.org>
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

From: Sun Jian <sun.jian.kdev@gmail.com>

[ Upstream commit 4520b96b8136ba2465a3f4dc5c3fb8bdf3d92e4e ]

fsnotify_recalc_mask() expects a plain struct fsnotify_mark_connector *,
but inode->i_fsnotify_marks is an __rcu pointer.  Use fsn_mark->connector
instead to avoid sparse "different address spaces" warnings.

Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
Link: https://patch.msgid.link/20260214051217.1381363-1-sun.jian.kdev@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
(cherry picked from commit 4520b96b8136ba2465a3f4dc5c3fb8bdf3d92e4e)
Signed-off-by: Youngjae Kwon <yjkwon0026@snu.ac.kr>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/inotify/inotify_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index e5ccd5572beb6..024be6cee849f 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -562,7 +562,7 @@ static int inotify_update_existing_watch(struct fsnotify_group *group,
 	fsn_mark->flags |= inotify_arg_to_flags(arg);
 	spin_unlock(&fsn_mark->lock);
 
-	fsnotify_recalc_mask(inode->i_fsnotify_marks);
+	fsnotify_recalc_mask(fsn_mark->connector);
 
 	/* return the wd */
 	ret = i_mark->wd;
-- 
2.53.0



