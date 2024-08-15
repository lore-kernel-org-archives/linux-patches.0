Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3953F1494C5;
	Thu, 15 Aug 2024 13:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729907; cv=none; b=Y5Gl8Ejd14/SAIw513sPBSBAlhkZbf7kjC/tidcghzuW5GAyQZq30qQZR9yiWzB+pgkoe1J31VBtf5CuHKNrZVhekv+5WfSt3Dylp11hH9yPLYiZ1WRcQrvYlB2P8O67tTfNONPL0K65pG409z7dt+JD+tYAC9X8aynufVsM3ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729907; c=relaxed/simple;
	bh=ivHJyalYEghpkP39gHqTf2QLFF1PsRl9SZFlSH9JNyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gz66VQhowSGqVTdx2NCpb02u87OdEY5UlcEYKQ3GzaLkBNmb02Me+Cj1MloJ3+hsiR6nWwEgYAP4mDwVaFCCvg2mJZnw5zW51eYWEYrCAYdRpoVDD1QQQ4FAXRS1IyKOaRLaQ/HV0yVtoKqDjr5M5KJkPP3WrjkdQl8PhUmrlDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NnasSQOD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NnasSQOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B385CC32786;
	Thu, 15 Aug 2024 13:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729907;
	bh=ivHJyalYEghpkP39gHqTf2QLFF1PsRl9SZFlSH9JNyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NnasSQODH5CUIrQ63e80iDy7AFFiCMRDjIPgcPn16+30GD0wmCEoOab0K7iIne0d1
	 08XCgIw5UZE1ZH6xn+m4chWvpnabmIRmLnf2occJeobqeN8dmr9uDyzPMNYzaassUe
	 zCPquyjLxNAVPNXH3BUMR2HxFdMvEPz8eDwekeio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Peng Fan <peng.fan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.15 245/484] remoteproc: imx_rproc: Skip over memory region when node value is NULL
Date: Thu, 15 Aug 2024 15:21:43 +0200
Message-ID: <20240815131950.865283846@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

commit 2fa26ca8b786888673689ccc9da6094150939982 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/imx_rproc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -588,6 +588,8 @@ static int imx_rproc_addr_init(struct im
 		struct resource res;
 
 		node = of_parse_phandle(np, "memory-region", a);
+		if (!node)
+			continue;
 		/* Not map vdevbuffer, vdevring region */
 		if (!strncmp(node->name, "vdev", strlen("vdev"))) {
 			of_node_put(node);


