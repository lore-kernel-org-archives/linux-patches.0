Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADBDFC00
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2258C433EF;
	Mon, 15 May 2023 17:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171853;
	bh=F4VmDvo9vhiaWp/qqDmfCbSrANSvjEq2IIoUGwzChOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Un62rheKXTiDgfuPJdHWu4uiOOdMWeWMX4OHdhdVKRT4ipA1OkJd7emS2pD6Hx9zc
	 iKa2f1tGdZ4EGfGPptNlahd554SpB/ygxzl+w7EYsPqp78aiHuaN1Rx1l9a+oGXuGX
	 rbhJbYLC3FJctkTCJXWucpjZKXT9DWH37U4MuHI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 5.15 099/134] ASoC: soc-pcm: Move debugfs removal out of spinlock
Date: Mon, 15 May 2023 18:29:36 +0200
Message-Id: <20230515161706.435184021@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161702.887638251@linuxfoundation.org>
References: <20230515161702.887638251@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

commit 9f620684c1ef5a002b6622ecc7b5818e81252f48 upstream.

The recent fix for DPCM locking also covered the loop in
dpcm_be_disconnect() with the FE stream lock.  This caused an
unexpected side effect, thought: calling debugfs_remove_recursive() in
the spinlock may lead to lockdep splats as the code there assumes the
SOFTIRQ-safe context.

For avoiding the problem, this patch changes the disconnection
procedure to two phases: at first, the matching entries are removed
from the linked list, then the resources are freed outside the lock.

Fixes: b7898396f4bb ("ASoC: soc-pcm: Fix and cleanup DPCM locking")
Reported-and-tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20220119155249.26754-3-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/soc-pcm.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1289,6 +1289,7 @@ static void dpcm_be_reparent(struct snd_
 void dpcm_be_disconnect(struct snd_soc_pcm_runtime *fe, int stream)
 {
 	struct snd_soc_dpcm *dpcm, *d;
+	LIST_HEAD(deleted_dpcms);
 
 	snd_soc_dpcm_mutex_assert_held(fe);
 
@@ -1308,13 +1309,18 @@ void dpcm_be_disconnect(struct snd_soc_p
 		/* BEs still alive need new FE */
 		dpcm_be_reparent(fe, dpcm->be, stream);
 
-		dpcm_remove_debugfs_state(dpcm);
-
 		list_del(&dpcm->list_be);
+		list_move(&dpcm->list_fe, &deleted_dpcms);
+	}
+	snd_soc_dpcm_stream_unlock_irq(fe, stream);
+
+	while (!list_empty(&deleted_dpcms)) {
+		dpcm = list_first_entry(&deleted_dpcms, struct snd_soc_dpcm,
+					list_fe);
 		list_del(&dpcm->list_fe);
+		dpcm_remove_debugfs_state(dpcm);
 		kfree(dpcm);
 	}
-	snd_soc_dpcm_stream_unlock_irq(fe, stream);
 }
 
 /* get BE for DAI widget and stream */


