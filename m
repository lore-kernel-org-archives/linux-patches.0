Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8841C3BEB;
	Mon, 18 Aug 2025 13:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522009; cv=none; b=Bu9Fbwc8M5P9LFIJcbatReXvV1nwuRYzA6pT3/uRkLlruzI2i7syzsBjCbc7VWKAszqb76qf0Sf90oLUSEWRjOcch77wwcbYOLlMveJ5Zeblo+mcknXdFxRRYtEbKIMOhKsl40etUxqGPwKqUq8RT3HKXIGip0Cqzwph6oygoWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522009; c=relaxed/simple;
	bh=th5Scw5NFJWxmy1EL9YNzqgi4tm0vGcUhJEAZ4L/UxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWgJ4c5+b0KXldz6dLitaQUCUVIqsRxtECxIJH5gTYaXzEFhIJCBZ8vOut8aw3S1ljWafUVebF4w2Rlf3QJ9MF/SqHk0dDibpzSEs+kwXTtPfYD3PRuiMYv2BFolCdyaYaHAlcj87meyRIDdrvc7MJJRf+skndSgf2CMfKFd6KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L0oIsuk+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L0oIsuk+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC27C4CEF1;
	Mon, 18 Aug 2025 13:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522009;
	bh=th5Scw5NFJWxmy1EL9YNzqgi4tm0vGcUhJEAZ4L/UxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L0oIsuk+iTqSO2TeoErSSn0JGqF7ciUB+c94QL5+dnj6vTuD5o9h5lPO9yii8s+Uf
	 Gx7SAyTB4IGNnRvwI95O+CZWnluziOJimr7xf8WcINu9+58ooGsszrJ0yQZAAhw4I+
	 WjwqS732dBHWTLVe5C8XKALFDuLUYCCdKi226SmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Lucy Thrun <lucy.thrun@digital-rabbithole.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 155/444] ALSA: hda/ca0132: Fix buffer overflow in add_tuning_control
Date: Mon, 18 Aug 2025 14:43:01 +0200
Message-ID: <20250818124454.713238322@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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
index 77432e06f3e3..a2f57d7424bb 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -4410,7 +4410,7 @@ static int add_tuning_control(struct hda_codec *codec,
 	}
 	knew.private_value =
 		HDA_COMPOSE_AMP_VAL(nid, 1, 0, type);
-	sprintf(namestr, "%s %s Volume", name, dirstr[dir]);
+	snprintf(namestr, sizeof(namestr), "%s %s Volume", name, dirstr[dir]);
 	return snd_hda_ctl_add(codec, nid, snd_ctl_new1(&knew, codec));
 }
 
-- 
2.39.5



