Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D09DFC0D
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2DBC4339B;
	Mon, 15 May 2023 17:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171856;
	bh=/C1nt0VkewCeECE6zGbk4JRXWaDZikvWt0oIWbdPne8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GQ5A2To2G6W271kPwmYaQnZqxl+BYCyASXm8d/HIGKTyJ9n5IIFpFOsnWCdJEb/H2
	 jbGgbNKHSMggDvGn+1bbktkyBjhNdbU68m4T3dI+T7RBI96ap5/8XokNYwf2BS5psM
	 nnudHqDaehpXnkGh2HMwp6l2cHaGZR+6PKEK7aLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Natalsson <harmoniesworlds@gmail.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 100/134] ASoC: DPCM: Dont pick up BE without substream
Date: Mon, 15 May 2023 18:29:37 +0200
Message-Id: <20230515161706.464951360@linuxfoundation.org>
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

commit 754590651ccbbcc74a7c20907be4bb15d642bde3 upstream.

When DPCM tries to add valid BE connections at dpcm_add_paths(), it
doesn't check whether the picked BE actually supports for the given
stream direction.  Due to that, when an asymmetric BE stream is
present, it picks up wrongly and this may result in a NULL dereference
at a later point where the code assumes the existence of a
corresponding BE substream.

This patch adds the check for the presence of the substream for the
target BE for avoiding the problem above.

Note that we have already some fix for non-existing BE substream at
commit 6246f283d5e0 ("ASoC: dpcm: skip missing substream while
applying symmetry").  But the code path we've hit recently is rather
happening before the previous fix.  So this patch tries to fix at
picking up a BE instead of parsing BE lists.

Fixes: bbf7d3b1c4f4 ("ASoC: soc-pcm: align BE 'atomicity' with that of the FE")
Reported-by: Alex Natalsson <harmoniesworlds@gmail.com>
Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/CADs9LoPZH_D+eJ9qjTxSLE5jGyhKsjMN7g2NighZ16biVxsyKw@mail.gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20220801170510.26582-1-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/soc-pcm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1339,6 +1339,9 @@ static struct snd_soc_pcm_runtime *dpcm_
 		if (!be->dai_link->no_pcm)
 			continue;
 
+		if (!snd_soc_dpcm_get_substream(be, stream))
+			continue;
+
 		for_each_rtd_dais(be, i, dai) {
 			w = snd_soc_dai_get_widget(dai, stream);
 


