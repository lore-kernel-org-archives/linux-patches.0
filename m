Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AF0336EC5;
	Fri, 17 Oct 2025 15:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714499; cv=none; b=nVl2+TG1BDORWHKgbBxrGkIBIU5wACSDR8JrVuYdA7j+KwCLo5QdrvjgEVGw+ettBiVRZHORsBpDmNtkQpl+hdf7+RxIYRuTorV6fiLQrtpBC8Y8bFn3HjeTKc2rUq4BGP1UOGUA2lW1HaP2K7JyDBkTmW2vKyHwWxjyzeWw6Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714499; c=relaxed/simple;
	bh=wzIOe8SpDSARu5fbflSkjUJ8U35+BAWpuO0POXXWRpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgJNIIcG+B71jZMDGu9Fd69rQhkV+Qf7OxaI09Nrs3ZrsJVwRzPXw7U7QLjxXlc90ma0aYS9zWzEemyoWrGyyBQ+0ZusgVR+S7tNj8B7b922Q3i6BBaPdgSfxF0h9lSN5Bj9diTU7aUpW6+3Bm32bJbcZ6Y7RSsEG+tSJqYS1Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nVqc89gc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nVqc89gc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702D5C4CEE7;
	Fri, 17 Oct 2025 15:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714498;
	bh=wzIOe8SpDSARu5fbflSkjUJ8U35+BAWpuO0POXXWRpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nVqc89gcSHFQpZuwhw0QDRG1y3hDqa2dZef1qwcrTbzW0JixdFIyOvJVfiTIiMfbp
	 i4yBqhswDN5ka5Ba2gW/P7C1GQnp1VQ9FvRZ0I0Ef/jmHkaDOPlHRZGYzZAvp2fUua
	 K7kLZ2NJNl7Y+kAb5YmvcT1BzYMRP1//Kr6AzbwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Andreas Larsson <andreas@gaisler.com>
Subject: [PATCH 6.12 165/277] sparc: fix error handling in scan_one_device()
Date: Fri, 17 Oct 2025 16:52:52 +0200
Message-ID: <20251017145153.150740869@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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


