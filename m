Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5210192D97;
	Tue, 10 Sep 2024 10:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964786; cv=none; b=FJoZh28wp1Te7uZzlf79MEf6Hu992ZcXekHhBQeTkUDhqPjjDZbtqWWY0rry1kGMHgBDAflG+TP1CXY/UQlHwjR5pXLq1890K1Fq3z59Pm88JnIiQOgbZciDV07PIf7pxVToBeoi3BBCmdf7W3gW8pnXoO0dlxd7RxE5fNntSuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964786; c=relaxed/simple;
	bh=uE4LLWK1y678qch9MHDqgGsly2PxGDxkHT54g6JmzUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvE2T1VSYxKgV8g0AcdNz/tOi+5i3bUNGtIj5ZuhasYWtrO4PnWDm2HyBQiOZBDCXg0/V2AzPrFYGK8zqA3DTQklT7y4SG1/IyW8QtGDfUkhMrECE8PWMtXvbznxur7JEEuj9NIRURoqIwllCQN/+mDZJ1GnVh4NUfHo+BZ/JoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yja1AAZM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yja1AAZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6795DC4CEC3;
	Tue, 10 Sep 2024 10:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964785;
	bh=uE4LLWK1y678qch9MHDqgGsly2PxGDxkHT54g6JmzUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yja1AAZMiQxITU5GYHi/Kj2keFBFB9nFcCf0sis1wU+++FtEzhVQ1tH6ykY+hFU5G
	 pYZyLT0p0fPdzfDW3iPpQ5hR+bXNsCsY5QNvEXEu5qmAb7R7UiF0YLTuRK38lrPPkE
	 jr/eAzgRmsVDamSokZ+E9dAht2mHA/sG9MVIdLKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/186] ALSA: hda/conexant: Mute speakers at suspend / shutdown
Date: Tue, 10 Sep 2024 11:31:38 +0200
Message-ID: <20240910092554.781159822@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 4f61c8fe35202702426cfc0003e15116a01ba885 ]

Use the new helper to mute speakers at suspend / shutdown for avoiding
click noises.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1228269
Link: https://patch.msgid.link/20240726142625.2460-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_conexant.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 5b37f5f14bc91..2d10c6e744ab2 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -181,6 +181,8 @@ static void cx_auto_reboot_notify(struct hda_codec *codec)
 {
 	struct conexant_spec *spec = codec->spec;
 
+	snd_hda_gen_shutup_speakers(codec);
+
 	/* Turn the problematic codec into D3 to avoid spurious noises
 	   from the internal speaker during (and after) reboot */
 	cx_auto_turn_eapd(codec, spec->num_eapds, spec->eapds, false);
-- 
2.43.0



