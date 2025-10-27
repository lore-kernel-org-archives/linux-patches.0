Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11782D5C95;
	Mon, 27 Oct 2025 19:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593002; cv=none; b=gJQygjVDpzgy+ns/Do590PZT+lTbMkeLIRPiwqtka+eUdJZ2cd/6hGJ7XrDTB/b4PXmAKm6OqGasM9DpGP7uDDiN5HgIFA6+KHpAoZW3WnDunZIXzH6VbyiNAYSTLhf5yedddaqoljttMRZojOnAjpbMQv6mQzWK1JOWybvtPgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593002; c=relaxed/simple;
	bh=t2j33ZKLQnfqdgSAsj2+IRWAXm60GJf94JqR85E8jus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=isSbcoI9xuA0UFF8d8BeWE6WW9PsE3T7dz39iQw6LHQQQnm8cLjwd8fCqHN+rYn7c3vC0Pxfq34dSxhgCsEAvTV9VzPtdKf+H5eaozDklaH1uJUo35zGwB25rZCIDF2/1Vz9JPCePOL1NC6CAyDulAPWfoOCH0HbQ5uQAE4jV/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zUiI27Xn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zUiI27Xn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8014EC4CEF1;
	Mon, 27 Oct 2025 19:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593001;
	bh=t2j33ZKLQnfqdgSAsj2+IRWAXm60GJf94JqR85E8jus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zUiI27XnwvRS9D+HG1PIdc5e4r4gAOc6DKnzvt5aTHftTAZ36q1gFGlIpBnfrC+Nr
	 JbDovU2Fu7dcjk4cayu/kMrdAiHnfDbWKMvDTS2cUwQ5H3Zrcxg+60/tNVT8NWgt0o
	 ERTIuulR+QqiFU2aIFqV74QlR8tA43Pnay63muo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suma Hegde <suma.hegde@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 6.12 093/117] platform/x86/amd/hsmp: Ensure sock->metric_tbl_addr is non-NULL
Date: Mon, 27 Oct 2025 19:36:59 +0100
Message-ID: <20251027183456.535590555@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suma Hegde <suma.hegde@amd.com>

commit 2c78fb287e1f430b929f2e49786518350d15605c upstream.

If metric table address is not allocated, accessing metrics_bin will
result in a NULL pointer dereference, so add a check.

Fixes: 5150542b8ec5 ("platform/x86/amd/hsmp: add support for metrics tbl")
Signed-off-by: Suma Hegde <suma.hegde@amd.com>
Link: https://lore.kernel.org/r/20250807100637.952729-1-suma.hegde@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[ Minor context change fixed. ]
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/hsmp.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/platform/x86/amd/hsmp.c
+++ b/drivers/platform/x86/amd/hsmp.c
@@ -569,6 +569,11 @@ static ssize_t hsmp_metric_tbl_read(stru
 	if (!sock)
 		return -EINVAL;
 
+	if (!sock->metric_tbl_addr) {
+		dev_err(sock->dev, "Metrics table address not available\n");
+		return -ENOMEM;
+	}
+
 	/* Do not support lseek(), reads entire metric table */
 	if (count < bin_attr->size) {
 		dev_err(sock->dev, "Wrong buffer size\n");


