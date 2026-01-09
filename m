Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9D533372B;
	Fri,  9 Jan 2026 12:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962758; cv=none; b=BWduvnlBOLFF7ktcBiqWknVUN/deY+4InbQAijTYJqEcYaIWLSAgTQHtStlP0RqpVbJGBopzF2ELyUgQHPlzv4IqmFlyI1mYLSV/xzZ72ZF7OhdY6OrAZXkoVU3G8ioVZu+eQdxkc1sRZ5F42XdE7yIcMQVF3yalwgrjS4zj4Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962758; c=relaxed/simple;
	bh=c6mBhJ7f7yI8eAT3XmUAhbwNKGf9C3JKbZP6V53VjtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YBUYgOAYubbkWI1SVtRO6sIwSBSULIZR9CafS+zTNkgVYsrzH2p/Ay9wPRszzxcdi4t1CLPuNYANcCRPDRW9BZ5w0IDC9izztKWkQmqQ8yt5dnmbMa5hfQCnMz1ZlmyTDKAeVb6plk7aKQCLPUbEUqli/NlBv4ZuzfUrzolD73k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LXFOarK2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LXFOarK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272C3C4CEF1;
	Fri,  9 Jan 2026 12:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962758;
	bh=c6mBhJ7f7yI8eAT3XmUAhbwNKGf9C3JKbZP6V53VjtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXFOarK2iccBH3Ke5KFdhoifaWTQtabRU4I6yi4FpweFkZKHPqDxOQ8T7tXjJdq7y
	 Tb0HqVEByYNuIpLK0fEBQMnMhMdM4ZnTQRLOjxtt/xMw1f/Q20ApgtstlE7Clh783C
	 m0vfGn8NtSZ4Oci6GcPXQWFz1zJw1ruFvklLlIso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 477/634] fbdev: tcx.c fix mem_map to correct smem_start offset
Date: Fri,  9 Jan 2026 12:42:35 +0100
Message-ID: <20260109112135.496642781@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


