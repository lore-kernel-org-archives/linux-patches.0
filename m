Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328C7482E4;
	Mon,  1 Apr 2024 17:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991281; cv=none; b=L5pMkpDgpTjVq2sgEOsTfLcFYJWTSqdgh2dOb0qlVEFlMNyu3VIbh54e03E+NRnV8TTGk7GZo8I6/znc4Q3d3fcoTYCSVIfZzIJpcY9FTC3lLov8b79rcYLemf74mYcJMSb3tRQRK+s3YZebLRSFwl0d5LKBK4heaSlP/K6WYzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991281; c=relaxed/simple;
	bh=nmwp2fyMJ2vzm6MB1aGtRyyhs+kENjaw8BTYxd3nKz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dYs2qlSGuQJcwvUcUL6Q+8GWDlSdeDCh00ztSwg0qOrnnYh0hAbCejB3l/1aw4Fbh+fGzKhysyrtoyLfQp6K4pa/FVnY3D9ouCNu9eqVUKfOOyuuiVgeLh6rbXGCyJwAbT7MZeVN6za6IVET6lwJJzsellzfklkaq0H2B6E0cqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FLwjOec1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FLwjOec1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2223DC433C7;
	Mon,  1 Apr 2024 17:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991280;
	bh=nmwp2fyMJ2vzm6MB1aGtRyyhs+kENjaw8BTYxd3nKz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FLwjOec1iIgILbgOAOAtgj4dNpJRBoEnmKeugb++Flo/Zjl8uOouUlRJtqqgNA3xp
	 vUMswnJgxI1X3k7qRqhYFgSUNR1fFO4Ea0mdpYUjHTklk8k2NhkrjZQ/2dSlCvvZwc
	 QWAXWcJN72IJ8kN0a/tTQbf5f457upfgKXb1OMxU=
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
Subject: [PATCH 6.1 210/272] init: open /initrd.image with O_LARGEFILE
Date: Mon,  1 Apr 2024 17:46:40 +0200
Message-ID: <20240401152537.479706294@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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
@@ -680,7 +680,7 @@ static void __init populate_initrd_image
 
 	printk(KERN_INFO "rootfs image is not initramfs (%s); looks like an initrd\n",
 			err);
-	file = filp_open("/initrd.image", O_WRONLY | O_CREAT, 0700);
+	file = filp_open("/initrd.image", O_WRONLY|O_CREAT|O_LARGEFILE, 0700);
 	if (IS_ERR(file))
 		return;
 


