Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2161B3F1655;
	Thu, 12 Mar 2026 20:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346470; cv=none; b=HzmzuRrGzNUxCu1Aidhd2kfpeRQotuH7Z8FWpBsph4vIMIs/v15Ym6RlR/VMOT4EcRl+jrthNbddYkQylPcQxlFQOZzOnJfY1yDxDeh2ydUzDTc80TPe3aBNkJ0pclZhEyKhZsqAP19pIRd1QAKpWtRcU96fFCzvzXCvZZYrBWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346470; c=relaxed/simple;
	bh=PNcPy4jpEx8+kZdu6894zcmxeXDajucRjJY1FYxTUfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVvlYhu/eJh/YrOBpdocNyEZBlDxZhjU0zyjdBIHXjJOb1Jh0N96BKjNYnnkYHhwbsTH/fscGKBR2uninVxDg0/3AZEEIbEzYy9/OYwvx/S3FW9pRQJTFbAdns07mweyMbn6ildSH7yFzoPKWOlXhuOgIEz4vbmiB0bvpZU2LhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XyNQRdWM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XyNQRdWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DEC4C4CEF7;
	Thu, 12 Mar 2026 20:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346470;
	bh=PNcPy4jpEx8+kZdu6894zcmxeXDajucRjJY1FYxTUfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XyNQRdWMvV6ZiPWYA6FugzBhzgpadb0CyxQFlyX2kngdivFa9rdln4bqEXYv+Yny8
	 quvdWLjZ3lVrc4X3BAjnVOR/EpCryalXwjBwCwmGAfv72xvN/vEUEGuv5G8GVufOnt
	 9UDf0FRNCZ0++3Lot18uDCbuyid1w7IA6ROQx5jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/265] ALSA: usb-audio: Cap the packet size pre-calculations
Date: Thu, 12 Mar 2026 21:06:45 +0100
Message-ID: <20260312201018.836155142@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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
index cb94c2cad2213..729d86fffab4c 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -1399,6 +1399,9 @@ int snd_usb_endpoint_set_params(struct snd_usb_audio *chip,
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



