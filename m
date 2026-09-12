Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92A72D0C94;
	Sat, 12 Sep 2026 19:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241892; cv=none; b=IIYjdEuSMAUpUYjUNq6wBFPg4bIH3RUkV7oJHnvA0JIDslAF4iiBnR7dMFvmw2la7umTU9TgQAbtu9yEosJjDAB0syPfmXEQOefLHTHNIZzk6ORM3R4wsPhMSbD1rkaeFxNH7n1xVb75TTKCKLNdRGipZ0iToSWQJFt0mglHQ5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241892; c=relaxed/simple;
	bh=M/fJMl3tPr5LhtC9FNUTye6pyIvgPoOMo3oyvLAz4Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7z8e6vjTNvNsXsG469HOoGhCV9+kiDRQWJLxVCD46QfTMrzimqWzqK1lhYawovA2ej/VmYvObVQwviXipudctnGWWmuy70ShPOWW3eNzQBIp4jV3LQLQj+6sK5u4NUW1ZFqhG7FmjfuQjAVDiXDiB9sET1rPVEAlX6SNU+8PRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jfk4EO4a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jfk4EO4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813491F000FF;
	Sat, 12 Sep 2026 19:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241891;
	bh=GNxyfKcj6cqmlSw1Tw12xD+/H15bwdbWs+ycwaRl5XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jfk4EO4a+vLQ+/F9FCDqMt3Ap4t2ai86bdjsrQnJX1s3EhJuf+6VBEznFG1bQFkpp
	 /97TcjowFFthrwotkThlEr4dgy/gqnv+x5y1JP9vcfRurOY+Snwzry/9ENgL1Ogja4
	 RTyxStzRhi6a/lrjPKqQZCp8uiZrGCXbGkQ85dwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 228/798] dm: fix resume-vs-remove race
Date: Sat, 12 Sep 2026 08:57:36 +0200
Message-ID: <20260912065522.365886167@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 44b43ec132f1cf3275ecc182d0c82f50c3c4c3d5 upstream.

If the user issues the resume ioctl and the remove ioctl at the same
time, it may be possible that the device is resumed after it is suspended
in __dm_destroy. The result is that the table is destroyed without
calling the postsuspend method.

Dm targets expect that they may be removed only after the postsuspend
method method was called. If we break this expectation, it can cause
misbehavior in various targets. For example - in the dm-integrity target,
the reboot notifier is not unregistered, leading to use-after-free.

Fix this bug by refusing to resume if the device is being destroyed.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2629,7 +2629,7 @@ retry:
 	r = -EINVAL;
 	mutex_lock_nested(&md->suspend_lock, SINGLE_DEPTH_NESTING);
 
-	if (!dm_suspended_md(md))
+	if (!dm_suspended_md(md) || test_bit(DMF_FREEING, &md->flags))
 		goto out;
 
 	if (dm_suspended_internally_md(md)) {


