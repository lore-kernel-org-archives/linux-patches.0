Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7D2146584;
	Thu, 13 Jun 2024 12:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281286; cv=none; b=j1EExFtLXEjVit6Sz6cf1NPKBUj5/CZ22NphxX/jor6EmEGprYGnqGLiXIp3Z/Hlt7LSJ3riTdunpTp+4fNpn+wqigASWlNZWh2c6a6KO1xc6Tz2sjuIpFFJiTQS4PXlA7GzMR+uSVGifjlEsDmhfZRXnTrZxjT+TxIE5GdaNBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281286; c=relaxed/simple;
	bh=eiMOiNHS9s8S01cyG6oNX0qGk/w5fYO1P5IDeOmFpWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSSk1AGkPo9XiFpPpyUdxTPOrF10Y2YQ6jBWvPzKJ/vGbqwGsoPy6pKSwpdmpnjZXXK6v5tx2dwrBsR8oqADkGBCg6HEGULALhiLwhTc622LWCVmHu9v+Pn6henQ/g1sJXGzSJOusWiVMz7O7IcGFmR+aZMAU6BRerK28XN66DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQvp4coM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQvp4coM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5622BC32786;
	Thu, 13 Jun 2024 12:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281286;
	bh=eiMOiNHS9s8S01cyG6oNX0qGk/w5fYO1P5IDeOmFpWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQvp4coMIvlDqiluQ8TBO2bCdsKg7/ZmiF2EzxFW/dNY1GVSnL6w1C/yxu1JPj1/D
	 A0ME+AXSlcVZkACsuLy5irsh+GGls88etNqu2RBJZOr+hUHVdNhgg5vpMteipK8sMT
	 xRuuANjsSAZEcCpt4KqEi7/BBZsvF5g/YUaLvGaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Johannes Berg <johannes@sipsolutions.net>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 204/317] um: Fix return value in ubd_init()
Date: Thu, 13 Jun 2024 13:33:42 +0200
Message-ID: <20240613113255.446539292@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b12c1b0d3e1d0..de28ce711687e 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -1158,7 +1158,7 @@ static int __init ubd_init(void)
 
 	if (irq_req_buffer == NULL) {
 		printk(KERN_ERR "Failed to initialize ubd buffering\n");
-		return -1;
+		return -ENOMEM;
 	}
 	io_req_buffer = kmalloc_array(UBD_REQ_BUFFER_SIZE,
 				      sizeof(struct io_thread_req *),
@@ -1169,7 +1169,7 @@ static int __init ubd_init(void)
 
 	if (io_req_buffer == NULL) {
 		printk(KERN_ERR "Failed to initialize ubd buffering\n");
-		return -1;
+		return -ENOMEM;
 	}
 	platform_driver_register(&ubd_driver);
 	mutex_lock(&ubd_lock);
-- 
2.43.0



