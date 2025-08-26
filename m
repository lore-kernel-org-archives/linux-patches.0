Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B17428314A;
	Tue, 26 Aug 2025 13:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214358; cv=none; b=dqR6Y8r3KeQlmSzvQiAE204oA9tqNBsyeU2E3jbLP+MGENac+lbAEiCe7DHjQLKSd08EEwTI91yHYBXhuCixlh0vf3EKMTYQr9DIjMHbBY40qVU7qhJbLiexrgStDS40I+dQ/2a9bCgV5ucjFCN9tBFfpjrC6xRDJRGGoACFrYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214358; c=relaxed/simple;
	bh=BkwxaZUxO3Xf7K1Y/5Bd+XkHQSyROV7XdHKbsmTP+vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+3plYaOXK6dwD1oEwTLjzgdxjrBo9o4hHhnNaXl43DWzu/2KiLPR0moq4RVSrIANnHvH2v0eh7uX9t2ZInUbezwmsQgrthmwEb4nWVKIl52rLkFoB69cpxwNXdx+XhkGX5stkL8nOJA9RXUaLUkuUS2OyPAmvK1x7vnhqkSc24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mk2VFozl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mk2VFozl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE9AC4CEF1;
	Tue, 26 Aug 2025 13:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214358;
	bh=BkwxaZUxO3Xf7K1Y/5Bd+XkHQSyROV7XdHKbsmTP+vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mk2VFozlUXKuP7hYn9FWExmIvn9YunBcnxYp+OTGGs7BG1U5VeMxYvTak1g4Y3ko0
	 U1NkPG57WoK1NMNIrgXoVhB5ig7NraFzGMvkNKOW8r9cYVMPsN+Z8LLdZGIw0fXbCA
	 Q/smyXi6vOAE4cJItvcSiKLRSN8viDwFzbvgEj6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Lucy Thrun <lucy.thrun@digital-rabbithole.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/482] ALSA: hda/ca0132: Fix buffer overflow in add_tuning_control
Date: Tue, 26 Aug 2025 13:06:01 +0200
Message-ID: <20250826110933.494924981@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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
index d825fcce05ee..45b267c02a98 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -4399,7 +4399,7 @@ static int add_tuning_control(struct hda_codec *codec,
 	}
 	knew.private_value =
 		HDA_COMPOSE_AMP_VAL(nid, 1, 0, type);
-	sprintf(namestr, "%s %s Volume", name, dirstr[dir]);
+	snprintf(namestr, sizeof(namestr), "%s %s Volume", name, dirstr[dir]);
 	return snd_hda_ctl_add(codec, nid, snd_ctl_new1(&knew, codec));
 }
 
-- 
2.39.5



