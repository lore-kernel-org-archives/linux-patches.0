Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315141BBBE8;
	Thu,  6 Jun 2024 14:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683497; cv=none; b=qFMSgIoCtgWjT1Mk7xmJcyAZ4cvHmRORIbtD/QtLP4g316tWXRoD194dUGed1vpJddWEGlgluBq0KeXZbAeSXvuKm7EilceX1NT5qttW/1HNyV5qm6L3NRAsp1/FLKLdGNe3jRzNf6+IosPIcMUBrPe4VwkpisHJBQJcJHQ3qT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683497; c=relaxed/simple;
	bh=DKpjCMRWIJHcoc2kflikuImXssY29byO8XUqVJnwPx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DO2DNcBaYqNWgbc8LAGtPj80DVSmcRRr2vYFbmpX+E3WpELmePXSGluvf1re6qENFLQ/VmE5pl8kc5eu26C/a8PeSNZMqxb4xkLLp99HQ6s+bFQ/OyUK8sF21o4ZRSYSh8JrzXEsYN06DM+8XSe2aa1bSnFKUWDzxTNuar5GcT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjsfGbJT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjsfGbJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD40C32781;
	Thu,  6 Jun 2024 14:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683497;
	bh=DKpjCMRWIJHcoc2kflikuImXssY29byO8XUqVJnwPx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjsfGbJTrXoa9Vgujctsv39XnYXJWRfyrM1bRzdPnwmsFy6p7/r/7yOhnYCm2/xnZ
	 9zaF47oO289KqmMqLKz2YNBKMWWD5U1xsAwDhWx6atQUlqHI/tgfJON9eDhUgrHhhZ
	 eLH1bteSEAwb/DcdMUxqafNzIW9HvtCIxgMuyB7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Johannes Berg <johannes@sipsolutions.net>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 373/473] um: Fix return value in ubd_init()
Date: Thu,  6 Jun 2024 16:05:02 +0200
Message-ID: <20240606131712.221363466@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f4c1e6e97ad52..13a22a4613051 100644
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



