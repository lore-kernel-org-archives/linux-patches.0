Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1F1FBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8934C433EF;
	Mon, 15 May 2023 16:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169757;
	bh=1KPsK5CooWq2LIUUkVehmIvDtU8paAYcvb+8wlSp0d0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zwb0Px5oEdmD/jC/6T8bdoO+BjG41ofUhiRaCINFHOVXx5xJe7kWFzfgG39KYVNGR
	 OvJ1M6fBsbCPdde3ZJInMPSviSZ+GfteXNw5secp0CXQ4lj0TjZu6xf3k4p0C2QdZ1
	 K5foV9SJmcpqjEQx4cKV0/qTBdEqdLSwyrKALL54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.3 161/246] remoteproc: rcar_rproc: Call of_node_put() on iteration error
Date: Mon, 15 May 2023 18:26:13 +0200
Message-Id: <20230515161727.466467941@linuxfoundation.org>
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

commit f8bae637d3d5e082b4ced71e28b16eb3ee0683c1 upstream.

Function of_phandle_iterator_next() calls of_node_put() on the last
device_node it iterated over, but when the loop exits prematurely it has
to be called explicitly.

Fixes: 285892a74f13 ("remoteproc: Add Renesas rcar driver")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20230320221826.2728078-4-mathieu.poirier@linaro.org
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/rcar_rproc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/remoteproc/rcar_rproc.c
+++ b/drivers/remoteproc/rcar_rproc.c
@@ -62,13 +62,16 @@ static int rcar_rproc_prepare(struct rpr
 
 		rmem = of_reserved_mem_lookup(it.node);
 		if (!rmem) {
+			of_node_put(it.node);
 			dev_err(&rproc->dev,
 				"unable to acquire memory-region\n");
 			return -EINVAL;
 		}
 
-		if (rmem->base > U32_MAX)
+		if (rmem->base > U32_MAX) {
+			of_node_put(it.node);
 			return -EINVAL;
+		}
 
 		/* No need to translate pa to da, R-Car use same map */
 		da = rmem->base;
@@ -79,8 +82,10 @@ static int rcar_rproc_prepare(struct rpr
 					   rcar_rproc_mem_release,
 					   it.node->name);
 
-		if (!mem)
+		if (!mem) {
+			of_node_put(it.node);
 			return -ENOMEM;
+		}
 
 		rproc_add_carveout(rproc, mem);
 	}


