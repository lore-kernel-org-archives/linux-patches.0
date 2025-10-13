Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C10130F923;
	Mon, 13 Oct 2025 15:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367933; cv=none; b=YoH7dOadwaPkbLsMxRmC0pJXyzO7GGQDL3MMqHCJuTGAqf9bwzwG3mE1IRJtnRbc7Fr2JvVd1k6JsdTU1Vf8wnVneH1eBCzjDMcQWVBmNVZD1lpVz7bO5lHnW1LApBiu/KUmbN2UK+z7nh15TQnlcpypkuzxXSfkiBP59iznS+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367933; c=relaxed/simple;
	bh=7MOgHc4vFfhuoRmtguRU+eaYPGaUgnLquWQSIoqXXec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NlRcAcwQwbAIcvMyftNmtlP/G621QUK2zd3hgqtyaCvETZeB5Wk0Xde5X9rlY1VpJCwkkujDTXz0Dp2qifqZVpYMldLV4H192YVameRVpYtB5koRXUscesd4l5Ycy/aIs5X6ZfzUIEutAtyaTX7DZKNO9drCyjvNTz961ceJh8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XF2hhxyU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XF2hhxyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1A5C4CEE7;
	Mon, 13 Oct 2025 15:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367933;
	bh=7MOgHc4vFfhuoRmtguRU+eaYPGaUgnLquWQSIoqXXec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XF2hhxyUEZDSYkIf2y3GR/NUq9nHtBx91Br2F926qFZRmLRJBYBHW3eK8Fvmfuzli
	 ZP3P8zkKL/6pXLkTvsWvc6W70/E7Hh59CJJuaZs3s1MPr6HDYR29V/cjp5VqLqKnuY
	 4v9CSNjsukR9JmZRlo+KUZnIZoPGwKvzue5TGgNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>,
	Ling Xu <quic_lxu5@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.6 184/196] misc: fastrpc: Fix fastrpc_map_lookup operation
Date: Mon, 13 Oct 2025 16:46:15 +0200
Message-ID: <20251013144321.963979855@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Ling Xu <quic_lxu5@quicinc.com>

commit 9031626ade38b092b72638dfe0c6ffce8d8acd43 upstream.

Fastrpc driver creates maps for user allocated fd buffers. Before
creating a new map, the map list is checked for any already existing
maps using map fd. Checking with just map fd is not sufficient as the
user can pass offsetted buffer with less size when the map is created
and then a larger size the next time which could result in memory
issues. Check for dma_buf object also when looking up for the map.

Fixes: c68cfb718c8f ("misc: fastrpc: Add support for context Invoke method")
Cc: stable@kernel.org
Co-developed-by: Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>
Signed-off-by: Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>
Signed-off-by: Ling Xu <quic_lxu5@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://lore.kernel.org/r/20250912131236.303102-3-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -366,11 +366,16 @@ static int fastrpc_map_lookup(struct fas
 {
 	struct fastrpc_session_ctx *sess = fl->sctx;
 	struct fastrpc_map *map = NULL;
+	struct dma_buf *buf;
 	int ret = -ENOENT;
 
+	buf = dma_buf_get(fd);
+	if (IS_ERR(buf))
+		return PTR_ERR(buf);
+
 	spin_lock(&fl->lock);
 	list_for_each_entry(map, &fl->maps, node) {
-		if (map->fd != fd)
+		if (map->fd != fd || map->buf != buf)
 			continue;
 
 		if (take_ref) {


