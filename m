Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5859D46EF9A;
	Tue, 21 Jul 2026 19:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663521; cv=none; b=imDOaZD+0JCaiMw1b9AAbtPzysRPe09RYbosxLUeWWOuR5oj7d7Yw7AB34KdV/QOMiy3ZEUo9FZuocY9vdvmsM5Rvgsq/JMJWpEoJRzpCPw9uNNVQP6RusAPE/X7aQ6FEP7h2MxfGF0QPM7F5kx4Yv7Lyea+u9prOV0fEVo6uPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663521; c=relaxed/simple;
	bh=MXcg+7ZldL9krkb1e/GTSTTsaXtJsNN4OSgqNw9qiyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YKDkv+r0I/7MDkuFJhA8pCa34GoLpIsUdGMWDc9JQw0mlI9UqgUiYWxRIk97fIWKV0FkQ4RdguVr4LWU4qT1vf+lHlVZ/ULLTBLV9PLOTByH7MZWtrzkCe1aX7gBsFYbfmOpnfmM7M3KajxGmNnZdxjDnqJ1D5mUVhLSOmpAMiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OfHh1XqT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OfHh1XqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87001F00A3F;
	Tue, 21 Jul 2026 19:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663520;
	bh=0qg79EoZ9aeeKe4A6rACgN76A9w9XcQaPWVWvuPh24g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OfHh1XqT3IWbncVB/E8kIwzPBOHVJmbCbLvyiUWZgjVwZif0ezsrFe2XIryIREbTe
	 MNxMDKVD7+wBKyaRL//gogHest++qjL0ysxIe32mXtQNf3gCOvrUqCGL2X2YFreHFk
	 xfs5mWAEjA9ELq2kKoMH0zflm7yqnYR4rtmW2vhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 0854/1276] ASoC: mediatek: mt8192: Release reserved memory on cleanup
Date: Tue, 21 Jul 2026 17:21:37 +0200
Message-ID: <20260721152505.162395171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit 965e17ae6751c5d3302430c8ebd650e72d45a85f upstream.

The MT8192 AFE probe calls of_reserved_mem_device_init() and falls
back to preallocated buffers when no reserved memory region is
available. When the reserved memory assignment succeeds, however, the
driver never releases it.

Register a devm cleanup action after a successful reserved-memory
assignment so the assignment is released on probe failure and driver
unbind.

Fixes: ec4a10ca4a68 ("ASoC: mediatek: use reserved memory or enable buffer pre-allocation")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260527-asoc-mt8192-probe-cleanup-v1-1-1bb834d05b72@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-pcm.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
@@ -2155,6 +2155,11 @@ static const dai_register_cb dai_registe
 	mt8192_dai_memif_register,
 };
 
+static void mt8192_afe_release_reserved_mem(void *data)
+{
+	of_reserved_mem_device_release(data);
+}
+
 static int mt8192_afe_pcm_dev_probe(struct platform_device *pdev)
 {
 	struct mtk_base_afe *afe;
@@ -2185,6 +2190,10 @@ static int mt8192_afe_pcm_dev_probe(stru
 	if (ret) {
 		dev_info(dev, "no reserved memory found, pre-allocating buffers instead\n");
 		afe->preallocate_buffers = true;
+	} else {
+		ret = devm_add_action_or_reset(dev, mt8192_afe_release_reserved_mem, dev);
+		if (ret)
+			return ret;
 	}
 
 	/* init audio related clock */


