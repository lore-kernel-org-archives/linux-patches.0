Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0A62FD1DC;
	Tue, 12 Aug 2025 18:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021973; cv=none; b=Hna4zdEACdzW7QYdr8OI7KvwFmVNZVDsD7FdL+miptjKG161P1Vb130m8urNb3PklEck0EIsSi4gDbCnFj49bFKEokiQ+ia6p498Anstof2n4hxK1GngiuUiPWcVQhrBaAzBX89KoQUtdfMOw6tTMb9HiAdpBsAMRgyLFBnH5Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021973; c=relaxed/simple;
	bh=6rBSJ5WIoHeanF8rYktXPYtY9MbwCHSdk7T2iG914Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JK+sM8fgHmFSXjuUIhAs6NI9CW+YFW2cXbt/+0DmhdOwmU+oYla4eMlrCs+nvJvsIJomI7zoKpONZyEh5MnpDKSpgLLKaFGgS5/UZpgxz+6GkasPxj+r3CUS8zFmz5gmtfquH5oK0j/V06Lh3CTSgAZ4hmYKqsVtGT9hUIKL+q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ji578aj5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ji578aj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C15C4CEF0;
	Tue, 12 Aug 2025 18:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021972;
	bh=6rBSJ5WIoHeanF8rYktXPYtY9MbwCHSdk7T2iG914Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ji578aj5LXYSc6XeBXNNE9mqvCIHiaazvqVKBM4oE0k+WP0SsQGUwIxCkJHsyKObr
	 n8zbMsCmZA5osPD/v7l5NlKxWcbmr4IwzGyorkj4ftjxaMUkrEAv6QSsc5L7BAWKvl
	 HBhk0pFbyDzZASRM1y0TJFqFQfzFiG1h3KxqM4yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Giedrius=20Trainavi=C4=8Dius?= <giedrius@blokas.io>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/369] ASoC: soc-dai: tidyup return value of snd_soc_xlate_tdm_slot_mask()
Date: Tue, 12 Aug 2025 19:25:15 +0200
Message-ID: <20250812173015.426132142@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit f4c77d5af0a9cd0ee22617baa8b49d0e151fbda7 ]

commit 7f1186a8d738661 ("ASoC: soc-dai: check return value at
snd_soc_dai_set_tdm_slot()") checks return value of
xlate_tdm_slot_mask() (A1)(A2).

	/*
	 * ...
(Y)	 * TDM mode can be disabled by passing 0 for @slots. In this case @tx_mask,
	 * @rx_mask and @slot_width will be ignored.
	 * ...
	 */
	int snd_soc_dai_set_tdm_slot(...)
	{
		...
		if (...)
(A1)			ret = dai->driver->ops->xlate_tdm_slot_mask(...);
		else
(A2)			ret = snd_soc_xlate_tdm_slot_mask(...);
		if (ret)
			goto err;
		...
	}

snd_soc_xlate_tdm_slot_mask() (A2) will return -EINVAL if slots was 0 (X),
but snd_soc_dai_set_tdm_slot() allow to use it (Y).

(A)	static int snd_soc_xlate_tdm_slot_mask(...)
	{
		...
		if (!slots)
(X)			return -EINVAL;
		...
	}

Call xlate_tdm_slot_mask() only if slots was non zero.

Reported-by: Giedrius Trainavičius <giedrius@blokas.io>
Closes: https://lore.kernel.org/r/CAMONXLtSL7iKyvH6w=CzPTxQdBECf++hn8RKL6Y4=M_ou2YHow@mail.gmail.com
Fixes: 7f1186a8d738661 ("ASoC: soc-dai: check return value at snd_soc_dai_set_tdm_slot()")
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/8734cdfx59.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-dai.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/sound/soc/soc-dai.c b/sound/soc/soc-dai.c
index de09d21add45..ad106087dd4b 100644
--- a/sound/soc/soc-dai.c
+++ b/sound/soc/soc-dai.c
@@ -273,13 +273,15 @@ int snd_soc_dai_set_tdm_slot(struct snd_soc_dai *dai,
 		&rx_mask,
 	};
 
-	if (dai->driver->ops &&
-	    dai->driver->ops->xlate_tdm_slot_mask)
-		ret = dai->driver->ops->xlate_tdm_slot_mask(slots, &tx_mask, &rx_mask);
-	else
-		ret = snd_soc_xlate_tdm_slot_mask(slots, &tx_mask, &rx_mask);
-	if (ret)
-		goto err;
+	if (slots) {
+		if (dai->driver->ops &&
+		    dai->driver->ops->xlate_tdm_slot_mask)
+			ret = dai->driver->ops->xlate_tdm_slot_mask(slots, &tx_mask, &rx_mask);
+		else
+			ret = snd_soc_xlate_tdm_slot_mask(slots, &tx_mask, &rx_mask);
+		if (ret)
+			goto err;
+	}
 
 	for_each_pcm_streams(stream)
 		snd_soc_dai_tdm_mask_set(dai, stream, *tdm_mask[stream]);
-- 
2.39.5



