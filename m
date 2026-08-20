Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E31D37A498;
	Thu, 20 Aug 2026 15:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238141; cv=none; b=C36s+qTQyzbvXkTFnbRu2uoqUQ/cMzHN9Cg/hM6kGpPpL18zXVeFWK2bSqdCZTgs/gagRV7n9ZgT92VQ8Xm9JkR/QiaB9IUkUYtr0G/TVr/Viwn6ITbXdGAT9M47DBAjaGt+ksYrTk6hZSdzI9KN0nUqQVQf+vFkvGQlLZoP+3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238141; c=relaxed/simple;
	bh=SvPjlHlMgmb8936HrtEfyGa3cyCDz+7AZlMEP8lqor8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2doTbgNqnC1zgTTE9kDN8FsTf2aKCNp2iXbk18EzMGviDFhN0HeORvqgIHkpuhz8sIZoetkgsTjVrazh2ifUN1WftizuxJ0xAcTPmOVSp0QVHYbixOWCcugjExw+RbSbVT+eojD7RQA+c6mNemTzL6h37QjlNBE39cyw5F8Rw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WizUSuUZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WizUSuUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFAC1F000E9;
	Thu, 20 Aug 2026 15:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238140;
	bh=oVE3I2MUCCA88m5jEL1gVTZ6vAeh8kswLz/Jr3ehAro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WizUSuUZMrhoRy4UHaah90Wb1qQ331wd4vOqp80EcZ4LZjKSPaeSnJXgytrkJRbTv
	 vPOyNPxzdRBAZJUBDcGXsN8q7yexg2EHAwPy7sE1AZUygjLojILXsF6dkj7sRth07k
	 xF5xEuhkEJB7E5V2JkUd6llf2/cZnln8vWL9bnqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.1 018/228] ASoC: SOF: ipc4-pcm: Continue the pipeline trigger in case of IPC timeout
Date: Thu, 20 Aug 2026 16:52:40 +0200
Message-ID: <20260820145245.017463865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


