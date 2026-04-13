Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5832BEC3F;
	Mon, 13 Apr 2026 16:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098653; cv=none; b=mfe0KvvkzZeKOAs8qcAp3XjOAakD/mi8t2o1IZIsdQq1C87xuNozvV/TjXL6DE9Cdrh/Iz08gvK9VZytjPYrnaIVjjTwoCj2cbbv4GIian98B1QP1PlgvjVZ3LjmN2LgO/0fmlIH1z5vohjkp8hlLxRYv8glA2xjsrlTVrqzSUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098653; c=relaxed/simple;
	bh=pUQYfRL+uTl4RhxVncBbMUIIlnPKG2UHsSQgDs4wCH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AEH80vTm7RbzPzbgwYjTkewSdqxLhClxz11fLkuvl0koYU6scQOBg6SbHLbNa7WRa+KRilb7CvIb0G9xYHenXrcloLsm2KeO5VuLS+62v3OP77RTr+UP9SOuuYNiK3LcLMQTU31QX0AjAgDDLoVu4K465Gsx+5z4Af1H9/j5PeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NpigwD4B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NpigwD4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C338C2BCAF;
	Mon, 13 Apr 2026 16:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098652;
	bh=pUQYfRL+uTl4RhxVncBbMUIIlnPKG2UHsSQgDs4wCH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NpigwD4Bj+XDCK3SH79e5xoyzpDKnKEQ3m5CucQ6tWDj9nB+QmWM+crIb0OVzqbJZ
	 aPTdVfJayslChnTT5Zbluk7W4oc7IlxGhw6xAV0NLO6U60q5kip67zz5jsikmwMtte
	 4oKVqvQTopd/BqCPe8UWPz+8u20op2V/BQMjUZ6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 005/491] ALSA: usb-audio: Cap the packet size pre-calculations
Date: Mon, 13 Apr 2026 17:54:10 +0200
Message-ID: <20260413155819.252198974@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7fe8dec3f628e9779f1631576f8e693370050348 ]

We calculate the possible packet sizes beforehand for adaptive and
synchronous endpoints, but we didn't take care of the max frame size
for those pre-calculated values.  When a device or a bus limits the
packet size, a high sample rate or a high number of channels may lead
to the packet sizes that are larger than the given limit, which
results in an error from the USB core at submitting URBs.

As a simple workaround, just add the sanity checks of pre-calculated
packet sizes to have the upper boundary of ep->maxframesize.

Fixes: f0bd62b64016 ("ALSA: usb-audio: Improve frames size computation")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=221076
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260225085233.316306-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/endpoint.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 21bcdc811a810..8e2b90cb5b952 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -1099,6 +1099,9 @@ int snd_usb_endpoint_set_params(struct snd_usb_endpoint *ep,
 		return -EINVAL;
 	}
 
+	ep->packsize[0] = min(ep->packsize[0], ep->maxframesize);
+	ep->packsize[1] = min(ep->packsize[1], ep->maxframesize);
+
 	/* calculate the frequency in 16.16 format */
 	ep->freqm = ep->freqn;
 	ep->freqshift = INT_MIN;
-- 
2.51.0



