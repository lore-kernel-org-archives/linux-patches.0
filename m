Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D02861FFE;
	Tue, 12 Aug 2025 18:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022966; cv=none; b=cFeuiccCRdz0us2h1PyVxgUzcOEdE4ivGe5DnMBpNtcazP4Z+6H6s3786Jooee+IKftlTxFnsYgFEcCkAIxOJJoBXwVtXPLNcsYcEf596UpoDMD81YcpSGFkSOWjSh6D+wu7ddPUIrBMkU2tgvU6C0iGpnzHNarQ2KkpD5ap4k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022966; c=relaxed/simple;
	bh=sWxBc2KhL19DrSKhoenZRd4WWCaZgnU0LTLi6Sq15sE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zc5LdniZzvpFyGWlDowKF02qlNqcrVh7TAHKvw4J9glAOpUfTcL/TiXzjXsE+p8HUfW/BP+KuQeJQD7CrgAROvTq5qAMY1YPuQYYUyN/0qAHa+GyClUTNSewsm5DtU2es9H8fRXjGqlDWk8noCXL27pfJSe1Xm+qjcsmPJulXB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pH5QE4AT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pH5QE4AT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1D5C4CEF6;
	Tue, 12 Aug 2025 18:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022966;
	bh=sWxBc2KhL19DrSKhoenZRd4WWCaZgnU0LTLi6Sq15sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pH5QE4ATbM6TUK7rN/mzRGy7uFNpHv6zv3KMF9HVTN69b+4GwV8zm6JNiyu/QdIFC
	 JD+GbPwEK+UFKCJwXaAxMhnECu00NdQNECYikNDN8gc6tWdN3LkTdiTd7aKi0htmgJ
	 5207K8mUkw7WrxZHglUZfw9B13xjfJAOCTAlVJYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 310/369] ALSA: hda/ca0132: Fix missing error handling in ca0132_alt_select_out()
Date: Tue, 12 Aug 2025 19:30:07 +0200
Message-ID: <20250812173028.389614727@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d40197fb5fbd..77432e06f3e3 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -4802,7 +4802,8 @@ static int ca0132_alt_select_out(struct hda_codec *codec)
 	if (err < 0)
 		goto exit;
 
-	if (ca0132_alt_select_out_quirk_set(codec) < 0)
+	err = ca0132_alt_select_out_quirk_set(codec);
+	if (err < 0)
 		goto exit;
 
 	switch (spec->cur_out_type) {
@@ -4892,6 +4893,8 @@ static int ca0132_alt_select_out(struct hda_codec *codec)
 				spec->bass_redirection_val);
 	else
 		err = ca0132_alt_surround_set_bass_redirection(codec, 0);
+	if (err < 0)
+		goto exit;
 
 	/* Unmute DSP now that we're done with output selection. */
 	err = dspio_set_uint_param(codec, 0x96,
-- 
2.39.5



