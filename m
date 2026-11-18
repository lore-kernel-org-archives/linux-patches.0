Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041599;
	b=qD8u5Mj2bjAHDtcHLSLG4Wdl6Sm+cDunvDjOApuUhKwKQwEINskT3UMi6zvNqGjyNgOt
	 u8xLr2+a64GmF99vRVqCzS/B435iosgsSXcYFNd9z5LXHUcsJ4yglUNMdIb65jwQOsI56
	 nSPl1if0SHyAiSdRzb3vVNBNn/mgaYI2kBlv+UukSwk5doJ/cEgOtswzsZcNu+dsq9MG/
	 xmnp6num/pRT6WQZpPL9cGzrZDNtZLlr7FrE5vqb/jyVHDgn5vn3blejczQVVokok/tBa
	 0z26ADgIpfDokKtxtxJuZm3tIfrwlRZHRImT+D9ie9VJ+bw7Cu9INLU1dmvV8EMaXmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=993LKLC9lbsv6nRS0dXSx8+yaQUOOdWUzQP5yrvRiPc=;
	b=xVEeFI38/mxBi0MJ18GmsGBRlYWDiiPUVUMypE3ZXRdIpd4jS5/1UVOCHJb+ibr0VtnX
	 7FzIjhK2AmoFcO87OJAyqmI7tzCOmqHsQ8ibG7YpBg2IC/e/sUxX4ZaqaYXsWHGkg1Bod
	 OxkKe08lmaopalV2a8jlEa2W9zrhp2eIgzia1G1x76u53wdVKKzQGwNhlnGpBjnyirzAY
	 GAKN7QiF+ycMSEIa0rw1ZiyFiZklMWFJJENaTYM9MBKXaQQVbZuRHS83exnEuLwkAxY59
	 cF9qeXvHq1ppj7bs0ze9NqhtpYju3h1G6BfdrRIVc1Z0sTaoqL49gu6Gh1ZPQXyysLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dt4yzL8F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82880606A334;
	Wed, 18 Nov 2026 22:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dt4yzL8F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E861F000C4;
	Wed, 18 Nov 2026 22:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041599;
	bh=993LKLC9lbsv6nRS0dXSx8+yaQUOOdWUzQP5yrvRiPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dt4yzL8FMwz4Jdkd8Wtnz71tvn+KRw5SfDtPk2O5z9ziD39v1/oQQm8ZGXCBHvtEF
	 WObVo41WTgdkU26qbBXGpoEsmwB/npDYa6rITMZhiQIgXZCB8KSN88CNt4RUmVoEUb
	 R2xlpH8B/ix8glvRlLoIgFT69AvtI2E6V9Rm3ges=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atul Akella <atul.akella@gmail.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2871/3318] rpmsg: virtio: fix error handling in TX buffer wait
Date: Wed, 18 Nov 2026 15:58:13 +0100
Message-ID: <20261118150446.689214195@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Atul Akella <atul.akella@gmail.com>

[ Upstream commit 7dd4cffdf4c2a496ccf783303a03d687a2127baf ]

The TX buffer wait loop in rpmsg_send_offchannel_raw() ignores the
possibility of wait_event_interruptible_timeout() returning a
negative value, which happens when the wait is interrupted by a
signal. In that case the loop spins back around and re-arms the
wait instead of propagating the signal, which can stall a task
that is trying to be killed.

Separately, on a genuine timeout (return value 0) the function
returns -ERESTARTSYS, which is reserved for signal-interrupted
syscalls that the kernel may restart. A timeout is not a signal
and should not be treated as restartable; return -ETIMEDOUT
instead.

Handle both cases explicitly: return err directly when negative,
and return -ETIMEDOUT on timeout.

Fixes: bcabbccabffe ("rpmsg: add virtio-based remote processor messaging bus")
Signed-off-by: Atul Akella <atul.akella@gmail.com>
Link: https://lore.kernel.org/r/20261013160055.1362-1-atul.akella@gmail.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/virtio_rpmsg_bus.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index b1ea444d197c8..e4ab689d7a9ad 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -535,10 +535,13 @@ static int rpmsg_send_offchannel_raw(struct rpmsg_device *rpdev,
 					(msg = get_a_tx_buf(vrp)),
 					msecs_to_jiffies(15000));
 
+		if (err < 0)
+			return err;
+
 		/* timeout ? */
 		if (!err) {
 			dev_err(dev, "timeout waiting for a tx buffer\n");
-			return -ERESTARTSYS;
+			return -ETIMEDOUT;
 		}
 	}
 
-- 
2.53.0



