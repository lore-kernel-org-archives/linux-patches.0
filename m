Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC3D33EC;
	Tue, 26 Aug 2025 12:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212867; cv=none; b=elGscO+53E5uhPpcP9XdP8FVS53JnOUkZrnLPBh8NIGNGifeJtqNWxqfVg+qsJA0ZqcmQ5Zju0hBcBv476qGvHD0PNnHWZ483e9lW+Iwnztgog57BBYJMhHdcRW6wzw9/fZWjxNnE0lqkqXeuVRyVC3t8WHc+9WAnBxD7JL92ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212867; c=relaxed/simple;
	bh=rcWfz6dXDOebpI2HPDI1dS5gWLMsEtG1N1R9lOa5HRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3HIHUZwJDHkfA1bWlYcRej+cvmm28AmUR6OvmqSjoI0bPXhIypNkTQwlAOXbIe5rponqJm3acxQO9qSMfjDA2q7XsH3EM5ymfGuYMq0Uzst3aJ/LxF6JkybuIve8XeO06ZUTNMYpnwjDptXe6DlWNioHL79AT5GFpAndNg+B5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oNQ8MJDz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNQ8MJDz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E95BC4CEF1;
	Tue, 26 Aug 2025 12:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212867;
	bh=rcWfz6dXDOebpI2HPDI1dS5gWLMsEtG1N1R9lOa5HRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oNQ8MJDzpR1gF3hYdgpRq8Utbjaf864zeE22PoYRsKSFxm9iF7jgJTXSpTYQY2Qco
	 +VgbgSjGFfC4EDp4XqyoHVO5LxDQIWY2SK+VjNamIzUZ90iRZ2tbpAm1I1KJbySuBn
	 dfYIyjtrpVRIgtzxbNbU3e3WLZcP04YSbVEXUmwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Lucy Thrun <lucy.thrun@digital-rabbithole.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 133/587] ALSA: hda/ca0132: Fix buffer overflow in add_tuning_control
Date: Tue, 26 Aug 2025 13:04:42 +0200
Message-ID: <20250826110956.338577647@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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
index 94b452595f30..851e9231bbbd 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -4411,7 +4411,7 @@ static int add_tuning_control(struct hda_codec *codec,
 	}
 	knew.private_value =
 		HDA_COMPOSE_AMP_VAL(nid, 1, 0, type);
-	sprintf(namestr, "%s %s Volume", name, dirstr[dir]);
+	snprintf(namestr, sizeof(namestr), "%s %s Volume", name, dirstr[dir]);
 	return snd_hda_ctl_add(codec, nid, snd_ctl_new1(&knew, codec));
 }
 
-- 
2.39.5



