Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AE92690D5;
	Sat, 30 May 2026 17:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160425; cv=none; b=hhU4DyQjd0cU5LgXnian0puw51Pxp02PGIhypZk9B6qAp+HhUzcisi5XBd1BL2Kze12nFXI+8gXgzVl/aVcs/F8+ljEeD9jg3z83Co4JHGXAqnWbLTG93tUorHRcMlXLGLFXMTk2+g9CGD12ciTjmh56goUFhEBA67gbstIOrSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160425; c=relaxed/simple;
	bh=Wy44wvZFtgOO7kkAvchg/lF+HkaWW+Ftx81b6lZPGeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZiSnD8SWxam8kJkZteqnLA7j0zmxmhtkMEsuTIFjQSc4UJgF6rGXf0BRo0vllYx3eRMpg5ITo5Q9E+nliJuRkY8CsN8Qg2T/bNTt6dL5JtaraLL/w72iNESXg5xHMp05Rfu2ueKWKVXKAFwmtaTb5PpqssgWxk8F6bGmPThoRKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XD5ZpdJv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XD5ZpdJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3AF31F00893;
	Sat, 30 May 2026 17:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160424;
	bh=VKf81t6SOmYYV2ofpbXK6fD3Bd9z1KCwEPt0Yt2OjNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XD5ZpdJvVboS2NqbnvasrT9yCY9Kfk92fTjN/6uCKKtN4PYYd2Yry9a/c+FCiEwx6
	 XZXUwnza2FUqIu8Xzw1OpvJiit0ZIZFvDEzAcjjS/4WX4Qg/NTxt0IhcEvLivQeFmF
	 GazmVcWk7mFyfdEFXSNI2Ug/sDQvA6QhyCvuxJd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 307/969] ALSA: usb-audio: Avoid potential endless loop in convert_chmap_v3()
Date: Sat, 30 May 2026 17:57:11 +0200
Message-ID: <20260530160308.904230678@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 6e7247d8f5fefeceb0bb9cc80a5388a636b219cd upstream.

The convert_chmap_v3() has a loop with its increment size of
cs_desc->wLength, but we forgot to validate cs_desc->wLength itself,
which may lead to potential endless loop by a malformed descriptor.

Add a proper size check to abort the loop for plugging the hole.

Fixes: ecfd41166b72 ("ALSA: usb-audio: Validate UAC3 cluster segment descriptors")
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260427152224.15276-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/stream.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -352,6 +352,8 @@ snd_pcm_chmap_elem *convert_chmap_v3(str
 		if (len < sizeof(*cs_desc))
 			break;
 		cs_len = le16_to_cpu(cs_desc->wLength);
+		if (cs_len < sizeof(*cs_desc))
+			break;
 		if (len < cs_len)
 			break;
 		cs_type = cs_desc->bSegmentType;


