Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2895B26CE04;
	Thu, 15 Jan 2026 17:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499704; cv=none; b=fgr31R0caHltI53KAWaO7zmn769nwDwdm51hWxZZtMBRDT3ZtZofBtHSZJhtp5FO+tCHgYihYHQo8q2fw0Xy55tdRMXAQJsm16xIQZp6PiTEnY6WHlMb/Q9f+cWcyzaGgGz+uHQ8fGQ5LRi0bBcC1QNIKQJ27wWAK0GznE0swCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499704; c=relaxed/simple;
	bh=Mc1QKfOYQIknN87nDp3zqv12RiF+EEANfA+6B46KVXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xw2RZqEiz2WESfBwpwIH/Qo/DBMnVIviP1GfJZu3kKcfvGY8qZPSE8pyQ/O+neRvSl4qqiGFX+fDZYW6dpi1mC0iJ2y3H61i8jiSa6LJHJay50PJDpIXamZK6TlnTC19yE/UGvAFEzVHI0irtsr+BhxXsKzFz2oVfFnzFP/mopc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=141UVbry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="141UVbry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDC5C116D0;
	Thu, 15 Jan 2026 17:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499704;
	bh=Mc1QKfOYQIknN87nDp3zqv12RiF+EEANfA+6B46KVXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=141UVbryavtr+4B+QESv9yI1/wjCMinQvKoZ/M6LGONDlF/Ay9boLGcxzUrLxlJnw
	 GYgZMiWv1Q5qSmTwo+ZgKv4KvKWmEwRcDuCfYpRouQzFoHOpYjlibUSYmiVrrLk6ll
	 1bNdGRNBlYKR+t5rZ8l/q8GTbXd1/IEp+ug2oSR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 321/451] fbdev: tcx.c fix mem_map to correct smem_start offset
Date: Thu, 15 Jan 2026 17:48:42 +0100
Message-ID: <20260115164242.512280132@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


