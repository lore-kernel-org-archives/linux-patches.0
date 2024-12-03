Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBF31F7540;
	Tue,  3 Dec 2024 15:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239451; cv=none; b=JDbvyoVuNj5LR2EYkWYca6h7QBH7OIBurypjXnH64YLl9wpPXw9sA51s+ReMxRkBNnHATAkpm3c1nU7ySeCtUmYo0wqIv7XuL+Rm9TEXPqm0lIbDMfflhpIMHoKmpTN9WRE/ykysq6QT/4Y/hPkYs7SKX3Kmif/udO51LOzVrQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239451; c=relaxed/simple;
	bh=Io010QnyGJjAvlZFTow6/npamr8NTA0EqIDuT19zEIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gkmw2esh9dX9OI+XEHpWfNn+W/bLeGQg0ehqutj3I3NlhG0jTDStjOqd18Q/72CByabiuh+0TRFe1HSxpYe25tO7u4W08l3+HXch5/VuHvaW1dNOMMKjnJEOn2eh57D2yiUIYmmZ2QPPSwe9jZlkzRIIPDJcLI5HhTZDO7PGNvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OkMNsx+q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OkMNsx+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A6FC4CECF;
	Tue,  3 Dec 2024 15:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239451;
	bh=Io010QnyGJjAvlZFTow6/npamr8NTA0EqIDuT19zEIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OkMNsx+qpfQJNixlOQolAk4I3ADHQpdbV1HV1MKFvrjy0o1EGXfFDq2X86dZmFoYe
	 xY+vSwclPtSCmiZoOSWFe5Ql14DuYAb6Rb+VuxuEnarrE0tbyMz9LePrhEKjEMp0rP
	 1i9KlpttVIunin5TlN2w/KkItx+NmjFAy6JQ/+Qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 619/817] ASoC: imx-audmix: Add NULL check in imx_audmix_probe
Date: Tue,  3 Dec 2024 15:43:11 +0100
Message-ID: <20241203144020.097055976@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



