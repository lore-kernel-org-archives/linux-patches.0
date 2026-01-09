Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82045335561;
	Fri,  9 Jan 2026 11:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959865; cv=none; b=h470fw+f7rk9rGYZaw/GceXeb+6VQE+qdC2l1wTtoTGS4+lpDmaNvXClqNqyHmGuxpwMONAmojTBzCKcdjiTmss3Sxh/PHdtBWeIGzTj9Q5Xdm2MBhs7AeJPvNsfl8bb3xlIIoaj63asWWmCbQGg+c/ndtfS4LCDTBIdGu+Z3+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959865; c=relaxed/simple;
	bh=fVVY7XCk2dHwANiNigyRFg9djbl9qj+D8S3ECYKGDdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8mSMjsS2RS9OBKGXXx/6Ue2l6UZyYVzBSd1ISf9ceU24u0hyWzSgjBFeV8HvnB98BYg9jsyO8OF8PLvjcdkHwKrqQPoaxtZQJo6faKp91JOTrizsrgpqIJDjG7SizCWXqcJqu8zQb2P0sjK06BBhsS29YV7Jd/u+16Tdt7R1Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f3Vixbeb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f3Vixbeb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7D4C4CEF1;
	Fri,  9 Jan 2026 11:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959865;
	bh=fVVY7XCk2dHwANiNigyRFg9djbl9qj+D8S3ECYKGDdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f3VixbebT7TacsxPfqbA7rbip+ELM5mQ9o6+rPyLVoyrAHXsEgwT8vxIgCKAxncoD
	 l5OcR3nEtfOoEL1Zrj3xI5EvJs+/e/BF0JtU42bj+5hA7oPoBBx8B7glFaaEuQhDuq
	 1Rh0GH9po1ipnO0Ethz6xIL7qXtMdQ8N4vlknI1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianglei Nie <niejianglei2021@163.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 202/737] staging: fbtft: core: fix potential memory leak in fbtft_probe_common()
Date: Fri,  9 Jan 2026 12:35:41 +0100
Message-ID: <20260109112141.600985524@linuxfoundation.org>
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
index dce721f440c5e..5dfe2d7a73e37 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -1225,8 +1225,8 @@ int fbtft_probe_common(struct fbtft_display *display,
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



