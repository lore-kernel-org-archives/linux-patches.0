Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382E4FBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:55:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94CDDC4339E;
	Mon, 15 May 2023 16:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169754;
	bh=QmnDGkAw0UDgIUvCaXOQ+xUZF9d48JvpofGptycY9vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WnMlaeks/LPmIwn1zC1Ho2g4zG9ZoJPmZtT/gLjQMBmX8oBFHNPFstxPyQgPf+V0f
	 VXqDWpG4fp6lpS6O+H9Xu8UqJzb2bp0WSD+hFh9QXkNlulD4378gQZnk+Xl/UCZJYW
	 xbqzKYuyFxOzoXJsNJU0iaEVoQDLAnqRn+owPNSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 6.3 160/246] remoteproc: imx_rproc: Call of_node_put() on iteration error
Date: Mon, 15 May 2023 18:26:12 +0200
Message-Id: <20230515161727.355933093@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mathieu Poirier <mathieu.poirier@linaro.org>

commit 5ef074e805ecfd9a16dbb7b6b88bbfa8abad7054 upstream.

Function of_phandle_iterator_next() calls of_node_put() on the last
device_node it iterated over, but when the loop exits prematurely it has
to be called explicitly.

Fixes: b29b4249f8f0 ("remoteproc: imx_rproc: add i.MX specific parse fw hook")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20230320221826.2728078-5-mathieu.poirier@linaro.org
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/imx_rproc.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -541,6 +541,7 @@ static int imx_rproc_prepare(struct rpro
 
 		rmem = of_reserved_mem_lookup(it.node);
 		if (!rmem) {
+			of_node_put(it.node);
 			dev_err(priv->dev, "unable to acquire memory-region\n");
 			return -EINVAL;
 		}
@@ -553,10 +554,12 @@ static int imx_rproc_prepare(struct rpro
 					   imx_rproc_mem_alloc, imx_rproc_mem_release,
 					   it.node->name);
 
-		if (mem)
+		if (mem) {
 			rproc_coredump_add_segment(rproc, da, rmem->size);
-		else
+		} else {
+			of_node_put(it.node);
 			return -ENOMEM;
+		}
 
 		rproc_add_carveout(rproc, mem);
 	}


