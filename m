Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5A129B200;
	Thu, 15 Jan 2026 17:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497707; cv=none; b=Juw0mnk056oURmQB0wSs6B994g4FQ5UoEOVGqz+kEQ6Y476scrR/1EemPCjL1Rv78Qq3+s0GU+8g2Il+1nHAOpr76x4/jfQ4H/CFR0wNPi5YYZPcRSakWCytFurRb5yq3ksZKP+23m/gLe1F/o94nrQ1Aw7/yvNLJp5WCMhl4ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497707; c=relaxed/simple;
	bh=XhLAv4zOj260dEQv2JPXXF55uL7f60tqYWSK8Gb5gK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWfZ5ifedo0O8CnYUS1SVSzLyqUirWNBlkAEVMRxXAPExKOTrswRDNmo2A5ptSSnwud1yuWlYVMcDmzqMPOl6TD7skKLGs2Mx8Aoc6OCqsRaN01tYFpCuLwgVuSDeHnuDKVeaftWDJgj1Ihu8bQoI28VZlC8ggXCzt0VsrFpGKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aStyXtcm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aStyXtcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57931C116D0;
	Thu, 15 Jan 2026 17:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497707;
	bh=XhLAv4zOj260dEQv2JPXXF55uL7f60tqYWSK8Gb5gK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aStyXtcmtBGpqo1UIbWNRH5pYFnclbMQJNVtLtDXc24Ut4pDc+LGTNft7qiVlMLYa
	 cciBS+JQrZX/UX+O4dMOfVxwIf64wgvTicwxyDB3XDPLjIpx7q/kPqIjq16a8pvIQ1
	 x5fCDpC/jBxhcGTszMJb3K598y9ZjnI0AFMxYFeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 168/554] fbdev: ssd1307fb: fix potential page leak in ssd1307fb_probe()
Date: Thu, 15 Jan 2026 17:43:54 +0100
Message-ID: <20260115164252.348463453@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
index 7acf7c0b263e6..212494b0a4ba8 100644
--- a/drivers/video/fbdev/ssd1307fb.c
+++ b/drivers/video/fbdev/ssd1307fb.c
@@ -732,7 +732,7 @@ static int ssd1307fb_probe(struct i2c_client *client)
 	if (!ssd1307fb_defio) {
 		dev_err(dev, "Couldn't allocate deferred io.\n");
 		ret = -ENOMEM;
-		goto fb_alloc_error;
+		goto fb_defio_error;
 	}
 
 	ssd1307fb_defio->delay = HZ / refreshrate;
@@ -812,6 +812,8 @@ static int ssd1307fb_probe(struct i2c_client *client)
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



