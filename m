Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD1A2D541B;
	Thu, 15 Jan 2026 17:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499067; cv=none; b=t9y9qalXHhWK3wnEmcsxiM8j8tVGXLEynFzJy+4NURzT1Ahxjlu8u6ZgI9w3aNSenrg4oU0vLQTRj6cfIUXPTcHAe8nOMoW0iee3g4rgukTnGtdowOHOyrTWKrArRkc65kv8PcYWbdF587bUsYX9gahIuYs4ewUMXSLq5hZS8cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499067; c=relaxed/simple;
	bh=xvinPzltdDLUMhZ54IhFZU3gsLI+h2gWl0rkRNIlajQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fsls4/7KGFQKJrrSYGu/mFOumiDpr5Ea8JOSNCA7jjmfl/a2paVaBWQ+Hc29Ml+hfnVg0DQ31OswOcS9ZbYlvV2/zIi9gnabelSjKYaThAtgRoe94js9/fXKndGr1qf65EY5lgKb8Syg8wF3iK07MC+id8W554vP5Np3xRFSVwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HPwRaCz0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HPwRaCz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B75C116D0;
	Thu, 15 Jan 2026 17:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499067;
	bh=xvinPzltdDLUMhZ54IhFZU3gsLI+h2gWl0rkRNIlajQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HPwRaCz0bUaKsU4SQunkMix/jxdXsXgofT9G0I98DwFxtDF2IAoX7lFJPBHMIgZe1
	 R18n1nJgBiGi2yYii46GVOe41gVuUfLjCx47h+LnLo768huvwqmbvrxjXSusNNPNGt
	 55+CgPr00M3f7mbP4QizhiTXTlbncfbVFQS9A6IQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianglei Nie <niejianglei2021@163.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/451] staging: fbtft: core: fix potential memory leak in fbtft_probe_common()
Date: Thu, 15 Jan 2026 17:44:58 +0100
Message-ID: <20260115164234.426843782@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianglei Nie <niejianglei2021@163.com>

[ Upstream commit 47d3949a9b04cbcb0e10abae30c2b53e98706e11 ]

fbtft_probe_common() allocates a memory chunk for "info" with
fbtft_framebuffer_alloc(). When "display->buswidth == 0" is true, the
function returns without releasing the "info", which will lead to a
memory leak.

Fix it by calling fbtft_framebuffer_release() when "display->buswidth
== 0" is true.

Fixes: c296d5f9957c ("staging: fbtft: core support")
Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Link: https://patch.msgid.link/20251112192235.2088654-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/fbtft/fbtft-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/fbtft/fbtft-core.c b/drivers/staging/fbtft/fbtft-core.c
index 2c04fcff0e1c5..723ca72d1bd39 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -1229,8 +1229,8 @@ int fbtft_probe_common(struct fbtft_display *display,
 	par->pdev = pdev;
 
 	if (display->buswidth == 0) {
-		dev_err(dev, "buswidth is not set\n");
-		return -EINVAL;
+		ret = dev_err_probe(dev, -EINVAL, "buswidth is not set\n");
+		goto out_release;
 	}
 
 	/* write register functions */
-- 
2.51.0



