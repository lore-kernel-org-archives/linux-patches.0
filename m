Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743CC359FA0;
	Fri,  9 Jan 2026 12:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960949; cv=none; b=abNTaehoPUs0EVzNBwr0wYJDqm+HhjjAMB/ULxHnNiSW8/wbd603Q6hYlHkdBfmHbQu9jBGE/o/cXYUXBOIZAr/tLT+piMAsnjTnWfCM5qb4l+Y8bqwkEkPnXvxUzOlx37j9j7NgtHka48GtGs4O5yJfFawwmcaaFWNbINuOrqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960949; c=relaxed/simple;
	bh=PsGQzOPj5Pm9xOk3RZpRthxBmGCw5WuyP1ceAm+PlCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OnHkAUbDb0i7qCjv3GGo+50RYzMNxTSCYX9xJJ9sc6By60hFmASQyqgPlQQrvtfmtxYNjA28CbdcHeHooAqXCMsy1TAC7IF6fj2H8GhhTlErt7+wpUQEKo3e9memgxqt4/BNMQHNKsOMVFCy94cGcGNDEGdnjAU1LBdxLS6Vg0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=06KHpTH6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="06KHpTH6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1495FC4CEF1;
	Fri,  9 Jan 2026 12:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960948;
	bh=PsGQzOPj5Pm9xOk3RZpRthxBmGCw5WuyP1ceAm+PlCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=06KHpTH6FnvZ4LmfRF3QqHhXjmFZTaPKNF9Zj3OjUyddD5c/mA2q5rVt74DMNaRdu
	 Iq2xdn2ufmc4MT9YnMCIYe6EW2gVqjSDD9EXpbLLDV7VrCu8Cnzg8gAlMmyfGYtTJO
	 n8+eXppMi4xmVH9zyui4D2OIDWoNR+394XlhmzyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 582/737] fbdev: tcx.c fix mem_map to correct smem_start offset
Date: Fri,  9 Jan 2026 12:42:01 +0100
Message-ID: <20260109112155.895155248@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 
 	info->fbops = &tcx_ops;


