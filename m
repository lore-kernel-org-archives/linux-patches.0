Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBCD13E3F9;
	Thu, 13 Jun 2024 12:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282380; cv=none; b=qYPShL7uhTUT5p0Q5Fkmzi4g9QqfzDt6V4PWWISzGtmNP5AykfhzsLMp1SubN6Q+eQD3FZiKKZLFwuLXtDbLRp6sZwzIqPeNqiFKsfTuIFNb2enNTg5x61qxGK5L+bN01myiaFSOFbavPIWlcIWtalvMlsbLxqpZM96a7WRqHsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282380; c=relaxed/simple;
	bh=dHhyJWSlMYpv/Rj3mLB65nyV6l2BwnFN0ZFItneX6NE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEy9tmkioMCHCFiOSJElYWepmHnxE/1Msp05LmD/5qLvxvWEb/SP8e/1/jgHztRUgh1kapwOqO/LH1s3UrWqP5Mg+KN/qtBIkpupi1xn5l+iZwADdpDm5yjFm+AM2cV3ihWSsjaS50/nvceAIisPyp43nWc33crcfwCv/COtlg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JNxcS9tG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JNxcS9tG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5484BC2BBFC;
	Thu, 13 Jun 2024 12:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282380;
	bh=dHhyJWSlMYpv/Rj3mLB65nyV6l2BwnFN0ZFItneX6NE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JNxcS9tGPhaa/h5PRLxLidbW58vYLexVHdpk1wt29Y3tUUwtRbN7D3Us3QptXa/7j
	 v6tCWhWUHu56nyW1nsv91ypDC3EKfwT/60xuyK15qOm/4DPxJntFYLqY+D/g0LUmEN
	 ya4L/4qBWWfGGCTmxWImt4IO/xW/uDCGiOyEwfQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Johannes Berg <johannes@sipsolutions.net>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 258/402] um: Fix return value in ubd_init()
Date: Thu, 13 Jun 2024 13:33:35 +0200
Message-ID: <20240613113312.210622655@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fefd343412c79..b3a4cc5a2091f 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -1097,7 +1097,7 @@ static int __init ubd_init(void)
 
 	if (irq_req_buffer == NULL) {
 		printk(KERN_ERR "Failed to initialize ubd buffering\n");
-		return -1;
+		return -ENOMEM;
 	}
 	io_req_buffer = kmalloc_array(UBD_REQ_BUFFER_SIZE,
 				      sizeof(struct io_thread_req *),
@@ -1108,7 +1108,7 @@ static int __init ubd_init(void)
 
 	if (io_req_buffer == NULL) {
 		printk(KERN_ERR "Failed to initialize ubd buffering\n");
-		return -1;
+		return -ENOMEM;
 	}
 	platform_driver_register(&ubd_driver);
 	mutex_lock(&ubd_lock);
-- 
2.43.0



