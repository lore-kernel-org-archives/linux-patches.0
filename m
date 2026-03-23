Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC5A3AF648;
	Mon, 23 Mar 2026 14:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275289; cv=none; b=lpIUPxcN81UB2vI60EdouoBq0GpuSXTbD/lgx2rrgj+CawpwqjnX7r2CkgvSrlhnfqQbGN28B1u8kwwerDUJZjTI5zL4V53I+39OC8C7PzPZX6A3xj8neph6pwIq39/guAxYzcc8+/bt/elsPt6Zm7xzlgMgPwjDSSKpUAFBTjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275289; c=relaxed/simple;
	bh=xy8TPG2hu9YFQc5x6Q/n7s4X9azTJBZdC4d6JAuUFGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nw7qPupahQf0n1UBYzIRPUPZTFlOQF9XW3IwMBdrZ+pBlCtaMiR8Um+pohLwwbLyTKW3Txkpv0gbO0kbQniVKWTtPnrVzYTlTmmGBicvnhPjLHP2qSS1h56eKWNZJdCVRxOxQMhF3F6ujHGaN/ny29DDy7LVszdZOYzX1m6rUi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r0ZKpO/i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r0ZKpO/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9920BC2BCB3;
	Mon, 23 Mar 2026 14:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275289;
	bh=xy8TPG2hu9YFQc5x6Q/n7s4X9azTJBZdC4d6JAuUFGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r0ZKpO/i4vrN5WonoeFvr6EBi1a7McW8qcxN3PbI229wL/Uq5uGr20MWCRnr+hqUx
	 iAp33pmPnHuA3Mh9O4XRl1Obxlnv6tByRhF7XCdy90Pg3HP7n+AAKUYkDxBD7xT43/
	 Y4jULu+mj27FGy3pfo8esqBIXR85cM8utbAv+j/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matteo Cotifava <cotifavamatteo@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/460] ASoC: soc-core: drop delayed_work_pending() check before flush
Date: Mon, 23 Mar 2026 14:40:38 +0100
Message-ID: <20260323134527.744980021@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4ac870c2dafa2..791197c1e05b9 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -456,8 +456,7 @@ static void soc_free_pcm_runtime(struct snd_soc_pcm_runtime *rtd)
 
 	list_del(&rtd->list);
 
-	if (delayed_work_pending(&rtd->delayed_work))
-		flush_delayed_work(&rtd->delayed_work);
+	flush_delayed_work(&rtd->delayed_work);
 	snd_soc_pcm_component_free(rtd);
 
 	/*
-- 
2.51.0



