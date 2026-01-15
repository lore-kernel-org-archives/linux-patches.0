Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1353F396B7D;
	Thu, 15 Jan 2026 16:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496268; cv=none; b=XiTcWCqzKi5HXG9CSQfJPfp+RNto9K77HHLAFjAeC/XqzmhVYQp76QEBdWSldsdrS1P5Hw+a3vUNyGymViaZP5rxDpVRRFHwFf5e4UgM+Bp79LoXBQT6nNGIWfnS1y3Nk8y6+feGbUSI6WxFL9vSUks/4bURwOGSXGgoJ9ESwZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496268; c=relaxed/simple;
	bh=ki+MCNqEe/k7Bikj/puT/LOCqstK5nyQcceH9VSg/x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2EzSwmtiOemAgk9oFUKFbwjnags736W485RbeV/pwDtEwxZbMaqoIxTko04RSfX3ckYRI8BZmQuZfyijxE3KPhvoF12qfuoX7iZXjh/1oG3zpKITy1EMo7N1o5dKg4s2j1Jdu++V0MVsEvP1tvZ0djTx1QqDgZMjNrYJJutBRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uGOsnhed; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uGOsnhed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983BCC19421;
	Thu, 15 Jan 2026 16:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496268;
	bh=ki+MCNqEe/k7Bikj/puT/LOCqstK5nyQcceH9VSg/x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uGOsnhedsCOqr7vEw5v8xdexqfpc8vWEEgUk9qgPCRn0V4R5Hj+HxoTouEeeDcu/A
	 pPZ7BoCHcOcJ/4i4+u9ztBWmadMqx11tfUUaXr98fWoEqKzSeqOcIfQBmvGwga8m8p
	 6+tH98drnqSlOEMy61ofxKd1cqSCBCSGEvJifrwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Hay <joshua.a.hay@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Madhu Chittim <madhu.chittim@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	David Decotigny <ddecotig@google.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 135/181] idpf: cap maximum Rx buffer size
Date: Thu, 15 Jan 2026 17:47:52 +0100
Message-ID: <20260115164207.194627110@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Hay <joshua.a.hay@intel.com>

[ Upstream commit 086efe0a1ecc36cffe46640ce12649a4cd3ff171 ]

The HW only supports a maximum Rx buffer size of 16K-128. On systems
using large pages, the libeth logic can configure the buffer size to be
larger than this. The upper bound is PAGE_SIZE while the lower bound is
MTU rounded up to the nearest power of 2. For example, ARM systems with
a 64K page size and an mtu of 9000 will set the Rx buffer size to 16K,
which will cause the config Rx queues message to fail.

Initialize the bufq/fill queue buf_len field to the maximum supported
size. This will trigger the libeth logic to cap the maximum Rx buffer
size by reducing the upper bound.

Fixes: 74d1412ac8f37 ("idpf: use libeth Rx buffer management for payload buffer")
Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Acked-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Reviewed-by: Madhu Chittim <madhu.chittim@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: David Decotigny <ddecotig@google.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_txrx.c | 8 +++++---
 drivers/net/ethernet/intel/idpf/idpf_txrx.h | 1 +
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index 3698979b4c9ee..f66948f5de78b 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -695,9 +695,10 @@ static int idpf_rx_buf_alloc_singleq(struct idpf_rx_queue *rxq)
 static int idpf_rx_bufs_init_singleq(struct idpf_rx_queue *rxq)
 {
 	struct libeth_fq fq = {
-		.count	= rxq->desc_count,
-		.type	= LIBETH_FQE_MTU,
-		.nid	= idpf_q_vector_to_mem(rxq->q_vector),
+		.count		= rxq->desc_count,
+		.type		= LIBETH_FQE_MTU,
+		.buf_len	= IDPF_RX_MAX_BUF_SZ,
+		.nid		= idpf_q_vector_to_mem(rxq->q_vector),
 	};
 	int ret;
 
@@ -754,6 +755,7 @@ static int idpf_rx_bufs_init(struct idpf_buf_queue *bufq,
 		.truesize	= bufq->truesize,
 		.count		= bufq->desc_count,
 		.type		= type,
+		.buf_len	= IDPF_RX_MAX_BUF_SZ,
 		.hsplit		= idpf_queue_has(HSPLIT_EN, bufq),
 		.xdp		= idpf_xdp_enabled(bufq->q_vector->vport),
 		.nid		= idpf_q_vector_to_mem(bufq->q_vector),
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.h b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
index 0472698ca1927..423cc9486dce7 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.h
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
@@ -101,6 +101,7 @@ do {								\
 		idx = 0;					\
 } while (0)
 
+#define IDPF_RX_MAX_BUF_SZ			(16384 - 128)
 #define IDPF_RX_BUF_STRIDE			32
 #define IDPF_RX_BUF_POST_STRIDE			16
 #define IDPF_LOW_WATERMARK			64
-- 
2.51.0



