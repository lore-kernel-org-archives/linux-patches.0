Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BD9346E59;
	Tue, 16 Dec 2025 11:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886106; cv=none; b=XoFF1dh1STmDd1ogw6QordAKe8jaJFw3EdI0m3HDKEXVmDq05wbWu1dwiv3a1Ov98ssZdCMlF6JCPfAUl9WMYHxksbQR5ZEHRWSlN/4tpxdOKLb+VTYbUG0SuSbthfzQso+OXWK9ZpIW4HBIRqqSXYtEX2rIllCD9yvOUL32jsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886106; c=relaxed/simple;
	bh=9fHe4/GalohifQHsATqSyCAVu4X5sgy2f55TonlJXQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRcYDzrKC6y0j+n0muy0qrK1dFiGGChIV77rpr+x/DsM91mv5Ogi5Nf7uX5zYExe/UMS1Mi3dSAT06S+nTs7oMyMWKU84QVkKt0wIXb+sCGFSDbtCzD9feT78kzOkzVZH8VfgUq2WkoHNlAO35VgYsTUoTzWKzLkQtJVDofUMtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yTG75cqT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yTG75cqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126F9C4CEF1;
	Tue, 16 Dec 2025 11:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886105;
	bh=9fHe4/GalohifQHsATqSyCAVu4X5sgy2f55TonlJXQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yTG75cqT5vHjAflxQELL25EPyiOIwOcK9AlcpAZpGHWlxfCmk7hSAmmoNvvjFfL58
	 XlZUyUKBnIWMnXkoc/XIRbFXkTSQoe5MIzJPmkm+qz+kKmZ+W9vtRUP4VKuYa/AvQJ
	 ov1UgcSGl1NY1TRce9vEDoxmjURY9qvRNTXykZZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianglei Nie <niejianglei2021@163.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 339/507] staging: fbtft: core: fix potential memory leak in fbtft_probe_common()
Date: Tue, 16 Dec 2025 12:13:00 +0100
Message-ID: <20251216111357.743409205@linuxfoundation.org>
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
index 9e7b84071174c..8a5ccc8ae0a18 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -1171,8 +1171,8 @@ int fbtft_probe_common(struct fbtft_display *display,
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



