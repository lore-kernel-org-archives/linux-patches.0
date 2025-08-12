Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10902E7656;
	Tue, 12 Aug 2025 19:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026686; cv=none; b=LsuS4shPegPmUj/WaxA68bdNJ4qtO7jhFN+Pg/ANDtJwjMaAVYfhNZqMVe9hDySwuimY3G0wheBXehY6bwUBtAqApfn3SUOD+SmeGxidozWj2bRcuKVhZXLNQMsA7V/h2GwhrQGoR+sGvqBzn7bCkNweqyVtp2ViA0XWtgfyH/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026686; c=relaxed/simple;
	bh=mw74LkRrqy4l7TEPJC/tZvxZ9/s3nPsNvX40WTvD9b4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kb9BR6FHebbA3Fw0895ILjmZRIL/5HVoFXYNMVqG/F+tQ28+97kLmJxwjpoCKpP01GdALDjQPMzNFSvRaGx8vWKnmTkureN+htsXx58AJMhtn6vwRzBy/02e39ZUF0ZCm0okRCxx+MD6+k6SAHfqVR/M2wnR61Iqgu2vAx/7UDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BGblDORg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BGblDORg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD470C4CEF8;
	Tue, 12 Aug 2025 19:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026686;
	bh=mw74LkRrqy4l7TEPJC/tZvxZ9/s3nPsNvX40WTvD9b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BGblDORg7jd9EbJjv8BqcgETVYOm3FoFJ9X3i4+czSjNJNFw/NPb8iE3SEiP7vAN1
	 gsusWIwmSr5bRfo+UTNvy/SyaHeBaDuZtRFH21I+l6EbXRIMus+W4ZjLXi8pL6b3hQ
	 mdOIn2oidYlhD7ob+phXON9jlW7s6Rw+tH28s2iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 411/480] eth: fbnic: remove the debugging trick of super high page bias
Date: Tue, 12 Aug 2025 19:50:19 +0200
Message-ID: <20250812174414.378146958@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit e407fceeaf1b2959892b4fc9b584843d3f2bfc05 ]

Alex added page bias of LONG_MAX, which is admittedly quite
a clever way of catching overflows of the pp ref count.
The page pool code was "optimized" to leave the ref at 1
for freed pages so it can't catch basic bugs by itself any more.
(Something we should probably address under DEBUG_NET...)

Unfortunately for fbnic since commit f7dc3248dcfb ("skbuff: Optimization
of SKB coalescing for page pool") core _may_ actually take two extra
pp refcounts, if one of them is returned before driver gives up the bias
the ret < 0 check in page_pool_unref_netmem() will trigger.

While at it add a FBNIC_ to the name of the driver constant.

Fixes: 0cb4c0a13723 ("eth: fbnic: Implement Rx queue alloc/start/stop/free")
Link: https://patch.msgid.link/20250801170754.2439577-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c | 4 ++--
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.h | 6 ++----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
index ac11389a764c..f9543d03485f 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
@@ -661,8 +661,8 @@ static void fbnic_page_pool_init(struct fbnic_ring *ring, unsigned int idx,
 {
 	struct fbnic_rx_buf *rx_buf = &ring->rx_buf[idx];
 
-	page_pool_fragment_page(page, PAGECNT_BIAS_MAX);
-	rx_buf->pagecnt_bias = PAGECNT_BIAS_MAX;
+	page_pool_fragment_page(page, FBNIC_PAGECNT_BIAS_MAX);
+	rx_buf->pagecnt_bias = FBNIC_PAGECNT_BIAS_MAX;
 	rx_buf->page = page;
 }
 
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h
index f46616af41ea..37b4dadbfc6c 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h
@@ -91,10 +91,8 @@ struct fbnic_queue_stats {
 	struct u64_stats_sync syncp;
 };
 
-/* Pagecnt bias is long max to reserve the last bit to catch overflow
- * cases where if we overcharge the bias it will flip over to be negative.
- */
-#define PAGECNT_BIAS_MAX	LONG_MAX
+#define FBNIC_PAGECNT_BIAS_MAX	PAGE_SIZE
+
 struct fbnic_rx_buf {
 	struct page *page;
 	long pagecnt_bias;
-- 
2.39.5



