Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDD83B994F;
	Wed, 30 Sep 2026 19:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795070; cv=none; b=kpMzrm1fWmoAU4IWhw2F2x7W2kRRrPsYkSlT9BB9BCSxAQdh7/xD9oxrnZorZvjTVUTBre5lpo2eKjSx4TK/UgHYLnBnWnBBKLBoF9PCtr7ZGz7AQ1TKkuaJ48IPQlp/nbwIelWGyswsv0EolYdxjKDRp0r2YpyzFYMyHa+RSXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795070; c=relaxed/simple;
	bh=DGH/gmLLIbXJmLRFxgzoTXrbscu0CblxOqD3zMAVoLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iik6TUXMgu98N7f5t1Z+irDg+WWdeqP+86KmyQj1kxPNcGLb2A5tSjK3QuCsZv5al3XYVXq4fA54ona18hH1kmfoNqzo3HtF4bb4QeiscJXPLiS98BX/PS6NPpOexssvuSGp2MFAwBDIpJZsbkiiZY95T0veqCvfZwGbPEc7LtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2cR9r2RQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2cR9r2RQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157581F000FF;
	Wed, 30 Sep 2026 19:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795068;
	bh=HEOs09qJ7Kfc01Ab4hV31i4mWwu7LmdJFDys+cR6cDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2cR9r2RQB2dwqBKFnzcn+Q2AUybgxpY7juWeFjeUP94dH7jVbGyeFHTlAoL0a9zrt
	 IUwg9yrHOwSqQHn+28sJRtmDWk4B7ehhhWaHQO7n3Vk5OQep21qXZZeHnvaa1pfWIO
	 tb0yfQGSRSp4PEUE596RQpJE2KBF7ab4x0W7355Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0433/1193] ALSA: hda: restore MFG widget enumeration after core split
Date: Wed, 30 Sep 2026 17:18:37 +0200
Message-ID: <20260930152443.812422931@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit 32d7226e6105c257ef7b3d0ec819f11a81f53b6d ]

Before commit 7639a06c23c7 ("ALSA: hda - Move a part of hda_codec stuff
into hdac_device"), widget enumeration selected the function group with

	codec->afg ? codec->afg : codec->mfg

and read subordinate nodes from that group.

The core split moved this logic into snd_hdac_refresh_widgets(), but
hard-coded codec->afg there. For an MFG-only codec, codec->afg is zero,
so the Root Node is queried and codec->start_nid/num_nodes are populated
from the function-group range instead of the MFG's subordinate nodes.

Restore the pre-split AFG-or-MFG selection.

Fixes: 7639a06c23c7 ("ALSA: hda - Move a part of hda_codec stuff into hdac_device")
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/44809B8FF80DCCA2+20260901034024.2407783-1-raoxu@uniontech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/hdac_device.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/hda/hdac_device.c b/sound/hda/hdac_device.c
index 118bd202543b3..51984633ea64d 100644
--- a/sound/hda/hdac_device.c
+++ b/sound/hda/hdac_device.c
@@ -403,6 +403,7 @@ static void setup_fg_nodes(struct hdac_device *codec)
  */
 int snd_hdac_refresh_widgets(struct hdac_device *codec)
 {
+	hda_nid_t fg = codec->afg ? codec->afg : codec->mfg;
 	hda_nid_t start_nid;
 	int nums, err = 0;
 
@@ -411,10 +412,10 @@ int snd_hdac_refresh_widgets(struct hdac_device *codec)
 	 * widgets array.
 	 */
 	guard(mutex)(&codec->widget_lock);
-	nums = snd_hdac_get_sub_nodes(codec, codec->afg, &start_nid);
+	nums = snd_hdac_get_sub_nodes(codec, fg, &start_nid);
 	if (!start_nid || nums <= 0 || nums >= 0xff) {
 		dev_err(&codec->dev, "cannot read sub nodes for FG 0x%02x\n",
-			codec->afg);
+			fg);
 		return -EINVAL;
 	}
 
-- 
2.53.0



