Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A8733710B;
	Fri, 17 Oct 2025 15:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713698; cv=none; b=KZO1n2lJzUmUVkKHqo6K5UIusMZR58HEJyyglpxQw9UzeVA9bMHs/Uak1hajg9imVb1zIi8XgBmbKP/SiQx/h7uTOG+bJMgkalrjv2SVwHWcQrOBnvxaJxObHuSBuSJC+JfuQpU3WyKc/jsMn/qx3ImysU7PbXkAZoVMWLGIdp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713698; c=relaxed/simple;
	bh=YqqUF7mOXSq2i9MHC8pdri52zk1jgCLmp/qmCfgEKQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oN9NCQLxna7Ncp/htVNRKXFvoCrxW2bTM/XjU4gFmcYOacXtdriQWXaGlJ9NacbpctF5tRyvuiv/gbg3xP2RgJqOYUQaQIhRyzFgbbywaTo0mvxlJcEKMZFUh81tWS0ScW/Os+1i5h8scL5zzYwVsN+eR4SqfwfkoHeUB3SYly4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G5m+dwFH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G5m+dwFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2DDC4CEE7;
	Fri, 17 Oct 2025 15:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713698;
	bh=YqqUF7mOXSq2i9MHC8pdri52zk1jgCLmp/qmCfgEKQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5m+dwFH5BNUrC7xH4rrIdAjLWI9zHTCAR1eRRlMOC7LMMscGlZw481mypGvZsuKl
	 xUbZ2q3UMX4+mL6++bC72hgXAg/IozBdv8cKbI0uzpR069RxBU3CbtmFMNl6eodrQX
	 d4AeXFVz7xswWoX2I2KMzXy31E7BX7jrKpgJZiPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Thain <fthain@linux-m68k.org>,
	Helge Deller <deller@gmx.de>,
	Stan Johnson <userm57@yahoo.com>
Subject: [PATCH 6.6 089/201] fbdev: Fix logic error in "offb" name match
Date: Fri, 17 Oct 2025 16:52:30 +0200
Message-ID: <20251017145138.024228938@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

commit 15df28699b28d6b49dc305040c4e26a9553df07a upstream.

A regression was reported to me recently whereby /dev/fb0 had disappeared
from a PowerBook G3 Series "Wallstreet". The problem shows up when the
"video=ofonly" parameter is passed to the kernel, which is what the
bootloader does when "no video driver" is selected. The cause of the
problem is the "offb" string comparison, which got mangled when it got
refactored. Fix it.

Cc: stable@vger.kernel.org
Fixes: 93604a5ade3a ("fbdev: Handle video= parameter in video/cmdline.c")
Reported-and-tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fb_cmdline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/core/fb_cmdline.c b/drivers/video/fbdev/core/fb_cmdline.c
index 4d1634c492ec..594b60424d1c 100644
--- a/drivers/video/fbdev/core/fb_cmdline.c
+++ b/drivers/video/fbdev/core/fb_cmdline.c
@@ -40,7 +40,7 @@ int fb_get_options(const char *name, char **option)
 	bool enabled;
 
 	if (name)
-		is_of = strncmp(name, "offb", 4);
+		is_of = !strncmp(name, "offb", 4);
 
 	enabled = __video_get_options(name, &options, is_of);
 
-- 
2.51.0



