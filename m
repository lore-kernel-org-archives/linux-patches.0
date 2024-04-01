Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43521CA8F;
	Mon,  1 Apr 2024 16:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987438; cv=none; b=skGHb/c1ameBWmlCIb7asZ0Eu5/3PlQVQtNZgTFIWho8iXQ6tOg62DAKokeyTkDqEfvGlqJmYbWm9SvurqtUCu+y1rCgGKfss2BWb37SYWVTz+Ym/X6dHMQ+yej7dF2xJ/9Y/KRoa7hQphgZRH5BkcoEYYbIE7tr1ENGOw47k68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987438; c=relaxed/simple;
	bh=0uZYrqaWyS1WtiSo/vCT3G6tjf/G4HR8lOvLg7Oiavc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dlQxqKFlmwsrwggIc+l12XWCbRzfcQNsQiUkNjqm6FVQRcu7+E8lVC7B8ifM3L386UtD2MElF1fqSPOfVSqiEBT+OROjQxkiclrCktVFFP9hl+8FNSdQAq/UP5sxRe6c5znE15+fYkoFJf65BXVlkAcC2m0L65snG5J9wN67mFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ND6ira6a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ND6ira6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259A2C433F1;
	Mon,  1 Apr 2024 16:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987438;
	bh=0uZYrqaWyS1WtiSo/vCT3G6tjf/G4HR8lOvLg7Oiavc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ND6ira6ayKok+aYQrXyYwi+4a8eWH8aJfamwXDzOP2B5d8EkGIMEx4GqfDD2Di1ji
	 +iNJeu/pHx3OOzQvLBT6uN4LYzDt1qFSUsBKWKgLJ83C0+633hMKgJJsVhtZqYeVan
	 dOnPWmL3f3YIVfpUUmnkg0F0bJQuI3gdEoUjLuWc=
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
Subject: [PATCH 6.8 287/399] init: open /initrd.image with O_LARGEFILE
Date: Mon,  1 Apr 2024 17:44:13 +0200
Message-ID: <20240401152557.748912810@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -683,7 +683,7 @@ static void __init populate_initrd_image
 
 	printk(KERN_INFO "rootfs image is not initramfs (%s); looks like an initrd\n",
 			err);
-	file = filp_open("/initrd.image", O_WRONLY | O_CREAT, 0700);
+	file = filp_open("/initrd.image", O_WRONLY|O_CREAT|O_LARGEFILE, 0700);
 	if (IS_ERR(file))
 		return;
 


