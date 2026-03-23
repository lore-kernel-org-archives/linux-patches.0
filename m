Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F7736F414;
	Mon, 23 Mar 2026 14:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275198; cv=none; b=Fv3KTMtxXj+9rpXOcW3b6KyL0yClCyRqRrv9NZu6OH2pgD0nWeFP9adSRUFjk8yQa5ZNBy1lD1ybFTgkXXesrlVZs6X3ZeFhfCupGS5iXpriNez0QKqdyPeZzccmIJicxEWVmemh4XZU73XFl+tFwDE61roVy4jHf9m0LmjrtWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275198; c=relaxed/simple;
	bh=e+g3DFdRd1NjiEp8cPRmSLwZ0kuR+2mipgpKl4QF6GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPGjmZNG+MBk1JJ9nMtF/H4hZyPJJqYVPHDI9hFL9ftu6yjHMt2/aZckn8A2yvNstibWboWKPXCEntTIRe+m+jnGDhYHoYDPebnOCayObh7L8X1E4JT7t/U/Zh2atNqZyUyJEjV1C5erZT266Qnfnqot/Lr5PLPtJXsxnJ83aeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZ/BlUvM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZ/BlUvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF27C4CEF7;
	Mon, 23 Mar 2026 14:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275197;
	bh=e+g3DFdRd1NjiEp8cPRmSLwZ0kuR+2mipgpKl4QF6GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mZ/BlUvMSzkfUFw0T/nOWoyooJr1vt/KPIR0FAFVAmxq0fkPMTEQPO1NkxriKbvCd
	 ZE1ALfGYT36kxMtj7OrD3cbLp289Opfhteo5wiL1JAxxZ7ALjUZN2mYZzsZ8FUxIAr
	 fNZyxm661DVMxAA+eacwasmqOya3oiV8DrID0WUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/567] ALSA: usb-audio: Cap the packet size pre-calculations
Date: Mon, 23 Mar 2026 14:38:50 +0100
Message-ID: <20260323134534.012359462@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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
index 1092b964167e9..d035b25f67b64 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -1396,6 +1396,9 @@ int snd_usb_endpoint_set_params(struct snd_usb_audio *chip,
 		goto unlock;
 	}
 
+	ep->packsize[0] = min(ep->packsize[0], ep->maxframesize);
+	ep->packsize[1] = min(ep->packsize[1], ep->maxframesize);
+
 	/* calculate the frequency in 16.16 format */
 	ep->freqm = ep->freqn;
 	ep->freqshift = INT_MIN;
-- 
2.51.0



