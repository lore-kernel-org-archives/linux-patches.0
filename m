Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062022;
	b=Dh5MtmBuINCCzv2FaVF2p0FPbhkqwWPbOZBQJckeA2whUoqXif41DR48p9FgJVSblfq1
	 WioHuCnHeKxLJWC+d9Irfqv8rEDHKnfNqhLpF0Pvo1D7RUQuGYcUYUvl4QQM168je2lRL
	 Loc9h8AXlA/RpEbz1ZxJu/nzhgDhRsB9Ea6GUGn69aa1DkddoUtuQfG7RW0BDOaPWICLz
	 JmoWbOiEjMH6c9nQPcbqELygn9OSiY8NLO76RSeCuWZQuO1UVAexqJmOI8k8WFxmGgOhQ
	 GstshJ8cZFgMlz373VSVjSn7GgTG3/QtpbWZuPw30JNDML0xI8dtaFl+r5o5Fuf0czw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fTCAZDZEy5qSzQOs7UfM9v9tPGLysIiqbW1+baAy6rM=;
	b=i60uhcbnolFYVTmAMTKDsybgAS9ngvVH5n6slxNcDnNCBI64Bb4g+IFJ3rNa0djeWDqQ
	 lirebvPQo3+ZxVs2H+E73nuQt9HMN1ZLGEHBPSx06yDZdmA2Uj40A1rsvFoa8SiZq7F0a
	 FkaTlvZfBqskOsn95mn8BVGRDZ+4OPFbgVsOlyi4LQvnrpwoa3VvNUcuJ3E0IbEK/gvcC
	 XfeNcqgMhAqLObFmDbH6MNXaBX5GmP2OiqJcwbpeSFeN4cnZsE2ioSa3B0b4FL5d17N3v
	 kcFPWMiVy70BawMSI6vCEobUxdXx8Emdp1jUnia9fg876KGVpV3Mrmh/lCqVDT19CkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K7Q1RRcU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89186606A320;
	Thu, 19 Nov 2026 04:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K7Q1RRcU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE41B1F000C4;
	Thu, 19 Nov 2026 04:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062022;
	bh=fTCAZDZEy5qSzQOs7UfM9v9tPGLysIiqbW1+baAy6rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K7Q1RRcUiPzb3svgwUaR1mTs6klr3RdN8ngxvi1/NpKjZLhDXcrYL6dau4btRT+hv
	 VmGKfIdHiAjYj/MfsuIyP4uzFDJdKxKdcB2mp2fvPTM9WDln0AB2z05kDU4gvw0OWX
	 /VhdSsHRBB4qBa3HurfFTjCTkYmQTz1wEgRgooEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-reviews <sashiko-bot@kernel.org>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1761/1848] ASoC: amd: raven: Fix memory leak in acp3x_dma_close()
Date: Wed, 18 Nov 2026 16:03:19 +0100
Message-ID: <20261118150033.164120919@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
index 52944b59613d3..5c29e57ffb704 100644
--- a/sound/soc/amd/raven/acp3x-pcm-dma.c
+++ b/sound/soc/amd/raven/acp3x-pcm-dma.c
@@ -363,6 +363,8 @@ static int acp3x_dma_close(struct snd_soc_component *component,
 		}
 	}
 
+	kfree(ins);
+
 	return 0;
 }
 
-- 
2.53.0



