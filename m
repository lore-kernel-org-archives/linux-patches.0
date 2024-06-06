Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B61196D8E;
	Thu,  6 Jun 2024 14:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682983; cv=none; b=s2TDPVkkUCeat5O/sjgljhOjq9eFpoGyIdQ/57y+oZGQcItIe+e7mN5iaK9kiAPJVf5elFAz7kliot8jAjq+r+HzhoVyxulXUyXi8PIfVCVx5mr/0jeRz0SwOQanvn+dYfJnf5utv6QPW/VnqMB0N0Yiv8VCdhNrnwKMHSa6Frg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682983; c=relaxed/simple;
	bh=ydC1U5xxYIm+/x6Q7hySbkyy0u0vHgQHeMVBK898w+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmZfLifZLqIRR+HoycsEDCt1GJTeI7oP6GmhOKd9HNUa8qn90VTM+nD4FYTo5lFWG4tvUvnL6DZANF8qfqMNq2FIDtFMfEd0TntRmZHIQPjh7PnWXKfkd1pPaBKND0qKEd36GUoYKYlTLcjHRTNgvQe3piiapIonehcsanXm4I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r5S6sF8f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5S6sF8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BFAC2BD10;
	Thu,  6 Jun 2024 14:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682983;
	bh=ydC1U5xxYIm+/x6Q7hySbkyy0u0vHgQHeMVBK898w+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r5S6sF8f5Y1XNQrv8YRQc4oEMZ2FozuayJqCuzCz1XNtQF3iU7Ljk0aGihufDVsL/
	 xTqnuVlj70mWQj1j4U2a288Y0QUfRWeJAotVA12IQSqX2x/sZvGzImY3u5a3Uv0RyW
	 ip6QNeJkvcBjBlqOq0g9bJeGzJPjgTQAEPbaoazU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Johannes Berg <johannes@sipsolutions.net>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 167/374] um: Fix return value in ubd_init()
Date: Thu,  6 Jun 2024 16:02:26 +0200
Message-ID: <20240606131657.498040095@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 63fc062add708..ef805eaa9e013 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -1092,7 +1092,7 @@ static int __init ubd_init(void)
 
 	if (irq_req_buffer == NULL) {
 		printk(KERN_ERR "Failed to initialize ubd buffering\n");
-		return -1;
+		return -ENOMEM;
 	}
 	io_req_buffer = kmalloc_array(UBD_REQ_BUFFER_SIZE,
 				      sizeof(struct io_thread_req *),
@@ -1103,7 +1103,7 @@ static int __init ubd_init(void)
 
 	if (io_req_buffer == NULL) {
 		printk(KERN_ERR "Failed to initialize ubd buffering\n");
-		return -1;
+		return -ENOMEM;
 	}
 	platform_driver_register(&ubd_driver);
 	mutex_lock(&ubd_lock);
-- 
2.43.0



