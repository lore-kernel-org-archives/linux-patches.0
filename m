Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8EE4330B36;
	Fri, 17 Oct 2025 15:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716460; cv=none; b=MYkIWE6LQTSXrdl3SOXX3MUZetNUq1Yvqmaaswc1RVJBUCYyCU9vni8geklZpEuPEJ3kJO4lL9Mfwb3oD9nWmgB/+D/agMF39pAg6EAK5q12eLb889AT7X4aHwNpN7gNd0TwLeRh82FyaCDnWq4PBhAeFR+Pva44HUYEva/+r3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716460; c=relaxed/simple;
	bh=vd9Dtknsg1n7hk/e4VVI5KX4RF/sQcP1RpDAL3tJ72Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSj84VMI048LI1QQGpIiQ14BvpZVwXQ1ZQfIX8wtbwP8QJMnfL2FSKx14K4bsYtlSvh2DYYQ0IPa3B2s8O/hj1nackde8CsEJI8NbsX3jM+gTZOB7DPinkm4XiXN3Ic940/qTvoXsAdOu6XY6CMqiiYJYrXBS8zX4kHN4gdIaMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nWTPvAgb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nWTPvAgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5399FC4CEE7;
	Fri, 17 Oct 2025 15:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716460;
	bh=vd9Dtknsg1n7hk/e4VVI5KX4RF/sQcP1RpDAL3tJ72Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nWTPvAgbcsBIbFBo2GfbMFzJUeYtnYPwKDeAzjTyFpf1VwYyBW/1ph5olLVy3moTX
	 8bTDOsU1CVUSS2YlewyoMlK6ukCuNzXi2R0+QAajh37OnVjSU0dybiznaGrgwRA2Dr
	 Bjtby2csJpikK38rt2fvEBD139X9T+XkAdSTmxMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Andreas Larsson <andreas@gaisler.com>
Subject: [PATCH 5.15 198/276] sparc: fix error handling in scan_one_device()
Date: Fri, 17 Oct 2025 16:54:51 +0200
Message-ID: <20251017145149.699262505@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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
@@ -680,6 +680,7 @@ static struct platform_device * __init s
 
 	if (of_device_register(op)) {
 		printk("%pOF: Could not register of device.\n", dp);
+		put_device(&op->dev);
 		kfree(op);
 		op = NULL;
 	}


