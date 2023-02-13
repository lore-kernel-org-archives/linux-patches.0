Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DED8F58
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 15:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01EDC433EF;
	Mon, 13 Feb 2023 15:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300436;
	bh=XIt0aMtj3q9xE1kISANr9W9bvVLa6OEbxd7bAs9JPko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QCEbX94IyvrPOG+8zmShxBsynVdhTOCYpBjW6h7GiMKlXtP5dh4HpeCvma6kmv/3J
	 HwKYs8F8rnyxHCiPRhOosU+CaYytuwpQrPxUBDKWjWQXZ2XMfopkjRFUzO4OiNZTBU
	 j3SIYPT/7dM692ll/5eAnUypLKr6VvfZT7iTEWAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artemii Karasev <karasev@ispras.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 006/139] ALSA: hda/via: Avoid potential array out-of-bound in add_secret_dac_path()
Date: Mon, 13 Feb 2023 15:49:11 +0100
Message-Id: <20230213144746.019462044@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
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
index a188901a83bb..29abc96dc146 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -821,6 +821,9 @@ static int add_secret_dac_path(struct hda_codec *codec)
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



