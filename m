Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F482F234A;
	Tue, 17 Jun 2025 15:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175678; cv=none; b=qrpmEREdfNT7OPiBsomDF9GgfW5iAVgdWB931qdVDxDUuhrZAp8+tomkPjv4OA9JWYpjWPvOQ4T2zfE7xB/GyBBgoNvzWged5MWrDv0UvjDumbXR6p+/P42qqzagjCps0TLXXkzqswcjNkSPuUFWG+pPQep/r5IdRuK9S1XNkLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175678; c=relaxed/simple;
	bh=8qzNkv8LDmVmCeExsbJiHYToZnDpZd6BfxvaDSX7734=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBrpmSSNxXrpIwxYj5vLEu2SxswE6tV7KGEviirKYWvWUYuBYzjLCKimwYUXhnnVGvXmPeW2ZjO3RZ+/eNP3WF7OAnobTQKhju8A1zV14M5uJg4h+PTjIRhh84jv5LgJ8o8gMRmeVI6oRt7lgCtnb77FdybOUBn3saL8CuNm4NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MnR6TqXe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MnR6TqXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FAB3C4CEE3;
	Tue, 17 Jun 2025 15:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175678;
	bh=8qzNkv8LDmVmCeExsbJiHYToZnDpZd6BfxvaDSX7734=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MnR6TqXeGSrjg/z8PyE5XzX2n07dEJjQk9Ug1xgfPLXJUR6ysSSLGdZrHXyA4+vZK
	 y+se9xk14fNqp4K3r6TmhecdUDGgKa94ElLEwtJvpRcCTLZRL/iW8isuzLk4gvoYRe
	 aHKc/AeClsQkaflgHYG0R0p67FdTiLeYX9KleGgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongbo Yao <andy.xu@hj-micro.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 112/780] perf: arm-ni: Fix missing platform_set_drvdata()
Date: Tue, 17 Jun 2025 17:17:00 +0200
Message-ID: <20250617152456.067214383@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongbo Yao <andy.xu@hj-micro.com>

[ Upstream commit fc5106088d6db75df61308ef6de314d1f7959646 ]

Add missing platform_set_drvdata in arm_ni_probe(), otherwise
calling platform_get_drvdata() in remove returns NULL.

Fixes: 4d5a7680f2b4 ("perf: Add driver for Arm NI-700 interconnect PMU")
Signed-off-by: Hongbo Yao <andy.xu@hj-micro.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20250401054248.3985814-1-andy.xu@hj-micro.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm-ni.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/perf/arm-ni.c b/drivers/perf/arm-ni.c
index 0c418a7ee10f3..de7b6cce4d68a 100644
--- a/drivers/perf/arm-ni.c
+++ b/drivers/perf/arm-ni.c
@@ -660,6 +660,7 @@ static int arm_ni_probe(struct platform_device *pdev)
 	ni->num_cds = num_cds;
 	ni->part = part;
 	ni->id = atomic_fetch_inc(&id);
+	platform_set_drvdata(pdev, ni);
 
 	for (int v = 0; v < cfg.num_components; v++) {
 		reg = readl_relaxed(cfg.base + NI_CHILD_PTR(v));
-- 
2.39.5



