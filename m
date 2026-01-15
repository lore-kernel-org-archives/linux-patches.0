Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243F63AA1A8;
	Thu, 15 Jan 2026 17:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498329; cv=none; b=VXlV/Jz8BVfrwk+wexwOxPSuveiY0s7djjLB9+hkmoQ1rUgXPLSaanmTOh6OEYkPxAepA7wIGdYoFQSh3IWpZRIKKuDfKpXuG/ZsAcsALMjs1hOaP/STXwsWyuHZ0z36VF5nuNA0EsLQHTpfQS3DelQkzGNVVMrYGtWtSZ+hyEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498329; c=relaxed/simple;
	bh=QmIg3geB0T9QNr27x5iTPzHthGePoSXM8TWshG1iqQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LRI1+mOYucN2dVQkV3enHF0XIYTT0QSTsE4A7kSmp5lhTOC8n9uHRV97Ey8MybXTZtvDHiXTbnv7pM3Irvd1MCpx2IFbbGdnP58tNFydAeh1eQznZLcT545vv0sftyRjsYi15OZX4Ff4NwwmyaVuZubOuSzx8K9BRo5ic1bf7nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w+6jB/R6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w+6jB/R6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B8AC116D0;
	Thu, 15 Jan 2026 17:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498329;
	bh=QmIg3geB0T9QNr27x5iTPzHthGePoSXM8TWshG1iqQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w+6jB/R69rTkDgRyWv/P/9SlwY/oW5B+lmK+Fq7uDR4BT3tael7iaaN2lIeKo7GN9
	 tU5OxRxi+JzhEE18fJEyJHqUfLlZGjF0pI2c/FOTq3ulHsC6+aR6Sj0VNuP1IknZ0g
	 2JG4t94tEDel2uYo92G6DIHZRwmUiiwPeM2sw3ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 394/554] fbdev: tcx.c fix mem_map to correct smem_start offset
Date: Thu, 15 Jan 2026 17:47:40 +0100
Message-ID: <20260115164300.496629984@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: René Rebe <rene@exactco.de>

commit 35fa2b4bf96415b88d7edaa5cf8af5185d9ce76e upstream.

403ae52ac047 ("sparc: fix drivers/video/tcx.c warning") changed the
physbase initializing breaking the user-space mmap, e.g. for Xorg
entirely.

Fix fbdev mmap table so the sbus mmap helper work correctly, and
not try to map vastly (physbase) offset memory.

Fixes: 403ae52ac047 ("sparc: fix drivers/video/tcx.c warning")
Cc: <stable@vger.kernel.org>
Signed-off-by: René Rebe <rene@exactco.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/tcx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/fbdev/tcx.c
+++ b/drivers/video/fbdev/tcx.c
@@ -436,7 +436,7 @@ static int tcx_probe(struct platform_dev
 			j = i;
 			break;
 		}
-		par->mmap_map[i].poff = op->resource[j].start;
+		par->mmap_map[i].poff = op->resource[j].start - info->fix.smem_start;
 	}
 
 	info->flags = FBINFO_DEFAULT;


