Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14FF1E1A25;
	Wed,  6 Nov 2024 13:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898405; cv=none; b=nwcH5xq+lTXUJhwgG9ZEBqnR9vfhN3s/qHZCBG0tJmb7jnkMzqOEbGk3ji2BYvD6lCpUlLgzirs5iG4Z3hjlAm2wLu0Y3r3dqj5x/MCALMER+GdoeJ7NxVpgF3nYnj+3M+kDln3c741+faB8lRXAqRZms33jNWefdLI/RQ289LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898405; c=relaxed/simple;
	bh=YopIsaDkhqFgb4Ow7CnpYiTcQuLP3/BXXfQc99G30ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJWR/gujyiBtsK/d/TLOkx9Uqy+uTpSoC6PAxpXcC/lAFtMvSZcrHJTCO5l6pPcmFlyFkoz+QrZPbuysMSm6kU5cpb5noB9JM0JOyi26ldNgAfSFJBNrZqfCv2e7jwgGMHXKp2jswKhPbiF4+iokfgm2VhWIJN+yR0aDsSlAxfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1QP8mL+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1QP8mL+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4896EC4CED4;
	Wed,  6 Nov 2024 13:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898405;
	bh=YopIsaDkhqFgb4Ow7CnpYiTcQuLP3/BXXfQc99G30ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1QP8mL+YmjL7TRFBsS4XuDyI93hsR3qZCgZ7y170jPtN73Na8uOxkoOeGvdY32a+3
	 yCSZRwUBniaOCxsSEGJA+ng6Lx+vL3vbP32OgCNcOYZGLm8PQGW09Q67JvPyiwoqtQ
	 kMa212blgHV/whIXmzQReADadONdCK60eOmdUI3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 191/462] ALSA: hda/generic: Unconditionally prefer preferred_dacs pairs
Date: Wed,  6 Nov 2024 13:01:24 +0100
Message-ID: <20241106120336.233482698@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 77c0abd252eb0..a534460b4222c 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -1371,7 +1371,7 @@ static int try_assign_dacs(struct hda_codec *codec, int num_outs,
 		struct nid_path *path;
 		hda_nid_t pin = pins[i];
 
-		if (!spec->obey_preferred_dacs) {
+		if (!spec->preferred_dacs) {
 			path = snd_hda_get_path_from_idx(codec, path_idx[i]);
 			if (path) {
 				badness += assign_out_path_ctls(codec, path);
@@ -1383,7 +1383,7 @@ static int try_assign_dacs(struct hda_codec *codec, int num_outs,
 		if (dacs[i]) {
 			if (is_dac_already_used(codec, dacs[i]))
 				badness += bad->shared_primary;
-		} else if (spec->obey_preferred_dacs) {
+		} else if (spec->preferred_dacs) {
 			badness += BAD_NO_PRIMARY_DAC;
 		}
 
-- 
2.43.0



