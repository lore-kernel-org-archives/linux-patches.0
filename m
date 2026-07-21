Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5712D408634;
	Tue, 21 Jul 2026 19:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662106; cv=none; b=SSgMIYexrWydL9nhjymGSfygYM0Zv0g8ade2jAaiDR2Csrh9fbZ//wTfVcdxxSgOb7zqOlytbxjpspL7PLdJKqOG9RR0yuacUwJw0Z+g5YfxnvcAl3w9I3ZutLQYRk1xSK1wuCzmEn3MXTMIbn7HrGwC6R45txhoOErNBM2YmqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662106; c=relaxed/simple;
	bh=eBb/cHfwbAa0Y8poEmdnOM2OflqrCeZT52XzDfoNre0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDhlMd2kohwCVruAs/fRC7NS3lxfdhE+42qg/fHtTnD8trao+7TXCPCQIQ1mOmlZwNL0qK3UuuxwC/tbMv+cC+ECiw0AUtmdHEOloLZ7mmYofUGF1mJuDdqcMX+xk3sSVH6FnMsrBNQgEHtcBhGEyui3M7sSck0QtEpB9GXBiYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=omB0ThrE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="omB0ThrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEF41F00A3A;
	Tue, 21 Jul 2026 19:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662090;
	bh=RwYAIBCL0yJR4zBIaZDFqZa8zhnJXMD7O1Kap6ycq2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=omB0ThrEmIEd41C3Tj0JFNN7TWsGxggRhkcPcL86e4JbXtr2FCeeuTkaJIj8Q5LS+
	 aCtZvQincfwTwv6V4TAyykYcTIK3NCALBpoVYzxlJ4+5J1LKCmKrpKgviBxi7faZ8k
	 4WxRt3+jkrc11WM3maackeOlJE35+4u66JbPHrBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0312/1276] cxl/test: Zero out LSA backing memory to avoid leaking to user
Date: Tue, 21 Jul 2026 17:12:35 +0200
Message-ID: <20260721152453.079826165@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 60f065dbaf46e65830da62a0041761f0c039e086 ]

Memory through vmalloc() is not zeroed out. When this memory is copied
into output payload, it leaks memory content to user. Use vzalloc()
instead to zero out the memory.

Suggested-by: sashiko-bot
Link: https://lore.kernel.org/linux-cxl/20260605173146.2B9A31F00893@smtp.kernel.org/
Fixes: 7d3eb23c4ccf ("tools/testing/cxl: Introduce a mock memory device + driver")
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260605184426.4070913-1-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/cxl/test/mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index 15eeb1e5f0097b..7d657ce54d643d 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -1484,7 +1484,7 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	dev_set_drvdata(dev, mdata);
 
-	mdata->lsa = vmalloc(LSA_SIZE);
+	mdata->lsa = vzalloc(LSA_SIZE);
 	if (!mdata->lsa)
 		return -ENOMEM;
 	mdata->fw = vmalloc(FW_SIZE);
-- 
2.53.0



