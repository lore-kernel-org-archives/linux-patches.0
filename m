Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C646F8F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFE9C433EF;
	Mon, 13 Feb 2023 14:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676299968;
	bh=kYCio/92WA6utWVpKVXwYFaL+XIh+5fb9xofR6DAk+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UGTgjfcHaOLvv+s29VhThgDTflFpGGS3svxFgrnDhltsuagpBxonlpvq0lD/YAeq8
	 bvY3j2GyscQAg9bl0PVXfO0kIjtG0wH1M34SkYQbFAnLhxjRL8LSZxfrnM51K1r4Ly
	 Rk3XONRAmAExsnHj5C6Y4e+XF6WLxUfOrIJhl0J4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Luca Di Stefano <luca.distefano@linaro.org>,
	993612@bugs.debian.org,
	stable@kernel.org,
	Rob Herring <robh@kernel.org>
Subject: [PATCH 6.1 013/114] of/address: Return an error when no valid dma-ranges are found
Date: Mon, 13 Feb 2023 15:47:28 +0100
Message-Id: <20230213144742.886237401@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Brown <broonie@kernel.org>

commit f6933c01e42d2fc83b9133ed755609e4aac6eadd upstream.

Commit 7a8b64d17e35 ("of/address: use range parser for of_dma_get_range")
converted the parsing of dma-range properties to use code shared with the
PCI range parser. The intent was to introduce no functional changes however
in the case where we fail to translate the first resource instead of
returning -EINVAL the new code we return 0. Restore the previous behaviour
by returning an error if we find no valid ranges, the original code only
handled the first range but subsequently support for parsing all supplied
ranges was added.

This avoids confusing code using the parsed ranges which doesn't expect to
successfully parse ranges but have only a list terminator returned, this
fixes breakage with so far as I can tell all DMA for on SoC devices on the
Socionext Synquacer platform which has a firmware supplied DT. A bisect
identified the original conversion as triggering the issues there.

Fixes: 7a8b64d17e35 ("of/address: use range parser for of_dma_get_range")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Luca Di Stefano <luca.distefano@linaro.org>
Cc: 993612@bugs.debian.org
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20230126-synquacer-boot-v2-1-cb80fd23c4e2@kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/address.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -965,8 +965,19 @@ int of_dma_get_range(struct device_node
 	}
 
 	of_dma_range_parser_init(&parser, node);
-	for_each_of_range(&parser, &range)
+	for_each_of_range(&parser, &range) {
+		if (range.cpu_addr == OF_BAD_ADDR) {
+			pr_err("translation of DMA address(%llx) to CPU address failed node(%pOF)\n",
+			       range.bus_addr, node);
+			continue;
+		}
 		num_ranges++;
+	}
+
+	if (!num_ranges) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	r = kcalloc(num_ranges + 1, sizeof(*r), GFP_KERNEL);
 	if (!r) {
@@ -975,18 +986,16 @@ int of_dma_get_range(struct device_node
 	}
 
 	/*
-	 * Record all info in the generic DMA ranges array for struct device.
+	 * Record all info in the generic DMA ranges array for struct device,
+	 * returning an error if we don't find any parsable ranges.
 	 */
 	*map = r;
 	of_dma_range_parser_init(&parser, node);
 	for_each_of_range(&parser, &range) {
 		pr_debug("dma_addr(%llx) cpu_addr(%llx) size(%llx)\n",
 			 range.bus_addr, range.cpu_addr, range.size);
-		if (range.cpu_addr == OF_BAD_ADDR) {
-			pr_err("translation of DMA address(%llx) to CPU address failed node(%pOF)\n",
-			       range.bus_addr, node);
+		if (range.cpu_addr == OF_BAD_ADDR)
 			continue;
-		}
 		r->cpu_start = range.cpu_addr;
 		r->dma_start = range.bus_addr;
 		r->size = range.size;


