Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DFF47A0CD;
	Tue, 16 Jun 2026 18:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635194; cv=none; b=AYncebAN+A4/6a+lonAb8YbpWK0XPsUc94ItScnNnHqlMbaLciDJAZSWyFuPtpQXgj0nUPidMX63irOeuYvFKSJoJCzvJ3fbS//jBGUe3HlNcndeuVrKatyztDUawaWWpCCX0iRwq6ZFVPanrf1crcYGNSa7zNIe4D8f8eVHKIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635194; c=relaxed/simple;
	bh=vs/3WnXGnLOAlAt8iHu3CigoSdX2N5HINoRk9W0hLok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlPxMykd95PGWLZy7mRfu5ESec60rbOhbUAP9BnClXI29CKPNXykMU8ywVLkdn8Me5/3t1W+aUEICYOmXjSbAYAXSm310ux7yfmnm4h6x5XjQiA+atg59wOIAt2ASBTBug2y7P+1ltunbarlaqk0J/jfuDm6comIFuh48mgfiaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D/qOgyvI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D/qOgyvI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7061F000E9;
	Tue, 16 Jun 2026 18:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635193;
	bh=80662teBGgGrb/ADAN4aBxDjh+xjVoN3e2nW+EOJtXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D/qOgyvIOaNn/yID5ucOHzG9s4+NjKlBQckggYDHzdrR8ItsxgrtkT7iCZnlBSyyN
	 i4ZkD91LkD8m1kiekB2Cm0Ef8zl2wnmakWtbLxqO4BKh6KffoOtH12CsCVemMBH6dq
	 AxJekxCkk8ZTQQIObdWpAu0ck6TeQUrIFX/1E9uM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <benh@debian.org>
Subject: [PATCH 5.15 409/411] fbdev: vt8500lcdfb: Fix dma_free_coherent() cpu_addr parameter
Date: Tue, 16 Jun 2026 20:30:47 +0530
Message-ID: <20260616145122.874481937@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <benh@debian.org>

Before commit 63a11adaceb8 "fbdev/vt8500lcdfb: Initialize fb_ops with
fbdev macros", the virtual address of the screen buffer was stored in
the fb_info::screen_base field and not fb_info::screen_buffer.  The
backport of commit 88b3b9924337 ("fbdev: vt8500lcdfb: fix missing
dma_free_coherent()") did not take that into account.

Change the cpu_addr parameter to dma_free_coherent() accordingly.

Fixes: 9c3873cccb3f ("fbdev: vt8500lcdfb: fix missing dma_free_coherent()")
Signed-off-by: Ben Hutchings <benh@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/vt8500lcdfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/fbdev/vt8500lcdfb.c
+++ b/drivers/video/fbdev/vt8500lcdfb.c
@@ -434,7 +434,7 @@ failed_free_palette:
 			  fbi->palette_cpu, fbi->palette_phys);
 failed_free_mem_virt:
 	dma_free_coherent(&pdev->dev, fbi->fb.fix.smem_len,
-			  fbi->fb.screen_buffer, fbi->fb.fix.smem_start);
+			  fbi->fb.screen_base, fbi->fb.fix.smem_start);
 failed_free_io:
 	iounmap(fbi->regbase);
 failed_free_res:


