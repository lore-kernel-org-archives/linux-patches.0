Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6024D2C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4551C433D2;
	Tue,  7 Feb 2023 13:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775252;
	bh=y2lR5wTufN+3XO4Pksl4GAytSosY7tsE5z1ebI2IkSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I51KJWMVQ7YrvhJOmv3F23nZe2e1vvwtff2bDF3gxQJQMwpLN5UeRSzfGetDIWgtI
	 8eqMLYRsUgk0iBNiSPd7IV3ax0xRDCwHsr0ygoZDZxx9lmOPqJ/8yGYSt5yUZWUkhq
	 H9c60Xjf+CIQXcKsOR50DOmHx9jkspvLDlYlX5k0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <michael@walle.cc>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.1 188/208] nvmem: core: fix device node refcounting
Date: Tue,  7 Feb 2023 13:57:22 +0100
Message-Id: <20230207125642.992438342@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Walle <michael@walle.cc>

commit edcf2fb660526b5ed29f93bd17328a2b4835c8b2 upstream.

In of_nvmem_cell_get(), of_get_next_parent() is used on cell_np. This
will decrement the refcount on cell_np, but cell_np is still used later
in the code. Use of_get_parent() instead and of_node_put() in the
appropriate places.

Fixes: 69aba7948cbe ("nvmem: Add a simple NVMEM framework for consumers")
Fixes: 7ae6478b304b ("nvmem: core: rework nvmem cell instance creation")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230127104015.23839-8-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -1237,16 +1237,21 @@ struct nvmem_cell *of_nvmem_cell_get(str
 	if (!cell_np)
 		return ERR_PTR(-ENOENT);
 
-	nvmem_np = of_get_next_parent(cell_np);
-	if (!nvmem_np)
+	nvmem_np = of_get_parent(cell_np);
+	if (!nvmem_np) {
+		of_node_put(cell_np);
 		return ERR_PTR(-EINVAL);
+	}
 
 	nvmem = __nvmem_device_get(nvmem_np, device_match_of_node);
 	of_node_put(nvmem_np);
-	if (IS_ERR(nvmem))
+	if (IS_ERR(nvmem)) {
+		of_node_put(cell_np);
 		return ERR_CAST(nvmem);
+	}
 
 	cell_entry = nvmem_find_cell_entry_by_node(nvmem, cell_np);
+	of_node_put(cell_np);
 	if (!cell_entry) {
 		__nvmem_device_put(nvmem);
 		return ERR_PTR(-ENOENT);


