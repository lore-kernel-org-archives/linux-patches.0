Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CF64D5B7;
	Wed, 21 Feb 2024 13:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523280; cv=none; b=jYgu0Ks46Tn8tGgS1dzQ7YQk+KqgzOIB5h1w1Y0W2ATyS7r9yKV4j6YQNC844JCfqfKhqVAnRoPYYsEWUe+NaNV+kJuGHhfJdvsLkFRzrPg3WnMPfT5Vkg7rxyDLmm2FK4nem1Qvw08UNpjB1uaGpZP/DE0H9KsOX3l721yCSZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523280; c=relaxed/simple;
	bh=V/HneihaETKNmlKuBjFubDXYnv/ieF0sNE1kD0JNrsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVjSlSkemwdMXdmbCqOyH6e5NCPkYYR74RYw/4HP9tXhooWLpPzIM42HbKgSSAR84xWF2UILbvwIwAGJ4CCLkaOVWSuDWr1xXLjJIO3HE1A0nnJQlVLM63a6n+saPSy7Sm0lQzOI0UytnaBzerBMEPFUEZX/gfVy50MSZ9IV+wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0imCjc8c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0imCjc8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352CFC433C7;
	Wed, 21 Feb 2024 13:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523280;
	bh=V/HneihaETKNmlKuBjFubDXYnv/ieF0sNE1kD0JNrsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0imCjc8cSSjTPBwCu3aZ+YpRL+7WM9ewK3TQWxSHcBXHtbEucZs5n2YIRB0tiizeX
	 cMQwtsPAqggAysKTesbjcJOsvVNuQ3zW1/YmaxSbyz43Jx8OdiJ7aCTh5/d3JpyGN2
	 GS+Ov4l57ubafTuigrT9z9cFnp6SvCl3HJttz1s0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Rodionov <vitalyr@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 386/476] ALSA: hda/cs8409: Suppress vmaster control for Dolphin models
Date: Wed, 21 Feb 2024 14:07:17 +0100
Message-ID: <20240221130022.308175845@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Vitaly Rodionov <vitalyr@opensource.cirrus.com>

commit a2ed0a44d637ef9deca595054c206da7d6cbdcbc upstream.

Customer has reported an issue with specific desktop platform
where two CS42L42 codecs are connected to CS8409 HDA bridge.
If "Master Volume Control" is created then on Ubuntu OS UCM
left/right balance slider in UI audio settings has no effect.
This patch will fix this issue for a target paltform.

Fixes: 20e507724113 ("ALSA: hda/cs8409: Add support for dolphin")
Signed-off-by: Vitaly Rodionov <vitalyr@opensource.cirrus.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240122184710.5802-1-vitalyr@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_cs8409.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_cs8409.c
+++ b/sound/pci/hda/patch_cs8409.c
@@ -1200,6 +1200,7 @@ void dolphin_fixups(struct hda_codec *co
 		spec->scodecs[CS8409_CODEC1] = &dolphin_cs42l42_1;
 		spec->scodecs[CS8409_CODEC1]->codec = codec;
 		spec->num_scodecs = 2;
+		spec->gen.suppress_vmaster = 1;
 
 		codec->patch_ops = cs8409_dolphin_patch_ops;
 


