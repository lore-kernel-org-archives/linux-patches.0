Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E991991D3;
	Thu,  6 Jun 2024 14:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683677; cv=none; b=VNMSoji15Hq7LwaxImkJXCDU6Rf7PJdEKZYxdHO+pvig+NFtlwWFQJVuQW6mx5hVOQW3j1fYKX76sK4SHXmsYXft3snohhZzdF0+1Q5jEeFaKVr1E9+lD312/+1oYVinbYG19nyiai2vqtpuio36Rj1g84JhdVQdnBDgo/9SZQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683677; c=relaxed/simple;
	bh=IsR42NrRNfqM47xRrydJPf3Eu8ASJuwERsxMqELOrzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqlimRLeeYTTMSafJdCb9ktVUJmivqs/pHJpEf+g6N+9ZM+//mw6wrpkPI0w+j+LlqyLHPBGb0vv6l7x5qZJVAyXJQxTLfZSfiUnZjbgmQX6BXWV0WmnkazD4VtCUjrcsDPN7qX80Hgp8p8TPRAf9D1orNqD67ww6uUWiAIgVtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4pSaQPH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4pSaQPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B89C2BD10;
	Thu,  6 Jun 2024 14:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683677;
	bh=IsR42NrRNfqM47xRrydJPf3Eu8ASJuwERsxMqELOrzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4pSaQPHXzSIJT+EaSfO7m6YGNbI7RONEIJp6W2Vf0nJmbR3b+bFU1nm8F9hjCF2H
	 oBx/EfrONQLcFiLsT+U+RSdWEAvPmVOXtXmAP7ei4oOVCNmu+pZH3RbnAhMXbljFkC
	 y9D0RJPUNXJQ470Gn2vIw7+9w1+rbp7Rjcu8ED6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Johannes Berg <johannes@sipsolutions.net>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 576/744] um: Fix return value in ubd_init()
Date: Thu,  6 Jun 2024 16:04:08 +0200
Message-ID: <20240606131750.934287426@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 31a5990ed253a66712d7ddc29c92d297a991fdf2 ]

When kmalloc_array() fails to allocate memory, the ubd_init()
should return -ENOMEM instead of -1. So, fix it.

Fixes: f88f0bdfc32f ("um: UBD Improvements")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/ubd_kern.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 50206feac577d..81405aeab8bf1 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -1099,7 +1099,7 @@ static int __init ubd_init(void)
 
 	if (irq_req_buffer == NULL) {
 		printk(KERN_ERR "Failed to initialize ubd buffering\n");
-		return -1;
+		return -ENOMEM;
 	}
 	io_req_buffer = kmalloc_array(UBD_REQ_BUFFER_SIZE,
 				      sizeof(struct io_thread_req *),
@@ -1110,7 +1110,7 @@ static int __init ubd_init(void)
 
 	if (io_req_buffer == NULL) {
 		printk(KERN_ERR "Failed to initialize ubd buffering\n");
-		return -1;
+		return -ENOMEM;
 	}
 	platform_driver_register(&ubd_driver);
 	mutex_lock(&ubd_lock);
-- 
2.43.0



