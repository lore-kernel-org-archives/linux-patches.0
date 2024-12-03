Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1F61F76D7;
	Tue,  3 Dec 2024 16:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242221; cv=none; b=iizIjOa+v8Btbh0nYFfUBdNh+wOq+xRZTtuCwOKd7whj8D+6bWcAIBPTUOg60d29wBwD8npFkoa8ePcmtBtC6ohXO4Xmw9lLTWglU/TbOMATeQHja+g3PUk7q03aqSJ7+DIcySzX4FONjdF2chhOYocmRVF4OQtKiK7gEzdLHQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242221; c=relaxed/simple;
	bh=92Sh+qUsR8EvdT80wUVF5lsWU1mIhbu2WvzHXzg8bBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L3L7QUJgEcgSGXFiPjgVIi722tWGFjiRf7KLtXNS3J0+OAJcA+VLc+7g9hC61u0NDrjr11pDHZonGiSNhK3xTpax7a3+BWkV4IPL2mnIbsvkYBZgroF2zxy7j2jTlnNpZuC6RT/KS6a7bj3ZZemffXncfqM5KUIObM343q1MRJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2FtG5/kH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2FtG5/kH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8266EC4CECF;
	Tue,  3 Dec 2024 16:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242221;
	bh=92Sh+qUsR8EvdT80wUVF5lsWU1mIhbu2WvzHXzg8bBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2FtG5/kHXmfKtmBEkUG2X1kysW2oSCEXvii2NLyXQX+wzqbZQPLkt69o77bw3dZ6a
	 pPNcd7zU4fyuCCdWr6n5YcofXR5ql1JuIgPKDhuLQ0HId+5oBHWXG+Ti5BR9v95qjM
	 taV0icqWInN+vmeyRZwET7fQG8qSzZsucY5zMvQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 615/826] ASoC: imx-audmix: Add NULL check in imx_audmix_probe
Date: Tue,  3 Dec 2024 15:45:42 +0100
Message-ID: <20241203144807.743601816@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit e038f43edaf0083f6aa7c9415d86cf28dfd152f9 ]

devm_kasprintf() can return a NULL pointer on failure,but this
returned value in imx_audmix_probe() is not checked.
Add NULL check in imx_audmix_probe(), to handle kernel NULL
pointer dereference error.

Fixes: 05d996e11348 ("ASoC: imx-audmix: Split capture device for audmix")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Link: https://patch.msgid.link/20241118084553.4195-1-hanchunchao@inspur.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-audmix.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/fsl/imx-audmix.c b/sound/soc/fsl/imx-audmix.c
index 6fbcf33fd0dea..8e7b75cf64db4 100644
--- a/sound/soc/fsl/imx-audmix.c
+++ b/sound/soc/fsl/imx-audmix.c
@@ -275,6 +275,9 @@ static int imx_audmix_probe(struct platform_device *pdev)
 		/* Add AUDMIX Backend */
 		be_name = devm_kasprintf(&pdev->dev, GFP_KERNEL,
 					 "audmix-%d", i);
+		if (!be_name)
+			return -ENOMEM;
+
 		priv->dai[num_dai + i].cpus	= &dlc[1];
 		priv->dai[num_dai + i].codecs	= &snd_soc_dummy_dlc;
 
-- 
2.43.0



