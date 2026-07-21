Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D41470441;
	Tue, 21 Jul 2026 18:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658658; cv=none; b=fQjR753TRJWGiKl8T85RgrXsNCe4IB5cJiK3KSFkH5+RVGN9c76hwNECHgwESGtDW1x4wMEhI3mTNUYocot8AjNvXuSkvtwkwFbgY6liVEfNh6gtnBmh1IGeEHK3yuVeuEzG/ulRK9t+jQ6bDytRVzI0X2YMe893SMSg9XSvuGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658658; c=relaxed/simple;
	bh=R8MOH2GaH5XgafF5Z6yAffRX/TenLEOe0lj8ZzNEvTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGVmB15VbX7h7nnjPqwdTAAxEylBfgifSzzEgDZBDY1+9RKamYjNxNfxNUKboGvJbmBg7jnBGWYMhIwqoBgFy8ZyD/Xi8s/AJGS6iiiDCNppgmpRNdO1gCV1rCR/2G7PfhiQa3Je5gnQWIa7dIkOgqM5TVvvpsGE0mw17vXNhVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vdzKfRJ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vdzKfRJ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBA41F00A3D;
	Tue, 21 Jul 2026 18:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658657;
	bh=VAKyHBtwA7MQ/UvwZAwkVZBkuUX53nX6ImrYajZh/ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vdzKfRJ3nyW1k9QhModXbvg9ayCLlbIbBp+xY6Km5h1sEATC7x1GZeHdaYWiIRf2T
	 /dOkwR/rKzxG/sx3HGjngiuBvyOdp6Z+StRmAzSeVTS6kIdRcCvJhycL4svcXEl1JZ
	 oC15fhE8U/xLyVL/ooU4aQNQnc2gSOnv25p9oeyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 1226/1611] MIPS: ip22-gio: fix device reference leak in probe
Date: Tue, 21 Jul 2026 17:22:22 +0200
Message-ID: <20260721152543.013488294@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


