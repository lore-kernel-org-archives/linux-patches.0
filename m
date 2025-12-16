Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345141991B6;
	Tue, 16 Dec 2025 12:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886418; cv=none; b=XLuxrBCxn9Pb6iRRfD/UYpwBkRsMOupYcXtFdsDX4s6orDBCIh/QRST93d2A1z22xm/Bjhb80fRYjofFHF4NwQaRHQOdQd4SM09EgHcG13n+X1CQviCWxqflX6x1K/YmsZFPABQVdOecdy1z55Yq7iAb86nfdO8kmtHoSEsjCD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886418; c=relaxed/simple;
	bh=fA8N1K899rP9sNWnCCMieQO8OpJBxPrVG18d3oWkXhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I59GgadIQli5dnqVTjdTBk8NUVzidKZDOMO1vLItaENOBsBtYoP1VGjRSf3wFbXQBk1Xma0JHaP7XAKoRltUegmdiwDbFbF6tVLMKon6Uq+nwx8Tw+3vPTF0gvnBPp/twY0W/pr73dBWiZ17rDXM2ieK19n7/gNqzqOu06rfji0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXx7vERZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXx7vERZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C8CEC4CEF1;
	Tue, 16 Dec 2025 12:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886417;
	bh=fA8N1K899rP9sNWnCCMieQO8OpJBxPrVG18d3oWkXhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXx7vERZVsMzCmtN/vpVRvJF6HyvWQlrhnXgFVsjDik3UwrKq5ppF4Dd7Lh0HLf05
	 lkG3I0cMOn9JC1zXqNUfAYL1Op7R9NhITEo7iT7aHDUr2vqB6Czif9p5lMjt8+SvA+
	 EYuP4vXyKHIQ5FxfLelesk5aGDGO7YNYhnqPZWtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 431/507] fbdev: ssd1307fb: fix potential page leak in ssd1307fb_probe()
Date: Tue, 16 Dec 2025 12:14:32 +0100
Message-ID: <20251216111401.074463848@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 164312662ae9764b83b84d97afb25c42eb2be473 ]

The page allocated for vmem using __get_free_pages() is not freed on the
error paths after it. Fix that by adding a corresponding __free_pages()
call to the error path.

Fixes: facd94bc458a ("fbdev: ssd1307fb: Allocate page aligned video memory.")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/ssd1307fb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd1307fb.c
index aa6cc0a8151ac..83dd31fa1fab5 100644
--- a/drivers/video/fbdev/ssd1307fb.c
+++ b/drivers/video/fbdev/ssd1307fb.c
@@ -680,7 +680,7 @@ static int ssd1307fb_probe(struct i2c_client *client)
 	if (!ssd1307fb_defio) {
 		dev_err(dev, "Couldn't allocate deferred io.\n");
 		ret = -ENOMEM;
-		goto fb_alloc_error;
+		goto fb_defio_error;
 	}
 
 	ssd1307fb_defio->delay = HZ / refreshrate;
@@ -757,6 +757,8 @@ static int ssd1307fb_probe(struct i2c_client *client)
 		regulator_disable(par->vbat_reg);
 reset_oled_error:
 	fb_deferred_io_cleanup(info);
+fb_defio_error:
+	__free_pages(vmem, get_order(vmem_size));
 fb_alloc_error:
 	framebuffer_release(info);
 	return ret;
-- 
2.51.0



