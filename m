Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E0934F46F;
	Tue, 26 Aug 2025 14:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217730; cv=none; b=qtu02TDEDF8n9SkwXw9S30LFFhOlZ9ESvHnssFWtwiTaN9T7suIZ5EC2WIepo5JC7yAXonZohdw03hjqPi46OP6zGL3vZPOmrq1g40CHSbq7tMYs4XvgvLH2bTIGSe9fM/UX5+9OsU2Ie36PL3n8TnLiEGu2GpO8NJ6qHLtMJpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217730; c=relaxed/simple;
	bh=JwIot8FCkJOi9Ng6uQRqlL8ghr69V5wPiiLvZ8GUDtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+HrgAQSAoKIYVP64nf7Mc7mgV+y16UABkaWC47IlNOgqTNYRRaqAC0aU0tpZAb7nfcyeFX8iUTf8HZsiMyLsaqnZj9ROhEs8ClKdDmRIuNpVikrUs8bOLXLSrNhpSwSjVcyDUcGJcd7QVrsaBBGf1fjWbfiFmzrBr35RdAicEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VoY9T59d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VoY9T59d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE0EC4CEF1;
	Tue, 26 Aug 2025 14:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217730;
	bh=JwIot8FCkJOi9Ng6uQRqlL8ghr69V5wPiiLvZ8GUDtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VoY9T59dvuUYDNoxPqxTEzlieTFOXNDdMExeiQPljbdHBIvD+WC5Wu+wTPBoyLlGz
	 +0ORqcTkqu/gkWxp4NiOqaF6gTPtBbXWmUCzrL3QzaWkAzbdiwRTuES8r7F8nweR/J
	 y1eMc3p8WYLTZuc04s1hSAPACwJwLcrJ9RV8j+/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Lucy Thrun <lucy.thrun@digital-rabbithole.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 253/523] ALSA: hda/ca0132: Fix buffer overflow in add_tuning_control
Date: Tue, 26 Aug 2025 13:07:43 +0200
Message-ID: <20250826110930.670130781@linuxfoundation.org>
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

From: Lucy Thrun <lucy.thrun@digital-rabbithole.de>

[ Upstream commit a409c60111e6bb98fcabab2aeaa069daa9434ca0 ]

The 'sprintf' call in 'add_tuning_control' may exceed the 44-byte
buffer if either string argument is too long. This triggers a compiler
warning.
Replaced 'sprintf' with 'snprintf' to limit string lengths to prevent
overflow.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506100642.95jpuMY1-lkp@intel.com/
Signed-off-by: Lucy Thrun <lucy.thrun@digital-rabbithole.de>
Link: https://patch.msgid.link/20250610175012.918-3-lucy.thrun@digital-rabbithole.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_ca0132.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index b9d88b156f40..3acb4066b5ea 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -4279,7 +4279,7 @@ static int add_tuning_control(struct hda_codec *codec,
 	}
 	knew.private_value =
 		HDA_COMPOSE_AMP_VAL(nid, 1, 0, type);
-	sprintf(namestr, "%s %s Volume", name, dirstr[dir]);
+	snprintf(namestr, sizeof(namestr), "%s %s Volume", name, dirstr[dir]);
 	return snd_hda_ctl_add(codec, nid, snd_ctl_new1(&knew, codec));
 }
 
-- 
2.39.5



