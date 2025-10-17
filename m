Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B04C330B38;
	Fri, 17 Oct 2025 15:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715568; cv=none; b=IRtp6ZiaHPyKsMWtwUh0CjMs9U5Ij2QJ5wkdLgDeyIGda3lYp/0Fo31YYwqkct/8Hd42uQ2Ws/kv4ZKqIsE7a4o49O6Z+3jd3oMTfDPc8rId5mS4p0uSH5/eJ1U/oKsJp42H0JT0vfctAcN4Jn4SMT7PCCTaSbvIfJmKipoPmmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715568; c=relaxed/simple;
	bh=Pe/LyNG8C2LUQHx03taKqlWf/4+mGKOb/XiuN72FSGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUQ9x5ofJ5lEedCSa22TUl7dqYwWA6ByhiL/0Bct71xP3E4r/zZ9LN8mMB7aCSVZ3ngH85tYU0su7MSOR1kUvjuUE3ZMRu2lczttt6o+rP9JFvtfunCcq0JQ3n/EMOzKU6ItOdIdr8ngjslhzA45pfE962BxPCh9TFK3zNElPKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h1HMCJt4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h1HMCJt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB1CC4CEE7;
	Fri, 17 Oct 2025 15:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715567;
	bh=Pe/LyNG8C2LUQHx03taKqlWf/4+mGKOb/XiuN72FSGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h1HMCJt4Oo7oDGJH1KEkhURhu+OLzH7mmdWH5bUWAr93lmHbTWI/pHH44R8CdDcwq
	 qQ6oG8I+lkRpSfqHLTPrDCl3PM+bWoWgvB6n2yOibXiBuTHZ4mRNKrh2oZctPdYPoh
	 iml8Lqn62H/yi4d1Q8D3U0iGvlhoR8oWGOz9DFLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Andreas Larsson <andreas@gaisler.com>
Subject: [PATCH 6.17 261/371] sparc: fix error handling in scan_one_device()
Date: Fri, 17 Oct 2025 16:53:56 +0200
Message-ID: <20251017145211.524098728@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 302c04110f0ce70d25add2496b521132548cd408 upstream.

Once of_device_register() failed, we should call put_device() to
decrement reference count for cleanup. Or it could cause memory leak.
So fix this by calling put_device(), then the name can be freed in
kobject_cleanup().

Calling path: of_device_register() -> of_device_add() -> device_add().
As comment of device_add() says, 'if device_add() succeeds, you should
call device_del() when you want to get rid of it. If device_add() has
not succeeded, use only put_device() to drop the reference count'.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: cf44bbc26cf1 ("[SPARC]: Beginnings of generic of_device framework.")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/kernel/of_device_32.c |    1 +
 arch/sparc/kernel/of_device_64.c |    1 +
 2 files changed, 2 insertions(+)

--- a/arch/sparc/kernel/of_device_32.c
+++ b/arch/sparc/kernel/of_device_32.c
@@ -387,6 +387,7 @@ static struct platform_device * __init s
 
 	if (of_device_register(op)) {
 		printk("%pOF: Could not register of device.\n", dp);
+		put_device(&op->dev);
 		kfree(op);
 		op = NULL;
 	}
--- a/arch/sparc/kernel/of_device_64.c
+++ b/arch/sparc/kernel/of_device_64.c
@@ -677,6 +677,7 @@ static struct platform_device * __init s
 
 	if (of_device_register(op)) {
 		printk("%pOF: Could not register of device.\n", dp);
+		put_device(&op->dev);
 		kfree(op);
 		op = NULL;
 	}


