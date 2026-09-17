Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA4F4C10FB;
	Thu, 17 Sep 2026 15:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659136; cv=none; b=YGpcGZ8Zsk7O2HXnJ4R1TjxvWsQs7bjayaw/Xc1rsW3Pepzu+8WkMA+JwSVAEAWT00nh4UbN95Xz2pv/qKefmQbAbGqwPTvflY4R5OO3GcJfCpKIl3j4k4gB8Zs1yhEx5m9PJwzPW9/PPwf83vMXF1iZhMwdPVBRvnkngza24Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659136; c=relaxed/simple;
	bh=B8otcySqFdBsH6zU0y58SysxhnIVg6AV/hMyupIUjCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzF0fTOWVtsrM0/bcfl/22Q8+vIVN6rYg3am1iJPbhHsuWkCm83SYJ+Mr/h9mEFL5R0WysqdGvJTMO1uQvUy8Imr2COgLACBzgKh8eiFimRKJ/gu30/rGlf8LZGTH8XW9NpvjT1WqRUHMbqrLBSFqZLE0VHMrCN5o1NyI5InokU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NPUa1oaf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NPUa1oaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1E71F0089A;
	Thu, 17 Sep 2026 15:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659129;
	bh=z7WxTV+Vx+RvLuu3RtV2zPfT7S/LCr6N7lXGmLTRneM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NPUa1oafpaiAtaO4YZFq6H6GO5nQGXorKbcbDRciniYw5kQEz8Pmk4+kp0SsGRV6P
	 i+kfyt5sfYhhZIAxi4rNklUZA0H8mDD85W2IoemKnmRnlXrjXU/OxgcIPy17glR/qY
	 vQVvigPIiYdPE5iRyHXRyQIdTPvdUzK26msP2LTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 152/733] ALSA: hda: restore MFG widget enumeration after core split
Date: Thu, 17 Sep 2026 16:07:40 +0100
Message-ID: <20260917151354.847282257@linuxfoundation.org>
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
 sound/hda/core/device.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/hda/core/device.c b/sound/hda/core/device.c
index 160c8d0453b0e..ebaa106d0f018 100644
--- a/sound/hda/core/device.c
+++ b/sound/hda/core/device.c
@@ -404,6 +404,7 @@ static void setup_fg_nodes(struct hdac_device *codec)
  */
 int snd_hdac_refresh_widgets(struct hdac_device *codec)
 {
+	hda_nid_t fg = codec->afg ? codec->afg : codec->mfg;
 	hda_nid_t start_nid;
 	int nums, err = 0;
 
@@ -412,10 +413,10 @@ int snd_hdac_refresh_widgets(struct hdac_device *codec)
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



