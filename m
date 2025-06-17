Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B459C2ECD0B;
	Tue, 17 Jun 2025 15:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175019; cv=none; b=IGXXXPEr/Ip6o+dF+t0R61emCLUCZDu/NAnXTI3ByG1zx3QgeUm7ETqMR9DhWgGsC/2K74NVKxV6hOQhjKdEBASMnTR5SXasmfsQOs+liaPP3dUPFAjmG/vJ9GM8QWzAKlrq1QYy7ozey9uTxlccyKCjglIJ8utMUVGBfQwiDMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175019; c=relaxed/simple;
	bh=JfJuR8ICMTUKinerAoZClXC34u1PY08xDQE3vTvUMQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bN96ZzzeiAkZabHVWlpYPrH9Sqkzh1qxNZNlSJI+KY7PQGy1+jsij4r0vqJjSITDFjUk8snppTjwNkEu3aLKgmXqB1uy4GDJiqml0tHzxxbQP7U24gDNj42FzrZyi52KClylFDwsFHwFJs8t+6llIq/OU5fbO6vadh8HZp+bBWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mCpxdhy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mCpxdhy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24230C4CEE3;
	Tue, 17 Jun 2025 15:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175019;
	bh=JfJuR8ICMTUKinerAoZClXC34u1PY08xDQE3vTvUMQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mCpxdhy81INADDs6pvKpsBsQQON716dFFp2MOLzEgb/QqFLBDhg5Q6fz/kZ3vg54Q
	 GZUj13+PnPNx0toJYiKLJL6GTQMwA/F2OWhe3e4N3wI/lyII8gGhhHx7FTwKt/srrB
	 Y2Qf+ey0soPvXxkcI/9aN0kH9uaifewYeYERolfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongbo Yao <andy.xu@hj-micro.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/512] perf: arm-ni: Fix missing platform_set_drvdata()
Date: Tue, 17 Jun 2025 17:20:41 +0200
Message-ID: <20250617152422.616474682@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3f3d2e0f91fa7..b87d3a9ba7d54 100644
--- a/drivers/perf/arm-ni.c
+++ b/drivers/perf/arm-ni.c
@@ -661,6 +661,7 @@ static int arm_ni_probe(struct platform_device *pdev)
 	ni->num_cds = num_cds;
 	ni->part = part;
 	ni->id = atomic_fetch_inc(&id);
+	platform_set_drvdata(pdev, ni);
 
 	for (int v = 0; v < cfg.num_components; v++) {
 		reg = readl_relaxed(cfg.base + NI_CHILD_PTR(v));
-- 
2.39.5



