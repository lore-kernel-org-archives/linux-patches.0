Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A042A29B200;
	Tue, 16 Dec 2025 11:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884995; cv=none; b=T0yrpLRXslaX7IYJtTFQub46MG1GL9/FAvJ/uOhowpBpqJNhuMOTCXbI3/LfQYOaeAac+KwjrDwCcK2eTx23z96pjp9KXeN+Qd+KA+R2uKBHt8c8S5uk6c+11358HlC6pBhGijzzUH6QtCliUGvtRfoD9rcZwe0UJJEXZahLE8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884995; c=relaxed/simple;
	bh=PM87CcBqoNwqbuoBelAjD0R0OEpE5p7ewtTKuD7NeGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9eoj9kF3x4CNi8eMCx5D+HDOPA/qudox7B9AaoJ7yb/jtRNs52DDlwy4Gi15fsEpZBcn+BO8JZFhPfysKkP2O4O53xw2jcmpW24vCEvOS9i7wtXuo4DQa0YGLhnj5SDekX6b+fbX51bd5m2KLnzCdXJh/Rs+61TMM25PthRCis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y5MNNZCJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y5MNNZCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059CDC4CEF1;
	Tue, 16 Dec 2025 11:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884995;
	bh=PM87CcBqoNwqbuoBelAjD0R0OEpE5p7ewtTKuD7NeGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y5MNNZCJ8FnZ33t4AFRju/UouZBU3VB+edyf7YBt9+13nZhVJv5BGP416mIvsDAOa
	 W4QHteJzS6tJbhyeYXiTc9ZzRRxlkIImKU07dGr6lSB5qB+4vivvHgU48a71tqgwva
	 jvB9lgQVj+vbb/Ehx7qY0Yfv67OzRy59dDg2pi2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 354/354] ALSA: wavefront: Fix integer overflow in sample size validation
Date: Tue, 16 Dec 2025 12:15:21 +0100
Message-ID: <20251216111333.735361777@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

commit 0c4a13ba88594fd4a27292853e736c6b4349823d upstream.

The wavefront_send_sample() function has an integer overflow issue
when validating sample size. The header->size field is u32 but gets
cast to int for comparison with dev->freemem

Fix by using unsigned comparison to avoid integer overflow.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://patch.msgid.link/SYBPR01MB7881B47789D1B060CE8BF4C3AFC2A@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/isa/wavefront/wavefront_synth.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/isa/wavefront/wavefront_synth.c
+++ b/sound/isa/wavefront/wavefront_synth.c
@@ -950,9 +950,9 @@ wavefront_send_sample (snd_wavefront_t *
 	if (header->size) {
 		dev->freemem = wavefront_freemem (dev);
 
-		if (dev->freemem < (int)header->size) {
+		if (dev->freemem < 0 || dev->freemem < header->size) {
 			dev_err(dev->card->dev,
-				"insufficient memory to load %d byte sample.\n",
+				"insufficient memory to load %u byte sample.\n",
 				header->size);
 			return -ENOMEM;
 		}


