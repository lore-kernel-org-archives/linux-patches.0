Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E43343E07B;
	Tue, 21 Jul 2026 22:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674271; cv=none; b=RweXsHkbDIUWZFnG3J6HrxssPBWiJYyASE5mNBRTo9ZwQwaBgPl7AF24Mz45YuDfpURjN8lOQDfjNq3m3OlCHsS0FARFcYzy38lXWr/KmP1KcFGhbcCBY3fguii5wzHjdO73b9TJ5zS6h/w+Ttor81/vrCdk36hMsfajp0M+EbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674271; c=relaxed/simple;
	bh=oTDg6eNbCkS9q7xiNYOgsTKzaaIG6UbYW7jYhe6NZrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTVAG4R5uyBHMxjjCaxdgUzQOviFYZ2iTcIyALEeWTKeu2NQv8PQNVdAQfnwBC7i7X1xZOS3u8rKtdOK5ghVTEividN+nCwlLONePVheW7eNM2fI5w4/fbkTqJf78UncDI0hElwz6+d58RvXX9IHfka4qtv9W0FNjOoTGJcA8wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejOWumdZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejOWumdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BBBD1F000E9;
	Tue, 21 Jul 2026 22:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674268;
	bh=3vnz4INLJM9NQE9m4cJ9rgMbzOENWxW9OM+XOPrjDOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ejOWumdZLmHzq5OsibTK7q+TG8Mpv3474mw5yKHyeHFYbeNpg05uOUyvD5GQe1qOs
	 zmrsza2iib3eLWYt8BhXqmBwb+MavPrrTy3N3q7InP35q5LSScFDmh4qmBCHToGTSh
	 UkbAIgzyUY8KSfdMhjE9Y1nqeMT+rjL0sBWPu2XQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 477/699] MIPS: ip22-gio: fix device reference leak in probe
Date: Tue, 21 Jul 2026 17:23:56 +0200
Message-ID: <20260721152406.459489390@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit b82930a4c5dbc5c4df39c0f93d968c239f2c6885 upstream.

The gio probe function needlessly takes a device reference which is
never released and therefore prevents unbound gio devices from being
freed.

Fixes: e84de0c61905 ("MIPS: GIO bus support for SGI IP22/28")
Cc: stable@vger.kernel.org	# 3.3
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/sgi-ip22/ip22-gio.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/mips/sgi-ip22/ip22-gio.c
+++ b/arch/mips/sgi-ip22/ip22-gio.c
@@ -133,13 +133,9 @@ static int gio_device_probe(struct devic
 	if (!drv->probe)
 		return error;
 
-	gio_dev_get(gio_dev);
-
 	match = gio_match_device(drv->id_table, gio_dev);
 	if (match)
 		error = drv->probe(gio_dev, match);
-	if (error)
-		gio_dev_put(gio_dev);
 
 	return error;
 }


