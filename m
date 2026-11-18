Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032758;
	b=Ns+BNstthHngzi4iMi6/ozKdbKf6QN9yA5MsjufS/X0wfFQoqInxdCGo+3rJUqO+o8CW
	 JJnD7IyqagmA5bqC3G731f45ZNFXP5b7tjHCnC376AJN87Oett1KWo0QFyVguNysog6T4
	 CHJAsycW4CB0/+hXLvSXC58JOBmAi5iwsxOgHFr09rDPCwn2SIJyLelydFCNnrsVL8hVU
	 ZexTv3bQbupX2T5hPoVj9K1E3GMDBLpO1C9VETpudsXL6ukLvUl65Nlf6QN+JlHyaLjfK
	 oU1tOB44g9RzOavh+XoZE09mj8hl30AjkQH3pahbin0AFt6QDVaTQqQEza1orfc0OBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VSYRkND1eF1Y7LZP3GDe58G/XG2LL48A735yTDaga9I=;
	b=kiOkoiLAk4oMWiohHvScrz5w7IcRCMlwnpW9ayNTwtyefJfAhijdIX4kH6RQflP91FAn
	 KzQpPVTefczCiejTo+i7LVtzbHPRqI0gblzOs0NecwvMyJ2CqYQLUV+6wba8Vr6j7K3X8
	 Sxm631qc784YMPRZyPH4GW4BwGJoGM0VJeFMXIakKDM4CPtTm8/pKXOlANeR36ee0ouBT
	 jFTZAkCwu91xD9VAWN1+rZy0IP/hyMzU0wYTrOeTuRFXi4/1BbBlQS/xp86moyZag4SVh
	 cW8ixYfF7YQKLRAGvn+L/SXQniFSAMk8oo6LMBdGtlBi2L3VYMEhXcXdNypQdIKwMTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OvmgWSSs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7D1606A31C;
	Wed, 18 Nov 2026 20:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OvmgWSSs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561791F000C4;
	Wed, 18 Nov 2026 20:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032758;
	bh=VSYRkND1eF1Y7LZP3GDe58G/XG2LL48A735yTDaga9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OvmgWSSs9BBUlcbK837HnCBi8+CfS8ODGMExiwM7LcjMxMrG0D8fR6X2/ExxFGCu9
	 7TmpPtNxbNXR6Y4ioHROLeycnRdBN1jfbYDOwJyeICg0gqiVclRoZ+jkBVXZ7RdqjA
	 kuw2JEo8wruZgp26b+3pUQ+4eUJgMSGPDiS0SAO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-reviews <sashiko-bot@kernel.org>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1526/1756] ASoC: amd: raven: Fix memory leak in acp3x_dma_close()
Date: Wed, 18 Nov 2026 16:00:53 +0100
Message-ID: <20261118150109.642808952@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit e0b17f84f6e3fa1201b8e2857094023c42ce5636 ]

acp3x_dma_open() allocates a struct i2s_stream_instance for
each substream, but acp3x_dma_close() never frees it, leaking
it on every open/close cycle.

Free it in acp3x_dma_close().

Fixes: 9f7041b71a2f ("ASoC: amd: closing specific instance.")
Reported-by: sashiko-reviews <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-173760@kernel.org/
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261016085047.535265-1-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/raven/acp3x-pcm-dma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/amd/raven/acp3x-pcm-dma.c b/sound/soc/amd/raven/acp3x-pcm-dma.c
index 3ba58a7795973..61b07195f3a8e 100644
--- a/sound/soc/amd/raven/acp3x-pcm-dma.c
+++ b/sound/soc/amd/raven/acp3x-pcm-dma.c
@@ -354,6 +354,8 @@ static int acp3x_dma_close(struct snd_soc_component *component,
 		}
 	}
 
+	kfree(ins);
+
 	return 0;
 }
 
-- 
2.53.0



