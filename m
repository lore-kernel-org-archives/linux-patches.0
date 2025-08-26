Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95352F0671;
	Tue, 26 Aug 2025 13:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216693; cv=none; b=StJEhrWokE/bXUoUbV4ScEuWMfbJ0FUTWmb29ku46ElJsyqCGpH8HChSwyxiwKIh2fO5DY1D0JcW72+pkro9Z6sEr1lw0FfGuPJ6W1I+peT58DMDdjJVeWhxWax9rK3KldlLCtSjh6zVJfBbaNbKn7BwrHLpFlCfgupOKaxoajc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216693; c=relaxed/simple;
	bh=Wfa1li5jLEYu4ZHbFenM2XERtAmrJIANC6XOaM2XjB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAv+hkWJRlaC8xbvMwlP6GCksMVR3BCj6eUlafBgQq8QPBCFDOasTMmKrspRiJsI2jrldbrat7Ad9KCVsaIa8nhqXFCFRSvDKSCJ3qwgJf+RsuiOozD+dGibGIAIXcpv6roItE3MgFNX7Ej7r3NSDx/At00ih0v165npBHrMUks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xk7s5bc7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xk7s5bc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A78C4CEF1;
	Tue, 26 Aug 2025 13:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216692;
	bh=Wfa1li5jLEYu4ZHbFenM2XERtAmrJIANC6XOaM2XjB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xk7s5bc7GFBKPJRfPp8FI0QN2ssJR2X/M7t+aElFd3GcZCttaMTjhRUFQGpVvLL5D
	 VIkCp/Iq9L4iiWTCQNAiTs9haUKRY/WB2PLx12uMsoqq76bNNC3/Cu8lqVZDbtYfAF
	 ubmNJrwpabZxDtf7aPMG177rJ01sDn7lLd3o1kog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jari Ruusu <jariruusu@protonmail.com>,
	Yi Yang <yiyang13@huawei.com>,
	GONG Ruiqi <gongruiqi1@huawei.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 466/644] Revert "vgacon: Add check for vc_origin address range in vgacon_scroll()"
Date: Tue, 26 Aug 2025 13:09:17 +0200
Message-ID: <20250826110958.028111743@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit e4fc307d8e24f122402907ebf585248cad52841d upstream.

This reverts commit 864f9963ec6b4b76d104d595ba28110b87158003.

The patch is wrong as it checks vc_origin against vc_screenbuf,
while in text mode it should compare against vga_vram_base.

As such it broke VGA text scrolling, which can be reproduced like this:
(1) boot a kernel that is configured to use text mode VGA-console
(2) type commands:  ls -l /usr/bin | less -S
(3) scroll up/down with cursor-down/up keys

Reported-by: Jari Ruusu <jariruusu@protonmail.com>
Cc: stable@vger.kernel.org
Cc: Yi Yang <yiyang13@huawei.com>
Cc: GONG Ruiqi <gongruiqi1@huawei.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/console/vgacon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -1170,7 +1170,7 @@ static bool vgacon_scroll(struct vc_data
 				     c->vc_screenbuf_size - delta);
 			c->vc_origin = vga_vram_end - c->vc_screenbuf_size;
 			vga_rolled_over = 0;
-		} else if (oldo - delta >= (unsigned long)c->vc_screenbuf)
+		} else
 			c->vc_origin -= delta;
 		c->vc_scr_end = c->vc_origin + c->vc_screenbuf_size;
 		scr_memsetw((u16 *) (c->vc_origin), c->vc_video_erase_char,


