Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D727BAF5;
	Mon,  8 Apr 2024 14:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584824; cv=none; b=ts8FhMOzk9pKHzySg4AnGKfmvYiqqyp/1LOWEDWTJEah6a6BAlXEebsiOiwBYFgwr544lyz3oVf0N8/LN6+xRAIIgsBKfQnO6HuGiusMFDZFMbQzKmfo9ynDz2qfYi/3gbXvElxerALhgYmv3urSacsExtUzwq1VWWV/MMwAnnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584824; c=relaxed/simple;
	bh=9jgapzTSxP3WpY64By3FAnTMJnZgQQhZfSmkE69aZKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIG8IN1wsbGEbaFYN6s9/10ySJhDStJxjqdBbeFk3FQh7A+CSfJTTtKTwNNjvpQs4k/RhwV2tM3fOYMvsF3dBHyKLjOESHpFfmzRo1btJnw1YSgW4zc/3ffgmZvF5fZUrAUD2I7exyEOuKnaHWPu5UcUSpT+OsPkyAOzhaoG1Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6ksJqaK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6ksJqaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F24BC433F1;
	Mon,  8 Apr 2024 14:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584824;
	bh=9jgapzTSxP3WpY64By3FAnTMJnZgQQhZfSmkE69aZKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W6ksJqaKJ7kyZVo3r8kC7exHsyCX2qY1uDTH42maeSQQy4SGi2LA0nDzzxqQdV3Hi
	 kgU2Zn3TEJEd6Xc5zeF9MZvGP4HBwJxdy9VTJoxmzLk9Om7SheUzTJFp+npC/gyc7y
	 R3uICGizEp811ZmPNe1RhVzx5JrBBdoAgW7jvNAI=
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
Subject: [PATCH 5.15 569/690] init: open /initrd.image with O_LARGEFILE
Date: Mon,  8 Apr 2024 14:57:15 +0200
Message-ID: <20240408125420.234727194@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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
@@ -655,7 +655,7 @@ static void __init populate_initrd_image
 
 	printk(KERN_INFO "rootfs image is not initramfs (%s); looks like an initrd\n",
 			err);
-	file = filp_open("/initrd.image", O_WRONLY | O_CREAT, 0700);
+	file = filp_open("/initrd.image", O_WRONLY|O_CREAT|O_LARGEFILE, 0700);
 	if (IS_ERR(file))
 		return;
 


