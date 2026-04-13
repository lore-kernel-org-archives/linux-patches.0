Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1727233722;
	Mon, 13 Apr 2026 16:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098727; cv=none; b=DjEq+MI3ZVTfACELQwyiMOV1DaQf9K9TJPpN6QQCr30l0F4eZ8sy6hsZodam+i8SqWb8CU3IKiLvHbPmoqcNlU5OYb4e0iUEXihdkFqo5LeeEqBDeixT7mol4+iBISDckvbxT+d/JdO3WRKjoLtxNeFwXQqcUsWOfU3iDMpPfJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098727; c=relaxed/simple;
	bh=p6ymIA8/dMDYjHXcLrKWtdsfkFq7+Ud4NiC8XJPS7BU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UB9yfWggVi9Ol9NCQY3lqRO+DZ2mLHRrxwVbXfqaIAA1vFxOp4WmEwkXohhOhSCekf7aM66zVo497hHgKel/n3goRWuVNK/cNZjAf7PBceH5XwhSiunYnF/4CsNTDEdKFeWU0gs/OhrYLcqpQYBeYvf1ghvSi6S+5ttoyoqXIZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJ2aYBtj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJ2aYBtj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588DAC2BCAF;
	Mon, 13 Apr 2026 16:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098727;
	bh=p6ymIA8/dMDYjHXcLrKWtdsfkFq7+Ud4NiC8XJPS7BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJ2aYBtjodqLkfKToMpXF7NdRzWsqrWhj4f/cWWOkDP3Pi4QUUT5CdRj//AlU7aHg
	 6H55o4eEeDuoDPY9YakYztCJUDQ0SdCgTxc+7EEfJEjXdgpF4YTk+9cW1r0PS/fg3N
	 ub+VbZufR9PObbsD3U4dtQgJdur3iv2AINu4GqmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matteo Cotifava <cotifavamatteo@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/491] ASoC: soc-core: drop delayed_work_pending() check before flush
Date: Mon, 13 Apr 2026 17:55:09 +0200
Message-ID: <20260413155821.444493435@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1120d669fe2e3..77f8d458406b0 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -401,8 +401,7 @@ static void soc_free_pcm_runtime(struct snd_soc_pcm_runtime *rtd)
 
 	list_del(&rtd->list);
 
-	if (delayed_work_pending(&rtd->delayed_work))
-		flush_delayed_work(&rtd->delayed_work);
+	flush_delayed_work(&rtd->delayed_work);
 	snd_soc_pcm_component_free(rtd);
 
 	/*
-- 
2.51.0



