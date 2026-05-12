Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C873EDE5C;
	Tue, 12 May 2026 18:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609375; cv=none; b=IzqYlrP1NTJnd/RR0x1nKPU7knTlDVP2okgY8NDcbMblf7dv1vFT6o2Ui6aXNCpVCk62u4eeXB0R+7N8F1Xmb6DAMKpWp/I/qqLU+ZeGatW+CZCZsqORzXzrWgp6eYpAL9AGEHzDWw/HRDhPgbH9x/2PAiICSnVoh4nd9//QqYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609375; c=relaxed/simple;
	bh=6zFRkque6RyBokJGXyNF9wgBs0+ozlnSUPzKKfbr9YU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=asbfZaTTZTrOGgOVOQWMrjVNQENx7tjktm5vZVj0HGX9I2DlqHvijLYaAJbNtr8jFuHNmK6e6QVy0XD7xUVMHfmYn4G0FuASvu8ZhS+yJcQUR9ezj+xjZ4n4NGIkgnja9946tpB+In9lD6+0azYdW4EH6oRtt48rebEzCG/k0K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e5DHN6Ak; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5DHN6Ak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72FC8C2BCB0;
	Tue, 12 May 2026 18:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609375;
	bh=6zFRkque6RyBokJGXyNF9wgBs0+ozlnSUPzKKfbr9YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e5DHN6AkCcFjO3Wq5kK8AwvSDhmWWZzyvIkBa3T+QLx369pIGEskOlnPV7/2phTo8
	 hxK2dseGo8l1e+Uv8Yp/RHE5+teJxVBz9QaBhQFs+9aPYhxLqruo/OiOchwGpm673P
	 LTTRZWUqEgX2rB/7mnlCZmH8+OLjkomMk2BzzIuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 172/307] ASoC: qcom: q6apm-dai: reset queue ptr on trigger stop
Date: Tue, 12 May 2026 19:39:27 +0200
Message-ID: <20260512173943.748963167@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

commit cab45ab95ce7600fc0ff84585c77fd45b7b0d67c upstream.

Reset queue pointer on SNDRV_PCM_TRIGGER_STOP event to be inline
with resetting appl_ptr. Without this we will end up with a queue_ptr
out of sync and driver could try to send data that is not ready yet.

Fix this by resetting the queue_ptr.

Fixes: 3d4a4411aa8bb ("ASoC: q6apm-dai: schedule all available frames to avoid dsp under-runs")
Cc: Stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260402081118.348071-6-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6apm-dai.c |    1 +
 sound/soc/qcom/qdsp6/q6apm.c     |    2 ++
 2 files changed, 3 insertions(+)

--- a/sound/soc/qcom/qdsp6/q6apm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6apm-dai.c
@@ -317,6 +317,7 @@ static int q6apm_dai_trigger(struct snd_
 	case SNDRV_PCM_TRIGGER_STOP:
 		/* TODO support be handled via SoftPause Module */
 		prtd->state = Q6APM_STREAM_STOPPED;
+		prtd->queue_ptr = 0;
 		break;
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -215,6 +215,8 @@ int q6apm_map_memory_regions(struct q6ap
 
 	mutex_lock(&graph->lock);
 
+	data->dsp_buf = 0;
+
 	if (data->buf) {
 		mutex_unlock(&graph->lock);
 		return 0;


