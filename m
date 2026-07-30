Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3E43839B2;
	Thu, 30 Jul 2026 15:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426615; cv=none; b=PvPXYD9tOcLU4GfzF+Ab/KLfbE3I5NhOjAJlRg+f3MBDnJxE/t8o0NdVbv4c0GrpU3vF+MFfsvE5t0f6WEYYRn8KCntlW5FWgJ8VG7mefonJXDq0E34tex4Z+Ki9+1PwsdqLzxh7aZGNrew2F23mEwKTXhsK6c/mj85fHzCsj5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426615; c=relaxed/simple;
	bh=YzWdwKRPpp+/+IfJWYDnWm7M+62yKWSJAcpzX4y+4Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nAN22+WxTB8WjWd1B9Jed5Bbyu032mAaHNEETFO5sho/k1nqkyEx0hDEVOI3J3QiZTaIFKu3yRxO+OO86NWgEKW1ZWcSHYJ3pBoGX/OJL98NMmzCP/UKcJBafzEateg5fTKQgR3qld7WVHJJkqQ7Rr8PWgHHUnxIP4n98Bhv/CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ytXuioeT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ytXuioeT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992A31F00A3A;
	Thu, 30 Jul 2026 15:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426613;
	bh=vqUTynDZBZ9l/90/PSnVwRD2CNXsqF502DlKaq90EBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ytXuioeTmfCxlJAD4lg1rLxfFAAGr9iTPZbf8k9BueQmXO6ABhLekllqXJq7JIrjS
	 HYY8UeG6O7RdUFDlweXT2P/hMrpMmYy9eaJR+3MOxwA3QGhTFbnULtQENsDBMk7yVg
	 Err+fDbd3sDM7rHADjPkUkIDirApfo5Z0CD6dkes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiacheng Yu <yujiacheng3@huawei.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 482/602] fbcon: Use correct type for vc_resize() return value
Date: Thu, 30 Jul 2026 16:14:34 +0200
Message-ID: <20260730141446.094651209@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
@@ -1366,8 +1366,7 @@ static void fbcon_set_disp(struct fb_inf
 	struct vc_data **default_mode, *vc;
 	struct vc_data *svc;
 	struct fbcon_par *par = info->fbcon_par;
-	int rows, cols;
-	unsigned long ret = 0;
+	int rows, cols, ret;
 
 	p = &fb_display[unit];
 


