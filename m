Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071F3313539;
	Thu, 28 May 2026 19:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998017; cv=none; b=ZaUyQJVtPMXL6OerQC0pyC5tPkswI2otfrGocBSL6X/ZjWDpSS16r+p9QITJdNp3/qf6ctdI9r/emvAEmMKKjixyeZp9nff+BGd2M8q7u3EwbmvATioTH5XfrZYRebtuSVZgwXA6lcqmbPf0vIj2hu1c7Z7LHoynP5vfvbEsk9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998017; c=relaxed/simple;
	bh=TYXMorCaAoJGJO4sDLv3zvEGc0aJfq/8H4/hfUsW7H4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mfzPhWDCzgnXiRNMxIuqt2gzzY7KLlI+QEgiHOOChRARgTc5WdUryS7LKqXvObWigzzUcXADaN3lLh4rAAJ50LhrzbU42HOjqBQ2nMjOmXjCPMH1d7+sUqaMkCTte29g1jjH5kHanm0fX1xn3mBGeSea6smQd85N/B1eRtzjT9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uPNKb+8E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uPNKb+8E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310071F000E9;
	Thu, 28 May 2026 19:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998015;
	bh=tMxDwubwYB5EuHtlmgwXSNEtwv3WQoTzZ5qmkpc1CTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uPNKb+8EbkS1Awz48ARX7+Be8X1ewAZyjqQ5udWIOydwcVd5mhnEgU4ohOI4f1xKU
	 f557ncJO9QJM42MqKqE6Fn+0SVFiIcqCtI7DwdswxxuYHFs29cnOE80IlMTjXk4Evv
	 4+TgEEjNlo1M2pWxqMNE/D/Zl+jReG0IesYKgmGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 023/461] ALSA: ua101: Reject too-short USB descriptors
Date: Thu, 28 May 2026 21:42:32 +0200
Message-ID: <20260528194647.554578696@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -894,8 +894,9 @@ find_format_descriptor(struct usb_interf
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


