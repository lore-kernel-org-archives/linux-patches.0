Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227A61DFFB;
	Thu, 15 Aug 2024 14:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732608; cv=none; b=XrTy2QQGAIswANW5bPPGwHAz8TG4bNTa3hZPpR3t0uLbZxHNfRQcFd+nh4AfsHbQCxucLl1LjIk3Uc3wRWvrycySifbw1u7aRPlYn/DZMD1J2m74CsnEE6LPUD3xlnk1nEsgr9fgaiHjdVQAdjD4ZdoH2fN784jxNA0gKiSVuDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732608; c=relaxed/simple;
	bh=gHBP0GeM8exA/144smdcc4fMcagyrbcpEyIVs0nT6yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNMXke4yObQJ6KNbtaVPBUzmha9Nzx7PlbwmigA7ZKNtNPGa/8AjAtsdPWyWf2NExZjYgwS+5lbNp12m+iM4ZkCGNKl8Uq2uVgtbuLzO+dOWI7PaPnAKdo/Q7A9pTaccNNfT+Q1PxBKLsKLUqn/XoXl8CSNt7vHlj60GTZfGYO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKtMScl7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKtMScl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F5A3C32786;
	Thu, 15 Aug 2024 14:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732608;
	bh=gHBP0GeM8exA/144smdcc4fMcagyrbcpEyIVs0nT6yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKtMScl7Re08g7zUI/ySAa2uIgyIG5nwp48ZEdjzjVOKI8lOeYavB4d3tH7p5wReG
	 omV9AXZrXpwtcRR+G7OxD8psxQvLxS3PxPU8W627gohx+5HQh2i/s3yr4qemyMxhIq
	 02Uo2lUUKh0AmoJZ24m+01BpWCDddhnBLpRgwkZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Peng Fan <peng.fan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 232/352] remoteproc: imx_rproc: Skip over memory region when node value is NULL
Date: Thu, 15 Aug 2024 15:24:58 +0200
Message-ID: <20240815131928.400409394@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 517d1b5733288..373fce8b91064 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -287,6 +287,8 @@ static int imx_rproc_addr_init(struct imx_rproc *priv,
 		struct resource res;
 
 		node = of_parse_phandle(np, "memory-region", a);
+		if (!node)
+			continue;
 		/* Not map vdevbuffer, vdevring region */
 		if (!strncmp(node->name, "vdev", strlen("vdev")))
 			continue;
-- 
2.43.0



