Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3439368941;
	Wed, 20 May 2026 17:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299556; cv=none; b=qkr6zsbufZF0z6P+lXLy3X70fxq66gWjW+z+kJQEs6/kQ2pxPXwSvdNDtwWC3rJ1wYVfsnsdCh5Z8qkIpc1qpx06bf7L/mv2WHt1U2dUtb5mhZHuPxfafFtZWrLs5+UJdJtElHrSqw05xxJF7uTo4DucKjmgj4bNlajcxMcgg3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299556; c=relaxed/simple;
	bh=4KjObqbU2D/O1gkNHdPw0DeiyZ9uaYR73c4aPNOcKvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BJXt2U3g3U1fswDJNtbdI6rOBrn5GgsKd20d0Mt+lOfKxQk1S3TFLAqfBRwrYG/57U5ELRZ94rhzJKIWnIAzD6Kv9WeunhUImaPkoDOg6GqIkYMPNr85vMWlChZa1DEsgF1F/JFc2xReF74qjcGY6sTok2Y78UXFkcOH+oNOnuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WeIeraVs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WeIeraVs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4377D1F000E9;
	Wed, 20 May 2026 17:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299555;
	bh=W+4RzHWJRZc91ZLeYpQu/DdffkaSZp3OiqO0sxAFVxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WeIeraVsChW3AD0y37Syf4CsNnwkz0lSgd74kjOv/TkCSfUF74038a5El5VZTLFy6
	 xO47mlOereuQkTgyzsYmCNOPxNHo/j7+FG5vRjMTaqAu1tDBICWX44MWAvdpP7iIk8
	 s3ZdiImYrYn1n0DgkkPQdEdTALOvH42js+xyju2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <christian.ehrhardt@codasip.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20 ?= <u.kleine-koenig@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 817/957] ASoC: codecs: ab8500: Fix casting of private data
Date: Wed, 20 May 2026 18:21:40 +0200
Message-ID: <20260520162152.285325388@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 04b5e1d5a6530..32d9cdbc8c310 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -2496,13 +2496,13 @@ static int ab8500_codec_probe(struct snd_soc_component *component)
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



