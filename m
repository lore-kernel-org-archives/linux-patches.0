Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B163B47DA;
	Mon, 23 Mar 2026 15:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278188; cv=none; b=T8Tw1AWeE8nvqnsfjV3NnlD2l01vf/k4/q5hXRgFr4d9zssWxf/j1wmsW/6DV556O8K+vT7eKcCvIi1piqWHnlffFay63QZkV4OqAKsliAvqQdRdN3IMwwE9Tx/MIorCQsNFYl7eRMw8kLI3ggJhIGckJE2IAcrF+f+NqAt7ofM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278188; c=relaxed/simple;
	bh=YajZ8N0A91SHcIk3gqkjD0Xl9JY138Bc+gJzO5Xowm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKu3Cndn/ppf5Rlk2o0Lm3W2uAMvkDPR4sSP/UzwZTbdaDJZ4ZlwS8FQgtLiKi9pY6elzU3AAumwNQ0IRSiMjPLrO3MfIbKa0+8wc7s+cNcXWzwCGepgD74rlRU3Ib1F2kVR/9UWGQcf8LrrzUofeR7tYtuCXFjEinh8YdUyyz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhzrteTJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhzrteTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41585C2BCB1;
	Mon, 23 Mar 2026 15:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278187;
	bh=YajZ8N0A91SHcIk3gqkjD0Xl9JY138Bc+gJzO5Xowm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xhzrteTJIiQ6R7S4cylN0cIjGacPC/bmir4DrX2MCBtpMAv/bdhwMPKxVTEMpW4WN
	 JFCfnrchugn+ZI+r9JNCsVYavnfRUcE+JN2/p5IoPyQ7x7YxEgtQV8IQLakwZa1DoB
	 3F+0FFFfgGgYpN0x6vzhGmkFgDUmkB8UfOk96DwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matteo Cotifava <cotifavamatteo@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 226/567] ASoC: soc-core: drop delayed_work_pending() check before flush
Date: Mon, 23 Mar 2026 14:42:26 +0100
Message-ID: <20260323134539.426870297@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dc95b6f415558..39570e0e92bbc 100644
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



