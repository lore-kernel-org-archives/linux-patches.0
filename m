Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52651D6A7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548A5C433C8;
	Wed, 20 Sep 2023 11:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211049;
	bh=BvLEHjiKCJjgILmXdFdrGGWgR/wtB6GM5BXqMOOoZmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LVQ6Qet/21xEUkxeLMpkgy6QQeorzYQye49vGE9stoQRlfJRVIDrNdABiEHTj5bSG
	 40UqNfj/vuMZg9++/lUM02c7BKhrDkVrfmYBDePhAxP6rwp3fBXvrgLI7A0J0GH96o
	 DQIRMra4IKG0n3EsTtexPsSAM8+VBnwJnFl3M4z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ekansh Gupta <quic_ekangupt@quicinc.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/139] misc: fastrpc: Fix incorrect DMA mapping unmap request
Date: Wed, 20 Sep 2023 13:30:24 +0200
Message-ID: <20230920112838.970698785@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ekansh Gupta <quic_ekangupt@quicinc.com>

[ Upstream commit a2cb9cd6a3949a3804ad9fd7da234892ce6719ec ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/fastrpc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index e9291694922bc..4c51d216f3d43 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -711,6 +711,7 @@ static int fastrpc_map_create(struct fastrpc_user *fl, int fd,
 {
 	struct fastrpc_session_ctx *sess = fl->sctx;
 	struct fastrpc_map *map = NULL;
+	struct sg_table *table;
 	int err = 0;
 
 	if (!fastrpc_map_lookup(fl, fd, ppmap, true))
@@ -736,11 +737,12 @@ static int fastrpc_map_create(struct fastrpc_user *fl, int fd,
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
 
 	map->phys = sg_dma_address(map->table->sgl);
 	map->phys += ((u64)fl->sctx->sid << 32);
-- 
2.40.1



