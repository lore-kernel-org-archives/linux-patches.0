Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE84415F10;
	Tue, 21 Jul 2026 21:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670046; cv=none; b=MFH5CRYLKGknZdWxPdEag6P2DLXjfTIi5/5BCE85cdxCjP6JyjWn/vvfvIplgTnOi2Vxx0lrvPG09RDlyHcx0dy9xrBjbf2MHkrsbhWahO+ppoewhUqt+J1kr0SvxR4VUk0lfdMC0GCiGANbkddrnOAYctzxQ+jTyXTmlhClLo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670046; c=relaxed/simple;
	bh=t963z5NpAYiEqJthwkDO/FHdVyZR9PAPbbQSDw7uS7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzhVzB+/bw8HH6Alq5OTF85iTij8JbtcVlqWGlsnb0ruOSOUDBkhEZ136xOMmigm+C5xKku56AvXGgt8ePy3T4buyU+w/2F2+N5/+8IbWkVoJFyqhpqD1m5Yw6ZMmXSgXB6Q00n0BjpSAc82wUxSGlTGxP4y2sCsYi9Yym6Ghqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iC39pH9I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iC39pH9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D961F000E9;
	Tue, 21 Jul 2026 21:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670044;
	bh=i3h2KUT/hmlwry9x+TCmpIU5/65nfgD6ladzjzwQd24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iC39pH9IIwRXTWUHkHn89as4yI9ZbO0ltiUKf9CqKRlNQ7hQDXQN3QHK94ThlDd/F
	 YAtYlczKKyBrDt25JKW4a57ZhFZV8C3oYMUiSxW4jEZvcvvyXuwkK9il8QZoanjglz
	 5HwcbeCg5cFJHD0T0Ej1FLEk9O2pLxb37ddxRloQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 0783/1067] MIPS: ip22-gio: fix device reference leak in probe
Date: Tue, 21 Jul 2026 17:23:04 +0200
Message-ID: <20260721152442.086283772@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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


