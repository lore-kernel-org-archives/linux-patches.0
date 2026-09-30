Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614062D9484;
	Wed, 30 Sep 2026 18:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792045; cv=none; b=cVSs/16oUK5iI3rNf5lMarMb722olI8lASt1pd4FhqDWJPHZ5uuXm3Zo83VvcU9NjxxE4YQTMyXSd8WSRPSo47YzVUL7NHJ7g1wCzXqmO2RdNzbt2fTynou5QywwZGjXAkdKxxa1jfOECOqqzXC9PCVziIYTPEkP/sDEPGWD3sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792045; c=relaxed/simple;
	bh=AC60K/O7u67GrBeYxFV21fR9I+vAGjMSE6DRTnvod7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=agT2aSzxh1aq87kqYqYqL0DNtQBQ1R2+6/djjctd4cEBx8cgAdNOMVcwnsbLZOroZj0rlkAa/4eAKb9OZW6I9YVR6HYeBUtIX5oXCw/oMSYXSwaiqF6PSGeBP/bXLlRz1V1UAqZhJEISEDNF/I4UipSMhgODmIoINqpDdjou/wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jJ5dG3aw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJ5dG3aw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F861F000FF;
	Wed, 30 Sep 2026 18:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792044;
	bh=D+AnqENgTDhTxk7bPoG/kjzR93/q7iDpTHDDOtr3CsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jJ5dG3awwW35/b9NzWleI5xjiAqhRVzRvd//Eb/9c/ta/eyZofXQcQE3aqkgJlPS4
	 aLDD1VHOTiizY7DNr6dnj7k6fpLBxFL8pLQrcZyQyP616YZQ8Bnpfh6K6ahe5e68H/
	 4eqvT+iJeZJksqhEK9FOrw0M8x9I9cpk5z2xHqfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 509/752] ASoC: hdmi-codec: Report a change when the channel status moves
Date: Wed, 30 Sep 2026 17:26:19 +0200
Message-ID: <20260930152409.271942797@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit c17ae8c26eac16ad244daef44044d714f68a2ddc ]

The put() callback of "IEC958 Playback Default" stores all 24 channel
status bytes and then returns 0. The core notifies userspace only on a
positive return, so a write that changes what the get() callback hands
back is never announced, and a mixer holding the control open keeps
showing the old value.

Compare the stored bytes and return 1 when they move, the way
snd_hda_spdif_default_put() does.

The same shape is in img-spdif-out and uniperif_player.

No board with this codec was to hand. The change is a comparison of
driver state with no hardware behaviour in it, and mixer-test counts the
missing notification as event_missing.

Fixes: 7a8e1d44211e ("ASoC: hdmi-codec: Add iec958 controls")
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Assisted-by: Claude:claude-opus-5
Link: https://patch.msgid.link/20260915092515.2638542-1-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdmi-codec.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/hdmi-codec.c b/sound/soc/codecs/hdmi-codec.c
index 5e326ae3b57ea..84b25dd9af31f 100644
--- a/sound/soc/codecs/hdmi-codec.c
+++ b/sound/soc/codecs/hdmi-codec.c
@@ -426,10 +426,14 @@ static int hdmi_codec_iec958_default_put(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
 	struct hdmi_codec_priv *hcp = snd_soc_component_get_drvdata(component);
 
+	if (!memcmp(hcp->iec_status, ucontrol->value.iec958.status,
+		    sizeof(hcp->iec_status)))
+		return 0;
+
 	memcpy(hcp->iec_status, ucontrol->value.iec958.status,
 	       sizeof(hcp->iec_status));
 
-	return 0;
+	return 1;
 }
 
 static int hdmi_codec_iec958_mask_get(struct snd_kcontrol *kcontrol,
-- 
2.53.0



