Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062860;
	b=wO0Tew/JYTeHnd4DEiAh9W30xVSnHG85c15iZhjJXkNBoXsz95Sies+9le00veF9beeV
	 G23jwh1yjdkTPsl9r53/5LfgLQWB6jPbIsEvlhpbkb30J6O0UYa5O3FqhHwudUNeP1f3B
	 IcqStiU5eLXE3YfVeQVjDHh4kCpg0BZLSBaG/Vj8kWSHcqEF1TWwnfTEay82JMPrpZdSJ
	 nPPDOTayQGSrx9Hc8OGYqzqawA+wS1Hr9vcL1aUZRJ924bdRu8hEBOybxbJ4N4nQJPxRB
	 ombO5H7lMO4lBcZXu6JZ6EXEqXRub+wVaXDT29bj6d7ZCRlHyQ0qfpFnC9upC1MN8vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ptXqVwRqtfxVAclmj8HHa11+5ROndYTFqKyuQjRA5XI=;
	b=R1CPXCNCQy7u5FNtpguQmyWdwdihFHSu8VUfegnnX5V198phZeIuNKbKIT/gNRW+JLzN
	 oKAEyyDgmmhU7e38sK417iPm1apnGEGcu6pM+RXIFvLGjrZ1F4k+vkVgVSppeAxsL/zKV
	 50RRSm78z6ucUS8RQQUSO1YCAhTS5CDOsK3JCHP7Mo7o7L3iXZfk0fnlt4pZjK2lcHApy
	 IKHHWIwB1j/yzE97790yMwenTDcESnLF5/zYrgQuSgVqVF7jjZSTJ0Ds66aMAiCfkfLaz
	 9NnYFqU69xABiS7zkV0K8PPsQt6x/ClOi40/8hl+wL8MAL9MvbdhSLq1JeR91DPn9gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=To+wOp51;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FF9606A32F;
	Sat,  7 Nov 2026 14:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=To+wOp51
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1421F0089F;
	Sat,  7 Nov 2026 14:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062859;
	bh=ptXqVwRqtfxVAclmj8HHa11+5ROndYTFqKyuQjRA5XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=To+wOp51+k1XllXBKo2UXeuOdj2xGRrsnqDC8FferW5umKbZ1RmPKMtyrmbO22ptA
	 1un0jBS/yp8bgwlLZ8FtrXgLEEDiZTdJVyx3UYdp4Di7YDSBCuZd9QCB4Le3Blvvn4
	 yRxqbhXxhnS3BxY7fQOL6mdNVEupwMl6MdsWH50c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 148/869] ASoC: arizona-jack: Fix runtime PM imbalance in arizona_start_hpdet_acc_id()
Date: Sat,  7 Nov 2026 08:47:10 -0500
Message-ID: <20261107134857.372289891@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit e04dcb895b4622d67164e218a1179785e2c75999 ]

In arizona_start_hpdet_acc_id(), pm_runtime_get_sync() is called to keep
the device powered during headphone detection. If setting the HPDET mode
or starting the measurement fails and the function jumps to err,
pm_runtime_put_autosuspend() was not called while info->hpdet_active was
set to false, resulting in a runtime PM usage count leak.

Add pm_runtime_put_autosuspend() in the err error path to keep runtime PM
balanced.

Fixes: 9dd5e53d9d2f ("extcon: arizona: Retry HPDET identification for high impedance")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260916072900.1971595-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/arizona-jack.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/arizona-jack.c b/sound/soc/codecs/arizona-jack.c
index 6b55610ad535d..b17c4539f4e49 100644
--- a/sound/soc/codecs/arizona-jack.c
+++ b/sound/soc/codecs/arizona-jack.c
@@ -713,6 +713,7 @@ static void arizona_start_hpdet_acc_id(struct arizona_priv *info)
 	snd_soc_jack_report(info->jack, SND_JACK_HEADPHONE,
 			    SND_JACK_LINEOUT | SND_JACK_HEADPHONE);
 
+	pm_runtime_put_autosuspend(arizona->dev);
 	info->hpdet_active = false;
 }
 
-- 
2.53.0



