Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2042248BC8;
	Wed, 15 Jan 2025 10:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937621; cv=none; b=SGBt93Fmq+8vxLpWZ/UKT+Rk1ypPdgl0bSK2h2ozXdVNgnLabC1zvm8i3kXDFGiW0/fSj63/eP+XRp3HYK4olTqc+9OZSDC485VfmoWTULYWMnDq+nSQ1hjXHJI1nhiTgBgmB8E98eB4jiwoXiUxFrBK6JdgGJhmEjSakttGAcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937621; c=relaxed/simple;
	bh=UBDxkXAx1fC4ti45nCXz3JD1acRGerPzBtoLxFjDqNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s61y1CenKRzOJi/c+/Q8JdzfWnAwQpAU/ShApBzP8a2kUtT2oHl0GDsHZcKkb0AthVZW3XSpQ50h3ncxZA2yChlYKTeSlmCvZ1u8mEzcX+86TqR0RUlgZ1nHgWUueHhcTilsera9XmB0sRUR4r/RJXvssLPMpsKlLKH/FPE7+J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RuZowKRq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RuZowKRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3A2C4CEE1;
	Wed, 15 Jan 2025 10:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937621;
	bh=UBDxkXAx1fC4ti45nCXz3JD1acRGerPzBtoLxFjDqNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RuZowKRqBUcYaZk6nQItC7YpLSkoNkrrwEEW0F0+GpEn7VIxLEu2bFv5cCKk3g1Gs
	 F/vVtpsjDcYpuCyjI3MeOVeEg2W+e5i4ZlaE7HX45a8NNGcYlo5zv+Y+/3VZIjwPBH
	 T87mgrggYwwjZ1jnK0wDuuRUJ6RFCBN7GcuqoM7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	He Wang <xw897002528@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 34/92] ksmbd: fix unexpectedly changed path in ksmbd_vfs_kern_path_locked
Date: Wed, 15 Jan 2025 11:36:52 +0100
Message-ID: <20250115103548.892780488@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: He Wang <xw897002528@gmail.com>

[ Upstream commit 2ac538e40278a2c0c051cca81bcaafc547d61372 ]

When `ksmbd_vfs_kern_path_locked` met an error and it is not the last
entry, it will exit without restoring changed path buffer. But later this
buffer may be used as the filename for creation.

Fixes: c5a709f08d40 ("ksmbd: handle caseless file creation")
Signed-off-by: He Wang <xw897002528@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index eaae67a2f720..396d4ea77d34 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1249,6 +1249,8 @@ int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *name,
 					      filepath,
 					      flags,
 					      path);
+			if (!is_last)
+				next[0] = '/';
 			if (err)
 				goto out2;
 			else if (is_last)
@@ -1256,7 +1258,6 @@ int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *name,
 			path_put(parent_path);
 			*parent_path = *path;
 
-			next[0] = '/';
 			remain_len -= filename_len + 1;
 		}
 
-- 
2.39.5



