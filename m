Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0252F28;
	Mon, 10 Mar 2025 18:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630577; cv=none; b=XbgcQROjDGvqfAg7qAZDq+RpqM48zGQyDDBlOId/IbV4gDVqO3dwCHpYVp1K2icFuuOk743DjHY5kPhgN7IdwKDsuyGUZf+ZwklVD6KvP3a5VxGK6Q8bkl3trdxghQnHABSWu30V2AlGztBX5UiYz+cMGcRRhrH7X5U34zFQDZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630577; c=relaxed/simple;
	bh=b/2gsvK/Idw5oRq9lUtgmFg+PHmMP2LoqHTg2mNQaCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjrWu8/Us8hfccNhkn/65pyMefSetJf2b8F10RLEv1k9CDexKxBuViSx2WtJJZveuM/y7MPwige4DCWs3XMJ43aB8IHzofIdTGaLWyV+nDXIFMrp52Q8ghzPCC9HO3XB9hvXCc99quangT0TkQZqiTHtzStfl/N9lYAsO79xStU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=arNSdmi3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="arNSdmi3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD669C4CEE5;
	Mon, 10 Mar 2025 18:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630577;
	bh=b/2gsvK/Idw5oRq9lUtgmFg+PHmMP2LoqHTg2mNQaCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=arNSdmi34NUOPw7jy1ItyuKYO6FS/TINjflLlMR3JFDtw7JReGrnjUmPFcq/6L7rw
	 aJbWwWM2w/qfGSmhHHt39mcSSHhlBn1776Fzm3NFB7j/dLpi71bSsy7xC7zpBjLvZp
	 pdRVBcegOn+e0LvKZqG7y/06DOgDzbCI3mM5oC/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 463/620] ALSA: hda/realtek: Fixup ALC225 depop procedure
Date: Mon, 10 Mar 2025 18:05:09 +0100
Message-ID: <20250310170603.860844886@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit 174448badb4409491bfba2e6b46f7aa078741c5e ]

Headset MIC will no function when power_save=0.

Fixes: 1fd50509fe14 ("ALSA: hda/realtek: Update ALC225 depop procedure")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219743
Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/0474a095ab0044d0939ec4bf4362423d@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index bf88deb1ae950..bc4a2c7fff4ef 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3770,6 +3770,7 @@ static void alc225_init(struct hda_codec *codec)
 				    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE);
 
 		msleep(75);
+		alc_update_coef_idx(codec, 0x4a, 3 << 10, 0);
 		alc_update_coefex_idx(codec, 0x57, 0x04, 0x0007, 0x4); /* Hight power */
 	}
 }
-- 
2.39.5



