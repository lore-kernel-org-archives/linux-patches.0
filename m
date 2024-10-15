Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8899B1AF0AC;
	Tue, 15 Oct 2024 13:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997803; cv=none; b=rdNy8o71WdgC/Dkv6Vt1Z85SWpBOV244PslPXHGAD8MaxpmYwN4CHnZHTEVhqPgeLbFBamb23Da4YH4Gql0hil7DiUAXoYxfaROGeEvbNrGLhLoE/R+De3pfC6iORJYeSB+gec1lfYk6yC+098f78vwLzt3SBRouGiE5KgWI+0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997803; c=relaxed/simple;
	bh=Z1IvryZprL1ukjo3kDSoqqIEiG6V5KivgygN1qhMBds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxxnlAxlJSWhP8xPcOwvb+1SBg+9Kdr0B+L35zIYBrcZmfwQSxTGRPplT+vZ+JyPcgxc805m/OM2kBYTXmJSn4jHr8VsZdOuu3qDwhRZCu2cZEM01k2o8Lkc7IgA48LuyFfCrPjQriofH1rpt+ID3uOinhSGKicY72uqaZK7ofI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZNZ1bUOj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZNZ1bUOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0736EC4CEC6;
	Tue, 15 Oct 2024 13:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997803;
	bh=Z1IvryZprL1ukjo3kDSoqqIEiG6V5KivgygN1qhMBds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZNZ1bUOjKDefpIoIy6PFoziQIoT4FBgBrx2MclkJvaydVPwOzB/9ZGyP6EiWMlIKs
	 WQ6Icx3bqeREKHmgZ1fhaALkUwW2TxuAO85s90EoEEkfdXcZOM+US1WZKVa5JBOVNq
	 YxJfowY2nN8nePGVgonatMNDzZrn36yIYq1Y1seE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 291/518] ALSA: hda/generic: Unconditionally prefer preferred_dacs pairs
Date: Tue, 15 Oct 2024 14:43:15 +0200
Message-ID: <20241015123928.219063458@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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
index 733dc9953a38b..d697041a8529a 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -1377,7 +1377,7 @@ static int try_assign_dacs(struct hda_codec *codec, int num_outs,
 		struct nid_path *path;
 		hda_nid_t pin = pins[i];
 
-		if (!spec->obey_preferred_dacs) {
+		if (!spec->preferred_dacs) {
 			path = snd_hda_get_path_from_idx(codec, path_idx[i]);
 			if (path) {
 				badness += assign_out_path_ctls(codec, path);
@@ -1389,7 +1389,7 @@ static int try_assign_dacs(struct hda_codec *codec, int num_outs,
 		if (dacs[i]) {
 			if (is_dac_already_used(codec, dacs[i]))
 				badness += bad->shared_primary;
-		} else if (spec->obey_preferred_dacs) {
+		} else if (spec->preferred_dacs) {
 			badness += BAD_NO_PRIMARY_DAC;
 		}
 
-- 
2.43.0



