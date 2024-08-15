Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F901AC896;
	Thu, 15 Aug 2024 14:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731572; cv=none; b=pcUIduSmkrZynFV/RRzhZZVt7JUz5UQw2x07d5HJuI263TWPrpC6HKwNYM/hG+e2s1vCq+3b/P9qw7va9rbVuW7wYuDxzynJp3DEtKmyJ1r7EL8NevGRpG8MoLAh+DwAyTwmdqrzEL/5yL1AWPQB6aFDu2QwaOwqgRsII5uAZhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731572; c=relaxed/simple;
	bh=L8PEQhtErBdbM9sTHmGaD+0/WhjpoVxbtDRBlm/zbys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMZdjKGOtxc3ZB/rupEnsqLY2UvIqh1HenbKI9ibPEX+hR7qPI1jo5pUQI293ud80djo7l5zWbmleEnzS3JotMEUJnIjCQbh919WBh07HL7Tuj4wkq2n3b7shBlPMJ9JRJTBoH9n0r6aj0czJSJu6UbDyrcbXvcidzigkauD8Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSWJ/eSt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSWJ/eSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA5DC32786;
	Thu, 15 Aug 2024 14:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731571;
	bh=L8PEQhtErBdbM9sTHmGaD+0/WhjpoVxbtDRBlm/zbys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YSWJ/eStOL7WCyupIRXQuzSzENkOagwOAvW2u/WFdurdSvgrdFrN9LpLABQntCxYe
	 qlpom5Qep2FQh+vhsWVLwyS4eLcnwZ6GH67Iq3GUTpt66SgDAXccy5sH605j1sii13
	 EhrLZfouZFV8KfoUL3PvcE9u/KJCRJbtXdA9JKaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Peng Fan <peng.fan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 172/259] remoteproc: imx_rproc: Skip over memory region when node value is NULL
Date: Thu, 15 Aug 2024 15:25:05 +0200
Message-ID: <20240815131909.420731402@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit 2fa26ca8b786888673689ccc9da6094150939982 ]

In imx_rproc_addr_init() "nph = of_count_phandle_with_args()" just counts
number of phandles. But phandles may be empty. So of_parse_phandle() in
the parsing loop (0 < a < nph) may return NULL which is later dereferenced.
Adjust this issue by adding NULL-return check.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: a0ff4aa6f010 ("remoteproc: imx_rproc: add a NXP/Freescale imx_rproc driver")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240606075204.12354-1-amishin@t-argos.ru
[Fixed title to fit within the prescribed 70-75 charcters]
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_rproc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/remoteproc/imx_rproc.c b/drivers/remoteproc/imx_rproc.c
index 0e6246678bc2b..3f3d1eb94e6fa 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -286,6 +286,8 @@ static int imx_rproc_addr_init(struct imx_rproc *priv,
 		struct resource res;
 
 		node = of_parse_phandle(np, "memory-region", a);
+		if (!node)
+			continue;
 		/* Not map vdevbuffer, vdevring region */
 		if (!strncmp(node->name, "vdev", strlen("vdev")))
 			continue;
-- 
2.43.0



