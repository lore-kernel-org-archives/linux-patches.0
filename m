Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A82930BBA6;
	Mon, 13 Oct 2025 15:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368729; cv=none; b=oej4UAEABwIzHcDON3CznHgltTBel/KWYv4U2UWQ4lJ5IdO5tJGjbMrq+pynHIA2TZfapOL9AS8i8BuStQ7XG/+EJY/dFvMe5uuxdUPv4gDv3pw2TAd276fZWGqAZ0e6VFr0TMRODXiuwVHmo5h3TEGO2rnviMChZlwdwSO5lsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368729; c=relaxed/simple;
	bh=hYSpS6HD/YbHmiGzshUpepi9P0PQIfUPpUWariizyhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDxMUnVLUgA/VedR0QA1plp54uhzunMi6asP1A3+UPjGfDi0vqGIPLpfvDjwOmQrb/CLJp7hEBaQ2pCqsUatsGxVifEsKAhtWABWNScG3LoSlK7ypDKKjeARM04OWSeDfqKF28wl7HKRlw44I8jnryl7k6RR53xr+Fzk7+q/oTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HT9R53mo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HT9R53mo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5876C4CEE7;
	Mon, 13 Oct 2025 15:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368729;
	bh=hYSpS6HD/YbHmiGzshUpepi9P0PQIfUPpUWariizyhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HT9R53moLfmD4Olpo5iQhOWzXpKLAo5PDuvl7ujVYweYqZq6uEv+JxMzdBebLyj+1
	 7I2q0dOQXusJF4XBsLSQxF0fTdfxDlTFkyROgf+toC7IUxYGjXUrQ32xP8d38wsheg
	 X1LGH2TPTSASwteYsVUG/ewyjuqKB6oxJx9yTgdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>,
	Ling Xu <quic_lxu5@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.12 248/262] misc: fastrpc: Fix fastrpc_map_lookup operation
Date: Mon, 13 Oct 2025 16:46:30 +0200
Message-ID: <20251013144335.169008481@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


