Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037AF126F0A;
	Mon,  8 Apr 2024 13:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583827; cv=none; b=fGmplQ6LVq38rRqQ2eI2Sn7+VFpKbk/5XDCcx7cxv6llJkByXdZjzVWsY3Qk/ZQsvs9oegadSgL3GZvLPU4b+Tuo3hKeDqSW2oQkmND6GtbgyxS2n/K2L+wsxgzbjrnWfS/zOG5q+TrvDMy53ocg+/1rnfg495uudFFodPpIqPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583827; c=relaxed/simple;
	bh=HB7J9mEouAcbej7Aw6miYIUMt6kmLD7KePhd6ht19WI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBrf6LKdvA5eGU8/ZSquNMUPEFM4/YaNEAuLbPfMVEYjh3TR7V0MaBF8W+OKHu+YADc8OarRjoeqJSLpJK5TzAYZDLsBgBNq8csYZjdtIFfaa/e6n7TzkIn9VBWko0KmZEoCIoSr2cfLr0sfizOuQuOPwb+Ml+QzgdKB/xiiEBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bfVhOdJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bfVhOdJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838DFC433C7;
	Mon,  8 Apr 2024 13:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583826;
	bh=HB7J9mEouAcbej7Aw6miYIUMt6kmLD7KePhd6ht19WI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bfVhOdJ8fG7DSadIDdb7+17ngXoF3QeXw6quPyL7qdCQgxWflV8nRCJ6lTvhKOTVz
	 dFwvnOIEeBBNxKN9EzrJp/0Z1oocma3kPcDRsXMqTk+T0M9GgAgWzoHkNPe8vqy+XW
	 EOJzGHS6E+00DYGdJPKXLBsVKTm205gmp8gXIRSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.8 224/273] ASoC: SOF: ipc4-pcm: Invalidate the stream_start_offset in PAUSED state
Date: Mon,  8 Apr 2024 14:58:19 +0200
Message-ID: <20240408125316.365103618@linuxfoundation.org>
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

commit 3ce3bc36d91510389955b47e36ea4c4e94fcbdd3 upstream.

When the final state is SOF_IPC4_PIPE_PAUSED, it is possible that the
stream will be restarted (resume or start) in which case we need to update
the offset from the firmware.

Cc: stable@vger.kernel.org # 6.8
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://msgid.link/r/20240321130814.4412-14-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-pcm.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/sound/soc/sof/ipc4-pcm.c
+++ b/sound/soc/sof/ipc4-pcm.c
@@ -420,8 +420,19 @@ static int sof_ipc4_trigger_pipelines(st
 	}
 
 	/* return if this is the final state */
-	if (state == SOF_IPC4_PIPE_PAUSED)
+	if (state == SOF_IPC4_PIPE_PAUSED) {
+		struct sof_ipc4_timestamp_info *time_info;
+
+		/*
+		 * Invalidate the stream_start_offset to make sure that it is
+		 * going to be updated if the stream resumes
+		 */
+		time_info = spcm->stream[substream->stream].private;
+		if (time_info)
+			time_info->stream_start_offset = SOF_IPC4_INVALID_STREAM_POSITION;
+
 		goto free;
+	}
 skip_pause_transition:
 	/* else set the RUNNING/RESET state in the DSP */
 	ret = sof_ipc4_set_multi_pipeline_state(sdev, state, trigger_list);


