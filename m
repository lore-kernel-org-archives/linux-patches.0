Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036286;
	b=WmIyuqMb9otyM8h7xuV5C8IhKZs18MvjrGhatXUR3er+QYb1j1SfTVu3bbhY2AaMQbtE
	 QnpRbrku/zFlKG94RONTLE3+F0ZaZ8D0hNLmMyPEKrgGY4zs0MYWwo9ZPcOWY3ew6HOGu
	 VjTkbat8StJtkmNkVIm1RtFrKs4qbkigzitEaCEzpQiHSblVS4JtByGaM5HD4+UPpot3Z
	 zQKBAvcaEnIPkbuVCzlR1rg9ieVLyABWIAX27jUwWuPiw8tSXBPfBra4UsycDEeD740Fl
	 +lrDNxbnxXfUsDlWC/C5fRVuvxmi6msZ3x4un0tQiXeK8EzWPBei63TeXgwsheSza5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CmXrbXVmxFmZkLQZMG1vUDq8oCcHURY7p6wgOCHZULA=;
	b=unWQOBP8LlJYLeLeFnVoBb16ZerQzaUUkCryV7/1xZNYDJbCsv8gyaCKXQR3WBXjdsHG
	 OSzbMqoxJrsthKOlkEbd34Aj3ERoNNDRppD9bwx4XgMLUeLcz7QPEvu9tOuAcL6WLERB0
	 6rCGddKT8IGrCkZd/nd3RqotK34VJJhr9cuyJLGp5PpGsPrzT3OUWG8OJ5XNBm6OW1Dpe
	 Mv3nNvfWdMuCpVuYiju9eDD9GRCrwGZVI9TQyOrzvfQsfgKvu4nK6wHuAPKWxKIQ/b4Vt
	 mic5obINwnRJ2wuFYsZnf/CRwXNsQOmFrVNVbrRLTAAgatO+p/pUwJEkpJ7FdaRt40Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iPlqkGqc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D838B606A332;
	Wed, 18 Nov 2026 21:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iPlqkGqc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76931F000C5;
	Wed, 18 Nov 2026 21:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036286;
	bh=CmXrbXVmxFmZkLQZMG1vUDq8oCcHURY7p6wgOCHZULA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iPlqkGqcVg/e8FmuJJzSWwpJi1tFAR3yahwyilmpQSOyPOzu3Mhu1uMmi40CRWujS
	 UypNCQLNWcZ36tC0EdC74zSMUeEb4lmEhqJu1orqeP9lTVWeT1+ac1eVaGoxvTn3ar
	 JTQ8rsOMxBx/vtbU9ZonZcNC3jdoeGAXSXs5JI9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1004/3318] media: mediatek: jpeg: retry HW selection after successful wait
Date: Wed, 18 Nov 2026 15:27:06 +0100
Message-ID: <20261118150349.999565311@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit eb0bbd0ad679bf363387e3b8be8892cfbedabb72 ]

wait_event_interruptible_timeout() returns a positive value when its
condition becomes true before the timeout. mtk_jpegdec_worker() treats
every nonzero result as a failure, so a normal decoder wakeup finishes
the mem2mem job as though no hardware became available.

Handle interrupted waits and exhausted timeout retries separately, and
retry hardware selection after a successful wakeup. Increment the retry
count only for actual timeouts. The encoder uses
wait_event_interruptible(), whose successful return is zero, so its
existing check is correct; leave that separate no-timeout policy
unchanged.

Fixes: dedc21500334 ("media: mtk-jpegdec: add jpeg decode worker interface")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
index 5a1ae5cd44b95..48ed4e3ae633c 100644
--- a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
@@ -1709,9 +1709,15 @@ static void mtk_jpegdec_worker(struct work_struct *work)
 		ret = wait_event_interruptible_timeout(jpeg->hw_wq,
 						       atomic_read(&jpeg->hw_rdy) > 0,
 						       MTK_JPEG_HW_TIMEOUT_MSEC);
-		if (ret != 0 || (i++ > MTK_JPEG_MAX_RETRY_TIME)) {
-			dev_err(jpeg->dev, "%s : %d, all HW are busy\n",
-				__func__, __LINE__);
+		if (ret < 0) {
+			dev_err(jpeg->dev, "decoder HW wait interrupted: %d\n",
+				ret);
+			v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
+			return;
+		}
+
+		if (!ret && i++ > MTK_JPEG_MAX_RETRY_TIME) {
+			dev_err(jpeg->dev, "all decoder HW are busy\n");
 			v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
 			return;
 		}
-- 
2.53.0



