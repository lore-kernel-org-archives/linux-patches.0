Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6110030BF70;
	Mon, 13 Apr 2026 16:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097360; cv=none; b=OcSD3xe61TdUWqEwHjgfYyGrAsDkbjxO0H5fG1JeiohKlt2jKNMJZ0bTPNLzR6Ta98hPysiPx7SSS0aKhwmICotwwD/bhJfxmoYFYPHGEbHdtUu6oHVHaPG6CjQ2Jm4qoxgZbTTVHoR7elov+ahEI/WSyv38FX9ILLmAYu0Wvi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097360; c=relaxed/simple;
	bh=KYbZT2BEM/cIPnRFHtaFRWVeVTt0pqsjTUmFr3nwCqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VaI9L4aLEjIn9+evDkcc4kuoc6LGxpgqzHdxoJnm/ewzWkD6WlfNvkTOUo+a6MMO0WpmuU9I2doIEm7f8CijVpAaho3szV60b3nJvPUq8cfj1JqSae8FPvIZSoztPko5DGsFjB5SJ3CnCfsJMAfP3jiO+pfaHq2RY7LTZITJooA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Stj+LIys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Stj+LIys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4A4C2BCB3;
	Mon, 13 Apr 2026 16:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097360;
	bh=KYbZT2BEM/cIPnRFHtaFRWVeVTt0pqsjTUmFr3nwCqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Stj+LIystRo/zqlkcaE2P+TZKk92c/U5oRUc01ft4NA8+IM1qwPRbl6IQr7SQ4W6Z
	 w1cZHNKq6jZIdyXrzm2rLDCWrAEjgGranJE0/tZv7+lawCQ5iDK1adD/J6DlgCbCcX
	 Ynp//ZkQ0rk32HXlZxLb6HkhvQkiWe8jAHy/Cm4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matteo Cotifava <cotifavamatteo@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 106/570] ASoC: soc-core: drop delayed_work_pending() check before flush
Date: Mon, 13 Apr 2026 17:53:57 +0200
Message-ID: <20260413155834.414289211@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: matteo.cotifava <cotifavamatteo@gmail.com>

[ Upstream commit 3c99c9f0ed60582c1c9852b685d78d5d3a50de63 ]

The delayed_work_pending() check before flush_delayed_work() in
soc_free_pcm_runtime() is unnecessary and racy. flush_delayed_work()
is safe to call unconditionally - it is a no-op when no work is
pending. Remove the check.

The original check was added by commit 9c9b65203492 ("ASoC: core:
only flush inited work during free") but delayed_work_pending()
followed by flush_delayed_work() has a time-of-check/time-of-use
window where work can become pending between the two calls.

Fixes: 9c9b65203492 ("ASoC: core: only flush inited work during free")
Signed-off-by: Matteo Cotifava <cotifavamatteo@gmail.com>
Link: https://patch.msgid.link/20260309215412.545628-2-cotifavamatteo@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 854d8f62008ee..243c623598483 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -400,8 +400,7 @@ static void soc_free_pcm_runtime(struct snd_soc_pcm_runtime *rtd)
 
 	list_del(&rtd->list);
 
-	if (delayed_work_pending(&rtd->delayed_work))
-		flush_delayed_work(&rtd->delayed_work);
+	flush_delayed_work(&rtd->delayed_work);
 	snd_soc_pcm_component_free(rtd);
 
 	/*
-- 
2.51.0



