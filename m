Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073E651C5D;
	Mon, 11 Dec 2023 18:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpsFs8fG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE13C433C8;
	Mon, 11 Dec 2023 18:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319809;
	bh=dW2svO/4LmZwEz+DVL0NcVKKmwLK7lesM8cSVRqbAmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mpsFs8fGQv77UWKaBvgye+IkomKAG8WHxe/uXRiiP7J7T8fyvnmTY2yez3YdfsX+I
	 VltN7VK31HqiLgEXjf8jaAYaXYmGBnYnNJhjiZt41b/6viH0wldg7AGqKDmYKLYHAF
	 md+RfjyKc0cxo0Vf2yAe6QhLv+i0FVULOLDuNIvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 6.6 211/244] nvmem: Do not expect fixed layouts to grab a layout driver
Date: Mon, 11 Dec 2023 19:21:44 +0100
Message-ID: <20231211182055.422333372@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit b7c1e53751cb3990153084f31c41f25fde3b629c upstream.

Two series lived in parallel for some time, which led to this situation:
- The nvmem-layout container is used for dynamic layouts
- We now expect fixed layouts to also use the nvmem-layout container but
this does not require any additional driver, the support is built-in the
nvmem core.

Ensure we don't refuse to probe for wrong reasons.

Fixes: 27f699e578b1 ("nvmem: core: add support for fixed cells *layout*")
Cc: stable@vger.kernel.org
Reported-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Tested-by: Rafał Miłecki <rafal@milecki.pl>
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://lore.kernel.org/r/20231124193814.360552-1-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index bf42b7e826db..608b352a7d91 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -796,6 +796,12 @@ static struct nvmem_layout *nvmem_layout_get(struct nvmem_device *nvmem)
 	if (!layout_np)
 		return NULL;
 
+	/* Fixed layouts don't have a matching driver */
+	if (of_device_is_compatible(layout_np, "fixed-layout")) {
+		of_node_put(layout_np);
+		return NULL;
+	}
+
 	/*
 	 * In case the nvmem device was built-in while the layout was built as a
 	 * module, we shall manually request the layout driver loading otherwise
-- 
2.43.0



