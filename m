Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A63340DB7;
	Tue, 16 Dec 2025 11:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884754; cv=none; b=jfCw/QSdOnP1mS+WoUqXLa41vNGsbYokgQNMlA1EBb1EMMf1x0qU0g0LJeaUwwwitHtgSGJSNlaE/JuQHOGrAHXTx6Q0+kQ3a7s5tnFk/B3IdcL9ZtsODxJ8n9BXsL8sA5dw2bN2aRJp5THcipVUjF8h6LH+nlAh9DK4JnKOCrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884754; c=relaxed/simple;
	bh=QWaLBjJJ+b4JI6UCsOYLTdGhtkfoFp4wX2UAH5mWjiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNmguE6x9gqQvCmxl2WGoa4Ig4SWEifgPE/zzGh+PRZIbf6GO5K4uFh+tJh3A3fk4Wk3bSR6ESsXiIithxP2TDmPrVPBOBTdHHze9en5VuED8IR5EV/T4xQKrDznhX39vBOlpoqmuN142mrQk/keLqo/aIT3q3B7YBdZycuviIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sRikCz/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRikCz/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6684DC4CEF1;
	Tue, 16 Dec 2025 11:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884754;
	bh=QWaLBjJJ+b4JI6UCsOYLTdGhtkfoFp4wX2UAH5mWjiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sRikCz/MGM4Gpq1EDMyObfAjJzRlMlYKjjw7smgt0idXYnpIh4QwdSfXKIcuOf7E9
	 zkBGg7jwtBFwEQ/UP56GYVfMGVtxNXXbsuAO7YlRhs0jeNaZQqv7fbTPiGBin+U7dF
	 WuEalLupNvk3RFRQ5N12/rHMYObCiED2LlHcfuy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 289/354] fbdev: ssd1307fb: fix potential page leak in ssd1307fb_probe()
Date: Tue, 16 Dec 2025 12:14:16 +0100
Message-ID: <20251216111331.383389526@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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



