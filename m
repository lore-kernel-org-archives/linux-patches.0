Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA9982C60;
	Tue, 29 Apr 2025 17:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946197; cv=none; b=XU5FgcA6f36EfeN3xOo9Ha0JNJYVBgXQwe6CHWqVIG2Bn1sjiPqBGDKNx45bGg1ki8ngP8cu3WwpgWhVulCxRMoyIIPDhfPi6YsCNWc0tVfx9HcBmO90fI1CrbHkJYJtj6jCKDf0HmLQZMuqouS5JYm2pZ2+Ak2zIDhrE0O9rzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946197; c=relaxed/simple;
	bh=8y/4lpliBb+H+IM4tmEPJmbdBgwjkgbKBsbs+q9hHKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CktBosl6LeIhRFfO9C4tZnKSlxSBX9sFFqzWGoYsEmxMqt3yxdGl516tqK7zJFp2Vr0vJSObJ4lda+02g2Rq/kS8IVRwZzhgCnO3X6ZkkAMCMtxc9T2HIsDFFABBJ1hapGWZ8YW89gyYYEs9vjQvOANlQxo2Mjj86KBB+W1zWw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wpHmLA+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wpHmLA+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE6EC4CEE3;
	Tue, 29 Apr 2025 17:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946197;
	bh=8y/4lpliBb+H+IM4tmEPJmbdBgwjkgbKBsbs+q9hHKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wpHmLA+c4bQxjF22K8JvGzKWJywXsKkbZiR5fpg+XMYlnExmZtfLQ3s8IX/N1LCJU
	 jR4l7tdqm0DIRp//hs7jrQzOdAvniHV9MFllt/xv5i5lYtdU3POUp/1JpdF17iLQpD
	 wS4EOLLudvTT4bpNgLMc3Ny6F8sn1MAumF9ZSqoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	stable <stable@kernel.org>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>
Subject: [PATCH 6.14 148/311] char: misc: register chrdev region with all possible minors
Date: Tue, 29 Apr 2025 18:39:45 +0200
Message-ID: <20250429161127.095723205@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

commit c876be906ce7e518d9ef9926478669c151999e69 upstream.

register_chrdev will only register the first 256 minors of a major chrdev.
That means that dynamically allocated misc devices with minor above 255
will fail to open with -ENXIO.

This was found by kernel test robot when testing a different change that
makes all dynamically allocated minors be above 255. This has, however,
been separately tested by creating 256 serio_raw devices with the help of
userio driver.

Ever since allowing misc devices with minors above 128, this has been
possible.

Fix it by registering all minor numbers from 0 to MINORMASK + 1 for
MISC_MAJOR.

Reported-by: kernel test robot <oliver.sang@intel.com>
Cc: stable <stable@kernel.org>
Closes: https://lore.kernel.org/oe-lkp/202503171507.6c8093d0-lkp@intel.com
Fixes: ab760791c0cf ("char: misc: Increase the maximum number of dynamic misc devices to 1048448")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Tested-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Link: https://lore.kernel.org/r/20250317-misc-chrdev-v1-1-6cd05da11aef@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -315,7 +315,7 @@ static int __init misc_init(void)
 		goto fail_remove;
 
 	err = -EIO;
-	if (register_chrdev(MISC_MAJOR, "misc", &misc_fops))
+	if (__register_chrdev(MISC_MAJOR, 0, MINORMASK + 1, "misc", &misc_fops))
 		goto fail_printk;
 	return 0;
 


