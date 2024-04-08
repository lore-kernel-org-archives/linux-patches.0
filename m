Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5207C0B0;
	Mon,  8 Apr 2024 13:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583818; cv=none; b=miyXNrB5TKQJ56/Eu4vXrUpCvN19pE9uP5TTDmaV5/9kMNAk/1l0CszK7B3HfmgpmdETEws8pKrEUm8AV1awtIGImbalWjVHa6o3VLzy5eNmPYPh8EyaLV3OjVVQspAYwbbYKuJ8wfXCmvT9qcGNnbkst9mP33nSkA7w3rm5ySM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583818; c=relaxed/simple;
	bh=fdaKcmGd/7PanR4W+YY7bwbDeheFoWFrRsle71xwBS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZ5gG6u5Mr/zBZzbiKfTUMYBSjb3LwbpWeBZ16XCwodpZFi9t7kZGLgdv8DrhA6908v1XWxHhnxfdjOIWo14xF5aHXh5kFNj2qkRXhe7I5iDbkF9ts3WkLr9yNpbarLakOVpmUn7V7Lf740ZUDoMqgxRU8Oc67/+KRLnodAEpsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sTHYxiwf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sTHYxiwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE484C433C7;
	Mon,  8 Apr 2024 13:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583818;
	bh=fdaKcmGd/7PanR4W+YY7bwbDeheFoWFrRsle71xwBS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sTHYxiwfL0G1JhAPxUdF+UAUWbounLQlQCtb6uEeglXD/6MwC6K+LJ4RX2sUAcMnj
	 xhmBEdYBQrPGKtI22WPXBZ5rLSmjkjTPo1fHpAI/bwU4fYrHpYjMiTRNIZ2R9VGLSC
	 DiaLQYmIr+FIbx3lnOFZ0nUGsXKEdzMYPiuoMeDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.8 223/273] ASoC: SOF: ipc4-pcm: Combine the SOF_IPC4_PIPE_PAUSED cases in pcm_trigger
Date: Mon,  8 Apr 2024 14:58:18 +0200
Message-ID: <20240408125316.333829984@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 55ca6ca227bfc5a8d0a0c2c5d6e239777226a604 upstream.

The SNDRV_PCM_TRIGGER_PAUSE_PUSH does not need to be a separate case, it
can be handled along with STOP and SUSPEND

Cc: stable@vger.kernel.org # 6.8
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://msgid.link/r/20240321130814.4412-13-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-pcm.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/sound/soc/sof/ipc4-pcm.c
+++ b/sound/soc/sof/ipc4-pcm.c
@@ -461,14 +461,12 @@ static int sof_ipc4_pcm_trigger(struct s
 
 	/* determine the pipeline state */
 	switch (cmd) {
-	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		state = SOF_IPC4_PIPE_PAUSED;
-		break;
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
 	case SNDRV_PCM_TRIGGER_RESUME:
 	case SNDRV_PCM_TRIGGER_START:
 		state = SOF_IPC4_PIPE_RUNNING;
 		break;
+	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_STOP:
 		state = SOF_IPC4_PIPE_PAUSED;


