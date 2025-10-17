Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836AF330B04;
	Fri, 17 Oct 2025 15:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715421; cv=none; b=UzS63eAZoPIWrWXTwbNuGCrXdmXFRxwHJ+NUysZzNfaxm555Il6nPFmsavCl9+hoyOc+hReRp2qo0UEzVjv3kP2nmTQp9J93KEBIPu+t3f9FIxupX37rD9vlj+zd/ifUEwzHMDwRV7UhnVFxk4nh8TNA5x47YA7pUukUowkdEcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715421; c=relaxed/simple;
	bh=qoJNz5YFHr+yleqPvAZkPFwRUR/3I/tjgtAjDdQ+fbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ekLPAKgQi7IStoscvS+1kFmLNbQ/cXkHmFKSsGlp8snDSi7ehGRfFrNDLmfopF2btyyw2bDrP1jOhw2ylKHqIRMuofsXvY/fnDZqzVE2LDvikuUfItSDf6hXae5pD/83lth0Zh9a3rv1esUtvJL2bdSYJNGkm8+1LAefDvbA/RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MB5jSUvC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MB5jSUvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE613C4CEE7;
	Fri, 17 Oct 2025 15:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715421;
	bh=qoJNz5YFHr+yleqPvAZkPFwRUR/3I/tjgtAjDdQ+fbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MB5jSUvCBhwusAzB0LYjCprFHmmWhHe4tIEs0vKYTQ8iFG6WzVkiHjuja8+w48/1s
	 keNRa5uxSiKyPDkj7xv5LvlpS3z7aJ3Ldqql3zeKe5dTkzSvvDojC5gDCirTwNSr2L
	 /NXBCINVhdsrc3Mu/VF4nZAHiCWiKcC2gz9pKyB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Thain <fthain@linux-m68k.org>,
	Helge Deller <deller@gmx.de>,
	Stan Johnson <userm57@yahoo.com>
Subject: [PATCH 6.17 211/371] fbdev: Fix logic error in "offb" name match
Date: Fri, 17 Oct 2025 16:53:06 +0200
Message-ID: <20251017145209.721068845@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/video/fbdev/core/fb_cmdline.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/fbdev/core/fb_cmdline.c
+++ b/drivers/video/fbdev/core/fb_cmdline.c
@@ -40,7 +40,7 @@ int fb_get_options(const char *name, cha
 	bool enabled;
 
 	if (name)
-		is_of = strncmp(name, "offb", 4);
+		is_of = !strncmp(name, "offb", 4);
 
 	enabled = __video_get_options(name, &options, is_of);
 


