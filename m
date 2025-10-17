Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE7D336EC4;
	Fri, 17 Oct 2025 15:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713857; cv=none; b=N4BfV4+E2DrbWmM37e+Wosf4eo1YwsOGLpPHdZjBx5bQjiykd1AEO0oYnBg25RtqoU9a4qVHDENBKbBdnhULHazQx1VEMp4BH5l1VdZtI5TAS14qySHitu6nnx/uZNt5o3qclU60E4QmyT8Vi8BZYGMYyyNtMad7pdfjJ/a/RS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713857; c=relaxed/simple;
	bh=E5YWFcEzkZ79NpfMPtO3gLRJjh6WmK8AZVBfBH9v5YU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXvijWzQva6mJ+rBGITrJ+cAaar9vdlYnNz5FwB+COj/9zJfpOv3C09B6brvNyq87MTwnIHIoeataR6YaJRomJKOBCeuqcm7lC83tDHjRpL7iyK6YYvgKGEbExqcc4XI13ljUS9qQCxzLaq4f/09pgM7rJXCaxAfTgrBYwoXBPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v5JsxBNJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v5JsxBNJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19E2C4CEE7;
	Fri, 17 Oct 2025 15:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713857;
	bh=E5YWFcEzkZ79NpfMPtO3gLRJjh6WmK8AZVBfBH9v5YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v5JsxBNJIxz7ZM01yV9TvDMpEQVK7frQiFnN0+wZN7+okZp/oc+oBadlqjnPadMp0
	 /wlVB6C7ELRIIw9dgfiQdZq2I5qeemZ6jBwvldwJxZWcOUtbg2Zdr+OTbfnGnWnPRx
	 yuiAKnhLJX6rt3axCPJyUA1ITw1+CAwTHpkaUENo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Andreas Larsson <andreas@gaisler.com>
Subject: [PATCH 6.6 117/201] sparc: fix error handling in scan_one_device()
Date: Fri, 17 Oct 2025 16:52:58 +0200
Message-ID: <20251017145139.042848887@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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


