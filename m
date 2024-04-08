Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5C37D3E4;
	Mon,  8 Apr 2024 13:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583719; cv=none; b=e3k0myqkRJvPrdADj4/WafwbXkmdWFyFgNj82f59rBlQwVrxPRyJYI2pflDdB0vz8UuEC+qHX0ABR8k34Ld7j11cRj1VODG1WTyhLyrz0yB2N6JOWbPyHsAip4Ehct53kITrouqcIEbJtKUY2VIRcYld3+JXBl5eTE0hYXG2crs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583719; c=relaxed/simple;
	bh=P0UaRJ3NSIbMQ66a7rEDG/gOWlEN47nHVo3T02arpTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tltoYX0rDsRSTmwypqNvMpeA7uyxiRL0Kh3S8Y0nKngv2G/CQFfxdOx4LsOSksSWlqGW5JsLszPLaQ1JCxlJLzadhrGwoIxtqQmzBQyjeG66iwlQp08GgWZOz1DeOjsvp8xMZADrwWzzT0Xzrh/4TieHmMPM/LIoKcNdD0xkLlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E3I1rNc2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E3I1rNc2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F5AC433C7;
	Mon,  8 Apr 2024 13:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583719;
	bh=P0UaRJ3NSIbMQ66a7rEDG/gOWlEN47nHVo3T02arpTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E3I1rNc2mcQKx8U7PgclBl4aV/jfuGM7Xn0tdqN9lSyJfYv7CQ+cWo/JBDbK9QLp3
	 gZCY5+ni+qUmG8BB4Gw0pvGsL/wU/1/eRfLEfIva48StyreurgkcGEPwOPdrbQ/1Jd
	 xIkW8ce78UrxFf15f9hBFocWHZMhP9H2FtsnqXjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.8 212/273] ASoC: SOF: Add dsp_max_burst_size_in_ms member to snd_sof_pcm_stream
Date: Mon,  8 Apr 2024 14:58:07 +0200
Message-ID: <20240408125315.942269651@linuxfoundation.org>
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

commit fb9f8125ed9d9b8e11f309a7dbfbe7b40de48fba upstream.

The dsp_max_burst_size_in_ms can be used to save the length of the maximum
burst size in ms the host DMA will use.

Platform code can place constraint using this to avoid user space
requesting too small ALSA buffer which will result xruns.

Cc: stable@vger.kernel.org # 6.8
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://msgid.link/r/20240321130814.4412-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/sof-audio.h |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/sof/sof-audio.h
+++ b/sound/soc/sof/sof-audio.h
@@ -321,6 +321,7 @@ struct snd_sof_pcm_stream {
 	struct work_struct period_elapsed_work;
 	struct snd_soc_dapm_widget_list *list; /* list of connected DAPM widgets */
 	bool d0i3_compatible; /* DSP can be in D0I3 when this pcm is opened */
+	unsigned int dsp_max_burst_size_in_ms; /* The maximum size of the host DMA burst in ms */
 	/*
 	 * flag to indicate that the DSP pipelines should be kept
 	 * active or not while suspending the stream


