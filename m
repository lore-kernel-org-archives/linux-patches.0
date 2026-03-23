Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55231282F0C;
	Mon, 23 Mar 2026 16:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282472; cv=none; b=lv2kAezQT/bpp9QUJd/uDeHg+DBKzRjTJDxRKU76fI9cQH8HXHwOaFK3TegyXfHA1r5LZ9tpmyHShs60HmcCVseD0Tu1o9xVyBBgOZrIRcrmD01aI2RS6Jk7ue9c0z1GWuuBzuG0gFgF0peDy9btNi36e+b9sJN8jyg0WSmTkA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282472; c=relaxed/simple;
	bh=A1i5l+o1xxlrVbSQAdgTUqHLcoFGqqTqJ4M5vjIInC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vfupeeln8GHqi14b8VUvx92tteB5c0MyCnYfQa4K2oxVKUyJqirr+irmJSq04Z96Fow1mJQhbXi0ANOSTVb+49gRtsXFfajbRy4M70q/1udvaN8TedME88+CM9ubmOyuLymSp/5r33QeOnLLL+qdAoKzQmglsaR0rPvnkIR2RBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BIHxkAZg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BIHxkAZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA639C4CEF7;
	Mon, 23 Mar 2026 16:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282472;
	bh=A1i5l+o1xxlrVbSQAdgTUqHLcoFGqqTqJ4M5vjIInC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BIHxkAZgrrwnCnsJyA883Asi+gVOiZny195LN3vmUavnShuyFLcCRpoJCzMCiveik
	 3ez4ezI97xx6o7tQJBkQlpoWp5yGmypUbNTd8ogJzXFMl7la3azyjBoqiB5LP9jYkH
	 1m6G9l/AbL0ajhPys/lfEwKLa3K6nEJodCSwrQGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matteo Cotifava <cotifavamatteo@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 168/481] ASoC: soc-core: drop delayed_work_pending() check before flush
Date: Mon, 23 Mar 2026 14:42:30 +0100
Message-ID: <20260323134529.321069807@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 80192b089f250..cb95a9293343f 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -381,8 +381,7 @@ static void soc_free_pcm_runtime(struct snd_soc_pcm_runtime *rtd)
 
 	list_del(&rtd->list);
 
-	if (delayed_work_pending(&rtd->delayed_work))
-		flush_delayed_work(&rtd->delayed_work);
+	flush_delayed_work(&rtd->delayed_work);
 	snd_soc_pcm_component_free(rtd);
 
 	/*
-- 
2.51.0



