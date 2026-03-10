Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A3A2D978B;
	Tue, 10 Mar 2026 11:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142030; cv=none; b=kPrx56gSy7yeruN8bh0KvUoUp71O9q1sgw3OTYW7UzKy/TlVwVGXCLtQKiXL19h8rQAiCsDsJNcKlvUUXKksOjtJm1rQM3tymhwQUCIs7o/IQH8Oxo+su7bSTUokHWXYI3qtVfdCHRZw7EYJBAICeN/KXfH5F1PPqJrsNbBnrhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142030; c=relaxed/simple;
	bh=VLR98SqN9N34AOiwiXf7W2LZfRheL7J2WG7SpjTa4UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdDAAz83aMAAFDDKtCm5sWeX2oBrQgScKlWfVGbSODSq6+CqUBek9Duyajoywnz8yiJxopVtJ+1B7AGYWihbOawslPXD0vpEWk7QdCepgxE8Gbv1iNDclkBrsTyGYjmehLdparygqmCdy3aGdSc+Bl8kO50Qb7JBDV9kuwB10dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G/lvBzDY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G/lvBzDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4DCDC2BC86;
	Tue, 10 Mar 2026 11:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142030;
	bh=VLR98SqN9N34AOiwiXf7W2LZfRheL7J2WG7SpjTa4UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G/lvBzDYikX81YnVyu3Shao1UZHzxcbani0LxUo4wiOnkpaTmib6O07E+yuT5b6pd
	 iZszncmppLInUVa2kISF9xgRzf4YFlj8vsusJbdLmGEYKE5m4RyifbR1YWNMF1oCT7
	 VT9Ll8G3UjnPhcvI23xGzb5UQICawcqU7BCn/5y9PQ8BwiJgRq0bbDH5DCtmjbkKo9
	 xV9fAJ7cfVKgRR03F4Go0KctzTPUA+TDuMJv7NSV5rkoX5KqyF6nvsJK1+YTGFE3LK
	 96mfJ0tP5CIwFl2aV016RyMDA+50KhhNIMJXQucOBIDeGYUt+TqLC/yR+9z8J3OqTH
	 eSFZwv+u9Z+/A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Panagiotis Foliadis <pfoliadis@posteo.net>,
	Charalampos Mitrodimas <charmitro@posteo.net>,
	Takashi Iwai <tiwai@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 157/314] ALSA: hda/intel: increase default bdl_pos_adj for Nvidia controllers
Date: Tue, 10 Mar 2026 07:16:56 -0400
Message-ID: <cf1c7846194494ce690bd237fda6e54059536c2e.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Panagiotis Foliadis <pfoliadis@posteo.net>

commit e9fb2028f1eb563e653cff3b0d1c87c5e0203d45 upstream.

The default bdl_pos_adj of 32 for Nvidia HDA controllers is
insufficient on GA102 (and likely other recent Nvidia GPUs) after S3
suspend/resume. The controller's DMA timing degrades after resume,
causing premature IRQ detection in azx_position_ok() which results in
silent HDMI/DP audio output despite userspace reporting a valid
playback state and correct ELD data.

Increase bdl_pos_adj to 64 for AZX_DRIVER_NVIDIA, matching the value
already used by Intel Apollo Lake for the same class of timing issue.

Cc: stable@vger.kernel.org
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221069
Suggested-by: Charalampos Mitrodimas <charmitro@posteo.net>
Signed-off-by: Panagiotis Foliadis <pfoliadis@posteo.net>
Link: https://patch.msgid.link/20260225-nvidia-audio-fix-v1-1-b1383c37ec49@posteo.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/controllers/intel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/hda/controllers/intel.c b/sound/hda/controllers/intel.c
index a19258c95886c..9306e7a31f02b 100644
--- a/sound/hda/controllers/intel.c
+++ b/sound/hda/controllers/intel.c
@@ -1751,6 +1751,8 @@ static int default_bdl_pos_adj(struct azx *chip)
 		return 1;
 	case AZX_DRIVER_ZHAOXINHDMI:
 		return 128;
+	case AZX_DRIVER_NVIDIA:
+		return 64;
 	default:
 		return 32;
 	}
-- 
2.51.0

