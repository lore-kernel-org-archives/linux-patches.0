Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D860F2512D7;
	Wed,  5 Mar 2025 17:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197209; cv=none; b=HSakdRG4nJe/DBGAB+9dFYdcmDZIIoA2mWzvwyKqnq+YjWje5R3/a5gSWalm+cemcpUZmIof7cicUl3eU+vlHswHUGVQrCObr5ddy5pcQI0Im0uEsGYHgqtUOM7ko+XMaGIfYn08Qh8qgvxXPPG3W15RlBL+Aw/XZFG0g+I1ABU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197209; c=relaxed/simple;
	bh=p50723vu2a1dQV2jOiqOHBeape2u1NNVp2phr5Mbgvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+CpfPQa/eHjQVxhDpwdiiihExsM2zRuoOONzpNE9WFqgo/PkMwJhNZdEpZhhJjzX05FTCSYm8ECTs4+VrnolBOiuwJVI6O2YZ+UHgXeT9YPiv5wJvV9sIXxksmokY8XNDDPGkvAe/oi/79R+4X/XTdYkiavtYEqg6Rt4pX6ZfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yj/TfVXe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yj/TfVXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E89C4CEE0;
	Wed,  5 Mar 2025 17:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197209;
	bh=p50723vu2a1dQV2jOiqOHBeape2u1NNVp2phr5Mbgvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yj/TfVXe2L5c5Yfyll8HX/W/PScXM4RZPjvr44XBgVWntk1pCfGrt++K32FeUwpyw
	 HMCFVKscljGjm2SfFfW8zhp2zbXxDn5bUII4wEvn1dQbpvLq/CnXMXdvwNsG+HlIEw
	 P+BBK9+3LaSpCxxm8/6D3vcTlzsXpg980w0F1Guc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 078/176] ALSA: hda: Add error check for snd_ctl_rename_id() in snd_hda_create_dig_out_ctls()
Date: Wed,  5 Mar 2025 18:47:27 +0100
Message-ID: <20250305174508.595019847@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 822b7ec657e99b44b874e052d8540d8b54fe8569 upstream.

Check the return value of snd_ctl_rename_id() in
snd_hda_create_dig_out_ctls(). Ensure that failures
are properly handled.

[ Note: the error cannot happen practically because the only error
  condition in snd_ctl_rename_id() is the missing ID, but this is a
  rename, hence it must be present.  But for the code consistency,
  it's safer to have always the proper return check -- tiwai ]

Fixes: 5c219a340850 ("ALSA: hda: Fix kctl->id initialization")
Cc: stable@vger.kernel.org # 6.4+
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20250213074543.1620-1-vulab@iscas.ac.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_codec.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2465,7 +2465,9 @@ int snd_hda_create_dig_out_ctls(struct h
 				break;
 			id = kctl->id;
 			id.index = spdif_index;
-			snd_ctl_rename_id(codec->card, &kctl->id, &id);
+			err = snd_ctl_rename_id(codec->card, &kctl->id, &id);
+			if (err < 0)
+				return err;
 		}
 		bus->primary_dig_out_type = HDA_PCM_TYPE_HDMI;
 	}


