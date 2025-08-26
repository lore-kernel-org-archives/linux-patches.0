Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770F73568F8;
	Tue, 26 Aug 2025 14:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217535; cv=none; b=Kuxw5+wsXfu9lC/noXvuZsnGj0UB+BPlbVHVOzAH8ZJX39U6Y0tgqJu9px2JfYwZB+TNtTpkjfjxuiFhWbhx6zNktf40pON713wzG93MJFf1SlxqL4iZm24lb0GL89bzVIDmfnllsoTIM6JuVzN8W/jVaXLXA+rtOhPSpsIdyOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217535; c=relaxed/simple;
	bh=6E/t1A1AWVIy68ytB358+cEhMC5t65VlUDd8F3Lg8Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ni9xT3RFUSSmBJnhpZT795nudVKjm2xu8AsEA2WvUqkJ+p8uQJKNYgG8frYw2PZNCNVBgJB2rhO002jNz96er9vlgRDU5EIK9kY4F5qrYZy4EajZEvumdPJXqg53Jnz9OL6oEiWsr3NJi5owTzvS6eWC7ktFDpkepAgA/CIyrNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DrUZzaH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DrUZzaH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A603DC4CEF1;
	Tue, 26 Aug 2025 14:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217535;
	bh=6E/t1A1AWVIy68ytB358+cEhMC5t65VlUDd8F3Lg8Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DrUZzaH4PkEXrFZLnFs20KDTB7tNwpCvofiWP/HWrzkNq+wI2QUJjfDBTivRaKJeG
	 uVrwpQJa4xi/dX591vzbAt4LXaFqoXd6Axj5+kYxqf/HP2m83iVats9V5E2XFZU+tD
	 LV7brLOU3rR/UGSMcRJVv53afuJHmJ6bzHr7cOOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 180/523] ALSA: hda/ca0132: Fix missing error handling in ca0132_alt_select_out()
Date: Tue, 26 Aug 2025 13:06:30 +0200
Message-ID: <20250826110928.896252527@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6d67cca4cfa6..b9d88b156f40 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -4671,7 +4671,8 @@ static int ca0132_alt_select_out(struct hda_codec *codec)
 	if (err < 0)
 		goto exit;
 
-	if (ca0132_alt_select_out_quirk_set(codec) < 0)
+	err = ca0132_alt_select_out_quirk_set(codec);
+	if (err < 0)
 		goto exit;
 
 	switch (spec->cur_out_type) {
@@ -4761,6 +4762,8 @@ static int ca0132_alt_select_out(struct hda_codec *codec)
 				spec->bass_redirection_val);
 	else
 		err = ca0132_alt_surround_set_bass_redirection(codec, 0);
+	if (err < 0)
+		goto exit;
 
 	/* Unmute DSP now that we're done with output selection. */
 	err = dspio_set_uint_param(codec, 0x96,
-- 
2.39.5



