Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A26C129;
	Mon,  1 Apr 2024 16:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988938; cv=none; b=WzXyZa0LSBJVwnweqe9UK9tA2myLI/C+ysibBKvy/hHIc5jcM833DuAKYJVrlqDnKvs6LoyfDZAkKGuteVrDto0t8CX7/ADTEfsNke7tZC+x3WJpygKtI+IvzaiqJv0KJu9qtLTMCJ1QyBn5EKxn3h9EKhcEQv0YN5kCJVAHps4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988938; c=relaxed/simple;
	bh=LP+5cm6sdu6OiNudPSOeRdNspnkRKqFU+mVg6KH97fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmc5pOlFMKd3vzogCTcY/oGe+ySm21Iqot9WdlhiYUYD83jWfq28B9kziZzg21bHRZxSZA3wYKwyuVTgRLjep9mDPq+0MjMK5oJdndzwG6EFvOtjjlHurR8XYcZNNF8ZEyGWzWdhEdsR6OkfnwB6cLLr/yBXQxxdJQ38VFy/YC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJAKAszC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJAKAszC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA892C433C7;
	Mon,  1 Apr 2024 16:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988938;
	bh=LP+5cm6sdu6OiNudPSOeRdNspnkRKqFU+mVg6KH97fA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EJAKAszCy5OsNZMd0t2cKcgW5IzKwObGkkegEthJJ4wYPkdW0FqZMEhewLMy+KUNA
	 UFxAllQbx0f+sqoSsJT5CzIOMWOK/X3pSuZ67J1lG4jWvTcByvXerkaS7Clgavepap
	 j5PbR+5KCKT+u4PrY1HaGGFX9Z4t2zVj+KRXO46k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Sperbeck <jsperbeck@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.7 334/432] init: open /initrd.image with O_LARGEFILE
Date: Mon,  1 Apr 2024 17:45:21 +0200
Message-ID: <20240401152603.184074598@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Sperbeck <jsperbeck@google.com>

commit 4624b346cf67400ef46a31771011fb798dd2f999 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/initramfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -673,7 +673,7 @@ static void __init populate_initrd_image
 
 	printk(KERN_INFO "rootfs image is not initramfs (%s); looks like an initrd\n",
 			err);
-	file = filp_open("/initrd.image", O_WRONLY | O_CREAT, 0700);
+	file = filp_open("/initrd.image", O_WRONLY|O_CREAT|O_LARGEFILE, 0700);
 	if (IS_ERR(file))
 		return;
 


