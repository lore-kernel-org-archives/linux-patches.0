Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D95318B96;
	Thu, 28 May 2026 20:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001271; cv=none; b=gqP/kZCjeWJFfBD25F44/K+cIDWkTfj8VL+uCOWypzr3KLF6n0cg9f2taFSVMLaGQRX9EgZBc4U1srSEqnoRHextDLhdtRsFZmyCHoXT40N2HNpLvBFh5mjcvskaabfDQshqvUswF+IgeyPUhKDrR7GzIZjBmJj1/lksNagbDA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001271; c=relaxed/simple;
	bh=sQ97Ask7iLvWynynd2WttuUQfJpwWCuTMrQ9jY284GI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZGR0QRUTvuYcJfQy5/fJwh3NNf3DjUwD2DmkOp7qCwNQo54CzoTcnhb5QMcH3R14XdBhJNhXIKARIDj2paDu+Ejp0RPeDPfZ+H4xwQlynF77G9DV04LJ2hSpRxGpjrhoidTyHoeLKvcbLvectY/T9pbd/B/Gh1zsPnt90oR5Mp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dDdvrf4D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dDdvrf4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405AD1F000E9;
	Thu, 28 May 2026 20:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001270;
	bh=o+jqwIamDmkluPp2g4ckc+xRMnpd2QFZn3WUn4dvOgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dDdvrf4DbW17mRBr6gYWAGJWyGBlYYfQHzjdYocGNeYp4jcBoISvR1GG2DfRrorQl
	 dxOxZbZel6vNz7WFs5QHBMrK1XQEJqQ35Abnktu4HxSKUHvTsLt6vLzFhAO/qBmVUh
	 WQ+iaFdyZ5gjNUcjsvVQKSD+MFu8KnzvNNzj8JT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 029/186] ALSA: ua101: Reject too-short USB descriptors
Date: Thu, 28 May 2026 21:48:29 +0200
Message-ID: <20260528194929.750125753@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit b59d5c51bb328a60749b4dd5fe7e649bfb4089b4 upstream.

find_format_descriptor() walks the class-specific interface extras by
advancing with bLength. It rejects descriptors that extend past the
remaining buffer, but it does not reject descriptor lengths smaller than
a USB descriptor header.

Reject too-short descriptors before using bLength to advance the local
scan. This keeps the UA-101 parser robust against malformed descriptor
data and matches the usual USB descriptor walking rules.

Fixes: 63978ab3e3e9 ("sound: add Edirol UA-101 support")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260519-alsa-ua101-desc-len-v1-1-4307d1a5e054@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/misc/ua101.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/sound/usb/misc/ua101.c
+++ b/sound/usb/misc/ua101.c
@@ -914,8 +914,9 @@ find_format_descriptor(struct usb_interf
 		struct uac_format_type_i_discrete_descriptor *desc;
 
 		desc = (struct uac_format_type_i_discrete_descriptor *)extra;
-		if (desc->bLength > extralen) {
-			dev_err(&interface->dev, "descriptor overflow\n");
+		if (desc->bLength < sizeof(struct usb_descriptor_header) ||
+		    desc->bLength > extralen) {
+			dev_err(&interface->dev, "invalid descriptor length\n");
 			return NULL;
 		}
 		if (desc->bLength == UAC_FORMAT_TYPE_I_DISCRETE_DESC_SIZE(1) &&


