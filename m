Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC858221DBD;
	Mon,  2 Jun 2025 14:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872814; cv=none; b=nvZ/jAMSjlP67Vv2QrpNXKj24F2lJHQrzI1LgCDPfW+R5wD5sTHx+QWL5AVNg4IM+hLugma1QNZc84TutCqEOOCFBWD9HLGX1p1yF4/cGe9qi3ddU/Ahvt+0b9xPsDqb8P1qEcFnR1i/bSxAcfpm5CIrZMlP+VFrQhwlEBmsSRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872814; c=relaxed/simple;
	bh=a1xcGuKqOY99s1M8JFQoG4BrFGY8EGLI1aIrsEmuE9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3Z6pqgqzE18ngZ+kGJjZDNqQ0p0CYLA/FZBqJsozQcz/mpGPY5bSFvYWYz4BYKqCIe9kuOHWEdeAF0FUI7hS1eYGwBKCLDxKoqNYOsDJY6S0iFLGII7npe3S5F0NOTdqSMo6JbMYsSeaffT4K4Udh0aZ5TXUG9EQ8WYlj0wuic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eih8+3Go; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eih8+3Go"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCDAC4CEEE;
	Mon,  2 Jun 2025 14:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872814;
	bh=a1xcGuKqOY99s1M8JFQoG4BrFGY8EGLI1aIrsEmuE9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eih8+3God7NO6esNaAzGbaL+GdfGKU3MqGHGbD4u1xnzxXaqdALrZWmzfjtpwMBr7
	 0Ab4qAju9ULjwpH7bfIlqFAbrejGPzBvzJ6g23hGoZ6sP5qQAYvEsOiTRX2xkTXVF5
	 1nfmr4PC9rD6R1PGiH6gUbxFmmD6kr0KkW1yYdyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 70/73] ALSA: hda/realtek - restore auto-mute mode for Dell Chrome platform
Date: Mon,  2 Jun 2025 15:47:56 +0200
Message-ID: <20250602134244.445934333@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit 5ad8a4ddc45048bc2fe23b75357b6bf185db004f ]

This board need to shutdown Class-D amp to avoid EMI issue.
Restore the Auto-Mute mode item will off pin control when Auto-mute mode was enable.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Links: https://lore.kernel.org/ee8bbe5236464c369719d96269ba8ef8@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 9e5c36ad8f52d..3f09ceac08ada 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6811,7 +6811,10 @@ static void alc256_fixup_chromebook(struct hda_codec *codec,
 
 	switch (action) {
 	case HDA_FIXUP_ACT_PRE_PROBE:
-		spec->gen.suppress_auto_mute = 1;
+		if (codec->core.subsystem_id == 0x10280d76)
+			spec->gen.suppress_auto_mute = 0;
+		else
+			spec->gen.suppress_auto_mute = 1;
 		spec->gen.suppress_auto_mic = 1;
 		spec->en_3kpull_low = false;
 		break;
-- 
2.39.5



