Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA4438E5C5;
	Thu, 17 Sep 2026 18:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668978; cv=none; b=KwfK0JDRUrKZ64/7MgRkfEdTDd/b4pHJQ4xsYygeXZS11a/yQU4ZsCPms4twah7NAk2VfnAoB4hUYS1Mx9KZbG46ra5J/ikmNHtGHdN2yGBXveQFKPs1eq7QTVi2Tvh8e1KTYTgkvEBAH8+V0Qz5i3+2ymHfyiVWnzQhc+FpLwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668978; c=relaxed/simple;
	bh=bHhOK2cod89G6bKpyX29ZIjGRCSh384GRDmKJJXw/zI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1CnnzI1mlHD4Q5rhmqgbc6CYxR2yINNFgEPjP9nrrwEF/+1LDVEqYDICQ4exyIZZad7DPypBh/MSLBCVQHto+lwMqtY3zh5Dc4NujFmow1NChqWnGvpy/cTh0XSmDn/LUB9vPD2DdBxLWLgvAdIF4IV58Ts089QkKaFBruzvl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xIygSpml; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xIygSpml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81AB41F00893;
	Thu, 17 Sep 2026 18:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668976;
	bh=NHsV2OP4rcUt+iq6va6ghIiXRJdwC7xy1BUmGjCUsHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xIygSpmlOxjRk25wPFAeRSshQ1i050RndV4DO5o8WEJq32u9R8qWNawt+mkhJP4p/
	 yrwTdaX7E9YyCXRD+IaxAbXdPvMpsvznjvM53Isi6Nlkz7Hu38R+y9W1gBp2gBt/ss
	 9CEjtwgEYdy69ceyOgV44xlXLnC26RxkzdI9oYtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingyu Zhang <usupergate@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0604/1102] ALSA: ump: do not touch legacy_rmidi before it exists
Date: Thu, 17 Sep 2026 16:09:07 +0100
Message-ID: <20260917151555.178187100@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingyu Zhang <usupergate@gmail.com>

[ Upstream commit adeee7187694719890aaffdc14b7e89cfd736f1d ]

snd_ump_parse_endpoint() sets ump->parsed on every exit, including
error, before the caller attaches the legacy rawmidi device.
ump_handle_ep_name_msg() then treats parsed as "legacy_rmidi is live"
and calls ump_legacy_set_rawmidi_name(), which snprintf()s into
ump->legacy_rmidi->name. If a UMP packet arrives in that window
(IRQ path from snd_ump_receive), legacy_rmidi is still NULL
(KASAN null-ptr-deref in snprintf).

Guard the legacy helpers. parsed only means endpoint info was
parsed, not that legacy_rmidi exists.

Fixes: 37e0e14128e0 ("ALSA: ump: Support UMP Endpoint and Function Block parsing")
Signed-off-by: Qingyu Zhang <usupergate@gmail.com>
Link: https://patch.msgid.link/20260902073918.880245-1-usupergate@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/ump.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/core/ump.c b/sound/core/ump.c
index 820a86d4e159d..6542206747a3d 100644
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -1316,6 +1316,8 @@ static void update_legacy_names(struct snd_ump_endpoint *ump)
 {
 	struct snd_rawmidi *rmidi = ump->legacy_rmidi;
 
+	if (!rmidi)
+		return;
 	update_legacy_substreams(ump, rmidi, SNDRV_RAWMIDI_STREAM_INPUT);
 	update_legacy_substreams(ump, rmidi, SNDRV_RAWMIDI_STREAM_OUTPUT);
 }
@@ -1324,6 +1326,8 @@ static void ump_legacy_set_rawmidi_name(struct snd_ump_endpoint *ump)
 {
 	struct snd_rawmidi *rmidi = ump->legacy_rmidi;
 
+	if (!rmidi)
+		return;
 	snprintf(rmidi->name, sizeof(rmidi->name), "%.68s (MIDI 1.0)",
 		 ump->core.name);
 }
-- 
2.53.0



