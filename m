Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B797E360745;
	Thu, 20 Aug 2026 15:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238723; cv=none; b=TI80COycKcAQ2dyAlaGZxauY7a0ZM7w+SDq7sH3Q6W67gOxnO6nVvhnqZnSiB8hpf84WkCht9UQnIUsxVirNPJlmL7ZXJOkMDxBYYmQYnZ0w6h8hQHBIQW9XgrAftYU37kNs3qNcr+EuLawwwH1bpHex5sLXw0lqmAuxk/Q/PUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238723; c=relaxed/simple;
	bh=wpvswps5GeFxhwAdsH97tAtnngMjPxpzJPnDhpDghAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GkoR+wmUQd0DPX9NEkvFIrm1uOdS4Acqw1R8Y6+AR512U3QAB4jXUkwOqEjRRayyDKcqLWjn1wq2PZXEAWCzjcgmX+MrT462bQ9X0kOXQEeQhC1j41rMyrRh1xKn6VRrkoREUCpNe7Hv5LbQ0TAQaKBSiAfR5tFeUKTi39d5agk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1KRmEAg/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1KRmEAg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF621F000E9;
	Thu, 20 Aug 2026 15:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238722;
	bh=/LbfwUCtpNpR4w+FUrHFA4KDryvss0ee4yeJzTt20Ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1KRmEAg/GmVVsXliEQ2zSe4+7XZ8BD7ZPBKJxX9Gj6jaG+nRmA/JiBvp7xs3Xs20N
	 cb5HTrXIA0Uiwt2iY9A6GhFRWZuSwE/pelltU+Fc8KpRd1u4mhRRirMftFSs2w3suU
	 wuoSkQeoPOhjxzBWOfQ/BN7f2BbWjgyO9iAuwEsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 019/217] ASoC: SOF: ipc4-pcm: Continue the pipeline trigger in case of IPC timeout
Date: Thu, 20 Aug 2026 16:53:07 +0200
Message-ID: <20260820145238.202910660@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 17661c67b206612cb3ba65d5ae726cd2015d0a53 upstream.

Ignore IPC errors for pipeline state change if the firmware state is
crashed or the IPC has timed out.

If the firmware has crashed the kernel still needs to go through the state
changes to reset its internal to be able to correctly work the next time
the DSP is booted up.

The case with IPC timeout is a bit more problematic, but it has been
rootcaused to be the result of system scheduling blockage and the firmware
did actually received and handled the message, but the reply handling got
blocked by issues outside of the SOF stack.
So far the best way to handle this is to continue with setting the state.

Fixes: c40aad7c81e5 ("ASoC: SOF: ipc4-pcm: Workaround for crashed firmware on system suspend")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://patch.msgid.link/20260730112343.26687-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-pcm.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/sound/soc/sof/ipc4-pcm.c
+++ b/sound/soc/sof/ipc4-pcm.c
@@ -528,7 +528,19 @@ static int sof_ipc4_trigger_pipelines(st
 	ret = sof_ipc4_set_multi_pipeline_state(sdev, SOF_IPC4_PIPE_PAUSED, trigger_list);
 	if (ret < 0) {
 		spcm_err(spcm, substream->stream, "failed to pause all pipelines\n");
-		goto free;
+		/*
+		 * workaround: if the firmware is crashed or the IPC timed out
+		 * while setting the pipeline state we must ignore the error
+		 * code and proceed to set adjust the local pipeline states.
+		 *
+		 * If the firmware is crashed we will not send IPC messages
+		 * and we are going to see errors printed, but the state of the
+		 * widgets will be correct for the next boot.
+		 */
+		if (sdev->fw_state != SOF_FW_CRASHED && ret != -ETIMEDOUT)
+			goto free;
+
+		ret = 0;
 	}
 
 	/* update PAUSED state for all pipelines just triggered */
@@ -560,14 +572,15 @@ skip_pause_transition:
 			 "failed to set final state %d for all pipelines\n",
 			 state);
 		/*
-		 * workaround: if the firmware is crashed while setting the
-		 * pipelines to reset state we must ignore the error code and
-		 * reset it to 0.
-		 * Since the firmware is crashed we will not send IPC messages
+		 * workaround: if the firmware is crashed or the IPC timed out
+		 * while setting the pipeline state we must ignore the error
+		 * code and proceed to set adjust the local pipeline states.
+		 *
+		 * If the firmware is crashed we will not send IPC messages
 		 * and we are going to see errors printed, but the state of the
 		 * widgets will be correct for the next boot.
 		 */
-		if (sdev->fw_state != SOF_FW_CRASHED || state != SOF_IPC4_PIPE_RESET)
+		if (sdev->fw_state != SOF_FW_CRASHED && ret != -ETIMEDOUT)
 			goto free;
 
 		ret = 0;


