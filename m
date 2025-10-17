Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6D23328FE;
	Fri, 17 Oct 2025 15:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714401; cv=none; b=JH7W2c7jWAK7XTH46xVghSqn26ZCVWtTooGq9YJcDJhIvgiiQs85OT6XxRTbJZ+krK49YZMYV5oXRxUKg9ItrwHMGI/2fvxEFEVLWMArY5zaWPtxyg4ZmOS/2qD7i1RuYudL6kg12OPmQmiNqiB/MDBk5A81i+2OSGKIICzd9pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714401; c=relaxed/simple;
	bh=sBBae0p2D/jjQtHNBFafEKabxJM9BKyE7NUyA2XRLFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SPCvejzsfD0BjgKrGhRnqIzvBiIrKUUGG7Bzb9KCIgZbNXN7EoGNWzLJNWUtTm8ZN8YOyJNeGL/MLz4gyFC6I1VdIj/5nWm/nxSdvlqLdj25/+eO5STdgOl+i3oy5SxAgwT/oX2+bczspQcce9wbMHn6Ic6B5c+icvMqD1plFQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OtIcl67l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OtIcl67l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1613C4CEFE;
	Fri, 17 Oct 2025 15:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714401;
	bh=sBBae0p2D/jjQtHNBFafEKabxJM9BKyE7NUyA2XRLFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtIcl67lM+lVXntNU3UvDhGru6xuRnidMxcix/MN2aOfTtQnrCMerdeg7BU9qnVin
	 +SJLQF3vrFqiZouL82tJTpRze5CFJGzyMXBnKav84nm+/2tiyg25rbyL/FecIWDEy5
	 OELkl044VFyx4fUIrhL6tmgJqBEKhiPlmxJBnP6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Thain <fthain@linux-m68k.org>,
	Helge Deller <deller@gmx.de>,
	Stan Johnson <userm57@yahoo.com>
Subject: [PATCH 6.12 131/277] fbdev: Fix logic error in "offb" name match
Date: Fri, 17 Oct 2025 16:52:18 +0200
Message-ID: <20251017145151.909579991@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


