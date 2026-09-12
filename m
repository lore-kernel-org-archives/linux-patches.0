Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C03736167B;
	Sat, 12 Sep 2026 15:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228177; cv=none; b=KUgtH6BwN+e5WQPtgjL3m3pqQwYmvFE+4zDaLz/ziO6cHyo7NuoRIevN+DF41IH/w43FP5HotBRDk6m6F5b5QMPOaQZxCBGnE8w0uvBYt+TZEMCTmAtyWafMiGM2nPABfLp131/+yAkvWoMcGYFmO9T7CpwYX9dnfgNP7otBXu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228177; c=relaxed/simple;
	bh=XZ/e3d5W7+NIt4l8BKrso5jRQVCXuA5KyKO9KUNsQjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIxjKlGFJ+Db1XTj3pKg2FsqwtwUM6HNGCdR9Fe9ijVwjK2SlrUS6Zg0njZ4Psj3ErwxMNbXwicasdRIBcJjQA8waWHjwmd6Q02mecShXEhDv62Uj8bLtrdmj9cUFIwYh9jvcQF5L3lP/njHIAl6d4BCB505jVxmYnI/bZzroqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MH7QnsuM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MH7QnsuM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6E91F000FF;
	Sat, 12 Sep 2026 15:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228176;
	bh=/Q8zphO8OyP9R2Ng7JboYAc7E0HHDhYzXzgt9WUcvBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MH7QnsuMVK4chXz81yob27IY3oAY33BSCf5JvEjml0cOLbAf2+CAa+gWA1GEhQYy4
	 mgDsw/A/5vbYDqMTKo4QPQ3rMvTXCMJSgi0Lj4cdl3W5La3InWw8h8JyOv5k2PmYER
	 QiIetADAJ2bbbS61/NbOnMIfQ/YKt9p0lY2RFoG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 0290/1191] dm: fix resume-vs-remove race
Date: Sat, 12 Sep 2026 08:50:18 +0200
Message-ID: <20260912065554.744392522@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2852,7 +2852,7 @@ retry:
 	r = -EINVAL;
 	mutex_lock_nested(&md->suspend_lock, SINGLE_DEPTH_NESTING);
 
-	if (!dm_suspended_md(md))
+	if (!dm_suspended_md(md) || test_bit(DMF_FREEING, &md->flags))
 		goto out;
 
 	if (dm_suspended_internally_md(md)) {


