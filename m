Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442A5315D33;
	Tue, 17 Mar 2026 16:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765429; cv=none; b=M+ZaEyeBl6tV4imf3fC9rv7VjKdhSRTYcU4RNGobYNV/cq8nSas6RCkhXzSQy9BxgUUKjGBhsYY2gdn3M4FJ1hVgaaaMkFB+eMLnrb1RxPHyzBTs+ptE230a63Te78AwUkRCdVovQqGbJw0nEipBDgJmWZ47TDCP3SmdnH87/4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765429; c=relaxed/simple;
	bh=jD/OVGPwmMS1+ZHAEwAi2sarTbDqSSRNzdJjLBpdfEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iAd9I6rTVr6an9FhDQ1OMI1RR0mm/o2Oy7v6fc+rnFWOd9G2WW50t1DxwVTD0wjFqs/l8d2EDHQnRD3eONMBByS0RfSbzgdEWWDASwd458cFbj+RDd0XV13N3PIp+6PjkfPu1i5shIMiryeUAFMWq/LhZRdedTNXGMeopsqwr+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBLialKj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBLialKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA6EC4CEF7;
	Tue, 17 Mar 2026 16:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765428;
	bh=jD/OVGPwmMS1+ZHAEwAi2sarTbDqSSRNzdJjLBpdfEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBLialKjy6kPSJ975QggTCPAMaMSvvqlXp3plYtGoVqIB00p0ok1Ub3F862zU9hFM
	 odhRyaV1oABC/DXhV/FwNIZUXNk2cPYd4uIS1VhMAQTwvqMeyCY5bHpNRt5eo4TavU
	 XABWJwhcVfmSgYpdDAl+nK2W1JtutUjyXU+JXi7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?Andr=C3=A9=20Apitzsch?= <git@apitzsch.eu>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 001/378] remoteproc: qcom_wcnss: Fix reserved region mapping failure
Date: Tue, 17 Mar 2026 17:29:18 +0100
Message-ID: <20260317163007.019320553@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring (Arm) <robh@kernel.org>

[ Upstream commit f9b888599418951b8229bbb28851ed4da50c58e9 ]

Commit c70b9d5fdcd7 ("remoteproc: qcom: Use of_reserved_mem_region_*
functions for "memory-region"") switched from devm_ioremap_wc() to
devm_ioremap_resource_wc(). The difference is devm_ioremap_resource_wc()
also requests the resource which fails. Testing of both fixed and
dynamic reserved regions indicates that requesting the resource should
work, so I'm not sure why it doesn't work in this case. Fix the issue by
reverting back to devm_ioremap_wc().

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reported-by: André Apitzsch <git@apitzsch.eu>
Fixes: c70b9d5fdcd7 ("remoteproc: qcom: Use of_reserved_mem_region_* functions for "memory-region"")
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: André Apitzsch <git@apitzsch.eu> # on BQ Aquaris M5
Link: https://lore.kernel.org/r/20260128220243.3018526-1-robh@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_wcnss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_wcnss.c b/drivers/remoteproc/qcom_wcnss.c
index ee18bf2e80549..4add9037dbd5a 100644
--- a/drivers/remoteproc/qcom_wcnss.c
+++ b/drivers/remoteproc/qcom_wcnss.c
@@ -537,7 +537,7 @@ static int wcnss_alloc_memory_region(struct qcom_wcnss *wcnss)
 
 	wcnss->mem_phys = wcnss->mem_reloc = res.start;
 	wcnss->mem_size = resource_size(&res);
-	wcnss->mem_region = devm_ioremap_resource_wc(wcnss->dev, &res);
+	wcnss->mem_region = devm_ioremap_wc(wcnss->dev, wcnss->mem_phys, wcnss->mem_size);
 	if (IS_ERR(wcnss->mem_region)) {
 		dev_err(wcnss->dev, "unable to map memory region: %pR\n", &res);
 		return PTR_ERR(wcnss->mem_region);
-- 
2.51.0



