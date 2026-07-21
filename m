Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A9A3B1034;
	Tue, 21 Jul 2026 20:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666080; cv=none; b=OsreKvHmcXFXolttw8KECbYwg5yKrxCBYzGOkyM0UXOF4qFonOI9s497OiMuK5ab+IHPSij4ey3So0PTAiVHceDSjL+vt2ocNWDHmYc1NJIeKzZhoW1wTdjWPqyS+IhVcFeNKZv+auVPoZc1hjTrOz1AKTQLaUHuGVO0D2rMO4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666080; c=relaxed/simple;
	bh=L1uOlmjHLP/nh+54Rftp29xXKmHPCs1lklxc35mX/4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hbkw0T+zdLQcELJrmZa693Lvw+/crGJK2ReNR2W0Fp7vGXmZqCT3Vj5ys7FRLLiEfezE1AS7HzHMsovS+ExlpkK6UzM3a2XlOwrnQATGNyERjrS9SwG2i2wgpWQnYFG6h3d7yHB2fAv0qhY03nDuYjQLJRWaBMcbhYIpr1TTl7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HpXTAIRl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HpXTAIRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427211F000E9;
	Tue, 21 Jul 2026 20:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666079;
	bh=5a1Uno7eBu59z6Sd/8Z63y22IKYiwCKZNHeaEmRAi4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HpXTAIRlPPFWT09v6iVvhQJhg584c/U/Cg34p5mam9BaavVHFrW6d3Z1tEkTenqiB
	 GYEDQWH82gteHFzQA5kNoeZkKHmbnPtngsTACCEqFKMRIJRwa2yv9gPxChBMlbNPow
	 K8/4sEFM5HY9jmozHqyzPgtRJBhYN7ELWZ8qY1lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0545/1266] cxl/test: Zero out LSA backing memory to avoid leaking to user
Date: Tue, 21 Jul 2026 17:16:22 +0200
Message-ID: <20260721152454.061577087@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index 6d4ffcce326dff..718f943ab3570f 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -1396,7 +1396,7 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	dev_set_drvdata(dev, mdata);
 
-	mdata->lsa = vmalloc(LSA_SIZE);
+	mdata->lsa = vzalloc(LSA_SIZE);
 	if (!mdata->lsa)
 		return -ENOMEM;
 	mdata->fw = vmalloc(FW_SIZE);
-- 
2.53.0



