Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7701D0492;
	Tue, 15 Oct 2024 11:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993411; cv=none; b=bNjm/vwqDVNc+3Rnsi0c7kVW/HMlSocL/OKhJsgLhiWBET2stVZ6dyHaqjFJP9Vn5KlV1WK9frzEK031zWEawjzCt2RX2GFzEYuwenvuNxYkgaepSAUW8j39sFswwO4w6FkOCE/VbG8tjUrz1zL1TdcxyRkh41V1lmKwqtldls4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993411; c=relaxed/simple;
	bh=zxRg/rqWloiV0J7VYLfJMF6qgbpM8lK8fc7QeETukwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKWP9Q0p+pYthuJst35Snc+1kGfvDsXDyFMUFT7rE5doOapmeWG9U0gF4EY+2ULXKTCIPLZKRXgtw5zquY/OvvhI/cvh904wmaPXbSaJDjzeY/wZt13XzDlbmx8leuU6ZkbWQMUoQFWsvmoa6IgDQJCdwbrv3nQYhvbyXXCcm2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wItdg3a1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wItdg3a1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD99C4CECE;
	Tue, 15 Oct 2024 11:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993411;
	bh=zxRg/rqWloiV0J7VYLfJMF6qgbpM8lK8fc7QeETukwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wItdg3a1uVcSpEMttdrS6126MThICGDWN4cIH7ZhbHanr8JHW71wHCVvWPi1+N+tC
	 nSqSN/qeZjbXGRKk+KWgRDAHzxy6+AISNzrcxgtyZr8VUZUJlt4jA6xIAtbX2LECzG
	 GnI4OPBHVvhYyzYxWvpcR8X8Rkj2b+JgtRXYrB1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 403/691] ALSA: hda/generic: Unconditionally prefer preferred_dacs pairs
Date: Tue, 15 Oct 2024 13:25:51 +0200
Message-ID: <20241015112456.339773623@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 1c801e7f77445bc56e5e1fec6191fd4503534787 ]

Some time ago, we introduced the obey_preferred_dacs flag for choosing
the DAC/pin pairs specified by the driver instead of parsing the
paths.  This works as expected, per se, but there have been a few
cases where we forgot to set this flag while preferred_dacs table is
already set up.  It ended up with incorrect wiring and made us
wondering why it doesn't work.

Basically, when the preferred_dacs table is provided, it means that
the driver really wants to wire up to follow that.  That is, the
presence of the preferred_dacs table itself is already a "do-it"
flag.

In this patch, we simply replace the evaluation of obey_preferred_dacs
flag with the presence of preferred_dacs table for fixing the
misbehavior.  Another patch to drop of the obsoleted flag will
follow.

Fixes: 242d990c158d ("ALSA: hda/generic: Add option to enforce preferred_dacs pairs")
Link: https://bugzilla.suse.com/show_bug.cgi?id=1219803
Link: https://patch.msgid.link/20241001121439.26060-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_generic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/hda_generic.c b/sound/pci/hda/hda_generic.c
index 992cf82da1024..2551fb9c6ed0d 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -1379,7 +1379,7 @@ static int try_assign_dacs(struct hda_codec *codec, int num_outs,
 		struct nid_path *path;
 		hda_nid_t pin = pins[i];
 
-		if (!spec->obey_preferred_dacs) {
+		if (!spec->preferred_dacs) {
 			path = snd_hda_get_path_from_idx(codec, path_idx[i]);
 			if (path) {
 				badness += assign_out_path_ctls(codec, path);
@@ -1391,7 +1391,7 @@ static int try_assign_dacs(struct hda_codec *codec, int num_outs,
 		if (dacs[i]) {
 			if (is_dac_already_used(codec, dacs[i]))
 				badness += bad->shared_primary;
-		} else if (spec->obey_preferred_dacs) {
+		} else if (spec->preferred_dacs) {
 			badness += BAD_NO_PRIMARY_DAC;
 		}
 
-- 
2.43.0



