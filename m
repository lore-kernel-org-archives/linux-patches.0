Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063111;
	b=TgLENyjSG27fIg4BEsGAr7k/O/bpHfiW+nUqWm1D2/i4x8OQfY2W2nJ6xFVqDzCRT3bc
	 QdvaBQ4CGSTfIgdX3jVhte4AYFLCbIM4lisEobPIk+xNwQ6+f/vg3nUHbwaDnFJhgePR+
	 NwJayYoQFg6M+SQC2tvHNg5qkg8ruZW0Ba2/7lsxaI6iLCzsuInt+9gq9bTDI48MQjwVB
	 Q5b7K9H8VEAoLZxsojH/cXvZhyPkD1N67u4drZIkKEWXwcJjSKxDSeYP15yphrEOYQjll
	 1dJqhGlNaD0unNRZFczg6W789EV5/GPh94SZQ/Fr8hp3sT5iMbWw+5PXugdZfOqf8tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063111;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6HHS5T5gn4SZqUFRd/k7eCXvjFcdsZ24PkFHarZAvUg=;
	b=4NHNgpi4dpSFcscNOeUmOU9xcIf1kE29eMWgA4ahKCdwH/8U+qaLkfa0n1Nfn60hKkER
	 /k+1ep0VpOsbSJ4e42iYukp7b1WsWa7DJgUYH0u8tdONSIaexEZIPIIF0MoBAfFRnzYri
	 kiqVBqOmLpyr7G5J/TT+2jdXDp4aRZ0JrXiaBZw42HwI6+rfZeO+m61yVKadpacR4/x3I
	 wcYFwgj2KurO8qARkNXJlEPxKbqpoPYafCdaEbB53ezfJYl1E/mdqiBUM50/c6TwPYxa6
	 A4JdsThbuxdUIZ8JdQ3U1fEXZStU/YJXGI/dQODW4sguhT6prXij5rGXVvwkO0XuOQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="FewHq/CP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1CD606A33B;
	Sat,  7 Nov 2026 14:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FewHq/CP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397C51F0089F;
	Sat,  7 Nov 2026 14:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063110;
	bh=6HHS5T5gn4SZqUFRd/k7eCXvjFcdsZ24PkFHarZAvUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FewHq/CPcStEz7Kz8DDOnrLPvqKGqNQmmiwXF7yfXKMPPQG8p60JIN72DuduI1R4k
	 oaRQ4raU32C/FqhRF+0CIelycuEvjnjqjevddm81/SD2rl6soRx0YC8xU2TCTMUnIA
	 44vLJ8MulTWteoTnAuisyf10aokRiVUHd0K8sf9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 342/869] media: chips-media: wave5: Balance runtime PM on encoder close errors
Date: Sat,  7 Nov 2026 08:50:24 -0500
Message-ID: <20261107134903.976780950@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 4009daa5d9a72a67dd497bb4546632b2506a3650 ]

wave5_vpu_enc_close() resumes the device before taking the hardware lock.
Its three error paths call pm_runtime_resume_and_get() again instead of
dropping that reference.  Each failure therefore increments the runtime PM
usage count twice and can prevent the device from suspending afterward.

Replace the extra resume calls with pm_runtime_put_sync() to balance the
reference acquired on entry, matching the successful close path.  This
aligns wave5_vpu_enc_close() with wave5_vpu_dec_close(), which already
releases the reference on its error paths.

Fixes: 2092b3833487 ("media: chips-media: wave5: Support runtime suspend/resume")
Cc: stable@vger.kernel.org
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/chips-media/wave5/wave5-vpuapi.c     | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/chips-media/wave5/wave5-vpuapi.c b/drivers/media/platform/chips-media/wave5/wave5-vpuapi.c
index e7ea2f6a99d5b..c76d657cf8631 100644
--- a/drivers/media/platform/chips-media/wave5/wave5-vpuapi.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpuapi.c
@@ -729,7 +729,7 @@ int wave5_vpu_enc_close(struct vpu_instance *inst, u32 *fail_res)
 
 	ret = mutex_lock_interruptible(&vpu_dev->hw_lock);
 	if (ret) {
-		pm_runtime_resume_and_get(inst->dev->dev);
+		pm_runtime_put_sync(inst->dev->dev);
 		return ret;
 	}
 
@@ -737,16 +737,13 @@ int wave5_vpu_enc_close(struct vpu_instance *inst, u32 *fail_res)
 		ret = wave5_vpu_enc_finish_seq(inst, fail_res);
 		if (ret < 0 && *fail_res != WAVE5_SYSERR_VPU_STILL_RUNNING) {
 			dev_warn(inst->dev->dev, "enc_finish_seq timed out\n");
-			pm_runtime_resume_and_get(inst->dev->dev);
-			mutex_unlock(&vpu_dev->hw_lock);
-			return ret;
+			goto unlock_and_return;
 		}
 
 		if (*fail_res == WAVE5_SYSERR_VPU_STILL_RUNNING &&
 		    retry++ >= MAX_FIRMWARE_CALL_RETRY) {
-			pm_runtime_resume_and_get(inst->dev->dev);
-			mutex_unlock(&vpu_dev->hw_lock);
-			return -ETIMEDOUT;
+			ret = -ETIMEDOUT;
+			goto unlock_and_return;
 		}
 	} while (ret != 0);
 
@@ -762,10 +759,12 @@ int wave5_vpu_enc_close(struct vpu_instance *inst, u32 *fail_res)
 	}
 
 	wave5_vdi_free_dma_memory(vpu_dev, &p_enc_info->vb_task);
+
+unlock_and_return:
 	mutex_unlock(&vpu_dev->hw_lock);
 	pm_runtime_put_sync(inst->dev->dev);
 
-	return 0;
+	return ret;
 }
 
 int wave5_vpu_enc_register_frame_buffer(struct vpu_instance *inst, unsigned int num,
-- 
2.53.0



