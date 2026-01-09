Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2340F33CE9A;
	Fri,  9 Jan 2026 12:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960019; cv=none; b=rKOfIftlyHw0gMU4gzFgykrTziyehM0vU690Y5C0GXTXBv6yEHm9LO3xoL3H1KTbsZ2fEmvnX+ZZb2VB7rN8WoQNKp69RhzCBYDs0Pty6hB2YDoVJmZ90jvMNZ6i7QJHR9UyS1QXws14iTZlm8ZK5eBypK20h0LYDO8L2GSpa9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960019; c=relaxed/simple;
	bh=ucL7VrkDak9p8zCCGGc82C4TP8GmN195KEf+4ZYdPCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pduEV12Fa8W51XYHT581fJcrtk6VJLpjwkt0sO3yTnShefUHbPGCwpkIu+XJqCVPuB9j/5mkjnN0oNut0b6SQLivWIWSICBMVV1Jr78AS8ksUxkSULLqyAX07x1HWrVHc3t1Aa+7vq2HlA4+lNS0I6qnDZDBlYIAGi2epdj8WNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nktlGdf5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nktlGdf5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99AAFC4CEF1;
	Fri,  9 Jan 2026 12:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960019;
	bh=ucL7VrkDak9p8zCCGGc82C4TP8GmN195KEf+4ZYdPCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nktlGdf5H2cjh9kDMGuShaVMbJarZtZ4N8BimltUwQVOyppcHrrD6fKCTOFCpFMsQ
	 LxQyLfUwTQqa9Znpqu+tjzUD+/KCVkKua0ofOeGsM/4qqTTGlGAENJiMnrJvZtf3+h
	 6m6PCvlKpN+jGDKWDGOY6eQVu9VKcpUCtpFXHBdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 257/737] fbdev: ssd1307fb: fix potential page leak in ssd1307fb_probe()
Date: Fri,  9 Jan 2026 12:36:36 +0100
Message-ID: <20260109112143.660703183@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1a4f90ea7d5a8..bf8ec4861b45c 100644
--- a/drivers/video/fbdev/ssd1307fb.c
+++ b/drivers/video/fbdev/ssd1307fb.c
@@ -688,7 +688,7 @@ static int ssd1307fb_probe(struct i2c_client *client)
 	if (!ssd1307fb_defio) {
 		dev_err(dev, "Couldn't allocate deferred io.\n");
 		ret = -ENOMEM;
-		goto fb_alloc_error;
+		goto fb_defio_error;
 	}
 
 	ssd1307fb_defio->delay = HZ / refreshrate;
@@ -766,6 +766,8 @@ static int ssd1307fb_probe(struct i2c_client *client)
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



