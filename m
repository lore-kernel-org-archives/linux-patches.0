Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038CE338F23;
	Mon, 27 Oct 2025 18:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591320; cv=none; b=rsM2JTgBsEp9wK7lnAbsR689RDHWsxC5ybacCYPMZqowe07mLdolS8EuzXciIbefgk6qS5gxIADu0QG8dqVavQKbH6fdIJvDp/dRoU/OkIMqLwxRl37KpLIfbvICh9NaFKh8LtZ96GDNnd0QXvl5gNNSoIxB7jXtH/QPBkzRpFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591320; c=relaxed/simple;
	bh=KkizM/AV0fKzmVWj6ZVzswDKakX4PpMF+PK2xwbSsrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jArdyouIb5x54JRIRu1ks9ReRI4DZcg0T1tw53DksiO7IDmLQnkdSyXbMfOQaIcFRFyHSC6ItcqSWNDwlBjDXg4bIyl2MINKRAVuyEzAzU7kF/p4bQySu4Dt9IYWv3Q3J2FEBrsoC2aWoMGCrk1wl9EndYUcE/10dwEfWtLpLMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rib7Kgoz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rib7Kgoz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79530C19421;
	Mon, 27 Oct 2025 18:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591319;
	bh=KkizM/AV0fKzmVWj6ZVzswDKakX4PpMF+PK2xwbSsrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rib7KgoziU63nki5nCve6r3+b14jTG76pLhiPvoGvji4exZfu4OPe3Pdx8LbAF68q
	 zXbQ4lGt4CNfUzGbUS35x1VBe2waby4DyVeo3dO8xuq6GLE1eBdGKf2ad+9l8/KGHI
	 J+obQk+1K5Ykxg+Z1ATZNptHoAER9UXzPjFoYDrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Andreas Larsson <andreas@gaisler.com>
Subject: [PATCH 5.10 150/332] sparc: fix error handling in scan_one_device()
Date: Mon, 27 Oct 2025 19:33:23 +0100
Message-ID: <20251027183528.594228465@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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


