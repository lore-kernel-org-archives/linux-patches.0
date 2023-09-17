Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9046FCC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7400EC433C7;
	Sun, 17 Sep 2023 19:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980408;
	bh=DYhFi3ULxSsHIl2GTL38lXPR4iX8Sf7rcrI40x6SljM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJh147OUKhWE7SgFYVg2t+flBnERRxkKvNVYyFMfwaKgPDRS3jHRE730Toj2ijF/D
	 /4GTnour/O8dFnRYRe52/yPJ9sr+yBcD9X6T7/cR6HpcHhhMR6YuGlMsk/v3EVhiYq
	 9Srf3oMnjy9jq3mSP4rKCznOa+qfGgc0w680LHrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ekansh Gupta <quic_ekangupt@quicinc.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.5 183/285] misc: fastrpc: Fix incorrect DMA mapping unmap request
Date: Sun, 17 Sep 2023 21:13:03 +0200
Message-ID: <20230917191057.955381128@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ekansh Gupta <quic_ekangupt@quicinc.com>

commit a2cb9cd6a3949a3804ad9fd7da234892ce6719ec upstream.

Scatterlist table is obtained during map create request and the same
table is used for DMA mapping unmap. In case there is any failure
while getting the sg_table, ERR_PTR is returned instead of sg_table.

When the map is getting freed, there is only a non-NULL check of
sg_table which will also be true in case failure was returned instead
of sg_table. This would result in improper unmap request. Add proper
check before setting map table to avoid bad unmap request.

Fixes: c68cfb718c8f ("misc: fastrpc: Add support for context Invoke method")
Cc: stable <stable@kernel.org>
Signed-off-by: Ekansh Gupta <quic_ekangupt@quicinc.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230811115643.38578-3-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -756,6 +756,7 @@ static int fastrpc_map_create(struct fas
 {
 	struct fastrpc_session_ctx *sess = fl->sctx;
 	struct fastrpc_map *map = NULL;
+	struct sg_table *table;
 	int err = 0;
 
 	if (!fastrpc_map_lookup(fl, fd, ppmap, true))
@@ -783,11 +784,12 @@ static int fastrpc_map_create(struct fas
 		goto attach_err;
 	}
 
-	map->table = dma_buf_map_attachment_unlocked(map->attach, DMA_BIDIRECTIONAL);
-	if (IS_ERR(map->table)) {
-		err = PTR_ERR(map->table);
+	table = dma_buf_map_attachment_unlocked(map->attach, DMA_BIDIRECTIONAL);
+	if (IS_ERR(table)) {
+		err = PTR_ERR(table);
 		goto map_err;
 	}
+	map->table = table;
 
 	if (attr & FASTRPC_ATTR_SECUREMAP) {
 		map->phys = sg_phys(map->table->sgl);


