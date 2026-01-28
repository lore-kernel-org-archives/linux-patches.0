Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB48F26ED40;
	Wed, 28 Jan 2026 16:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616135; cv=none; b=Lp/uNMTX2Es+M5+cvtpo5nyYSD0KDRzJeTigle4E8ug/0+1qinGSMIqVItYuau4zmFHCPJ7QDb6aJBYZP3fxbgeZWnA/RRxZauELZbK8SCNfyaNnPgnlhGy0vmm60MnRJCYR0wi4XKZ0woyVJqw7lfYDSlAN9GObjHCGaDSfnTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616135; c=relaxed/simple;
	bh=lLTo2ZDcbNuEJTXFDkTHr18ubxvzYzNa5LznhOGF3sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfDymzKDWmR68Hma7Svgsn/800ScmTzhYu9wtUuoEKfLOx7an7lNvakDzUfs1QVMs4iOk0W9ZGdcZedcdgN69lsatxSbmMC1Na2CoZrm3osXsf6kQmgGHfulCb2CGhOwdhAb1S9BqAao/aH71gDqJL5+okk/XvdLsIvJJyPUisI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AoF+cWTQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AoF+cWTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5C1C4CEF1;
	Wed, 28 Jan 2026 16:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616135;
	bh=lLTo2ZDcbNuEJTXFDkTHr18ubxvzYzNa5LznhOGF3sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AoF+cWTQHNupsDsFMk6Ju+zlwNSXxqtG3XCzgZnxhfXj7X2J0NgLVGIAIsDmri6HB
	 22SwoKQfZ6Ti9B5ILrqmrXyGypXBSZDxwnfY6qTkTiH+S8IHO6dM8VayABW1edX3pB
	 MnjPEafymFuWT8m3qMmUAFaKJaFFBUsNVm0+w3js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 217/227] gpio: cdev: Fix resource leaks on errors in lineinfo_changed_notify()
Date: Wed, 28 Jan 2026 16:24:22 +0100
Message-ID: <20260128145352.241475431@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

commit 70b3c280533167749a8f740acaa8ef720f78f984 upstream.

On error handling paths, lineinfo_changed_notify() doesn't free the
allocated resources which results leaks.  Fix it.

Cc: stable@vger.kernel.org
Fixes: d4cd0902c156 ("gpio: cdev: make sure the cdev fd is still active before emitting events")
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://lore.kernel.org/r/20260120030857.2144847-1-tzungbi@kernel.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-cdev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -2573,6 +2573,7 @@ static int lineinfo_changed_notify(struc
 	ctx = kzalloc(sizeof(*ctx), GFP_ATOMIC);
 	if (!ctx) {
 		pr_err("Failed to allocate memory for line info notification\n");
+		fput(fp);
 		return NOTIFY_DONE;
 	}
 


