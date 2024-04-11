Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F1014600E;
	Thu, 11 Apr 2024 10:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829879; cv=none; b=EsNiHOoYQQjSWQh+Fxxto6CfHps9eT5qYTY9YwbWnr3aRkJKfblJQRLLpL2ms09NFanlHxQoyJr7R8QCUVG9yzvcEalZBN4vh5mAeyyVFz3NXWz+6O0MpT/GFZSAt3zfIC5j99NSeM91h8tbUsZhq4SaDvfwqRPMUgB0iE4/0s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829879; c=relaxed/simple;
	bh=RBbiqdYb7a0KhzeAPgemP3xn3G0LT4MlFR3jHbaxSuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9ZoVBbGYvAsku62JEfmuMv4z9id7iYudPVbpbyCENBOrEm/Jd+deFvGjTyiVby7PvLTGoJXN46C0EI2e3FdYXmx6BOsrIYCoHX4fCS1iCJLufWDUVqZnoE1zTB2qhZdouTiMJhHwYu5W+u80EFDjI0hwAKlrtnPYIG6AMTCv04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qtIKfdr8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qtIKfdr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24E7C433F1;
	Thu, 11 Apr 2024 10:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829879;
	bh=RBbiqdYb7a0KhzeAPgemP3xn3G0LT4MlFR3jHbaxSuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qtIKfdr8S7aKIqUuZu0MQsW9Vy13tXEymr4Sze0+cJnWEiCLXwePMzrsQfEidyHBV
	 pq9YLMNDKV5mGHDkOhkro2Xr6HUyHabLq0DG14LY97QgAxxdpPdICrnZiWE9FgMq95
	 JlQ17VTrt4k+Uaz/dX0IeUyZd/59q+5v+IrxmY6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Sperbeck <jsperbeck@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 137/175] init: open /initrd.image with O_LARGEFILE
Date: Thu, 11 Apr 2024 11:56:00 +0200
Message-ID: <20240411095423.689248851@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

From: John Sperbeck <jsperbeck@google.com>

[ Upstream commit 4624b346cf67400ef46a31771011fb798dd2f999 ]

If initrd data is larger than 2Gb, we'll eventually fail to write to the
/initrd.image file when we hit that limit, unless O_LARGEFILE is set.

Link: https://lkml.kernel.org/r/20240317221522.896040-1-jsperbeck@google.com
Signed-off-by: John Sperbeck <jsperbeck@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/initramfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index e378d15a949e0..6b49c5ae78c7a 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -613,7 +613,7 @@ static void populate_initrd_image(char *err)
 
 	printk(KERN_INFO "rootfs image is not initramfs (%s); looks like an initrd\n",
 			err);
-	file = filp_open("/initrd.image", O_WRONLY | O_CREAT, 0700);
+	file = filp_open("/initrd.image", O_WRONLY|O_CREAT|O_LARGEFILE, 0700);
 	if (IS_ERR(file))
 		return;
 
-- 
2.43.0



