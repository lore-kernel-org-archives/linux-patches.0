Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208132;
	b=rjClsG91vn6QxVZZZ4TxB7JFFyGTgYx8G6ZzcMl1H2cl/WHn7B8vbBRO1q1O/4mCHLLu
	 BmF5huCFnPiE1OhwNaNIZHKNJzmKwt+Qc5cAli9RRI5MG2v5+dC4Uqf5nHuH1x/2ZKUcA
	 U1lEzSogGcZ+EPGDK/ZWbIvZhT0DH31CrRYwsnqwEhoWYsqOYFAmD9WwrmFuC1AOkv9bB
	 nx8dOtZTR1X+4mZnz/J3TKa8xOQYaPxZFdi6WV8MDQdtlZcclAfRhHm+C5/DG9eV7Vzvq
	 A2PAu3n8qZOtk2CJAqWdDKawRUKBQlrOp3uDri+3llEd8W2v+Yr6YXfoaiCSoRuzbyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0FS9YFJcDE+2iMTJCaraT9/qGyCVwyso3OXgga55mg0=;
	b=0d2gps7zckc0W8olsphzWlQNo6PFPATAlMUVe8GJHbpAWmdbIlci28ee8azSVV/avm/J
	 odfzyTSIi2tvTscRKGEEPzmZfXCgfXRGzZ7EMbUvSsAyAftw8kG/l0LsjSHxT0i19CIrM
	 UWYv38Bwc7RJgF16ZcyX2GVqjBbmdiJO1WmxnxZe6bWic/tE7AkuqM8pPXDW8pjNjB/ey
	 9MjmmhebCRIAmvNrzY2cBKs58ByYqLT50lV2/eXJDIWxoPnmuVkSnXxTsXWZGv7ZpNj9b
	 /AYSC4IEzKJP0JhQRH9FbdaNDi7yN0g3PcrQW6fjeHu4hBXUGGAeBJcBaG7WEVcDq9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=02dyD3BB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A429606A324;
	Wed, 28 Oct 2026 17:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=02dyD3BB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA7E1F01825;
	Wed, 28 Oct 2026 17:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208132;
	bh=0FS9YFJcDE+2iMTJCaraT9/qGyCVwyso3OXgga55mg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=02dyD3BBnjW8f5lkXB8IotIAUOTzdTUIIE/haaXLR0Nhlpmv0+yzbpF+BY+xtLZn1
	 cATLiTMnDZiMc4cnfnsNwKIgmmP/XADlYfkQe9pmhz+9eBu9urvH7q93c1a7uiG4A0
	 tBA5eGw6zIJfwZPYCnbAJKASvDRI59j58Po+K4f4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/516] nvme-tcp: fix host memory disclosure on R2T for a read command
Date: Wed, 28 Oct 2026 17:52:45 +0100
Message-ID: <20261028170003.840936623@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

[ Upstream commit 6efbc52237facda35d2d874fe1765bb4839275d8 ]

nvme_tcp_handle_r2t() does not check the direction of the request the
R2T refers to. A malicious controller can send an R2T for a READ and
the host will answer it: nvme_tcp_setup_h2c_data_pdu() builds the
H2CData header and nvme_tcp_try_send_data() sends the request's data
buffer. That buffer is the READ destination, so its contents go to the
controller.

The command then completes normally and nothing is logged.

Against a test controller that answers every READ with an R2T, a 4096
byte buffered read returned all 4096 bytes, split over two R2Ts. The
pages contained stale kernel data, including an array of struct page
pointers.

Reject an R2T for a request that is not a write.

Fixes: 3f2304f8c6d6 ("nvme-tcp: add NVMe over TCP host driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index e47c73a74177c..9e1c45d7cc999 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -654,6 +654,13 @@ static int nvme_tcp_handle_r2t(struct nvme_tcp_queue *queue,
 	}
 	req = blk_mq_rq_to_pdu(rq);
 
+	if (unlikely(rq_data_dir(rq) != WRITE)) {
+		dev_err(queue->ctrl->ctrl.device,
+			"req %d unexpected r2t for a non-write command\n",
+			rq->tag);
+		return -EPROTO;
+	}
+
 	if (unlikely(!r2t_length)) {
 		dev_err(queue->ctrl->ctrl.device,
 			"req %d r2t len is %u, probably a bug...\n",
-- 
2.53.0



