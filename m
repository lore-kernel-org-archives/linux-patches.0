Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58996568FB4;
	Thu, 17 Sep 2026 15:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658959; cv=none; b=FBYPz3K/kdgqRhk5HsoQa+/rEG6Oz9nSlQG8yjd+sfeK+Erj42Zw06xdL2Q5LuPp/oYrBk2JGbSv3Z7qqKQdZobeTfoSFjCakdrkxugJSfN05Ps/Slog8hEG+t1g0cCEtkhSARa5ncDHuc/5kOEmb1kEO/b3A2EtK6QxRTNTiI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658959; c=relaxed/simple;
	bh=RhnkZBoK/ijxYu7uwqu8jgkspl6FyPtEh7wvZzmRi4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0ygKr7hacqxQS/GPZ/PgewtysO4KMfx0hhoOx4gSyh5u7hDciz5MtOaiS+soKfFVBK02mck9l2vD/wX7Evl1taF+Jw6XZqtdRfYjLaVM99sHaGVB8KlhvOyzdbKe0ngA2nrdYkqtph4hUQY1PAgwJIpx3YrzGRSHQVZg+qeDf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0XoQi+rm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0XoQi+rm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8681F00898;
	Thu, 17 Sep 2026 15:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658949;
	bh=GS215ZXMwZW7Y7AseNit+AQ6rMDdBJLxrbrVm8yf9xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0XoQi+rmmMlFmkWm0GDzl1baH9GptkpTfF2PTgW1DN6lAPYJQ5Bg5VqcaMT4Zm5jw
	 K8eNw484KrKVIIH99gW3c8xszXanzs+SRGQbwi2JPjusAJGJ/YRo1lS//hOETO4doM
	 TOHC0T5tmI/u2LlxqoJ6BxNUyVva0vl+Ye0iEEB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 094/733] ovl: return EINVAL instead of EIO in case of mismatched user_ns
Date: Thu, 17 Sep 2026 16:06:42 +0100
Message-ID: <20260917151353.276363171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit a518e63c377574784f49653ef5314c70e2463b0c ]

The EIO was used to signal an internal error (commit 9efb069de4ba ("ovl:
add warning on user_ns mismatch")), which is no longer the case.

Fixes: 63981fc786da ("ovl: don't warn when the mount is completed from another user namespace")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Link: https://patch.msgid.link/20260825152330.850645-1-mszeredi@redhat.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 60b808b85fc43..43eb0c053dacd 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1543,7 +1543,7 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 	struct ovl_fs *ofs = sb->s_fs_info;
 	int err;
 
-	err = -EIO;
+	err = -EINVAL;
 	/* The fscontext fd may have been passed to another user namespace. */
 	if (fc->user_ns != current_user_ns())
 		goto out_err;
-- 
2.53.0



