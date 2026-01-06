Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F5F36B072;
	Tue,  6 Jan 2026 17:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722124; cv=none; b=oDqX+9JpLprHmHayGmoIbfTk9NCEzl/9XUfIwFjkA7DB19ZFj6vqLfKBaazjqc0vOCcKKBwEM/fAGxXomUS9ZId7r8or+942Q/6aZNEGyHi2NuNBuRYs9rqIZLpqJ1I4W0XkF1hi2qsR0N2VWRX0e4aDB9dKhSdqyxbI+FzjtDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722124; c=relaxed/simple;
	bh=Cx/dYM+F7kqOXtZYAmaojpP+OQJqiPQDyWoLrametp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gm4IPUapxB3ntyXwBMx7rujpJhH+8IreBG+nDjsCVgUb1wy+h9XiftfWYfTCp9Al1624mbGdAC6sT+IamD3UzpPWH2a+Y6S/R2rFvPBj4A2wzEdFhxwONhmC6VgnZFuIRb3sVkcSlIE4C+IRTbknacKtqwz3oYs+WCQpOVP8Rys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ApPV315d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ApPV315d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41E2C16AAE;
	Tue,  6 Jan 2026 17:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722124;
	bh=Cx/dYM+F7kqOXtZYAmaojpP+OQJqiPQDyWoLrametp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ApPV315dcd6vRWXi5QR+lcZ5lKnLL9rEhQq+Er8qBabafUs5R/wJZJf/2DcQvNbCn
	 0B16C+kr4eyJZO7tRqwPM3yscvkyCikf7kmHwmLaP38nh8bm5usUWgopWEzMuDX+Q9
	 KIT9jfRE8jfhmbA/Wi8k2UH9p2NDlVORz/RgKS2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 173/312] fbdev: tcx.c fix mem_map to correct smem_start offset
Date: Tue,  6 Jan 2026 18:04:07 +0100
Message-ID: <20260106170554.094299164@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -428,7 +428,7 @@ static int tcx_probe(struct platform_dev
 			j = i;
 			break;
 		}
-		par->mmap_map[i].poff = op->resource[j].start;
+		par->mmap_map[i].poff = op->resource[j].start - info->fix.smem_start;
 	}
 
 	info->fbops = &tcx_ops;


