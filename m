Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B06C21343
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHilURku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D817C433C8;
	Wed,  4 Oct 2023 18:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444405;
	bh=RybLq0S8P7lb2v40qz3UQBS0g52zCFnSvRdMo8ThFvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHilURku1wMBBz2uAGZfScImM+WMcWItYc5POtOBg3oAm9bV9Ldjm0Y8/YfvtN3Ja
	 kzcgdOfUqPO1b0e/cSA/w/gIayM4oWHoxYtRqDeST3Q9I8j3X0aiGPFirZO5fJdaYj
	 8iKc9r4lqNTz+UMT7f4JMK5ywERDauhclZb0AY7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 238/321] ASoC: cs35l56: Call pm_runtime_dont_use_autosuspend()
Date: Wed,  4 Oct 2023 19:56:23 +0200
Message-ID: <20231004175240.267986268@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

commit ec03804552e9a723569e14d2512f36a8e70dc640 upstream

Driver remove() must call pm_runtime_dont_use_autosuspend().

Drivers that call pm_runtime_use_autosuspend() must disable
it in driver remove(). Unfortunately until recently this was
only mentioned in 1 line in a 900+ line document so most
people hadn't noticed this. It has only recently been added
to the kerneldoc of pm_runtime_use_autosuspend().

Backport note: This is the same change as the upstream
commit but the cs35l56->base.dev argument in the upstream
code is cs35l56->dev in older releases.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20230908101716.2658582-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/cs35l56.c b/sound/soc/codecs/cs35l56.c
index fd06b9f9d496d..7e241908b5f16 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -1594,6 +1594,7 @@ void cs35l56_remove(struct cs35l56_private *cs35l56)
 	flush_workqueue(cs35l56->dsp_wq);
 	destroy_workqueue(cs35l56->dsp_wq);
 
+	pm_runtime_dont_use_autosuspend(cs35l56->dev);
 	pm_runtime_suspend(cs35l56->dev);
 	pm_runtime_disable(cs35l56->dev);
 
-- 
2.40.1



