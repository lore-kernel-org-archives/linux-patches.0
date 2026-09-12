Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09043264D4;
	Sat, 12 Sep 2026 13:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221506; cv=none; b=R9J/FcqCz33Pd1LaX3noqKgVsWLesdKvUh+iP1ehJgzpmSOwWOKvqaVdlAVmxUmF1bISYZeyqEwWabytD8z6io0ak09d3TEvTp3hoj665qowBEcjCHeLhVJmHUnn8DSAlTg6z+qsr/0cQJgZjS6bYqaxrQlxse9Uh29cnpVdtF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221506; c=relaxed/simple;
	bh=POWSDfuPCeEu9jT5ZN0saxjlHNqLe+/6q3wmA7L+ZOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dabfbHP9ZVUGHMDrI9PJE/kTeLG9MLLEcNzuU88EgKS7aXYVE3ZTPupvl8VO5T/W+I/JonCrTz6k9MFMj9tirsVT8BuIy2Ti/cXXkowPjVAjEOfCaKAsWjjNDqHhTFeoxW93A4ZZ3dIwsxUOxbv1cBqogEnX5q4OIo1zVLvZ41k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TSCgy1B7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TSCgy1B7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93A51F000FF;
	Sat, 12 Sep 2026 13:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221504;
	bh=bT4KUX6R8wW20HBYHnAWRh99d6a5VGbBVW70yfAB2bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TSCgy1B7aKbcl3gc6dRXh2sy6bX6Swm7OXjKAX6dX1k/pYdZ2lQAIFw2TgPCYIJM6
	 3FfPSAr9GAAp7S2KWk64hlfgUZAw9dtNHAgnNbuUGueef2UbbF9kuMWgckYATd2X2N
	 w+HTer640pB18ES8g9QnYMJSk6pJEY3R2LefXzBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 0353/1424] dm: fix resume-vs-remove race
Date: Sat, 12 Sep 2026 08:46:25 +0200
Message-ID: <20260912065615.194040509@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2873,7 +2873,7 @@ retry:
 	r = -EINVAL;
 	mutex_lock_nested(&md->suspend_lock, SINGLE_DEPTH_NESTING);
 
-	if (!dm_suspended_md(md))
+	if (!dm_suspended_md(md) || test_bit(DMF_FREEING, &md->flags))
 		goto out;
 
 	if (dm_suspended_internally_md(md)) {


