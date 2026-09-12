Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BE3385D7F;
	Sat, 12 Sep 2026 18:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238509; cv=none; b=bySYynornyYMkraHdDjAKxJbBeEl/q0s+X0VscgmvQ1cwJBRsfSmwp97gFr+DsgmOCBdPkhry1dDoYVYQvXlOzIm2IXO69QpAs9NntFIEAzape5DoJlPYwwxw5ehTOoJpyEZ2uyCM6A1n7Op/2Ptpvy4fynZcCGGQc1e5CWIwrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238509; c=relaxed/simple;
	bh=QBDef2NB71IgNCotDTZy/2XEArM25NEciDVKsFEi7Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ak48Mq+SrrCDOvN+IIF1clqi1JThbEp3EJd6JMo8Jua70e71dc4aJ3cPzCYnr/qn2zn1BWKyKDCvBnHw1GgHsiA1CvS/Y8cmI86hW+3t1PgNencNqDrIvNMrwpWSj/RyiALi/zrbwMXPrR+dLKJ7AxR/DKi3idv8gvm1n3cEafo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q1SqRpsG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q1SqRpsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978B91F000FF;
	Sat, 12 Sep 2026 18:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238508;
	bh=J8CQmHs0gK9F7ksacUx3ymoM08PjIlo+oxOFRhgRyDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q1SqRpsG4jXlZL44RDhKWVeAIT04RrZKgXhR/2cNxQ2EgvO+YOOmsdGpWPLcb3aOT
	 Fc8b2uT3RqxvRzLIsrUwtb1n77gHOfanZnCQnvKcQurUQdjI568JRUDp0C9KTg6Hap
	 zOmJMUEoJmI4lvpQacZPdp8GNongPTZWhI9KBtwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Slavin Liu <220245772@seu.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 475/935] usb: gadget: r8a66597: avoid double free of ep0_req in probe error path
Date: Sat, 12 Sep 2026 08:58:25 +0200
Message-ID: <20260912065537.721778374@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit 41d541e3718db01668a4cd29815ee4b3b55f76d2 ]

If usb_add_gadget_udc() fails, r8a66597_probe() jumps to err_add_udc
and frees ep0_req, then falls through to clean_up2 where ep0_req is
freed again when it is non-NULL.

Remove the redundant free from err_add_udc and keep the cleanup in
clean_up2 so the request is released exactly once.

Fixes: 776976a67ae2 ("usb: gadget: r8a66597-udc: cleanup error path")
Issue found using a prototype static analysis tool
and confirmed by code review.

Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Signed-off-by: Slavin Liu <220245772@seu.edu.cn>
Link: https://patch.msgid.link/20260624140908.1282-1-getshell@seu.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/r8a66597-udc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/r8a66597-udc.c b/drivers/usb/gadget/udc/r8a66597-udc.c
index 38e4d6b505a05..e36eacc0f4d72 100644
--- a/drivers/usb/gadget/udc/r8a66597-udc.c
+++ b/drivers/usb/gadget/udc/r8a66597-udc.c
@@ -1953,7 +1953,6 @@ static int r8a66597_probe(struct platform_device *pdev)
 	return 0;
 
 err_add_udc:
-	r8a66597_free_request(&r8a66597->ep[0].ep, r8a66597->ep0_req);
 clean_up2:
 	if (r8a66597->pdata->on_chip)
 		clk_disable_unprepare(r8a66597->clk);
-- 
2.53.0



