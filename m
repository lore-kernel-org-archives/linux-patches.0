Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7B62F234E;
	Tue, 17 Jun 2025 15:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175999; cv=none; b=leGZeObcqmYBjboMmTlhKFAbMoxOjhwHXZYQs8xeSV7lNTy4goLxsI6kQ0BEk130lzjzO/TedbvqCEHlgBxJ4hQ6bl2aDTSaVtGGBzcgOE09PcXr3fllSAUTP4Tqv2HPrIbgzOhFJDEi0oq5somQ5WLHBcXYU5fKiD67BY7gdbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175999; c=relaxed/simple;
	bh=tbLus1659B5A0r19W5gR6O6cqMTFa+0q+Hr2mCQ6GT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBq3IwcNs67RRQTJuP9CwAB2ygMSpFj9WLhKUaUMcmJDZ9SqZbiCfbrAg/fNCZwLzCMYFqTOImesSKr838hc0LzhIHnFHvgdLgiLQabXseLU5wRiNkUU9pWTHLY3NXdRIErnKlOt3MGgg7Z8pbs1GQiEfjaLoAkaPTPbb0rLZsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v2P13NaQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v2P13NaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89B4C4CEE3;
	Tue, 17 Jun 2025 15:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175999;
	bh=tbLus1659B5A0r19W5gR6O6cqMTFa+0q+Hr2mCQ6GT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v2P13NaQO5hKLW7/Gp1ptwyNr5992UFL6jmil19eY7tYDvhGMILdxnEtSoMT1HmzQ
	 wlaiZ7gafzLDKmukz1YU4cnhjxQTTqQkvdA8cYNZ+mJuUn4thktZdHyIg4y+sPxCiH
	 qiRYMjZlnWWqjY9hFqS1zP1Wvati58x7kX96m4oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 142/780] media: synopsys: hdmirx: Count dropped frames
Date: Tue, 17 Jun 2025 17:17:30 +0200
Message-ID: <20250617152457.284008299@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Nicolas Dufresne <nicolas.dufresne@collabora.com>

[ Upstream commit 57c8d79adf05244b171964d1d6c7e6fabbe5f5fd ]

The sequence number communicate the lost frames to userspace. For this
reason, it must be incremented even when a frame is skipped. This allows
userspace such as GStreamer to report the loss.

Fixes: 7b59b132ad439 ("media: platform: synopsys: Add support for HDMI input driver")
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/synopsys/hdmirx/snps_hdmirx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/synopsys/hdmirx/snps_hdmirx.c b/drivers/media/platform/synopsys/hdmirx/snps_hdmirx.c
index f5b3f5010ede5..7af6765532e33 100644
--- a/drivers/media/platform/synopsys/hdmirx/snps_hdmirx.c
+++ b/drivers/media/platform/synopsys/hdmirx/snps_hdmirx.c
@@ -1956,10 +1956,6 @@ static void dma_idle_int_handler(struct snps_hdmirx_dev *hdmirx_dev,
 					vb_done->field = V4L2_FIELD_NONE;
 
 				hdmirx_vb_done(stream, vb_done);
-				stream->sequence++;
-				if (stream->sequence == 30)
-					v4l2_dbg(1, debug, v4l2_dev,
-						 "rcv frames\n");
 			}
 
 			stream->curr_buf = NULL;
@@ -1971,6 +1967,10 @@ static void dma_idle_int_handler(struct snps_hdmirx_dev *hdmirx_dev,
 			v4l2_dbg(3, debug, v4l2_dev,
 				 "%s: next_buf NULL, skip vb_done\n", __func__);
 		}
+
+		stream->sequence++;
+		if (stream->sequence == 30)
+			v4l2_dbg(1, debug, v4l2_dev, "rcv frames\n");
 	}
 
 DMA_IDLE_OUT:
-- 
2.39.5



