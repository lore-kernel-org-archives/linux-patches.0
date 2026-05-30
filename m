Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1BE1A9F90;
	Sat, 30 May 2026 18:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166831; cv=none; b=LArGL99Ub7ZsdnB57phCccPquGu8qSBASeklCLW4GQ5qlmoWplX1d/XSwNCeFV1p4I+t7wKiHaajstrwIF/YWDiR6SR8uG0hCXX1uX8augm6JOjhXhOFRx11HezUSVqwWciUsWWCM6r4o/QXhCQqba+w6ZetwCVcg+MnJgCwvsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166831; c=relaxed/simple;
	bh=+cPJgCM7mq32WuDXjbaJKUHvuPF273Fa5Hi6C0HX4ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XvQOkblPMCh7T2JwY5+jlZvyXGcsajNwbYiz9TXzUcDR5sy0okptoAo7TY81GkjCsV05JUUgZm80VlNbqGl/3jcblzFjyoUIswjv8wMmajBEXMRmfaqkrNXa8qF05veFCvhuFSdk4MNBdY9f0j+Fna/OpRASS1bVzYjiKg2OXrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKRciGOt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKRciGOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4B01F00893;
	Sat, 30 May 2026 18:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166830;
	bh=0FLupfdpHYlsl+aMt0m1+AUmoA/UohrsWF9Wv+gIrBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jKRciGOtOsgJJQcW0j9BlW40guSzeC0lNcRjn4mY8erc8Z4fc3zEYWEp0rPaSWphh
	 u/gOJMuVgBWysLUpOUZ3vLqZ90gxwzxjHFgSgOqFLNxRk8dyWs0qKvZ/arp57dMNH7
	 SEKViBb+xCimXiljZsluR8MLNjTaXh3rJLMDQxrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <christian.ehrhardt@codasip.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20 ?= <u.kleine-koenig@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 485/589] ASoC: codecs: ab8500: Fix casting of private data
Date: Sat, 30 May 2026 18:06:06 +0200
Message-ID: <20260530160237.391320723@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian A. Ehrhardt <christian.ehrhardt@codasip.com>

[ Upstream commit a201aef1a88b675e9eb8487e27d14e2eef3cef80 ]

ab8500_filter_controls[i].private_value is initialized using

	.private_value = (unsigned long)&(struct filter_control)
		{.count = xcount, .min = xmin, .max = xmax}

thus it's a pointer to a struct filter_control casted to unsigned long.

So to get back that pointer .private_data must be cast back, not its
address.

Fixes: 679d7abdc754 ("ASoC: codecs: Add AB8500 codec-driver")
Signed-off-by: Christian A. Ehrhardt <christian.ehrhardt@codasip.com>
Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/20260428192255.2294705-2-u.kleine-koenig@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ab8500-codec.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
index 31a8c4162d209..b4bf411124fa0 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -2505,13 +2505,13 @@ static int ab8500_codec_probe(struct snd_soc_component *component)
 		return status;
 	}
 	fc = (struct filter_control *)
-		&ab8500_filter_controls[AB8500_FILTER_ANC_FIR].private_value;
+		ab8500_filter_controls[AB8500_FILTER_ANC_FIR].private_value;
 	drvdata->anc_fir_values = (long *)fc->value;
 	fc = (struct filter_control *)
-		&ab8500_filter_controls[AB8500_FILTER_ANC_IIR].private_value;
+		ab8500_filter_controls[AB8500_FILTER_ANC_IIR].private_value;
 	drvdata->anc_iir_values = (long *)fc->value;
 	fc = (struct filter_control *)
-		&ab8500_filter_controls[AB8500_FILTER_SID_FIR].private_value;
+		ab8500_filter_controls[AB8500_FILTER_SID_FIR].private_value;
 	drvdata->sid_fir_values = (long *)fc->value;
 
 	snd_soc_dapm_disable_pin(dapm, "ANC Configure Input");
-- 
2.53.0



