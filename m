Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585819;
	b=hR97culmwedIKQEeE68c0RFOSx1BWqq7XISf7y9qG7YgDgaXu2H2oTxNwvm6ppTbtZyG
	 EDsl+Gb0/HUjnOZCcJmOuPeWj+YrT1HJfpFfuLYl+xJybiCqMKunOryK0Gu7X3foNLnw9
	 NchVrbh92BTMNxvGGGrjb2iGt0GdEyT5wD03vWnMjnPiZ1zbNEbtgVAxWlEhXW2QA9EVK
	 dP7x7EVwOfvWaed5OHCD4AWfXpyRK1PgMHQzuRXrs4VkMRcxmG8Nl1GL572IulfIumzGh
	 raIzRi22ZVCuC6+W5yq4viV7Y2lHMbMItEw6KnX5rlteTmRbj7Ho1CE8f/bbB1EEVvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585819;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hb9Bo13cpWy6ghZmlBA7pEstPdZSk29LrKNehvaIhqk=;
	b=bbHy5m40lHQJ+T44tHVFcY/E8eqrzx4Nziy80CE0ZQSFFgiu79DTaLa5ufOxw+JJvrS0
	 4illhwmqeidZz7hYZP1m0MYuOaA5W0ugr9fhE6k8JtsJfW3CLUhFCffTxsfO+RT5u+Mma
	 HHpK44t2a2h9ZrJ0hNDdoqdflDxj7NM12L8d7KenaTcimhotRI8OTwgctyDHcLnSxphxe
	 s9xLisYn93IdFGkhoBU3lztBE57wUIlZyPpJsexOKe7pqGDtroiLivGx1h9n70VYlMLws
	 FQG21+jvg/sgnfmt9L67pTuFiVH62AHc7hGnxgCxuRtWquIt3aHxWI+oZouimJVhixw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TvEDHmCb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA30606C566;
	Fri, 13 Nov 2026 16:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TvEDHmCb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0C91F000C7;
	Fri, 13 Nov 2026 16:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585819;
	bh=Hb9Bo13cpWy6ghZmlBA7pEstPdZSk29LrKNehvaIhqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TvEDHmCbZP5sVTd+ytp+iFcfuoO7KxlgEDQY4Fg+LVVZldeB8RWIixwvCGacLMGJM
	 xLUfpT7rx7RwTqXqoj8hAutFFuFw3yNh7nITV+m/1KGrDsHjkLsYnCYDPzBZ/T5Ire
	 7qwutpdLTVK8yMd7+rDVX96JtLSmkcieujQsRom8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 400/507] ALSA: caiaq: free the EP4 URB when input setup fails
Date: Fri, 13 Nov 2026 10:51:44 -0500
Message-ID: <20261113153810.301696553@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit d21746bafdb8e1a5fc9bdcb86f603d827a500a62 ]

The three controllers that use the EP4 input URB allocate it before
checking the endpoint type and before registering the input device. On
failure they jump to exit_free_idev, which clears cdev->input_dev but
leaves cdev->ep4_in_urb set. The card teardown then calls
snd_usb_caiaq_input_free(), which returns early because input_dev is
NULL, so the URB is never freed.

Release the URB before dropping the input device on the error path.

Fixes: 6da7a2aa899f ("ALSA: usb/caiaq: Add support for Traktor Kontrol X1")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20261104025341.1527407-1-vulab@iscas.ac.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/caiaq/input.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/caiaq/input.c b/sound/usb/caiaq/input.c
index 8d924330c54c8..309a361ca9f75 100644
--- a/sound/usb/caiaq/input.c
+++ b/sound/usb/caiaq/input.c
@@ -840,6 +840,8 @@ int snd_usb_caiaq_input_init(struct snd_usb_caiaqdev *cdev)
 	return 0;
 
 exit_free_idev:
+	usb_free_urb(cdev->ep4_in_urb);
+	cdev->ep4_in_urb = NULL;
 	input_free_device(input);
 	cdev->input_dev = NULL;
 	return ret;
-- 
2.53.0



