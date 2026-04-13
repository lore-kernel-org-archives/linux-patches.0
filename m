Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BD52BEFEF;
	Mon, 13 Apr 2026 16:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096658; cv=none; b=K6xLqsHwMXk33H7ILY1NXRisEs9ItYkuuz80YJqfSCk6Fgj3hp+1jlVzq/fEfxNGCjiC4A5FXwdjOSo/N8V3pS3lJrfV5H0SX+vdGMtyqpaSuLD/SX0a/ejN9786lUmc+KZkx7KFwzPFbKJVfKXIeBlZ1sLpJnnd4XlesbSn6ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096658; c=relaxed/simple;
	bh=vZLZKlfQuvP/qnufM4R8LB3meiA0SbY8m9Vfg0H5Glc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ieizUmxxWKCQlQOFbdk2DnXrgwNwPEWYl0AKswuTqnwOK7izmUUtP3OVUf3Cvc6EtyxMKQa8zZAfVQLN8aqu8SeRz/7+rSMLBvPeJzZAP0BgJTtsBTDCxTBxKStsPqjV1grLulBva5452h342j9uCSk55NCW8aNEtJsSSNEclFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=05ZG55Bu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="05ZG55Bu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D783C2BCB0;
	Mon, 13 Apr 2026 16:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096658;
	bh=vZLZKlfQuvP/qnufM4R8LB3meiA0SbY8m9Vfg0H5Glc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=05ZG55Bu4eBNKZUvlOUyaNpc4qvDyW8gN0sBYwqWHbmHhYJC0OBIqwHq3/Gqgy6kh
	 582j+7xVwUF+thDTeiSTxKkZV4TKNcMTISx3CWP7U50+D4LUmqq0Ydh0CMbYfyJbB1
	 iPH+5hSPS65Nbaff/NKxE0S7UOgsYyRT5+Ni5HBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Nathan Rebello <nathan.c.rebello@gmail.com>
Subject: [PATCH 6.12 02/70] usb: typec: ucsi: skip connector validation before init
Date: Mon, 13 Apr 2026 17:59:57 +0200
Message-ID: <20260413155728.273952877@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
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

From: Nathan Rebello <nathan.c.rebello@gmail.com>

commit 5a1140404cbf7ba40137dfb1fb96893aa9a67d68 upstream.

Notifications can arrive before ucsi_init() has populated
ucsi->cap.num_connectors via GET_CAPABILITY. At that point
num_connectors is still 0, causing all valid connector numbers to be
incorrectly rejected as bogus.

Skip the bounds check when num_connectors is 0 (not yet initialized).
Pre-init notifications are already handled safely by the early-event
guard in ucsi_connector_change().

Reported-by: Takashi Iwai <tiwai@suse.de>
Fixes: d2d8c17ac01a ("usb: typec: ucsi: validate connector number in ucsi_notify_common()")
Cc: stable@vger.kernel.org
Signed-off-by: Nathan Rebello <nathan.c.rebello@gmail.com>
Tested-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260407063958.863-1-nathan.c.rebello@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -43,7 +43,8 @@ void ucsi_notify_common(struct ucsi *ucs
 		return;
 
 	if (UCSI_CCI_CONNECTOR(cci)) {
-		if (UCSI_CCI_CONNECTOR(cci) <= ucsi->cap.num_connectors)
+		if (!ucsi->cap.num_connectors ||
+		    UCSI_CCI_CONNECTOR(cci) <= ucsi->cap.num_connectors)
 			ucsi_connector_change(ucsi, UCSI_CCI_CONNECTOR(cci));
 		else
 			dev_err(ucsi->dev, "bogus connector number in CCI: %lu\n",


