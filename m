Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB13035B129;
	Fri,  9 Jan 2026 12:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961814; cv=none; b=hT98ZPuGZ/SZxQcy0hofE8Ysm6M1IFM6C9rHcz5byn1vRQJ5+J9bEfFEQVkOn0PRYQkRmu1yk4KPLu0iLJf9S9KxYxFNlMqcxbfWJlagmjDhuOUlelccMEldtXztfTyNdg6zyC6yy5qdooj8sr6cMaWSLc++hmbQt+9tzuH8sL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961814; c=relaxed/simple;
	bh=mft0QLBMtDmef1LhCEb3+r6XtsoGyono1JrRlRLLfjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6I/DXJ9diImQXCEVFWmViHgdj25ohedVxIuyIb5vBxpL4TuLKSYxYRacqDH8kb/eqMm2rzvJHrVl0O7ZzcyGne1LPzpVhFQgLFyL2Xhc68yFC3LGJIkJGaIg5N2z3fzCAk+6/febRGII3x3wxz3fuzlYQbKo+h8vKX/Y2vHVV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MgSqlrph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MgSqlrph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4046C4CEF1;
	Fri,  9 Jan 2026 12:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961814;
	bh=mft0QLBMtDmef1LhCEb3+r6XtsoGyono1JrRlRLLfjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MgSqlrphGzUWTtywsC13RcdKPJA9Ankj4VohurlcC7wbGusJ8YDr7p7edAaBXaspJ
	 uFS/PNGWdwQYBdkf4IPx/qawOZWd9ms3r5Mns0RQs25bka1CySymE7BGMKKP7/hr8a
	 88zpuRE+sHfSHfLjWJVe9U+ZlmEdFoznn1rbRzDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianglei Nie <niejianglei2021@163.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 146/634] staging: fbtft: core: fix potential memory leak in fbtft_probe_common()
Date: Fri,  9 Jan 2026 12:37:04 +0100
Message-ID: <20260109112122.948515822@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7b802b0226273..c20e1afc0ada2 100644
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



