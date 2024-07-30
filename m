Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4027B1A76A0;
	Tue, 30 Jul 2024 17:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359648; cv=none; b=mtxWtfRHGBw2/REupVUr0zWh9/zvzh6mGm8NAukkqZ/QBKxXd/9NkAo1ANq+/Gj2/xMWAzZz7RT4S6wIAPtwp6VjpkW1EmBcoXrv2M1yiRJvsISU4HBXixLoDZyyiUzCna0LKVCC9frD4wHBJRUWbdNj9Vz5V6EkYNuyrKeupV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359648; c=relaxed/simple;
	bh=LCnxEwuqI/Soy44809sz3phrMGdJuM3SLMBgjAAeGhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ApNGSgV1r1vQLDuKb7B5ndwWcai2thXZqeudSWQhJsZWPsYtgq3ZDi6KfttOOEoyd+IRjy5Vyi9PwRUMoDSJmPBQ8B0Ja8jqkyAKaOv59uZIgcXwPvAAXWP6a6O8uG/Aw2NU6dCW5ZcizCP66J4s0VcIw6RKrMjNdhOajN9zQ9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IBMK6Nzm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IBMK6Nzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B8FC32782;
	Tue, 30 Jul 2024 17:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359648;
	bh=LCnxEwuqI/Soy44809sz3phrMGdJuM3SLMBgjAAeGhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBMK6Nzm9bgD95rasBAMZQUy+sEyxl6ClEZbbElmSfNqCzlCVDOoYif405tUMlv4D
	 HTWNpXEDZOGeKi7/QzkR8B6jVD2WGqGc5WdGgPDEQHfksc6FnBCBH6t0R4FcfOvGLl
	 B8LdloBM/Ftre0daHy075CSutpadokANNRtVkFqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Peng Fan <peng.fan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.6 491/568] remoteproc: imx_rproc: Skip over memory region when node value is NULL
Date: Tue, 30 Jul 2024 17:49:58 +0200
Message-ID: <20240730151659.221145974@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -729,6 +729,8 @@ static int imx_rproc_addr_init(struct im
 		struct resource res;
 
 		node = of_parse_phandle(np, "memory-region", a);
+		if (!node)
+			continue;
 		/* Not map vdevbuffer, vdevring region */
 		if (!strncmp(node->name, "vdev", strlen("vdev"))) {
 			of_node_put(node);


