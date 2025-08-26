Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC4F350D50;
	Tue, 26 Aug 2025 14:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218971; cv=none; b=DFg57Jt8yOc07EvIal0O+QoolonPxk4lZQY5jO53JOMXf+KgS4MO8jPzTPyWImxZ1P1WkPbTLGj8w0xQF1IGA7GSrFaWRtDRt4eLNz2u0sDUTsP7Yjk3E3vK24aiMCjtm11PljvoyaSsK5iFJhIYnnBFeTco9tzJWqV6GmNh98I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218971; c=relaxed/simple;
	bh=LdeMQYV+/hmHW6UlrKEHYN6tJXxZHNrCqr/aoF40NmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbiRbL7RRYkxZXN9ndz6VB2FlR3k/Wg2c27P1Ls0nVNXYrwnfPWPdOUhK53kQz6k4y4vYAhJ/oBduEo6+B4QcEb4UU0Pq8/Hyg8bTykSF+WsY+Ph3jFmzFnkOoefPxuKISHU6623S+LU78FlvfodltRsCTK3jHQnaur+WQbYByk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FC8GJncm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FC8GJncm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F04AC4CEF1;
	Tue, 26 Aug 2025 14:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218969;
	bh=LdeMQYV+/hmHW6UlrKEHYN6tJXxZHNrCqr/aoF40NmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FC8GJncmVCqIU4ZZHCXcZVLSYesHD9oy+Hd6xWlQpkbCJusVyZJf1ttEVaam3a5eg
	 xQ86ShbyUEktUr+FD8a4rZtfqt6X+DGnu0jy6kXKlcT7ygj9eTkFvea/dfVaLLcp24
	 zlF8nW89gLe4QkRcbJHDOmZSfvLD8RJ3Z3CDLYRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Lucy Thrun <lucy.thrun@digital-rabbithole.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 203/403] ALSA: hda/ca0132: Fix buffer overflow in add_tuning_control
Date: Tue, 26 Aug 2025 13:08:49 +0200
Message-ID: <20250826110912.462723310@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 40f50571ad63..dee38dd872b5 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -4014,7 +4014,7 @@ static int add_tuning_control(struct hda_codec *codec,
 	}
 	knew.private_value =
 		HDA_COMPOSE_AMP_VAL(nid, 1, 0, type);
-	sprintf(namestr, "%s %s Volume", name, dirstr[dir]);
+	snprintf(namestr, sizeof(namestr), "%s %s Volume", name, dirstr[dir]);
 	return snd_hda_ctl_add(codec, nid, snd_ctl_new1(&knew, codec));
 }
 
-- 
2.39.5



