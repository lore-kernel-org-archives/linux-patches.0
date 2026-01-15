Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4F83BF2FA;
	Thu, 15 Jan 2026 17:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497927; cv=none; b=KAzdK46WE6a7XinHjYiRNVKB4gcqZFdYmos5PIpWBzbYaRHydFd4RxFOoAB4qT4NuY6PxI1CmMgD1OpTv60VsvjUDIXUz7wRsbynJuwHOoLato9O1OjTQe7wYwgSjHu/JdDYJ4yvTnrD4PhPv3/34P+1oDFJ4ujMLqJhY0utM9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497927; c=relaxed/simple;
	bh=fSmUgqVO4AZHfjeLoMId4EdfbOD+tYYhZQesCQQ4vFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZPtICkPeg0YdcGv3JqlbWsH0kA9kU026j0GGQR7uLwzXyCU0Bsf1Cwx4wF0K1GK34rA2GRdtV+Z0U99wCn/yQThZsZ6zFYSyGForf8RWOFCNS2nWuntdgDuRICvnIGqxDmixbNgA1FBSMtUOYcemqDBzr/5DyKYMhL/hfUvetg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7W6nEqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7W6nEqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 057AAC116D0;
	Thu, 15 Jan 2026 17:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497927;
	bh=fSmUgqVO4AZHfjeLoMId4EdfbOD+tYYhZQesCQQ4vFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7W6nEqmZwT5IjBv+vs8V+MA9V9Ax7dKmKN68TpfMsAN/3dtsEp3i03X1svPhTzFQ
	 5yA64puZCKfzYOHk6D87Dncs+woFHsrvVgecg+PF3BgTZ+CuvvQLOpe7pj9ZZdMgA4
	 VP1XM6WdSRmi+pmDi24y6VPFZ23w5V1juLQAwNho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 253/554] ALSA: vxpocket: Fix resource leak in vxpocket_probe error path
Date: Thu, 15 Jan 2026 17:45:19 +0100
Message-ID: <20260115164255.394837801@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 2a03b40deacbd293ac9aed0f9b11197dad54fe5f ]

When vxpocket_config() fails, vxpocket_probe() returns the error code
directly without freeing the sound card resources allocated by
snd_card_new(), which leads to a memory leak.

Add proper error handling to free the sound card and clear the
allocation bit when vxpocket_config() fails.

Fixes: 15b99ac17295 ("[PATCH] pcmcia: add return value to _config() functions")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251215042652.695-1-vulab@iscas.ac.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pcmcia/vx/vxpocket.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/pcmcia/vx/vxpocket.c b/sound/pcmcia/vx/vxpocket.c
index 7a0f0e73ceb2..867a477d53ae 100644
--- a/sound/pcmcia/vx/vxpocket.c
+++ b/sound/pcmcia/vx/vxpocket.c
@@ -295,7 +295,13 @@ static int vxpocket_probe(struct pcmcia_device *p_dev)
 
 	vxp->p_dev = p_dev;
 
-	return vxpocket_config(p_dev);
+	err = vxpocket_config(p_dev);
+	if (err < 0) {
+		card_alloc &= ~(1 << i);
+		snd_card_free(card);
+		return err;
+	}
+	return 0;
 }
 
 static void vxpocket_detach(struct pcmcia_device *link)
-- 
2.51.0



