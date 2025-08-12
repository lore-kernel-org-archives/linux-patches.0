Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460EB2FE573;
	Tue, 12 Aug 2025 18:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021759; cv=none; b=I+WFBndbRheI4dG2+7VqA4P8rs/5asoVXqYbWMCyhp/vGoblfFxLpXk9N/YKckp04EzQdyY+fXPHjaOVQWiE7aCtPu0Hg9h3UOP1opgjDyPtx7UoRulF2w+KS46PKnZ/9/y6z9rq5UnLeJRUfQrKQg5V0JJ8NTZSM7xNhLVn70Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021759; c=relaxed/simple;
	bh=LhuxdgVcs30GQwao86gYV4+hyAJYEa/JiQ2kICu1A2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K8hNHCF2/UYIJhQ0npUaNrW6KyNfK+xi+b/YKsn4NaKstME5PO4gKYfqXPTjgkY72n27XiFowAbXY2y6HTnvTV0n0SWExHFJH4UhO7fCK6JSYWqjyvZT6L3NpGPcU/bi/yXulkkDiJ7xlos9HDqv0Z4c3shuB0KCw8ZbM5nw2yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aEtx2SyP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aEtx2SyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DF8C4CEF0;
	Tue, 12 Aug 2025 18:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021758;
	bh=LhuxdgVcs30GQwao86gYV4+hyAJYEa/JiQ2kICu1A2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aEtx2SyPNKpFIFYwJo0T3dNXbV9r1UmxjJU9lXsSnlgXxX28xz3nzGwoDke2dE/5p
	 dAwl2s+OzLh37p28UZmZ/mn2TYomqCmNfbDcadGqLTBVnQflGxAaJU15Xq58BE9W+k
	 IIzjAiKCEw4Qo47eZbqbywHurIXhEbvpEmHo1W7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 216/262] ALSA: hda/ca0132: Fix missing error handling in ca0132_alt_select_out()
Date: Tue, 12 Aug 2025 19:30:04 +0200
Message-ID: <20250812173002.344822687@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 9f320dfb0ffc555aa2eac8331dee0c2c16f67633 ]

There are a couple of cases where the error is ignored or the error
code isn't propagated in ca0132_alt_select_out().  Fix those.

Fixes: def3f0a5c700 ("ALSA: hda/ca0132 - Add quirk output selection structures.")
Link: https://patch.msgid.link/20250806094423.8843-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_ca0132.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index 27e48fdbbf3a..94b452595f30 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -4803,7 +4803,8 @@ static int ca0132_alt_select_out(struct hda_codec *codec)
 	if (err < 0)
 		goto exit;
 
-	if (ca0132_alt_select_out_quirk_set(codec) < 0)
+	err = ca0132_alt_select_out_quirk_set(codec);
+	if (err < 0)
 		goto exit;
 
 	switch (spec->cur_out_type) {
@@ -4893,6 +4894,8 @@ static int ca0132_alt_select_out(struct hda_codec *codec)
 				spec->bass_redirection_val);
 	else
 		err = ca0132_alt_surround_set_bass_redirection(codec, 0);
+	if (err < 0)
+		goto exit;
 
 	/* Unmute DSP now that we're done with output selection. */
 	err = dspio_set_uint_param(codec, 0x96,
-- 
2.39.5



