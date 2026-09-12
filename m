Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4030A26ED46;
	Sat, 12 Sep 2026 19:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242429; cv=none; b=dvNoyMsI+9f3sy4DFRg6nlbdPWi053p2fnSW7J0RbPY1itZgwbMJur3GhvdWvsRCDmz8Id4w+vnklAp6FKeVP1xSJGVNGGts6L4rteZOgPQB3bP2vNcIKT55Wn+tKZ9Yxec7+3grkuUwNQB6LG04as1CPXm6GHSduHYJcroF9eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242429; c=relaxed/simple;
	bh=oGksQtw3kPOswiAW/0f3lOceEIINNTHjRL7KRPWSBdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nL7p81M2nXCmn5SA09BhDQjMely8XMEBHoQzdceDk+PA7Fwv3i726D/ikiUuFOcbjx2h2aTFZ2kfOM5iwhpLHKf2kFaq7rrNAS6WT05hPEftpUe0hzyQnWwUon6X/KmHy5xXV1MG3e83KXZuMNLYS/9cAmzvw7rO+eFmJifSsGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dqcTs8es; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dqcTs8es"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9621F000FF;
	Sat, 12 Sep 2026 19:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242427;
	bh=PYdQCOto0rivUlIrEfbbthlUd4lxV8tezGwWnmRheJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dqcTs8esOkKhZwzmLNEkIRyKc5oToaRShLQukxiD8d7RcE8TtmdVi5Cbyh5sjmpft
	 ncP64FMMkP16+OTiBdWqojQAgEaYroW3o5q8E3xZTslFzZOajcHfezAsghqORQtfdf
	 DZ5bE1l7ZsvOn5JP+JGDxLUbnuoVXyXlRm4VZXDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 400/798] clk: qcom: gdsc: Release pm subdomains in reverse add order
Date: Sat, 12 Sep 2026 09:00:28 +0200
Message-ID: <20260912065526.317295675@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit 0e6dfde439df0bb977cddd3cf7fff150a084a9bf ]

gdsc_unregister() should release subdomains in the reverse order to the
order in which those subdomains were added.

I've made this patch a standalone patch because it facilitates a subsequent
fix to stable.

Fixes: 1b771839de05 ("clk: qcom: gdsc: enable optional power domain support")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20250117-b4-linux-next-24-11-18-clock-multiple-power-domains-v10-1-13f2bb656dad@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 86b23609d5e1 ("clk: qcom: gdsc: tear down per-domain genpds in gdsc_unregister()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gdsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gdsc.c b/drivers/clk/qcom/gdsc.c
index 6db451fb77974..ab1b42dd7ee0a 100644
--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -539,7 +539,7 @@ void gdsc_unregister(struct gdsc_desc *desc)
 	size_t num = desc->num;
 
 	/* Remove subdomains */
-	for (i = 0; i < num; i++) {
+	for (i = num - 1; i >= 0; i--) {
 		if (!scs[i])
 			continue;
 		if (scs[i]->parent)
-- 
2.53.0



