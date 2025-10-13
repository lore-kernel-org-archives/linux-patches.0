Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4313F2EB5D2;
	Mon, 13 Oct 2025 15:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370289; cv=none; b=dH2mKLUTPTfVi2gLzVBA8lfeo1bFeMyjsxPSRNEI8bQXikb9RzGbSH63mRa1S7M3yovkMwurA0hfk/qoGIMd+A3cfkflsJ75rO+0YWhRV34B6+SX3InrVL3ioqqvwjIIbAFMVjoSkeY3XOnpjaXn5eC8GJ/7UwLYsgkk7YBaiE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370289; c=relaxed/simple;
	bh=QoBWIqo+ddnGGLge3M8t/JiZ+oTb870Wb2w7fxycdCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fg3zc+OtahYU3XHZjkTeB5I9bi2hHJ/6XHaRGDfnhMG7gkAFtVfbeAeXL3FQJ/h+gNX+17WezDkifysDcNa/Ek8xfdb0ZpjhcNMFGoj3TJg2WguetUWo2JZjayiHmrOJhw+fBXgMSEDVrAB+ykz5HXxrhklacjYZ1DF8cjKgvhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dnh1Ofoy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dnh1Ofoy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC3EC2BCB5;
	Mon, 13 Oct 2025 15:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370288;
	bh=QoBWIqo+ddnGGLge3M8t/JiZ+oTb870Wb2w7fxycdCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dnh1OfoyY2Y6oKVjyLSdpSrM4byOR2SfvyF5PRgJsnF4Vc7sCX73zkaLTXzRY5vKP
	 J989aF3cL5HHDvDLpwAVuqg9bu5DFIM40vRChuJkeU7LUIVmieHMu0nYAD/3WRu7Di
	 1aYMNlsunFBvCM4JcXoG7jb19mQNuFYemtohe4Jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>,
	Ling Xu <quic_lxu5@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.17 544/563] misc: fastrpc: Fix fastrpc_map_lookup operation
Date: Mon, 13 Oct 2025 16:46:45 +0200
Message-ID: <20251013144431.015409406@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -367,11 +367,16 @@ static int fastrpc_map_lookup(struct fas
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


