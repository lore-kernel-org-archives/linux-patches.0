Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34FD484257;
	Thu, 20 Aug 2026 17:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248001; cv=none; b=AVg/y1nKIgpWAUJwWhSzhTfWseAEbyioXpSragvw5QsK5HwnlLbQXiaWCXerfilZbHkXXJPpktRdFeCp5kCIbZwN4MHOxetSF/h3XZ3GixQchr5asPDXKEVC+LXwTnvgZr3vnz20c5LD8MdrxRunYp4pqwU4567+6f5yJ2muGUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248001; c=relaxed/simple;
	bh=w3F+Wq/uyu8Zq8wuiU5dQdxRJHB34gihiZaxs9gd4BA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDIp0PXeCjPv1fjKWcgkxDZIjqAtT3XnVPX7cA71DFrBupUSqIFnze+hnS+nJKvfdL/8YXvLg8/wMSyogekc/NM/bLJOM0qYCODsBBPKKe5NUptfltc36Y/GbogunAx/sqDBGuOiGztRjEM5KRJjHcndl7o+O3+x2ffiGMRmoXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UMhxBYEs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UMhxBYEs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7431F00A3D;
	Thu, 20 Aug 2026 17:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247998;
	bh=wGAA1hlVEiqopSRZtE7SVUzGOwHX1rf98ChVf/7WtmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UMhxBYEsAjT2rwBfo/K4Bmbw1YEmGSsSopf6FX6s9UdAMX671th2SuHo0rqtBU3u0
	 Xzd5OnYBPkzka12lQ45p3PVJZQpNBFzE/0D3LxvLubFQlAvRhu/Hpc0dX5B+4Ty6Ah
	 XWG5SzY5+V21TZ1n3Ajz0xdXpj2gcmQ8Yl18b/Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiacheng Yu <yujiacheng3@huawei.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/303] fbcon: Use correct type for vc_resize() return value
Date: Thu, 20 Aug 2026 16:53:32 +0200
Message-ID: <20260820145255.445789811@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiacheng Yu <yujiacheng3@huawei.com>

[ Upstream commit 84202754fb1727dc3ee87f47104e4162ecc8ba3a ]

The return value of vc_resize() is int, but fbcon_set_disp() stores it
in an unsigned long variable. While the !ret check happens to work
correctly by coincidence (negative values become large positive values),
the types should match. Use int instead.

Eliminates the following W=3 warning:

  drivers/video/fbdev/core/fbcon.c: In function 'fbcon_set_disp':
  drivers/video/fbdev/core/fbcon.c:1494:14: warning: implicit conversion from 'int' to 'unsigned long' [-Wconversion]

Fixes: af0db3c1f898 ("fbdev: Fix vmalloc out-of-bounds write in fast_imageblit")
Cc: stable@vger.kernel.org # v6.17+
Signed-off-by: Jiacheng Yu <yujiacheng3@huawei.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -1354,8 +1354,7 @@ static void fbcon_set_disp(struct fb_inf
 	struct vc_data **default_mode, *vc;
 	struct vc_data *svc;
 	struct fbcon_par *par = info->fbcon_par;
-	int rows, cols;
-	unsigned long ret = 0;
+	int rows, cols, ret;
 
 	p = &fb_display[unit];
 


