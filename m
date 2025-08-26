Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E396110E0;
	Tue, 26 Aug 2025 14:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218018; cv=none; b=SgNfnL0elGxK0AzQB9BVVVIKZPtxyQICuvesfruhsYZN9go87M0fmQhj3hgRsM4xHOmTdFZDQ4ppK5SOeFR144Q94aHL5YuZuyVradHxVxOJk+MhDN//yoIg1LZz73GxgH+QAszxJ8zbPAlerdOTtkHMQrjtKiLqif/3QObcDhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218018; c=relaxed/simple;
	bh=BVRrxAUHbngCRWxtWlj2N7sBHF5XpTs8mOkw3X9VTZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fod/45WQPTzsDFMO3gzLzBPXSAgD+1QWTvXPpgfkNiUcFajhsVr/GZtcO8TmxCHq4zGfoqQueS5jjaZq9cJJ+3zRI1ioLYwWCxnl5L2VT6jTPXCPr8YK/2oTh5yuDb3sg6gmFvIscjsUudYnuc9V6QjBFDQZ77ua2bbKky1YlPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oZg1NpFO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oZg1NpFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769A2C4CEF1;
	Tue, 26 Aug 2025 14:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218017;
	bh=BVRrxAUHbngCRWxtWlj2N7sBHF5XpTs8mOkw3X9VTZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oZg1NpFO3qwX2OzrOkgVzECrIXfEG1OvH/pu4lZr/MQzbkeovD1EaOQUeAZLMv00l
	 agsvTCwOjJgW0zs7gY55WPndoffZ91Dc42ceVFN9cJJEOprUi/XrxyQdNruLhWj+At
	 m9sL6jFW8OnhXG1eAcCp9a/KkwRb3IFhBuGqT3dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jari Ruusu <jariruusu@protonmail.com>,
	Yi Yang <yiyang13@huawei.com>,
	GONG Ruiqi <gongruiqi1@huawei.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 362/523] Revert "vgacon: Add check for vc_origin address range in vgacon_scroll()"
Date: Tue, 26 Aug 2025 13:09:32 +0200
Message-ID: <20250826110933.398316462@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1200,7 +1200,7 @@ static bool vgacon_scroll(struct vc_data
 				     c->vc_screenbuf_size - delta);
 			c->vc_origin = vga_vram_end - c->vc_screenbuf_size;
 			vga_rolled_over = 0;
-		} else if (oldo - delta >= (unsigned long)c->vc_screenbuf)
+		} else
 			c->vc_origin -= delta;
 		c->vc_scr_end = c->vc_origin + c->vc_screenbuf_size;
 		scr_memsetw((u16 *) (c->vc_origin), c->vc_video_erase_char,


