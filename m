Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F533B95E0;
	Tue, 21 Jul 2026 20:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667319; cv=none; b=O2WwJiZBWgOMsO06LbtJDHHFjXBahhL/zDwB4am4OC6JyXxlvO3CdW93H/qrcP2Zo4lZNqoZGxwLVtiMK6+SnKOq0XH0JEJeZsvnfcFd7Q+B8nPXcXIJn8ps+LoT2x6ZcYo4ltb5QXDszaGiYBWt4CX6wgKwdM00qf+9rBPDgA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667319; c=relaxed/simple;
	bh=nmOZWd6A9Tog4vwEYry53x6XCxd1czaWQe2zmnXv+MY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QR6ipxgLM+dRxb6sElZ1YPk6E5obaAICQs8tUMOwSdRTjj7h8XQeXnTj0RGi/MP4fAvRYXzKXZhFGrjG+DBd0RoEHFpWLMu+l+XazqqQB7tmme6NghAucX2utdMKoq+buEf1Ozakl86ZFE5k3Rgc5DCnETEdDss4dfzQ9IOvl+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHm9bdoo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHm9bdoo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D561F000E9;
	Tue, 21 Jul 2026 20:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667318;
	bh=i/eQHjLxtDRopG8Jjkx+MJwAcUVH8ANl8hty4WUTXZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GHm9bdook/qfKT4Yq8MCCxDCQYRqdfTdtlbwho/XdkgmXNRezyRQ8B5hAwkBwx43X
	 bRiWrbEeS96F63QVI7gFRUIMBeN6hM974I7Jt1ii+TjN13cxD5W0XdpXTfV7qXWnsh
	 9e/Yl0RAZ3IGviW2zRA34gpFH9mAATSB/ZaIxAyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 0972/1266] MIPS: ip22-gio: fix device reference leak in probe
Date: Tue, 21 Jul 2026 17:23:29 +0200
Message-ID: <20260721152503.586088250@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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


