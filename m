Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142D32E540B;
	Tue,  8 Jul 2025 16:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993918; cv=none; b=eP9RJDYuIHtScu+t4EGjoH2OgdTdl4tMt/EkB4B20UaON9gnc7W0MR9uW2G7z0nKRc6bqBd8HrUozvyql8ytIiEjXd4chdT6hAtAH0+H7j6oJHXpihdgyfCjq6Ng+25HZm690Wxza/v+HLqZQh39UKVEvy+IJoL4O0zUN+5t/0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993918; c=relaxed/simple;
	bh=K8xO9plDs48ag0Qic5pOf/7BtwIwOBMVlnd0T2whu5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z01PGqeGUYn9gyMb5U2pGWVpcmcggl+rVUnR+cTowSNrIhXeEWN9Dia8izbLmF6LrkBi6c7XyuRRxFr8tPff8G0UNInU+JSK/PEHgCm/ww6uo4jINfDG2hukvyC/DO4Nm3CtzmZWy4mHMIbPHw4Gzp07Me+t5aigjX1jTxDGBmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z2jpXGvO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z2jpXGvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DE3C4CEED;
	Tue,  8 Jul 2025 16:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993918;
	bh=K8xO9plDs48ag0Qic5pOf/7BtwIwOBMVlnd0T2whu5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z2jpXGvOZyegadLHw2hQ8I+1/J+dhOq9pvMVFB2vSQzG6Ww+cnLO2jsEm69katRS5
	 Q3hmisn1R3Ep585BA6qythWPRLkmEcnqldU+yoqsQ2hKR6yo9nKMSbYrFjhFY0Ku2c
	 J9oD3VPmzbDNT/0HOL5TPZI8CHCNrcku0Kf9R5T8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngjun Lee <yjjuny.lee@samsung.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/160] ALSA: usb-audio: Fix out-of-bounds read in snd_usb_get_audioformat_uac3()
Date: Tue,  8 Jul 2025 18:21:39 +0200
Message-ID: <20250708162233.271722957@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Youngjun Lee <yjjuny.lee@samsung.com>

[ Upstream commit fb4e2a6e8f28a3c0ad382e363aeb9cd822007b8a ]

In snd_usb_get_audioformat_uac3(), the length value returned from
snd_usb_ctl_msg() is used directly for memory allocation without
validation. This length is controlled by the USB device.

The allocated buffer is cast to a uac3_cluster_header_descriptor
and its fields are accessed without verifying that the buffer
is large enough. If the device returns a smaller than expected
length, this leads to an out-of-bounds read.

Add a length check to ensure the buffer is large enough for
uac3_cluster_header_descriptor.

Signed-off-by: Youngjun Lee <yjjuny.lee@samsung.com>
Fixes: 9a2fe9b801f5 ("ALSA: usb: initial USB Audio Device Class 3.0 support")
Link: https://patch.msgid.link/20250623-uac3-oob-fix-v1-1-527303eaf40a@samsung.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/stream.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index e14c725acebf2..0f1558ef85553 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -982,6 +982,8 @@ snd_usb_get_audioformat_uac3(struct snd_usb_audio *chip,
 	 * and request Cluster Descriptor
 	 */
 	wLength = le16_to_cpu(hc_header.wLength);
+	if (wLength < sizeof(cluster))
+		return NULL;
 	cluster = kzalloc(wLength, GFP_KERNEL);
 	if (!cluster)
 		return ERR_PTR(-ENOMEM);
-- 
2.39.5



