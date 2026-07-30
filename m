Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C70399003;
	Thu, 30 Jul 2026 16:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428041; cv=none; b=YzroxlYgTykhdaJAxxn8RK7JQLgpsa5v/BF2YhRmX05wrl0VCayilkOdgBQmQA2uJ56yb5TQlTu29fDEA+1pBMjIVWSL/yZuFpC3e23nRwGSJ4I+b50vFgFZqBdGGgD5eiUk92rUTog+jQ/kO/InCmw5m1GAajcV089fCtdSyN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428041; c=relaxed/simple;
	bh=H/7NL9TjVNj6fWGalOrb1dYMtEO/ui/zygV2xZNFm4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Klz0ZixqgYVu4FIrYTykeackXJWwuM5JyFbyG6T3ZRnkBAjrFY/nhaNaT8HkCgR3B0Ha8qdxuEbr31BmNQIqf1yokLsiFQhwyL5qfQtB798QKob+QvdsjPHyfjuz3EQ9EAC4dfDyL4562gViZbIG2OsAsyK+g68abdPmwoW1TVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c7ybjbyH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c7ybjbyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F413B1F00A3E;
	Thu, 30 Jul 2026 16:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428039;
	bh=7FoghEqIXaKY6gPUPFgZlda+8YBe6P0ZR5ZgyZ6lyXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c7ybjbyHknEwqny99SK/G6qoOeZztn9YCykIT3qRRX6X/UARYisq00amVIz64p4QB
	 Emztfm0KYXvX3mHOBwJvYqB8tKzvFFJkg4vYBoEFI81tAllWRnL8x3bZZRdVLrSaLU
	 o5D3rvrMTibKMIAxvgAF5nZl+deaXO2VBF0HqKHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiacheng Yu <yujiacheng3@huawei.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 383/484] fbcon: Use correct type for vc_resize() return value
Date: Thu, 30 Jul 2026 16:14:40 +0200
Message-ID: <20260730141431.796348610@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1356,8 +1356,7 @@ static void fbcon_set_disp(struct fb_inf
 	struct vc_data **default_mode, *vc;
 	struct vc_data *svc;
 	struct fbcon_par *par = info->fbcon_par;
-	int rows, cols;
-	unsigned long ret = 0;
+	int rows, cols, ret;
 
 	p = &fb_display[unit];
 


