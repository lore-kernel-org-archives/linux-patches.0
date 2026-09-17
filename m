Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC16D4B4879;
	Thu, 17 Sep 2026 15:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659183; cv=none; b=DHunHPPmidGbUcO0uMkCCRtcJ7KibYLqcimf/jdmipO2AB8ccL01B0NN3+IZ0PXV9wsjasp+y0yhMg8as3s2N56hd3qOH1bcHScfs8QiXEHCWVVVUFhE4CNOqugCAnst0RONmcj6xE4gdirzK9SFMjOkkvH94x24TFN6048Bekw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659183; c=relaxed/simple;
	bh=nsJF8gG4cO696/W9mcfWjtO++M7Dgo/mKCtB1RRkcZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=suq59SR7msJq2oCRezDHOY829/X2NLOqW/szgcgj6Iu/iLRfGhIKmoAreISfuK3dStS8ZsszbfTPrtU2Wl1vkUqlejF7Kmkt4nyM4bIzrl09GLB3GURrd1sAogUSIdGeFFqzHC0a3calSAFMumOhluEPxJKMaZD1pYbvkCXcDZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XJIA5ggr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XJIA5ggr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84B01F000FF;
	Thu, 17 Sep 2026 15:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659176;
	bh=+LR5xoS4rYOI2jdDJWKC3SN5rWwNzIZ6wCW8nKb/pAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XJIA5ggrFHrrSswEy6IUC8SxgY89r1Sdj6/GtDbExKpw97J/m10IpMXkmeo0k6+Dd
	 9PM+sYV0+Gh+zQAnoRzuFKbnIXHIucxJ/EFFcGd9mTRee68tJSKPqVPSdT0uwQsrxW
	 iXdiO/CfoGUos3XUTiGzjIlDiq+2iRYtCLMd1BNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 162/733] ALSA: dummy: Report a change when one capture switch channel moves
Date: Thu, 17 Sep 2026 16:07:50 +0100
Message-ID: <20260917151355.111378559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 83162eeaf78c71ff6f6fa31dc95e3b6e90ee593f ]

The snd_dummy_capsrc_put() builds its change flag with &&, so it reports
a change only when both channels move at once.  Writing a single channel
stores the new value and returns 0, the control core then sends no
SNDRV_CTL_EVENT_MASK_VALUE, and a second reader keeps showing the old
setting until it polls again.

The volume put a few lines above compares the same pair of channels with
||.

The mixer selftest already reports this.  With snd-dummy loaded it fails
event_missing on all five capture switches:

  # CD Capture Switch.1 orig 0 read 1, is_volatile 0
  not ok 13 event_missing.Dummy.9

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Claude:claude-opus-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260901153921.3971-1-sammiee5311@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/dummy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/drivers/dummy.c b/sound/drivers/dummy.c
index 41ceeafce824e..21eb0d76d6f8d 100644
--- a/sound/drivers/dummy.c
+++ b/sound/drivers/dummy.c
@@ -782,7 +782,7 @@ static int snd_dummy_capsrc_put(struct snd_kcontrol *kcontrol, struct snd_ctl_el
 	left = ucontrol->value.integer.value[0] & 1;
 	right = ucontrol->value.integer.value[1] & 1;
 	guard(spinlock_irq)(&dummy->mixer_lock);
-	change = dummy->capture_source[addr][0] != left &&
+	change = dummy->capture_source[addr][0] != left ||
 	         dummy->capture_source[addr][1] != right;
 	dummy->capture_source[addr][0] = left;
 	dummy->capture_source[addr][1] = right;
-- 
2.53.0



