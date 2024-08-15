Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C50817CA1D;
	Thu, 15 Aug 2024 13:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728824; cv=none; b=pVcfF5FXTyI3lobg0tqMvJ4HhFP86yDjOXSH56UBZtcPhzESCqeqCBMuOGuEnEhCP1gnFflTc+aSMsmeo23JRzO7HZxt+LWK9pZ4bwuQa6nrAlMl1pygzduJj1MRZKu0NY4LzD8W3+tpdABnWgM/3uvfpQw7rhN4k2w23sXhFEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728824; c=relaxed/simple;
	bh=/8qwGDU+DEDCDVByKn5bX7moSuPU/vmZUVTpnipYgHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOl9iMo0P9FXc+/9tzGN37pcauYy6GCcmLK8LgRd3892WCCJHF3hc3rmoql15Yk+jEzvEZWjj7O6TlsoHfp3oLJReKCRMnYo5Cieyk/+god5BFZEpFL5HkvKjfChC6rAO6i22Jp6uz35qATA3lRWrizzJ07nGgpBTjQxgearv3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fjZIogAz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fjZIogAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918F2C4AF0F;
	Thu, 15 Aug 2024 13:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728824;
	bh=/8qwGDU+DEDCDVByKn5bX7moSuPU/vmZUVTpnipYgHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjZIogAzR7jQngTqzXHBj/eaE2UxkYPAqT4kC9LPDUqaZzhe9mnyrDXzpSs0gp8wP
	 cElCf+sXYmqcSA9oOeOZOSDsrvwRFCy5nvJ68A6qGTriyZ4RB3SA11Gs8QVWo2FM7d
	 BsKer4OvWO84CgvapmlQyygq0eN5E3oCDlO9SX2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Peng Fan <peng.fan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 122/196] remoteproc: imx_rproc: Skip over memory region when node value is NULL
Date: Thu, 15 Aug 2024 15:23:59 +0200
Message-ID: <20240815131856.744143024@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 4eec6b380f11c..7597f09a3455b 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -289,6 +289,8 @@ static int imx_rproc_addr_init(struct imx_rproc *priv,
 		struct resource res;
 
 		node = of_parse_phandle(np, "memory-region", a);
+		if (!node)
+			continue;
 		/* Not map vdevbuffer, vdevring region */
 		if (!strncmp(node->name, "vdev", strlen("vdev")))
 			continue;
-- 
2.43.0



