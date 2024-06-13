Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE10514265E;
	Thu, 13 Jun 2024 11:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279032; cv=none; b=WxSuCMTqUAVTwKZ2wBzZnH6LAYIItYjTAfepoRcQmb5RvmNf6jVqnsv28752O9QaKgE7G+f9K/zb1CPcYxjncLhNhRN8AovD6CkaKvOFXUyrxriiiXKNE6AUQZsDlo3FHX+0faTxala+eDXvjibfl8WZmzyD3cPnSs+4JUdDQm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279032; c=relaxed/simple;
	bh=xeI3+tO3EB962pE5dCyam8CFvsoMGwhoITWAtWsp26c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tgf+Hl5/XMGBYhwM6N8KAumB0h1J60RLuKtFX+2arJ5wmKUzeUgPOBsCRzSIKQF1XVbkn7Odvxynsicf7f2XLYXutUz1g2ttHCEcCj+wAdK2FRYFVp328yW2ZgHCz2D5V/Yk6bTmioibk/1nvdNH5dPmwufKWxC+mQXBkRzHCPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TaUkxEp8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TaUkxEp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9B9C2BBFC;
	Thu, 13 Jun 2024 11:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279032;
	bh=xeI3+tO3EB962pE5dCyam8CFvsoMGwhoITWAtWsp26c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TaUkxEp8sf14pYdJRlm18IuzYHInIH8mEQeMedbRY0zulcPLwJXxHyX29U0M2vsq6
	 qeFHEl+738JvpOwunGxYwg7HeUnJ83v3a+tRu3DQsYj72oYFCDI4bDz8meaOT6vRn6
	 mwRF0mpV712F1//SIpINe+ELE2th090zzSrC5RQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Johannes Berg <johannes@sipsolutions.net>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 112/213] um: Fix return value in ubd_init()
Date: Thu, 13 Jun 2024 13:32:40 +0200
Message-ID: <20240613113232.322091116@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 788c80abff5d3..4a32df89a491e 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -1135,7 +1135,7 @@ static int __init ubd_init(void)
 
 	if (irq_req_buffer == NULL) {
 		printk(KERN_ERR "Failed to initialize ubd buffering\n");
-		return -1;
+		return -ENOMEM;
 	}
 	io_req_buffer = kmalloc_array(UBD_REQ_BUFFER_SIZE,
 				      sizeof(struct io_thread_req *),
@@ -1146,7 +1146,7 @@ static int __init ubd_init(void)
 
 	if (io_req_buffer == NULL) {
 		printk(KERN_ERR "Failed to initialize ubd buffering\n");
-		return -1;
+		return -ENOMEM;
 	}
 	platform_driver_register(&ubd_driver);
 	mutex_lock(&ubd_lock);
-- 
2.43.0



