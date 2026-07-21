Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE7D46AA80;
	Tue, 21 Jul 2026 15:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648133; cv=none; b=axU945BBuU9fnz6r/feIHnClMoPklEPn9A/wBFMwBAqMsw0vTfQRj13oErGAvkfDZZ1vXBbk0gfEcTHOtNpo8qE12D3vBDX6Z5l+Jvv4Y5AeWYHhY5EOhY9s1IWj4RPUVxlecR0aK1OlTuqSaqSiCMcLKUEq/Zr+Sc1M5sIy4qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648133; c=relaxed/simple;
	bh=VTOzYYHxBZTN2cUHgX7yzCqZC2YBi+dS1ZmVl1lzkfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bznmeIcga/AEEgg49CasNb2W49LE5eo5QiLUliQVzXUp1hu5C/I5TktFtIV5TPh5vnYadpaxA6aGP6H3Dja614ANS1XUYuDo1dEBxGqB6HyE9C4K+qc/5jGPUpKJNjF1eKWjWjWpTU5IP1nLNYMP+ACtEfwZ9PoHVmnUtDC/+ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vcCiaL0i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vcCiaL0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9793B1F000E9;
	Tue, 21 Jul 2026 15:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648132;
	bh=qyO4z23R2requ++1rrLXT0s79QfdscCJpRs4ObsM9BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vcCiaL0icBBsrlzUvMF9Oba80uFbZGeu1Qu282LsAWre0b/FjTYoTMXkAhID5ZI8p
	 8Ff1oBtzPsdG5BDE1xGjT1HqafIuGl6HOmREWlu/1hs8UsC6k+gUaQDYO9EtvaEdjd
	 q3rQ1sfL3ZsXIZfHxaK7jLbVkUeS2F4Qc5CaEKW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiacheng Yu <yujiacheng3@huawei.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.1 0040/2077] fbcon: Use correct type for vc_resize() return value
Date: Tue, 21 Jul 2026 16:55:13 +0200
Message-ID: <20260721152553.633116626@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiacheng Yu <yujiacheng3@huawei.com>

commit 84202754fb1727dc3ee87f47104e4162ecc8ba3a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -1441,8 +1441,7 @@ static void fbcon_set_disp(struct fb_inf
 	struct vc_data **default_mode, *vc;
 	struct vc_data *svc;
 	struct fbcon_par *par = info->fbcon_par;
-	int rows, cols;
-	unsigned long ret = 0;
+	int rows, cols, ret;
 
 	p = &fb_display[unit];
 


