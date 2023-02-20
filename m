Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4407463B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C173CC433EF;
	Mon, 20 Feb 2023 13:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900422;
	bh=bMRyndYKK3kbzL9uFcZwC4pFFP3y7oIvGeXIb7/NQZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K8GFs8o07mtoUSgadvO1suVdkWneRtME4hchX6iFmsvVDOcOhny6VlYd2P6TRJQGF
	 8wcyVBGzU57imXSJ1ALN8ugoBI0j2S9bYENeJiQERrOGlGS0otE5qM+s40Ao3nDkfi
	 8CkFlhLbkpQxk/IrlMoZgATxYFpC5gNWOx9uj4Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artemii Karasev <karasev@ispras.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 03/89] ALSA: hda/via: Avoid potential array out-of-bound in add_secret_dac_path()
Date: Mon, 20 Feb 2023 14:35:02 +0100
Message-Id: <20230220133553.207940532@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Artemii Karasev <karasev@ispras.ru>

[ Upstream commit b9cee506da2b7920b5ea02ccd8e78a907d0ee7aa ]

snd_hda_get_connections() can return a negative error code.
It may lead to accessing 'conn' array at a negative index.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Artemii Karasev <karasev@ispras.ru>
Fixes: 30b4503378c9 ("ALSA: hda - Expose secret DAC-AA connection of some VIA codecs")
Link: https://lore.kernel.org/r/20230119082259.3634-1-karasev@ispras.ru
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_via.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index 937155b1fae0..9e2252eee626 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -834,6 +834,9 @@ static int add_secret_dac_path(struct hda_codec *codec)
 		return 0;
 	nums = snd_hda_get_connections(codec, spec->gen.mixer_nid, conn,
 				       ARRAY_SIZE(conn) - 1);
+	if (nums < 0)
+		return nums;
+
 	for (i = 0; i < nums; i++) {
 		if (get_wcaps_type(get_wcaps(codec, conn[i])) == AC_WID_AUD_OUT)
 			return 0;
-- 
2.39.0



