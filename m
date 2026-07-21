Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEAA3D3321;
	Tue, 21 Jul 2026 17:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654350; cv=none; b=C41pcgLNUsVet0EWLzyVNb5cCD3m8WyDavdhOE9b+r1kFoBlaLBm5OSNeVCJqYLzyFEXXGRhjm+0/Rv5hD242U1zdmp0Ai4YdlHGWxm0/idYTMKWNToF8AtNrq1wd52sn6tqaqzRxNUXyWIuOtZEPGmvh6vL8RxA9EnoztIlLx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654350; c=relaxed/simple;
	bh=zByce+X5ZW9HUy2fGgqHx0sRQCrHl+RwVWoQs5cU6oA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFhIFosSXE1Iep67hkoETC/dO31yQPjzZPr9IVauezZ5oi4xwnDKEtQj3hcvHsOCx+jIAKLvMjTLUuD2lmX0lhiLWExCjwj0RTaUiat0BePu0jBSJU5VVPdFtSg9rHd95bbnyWzEJRgpA3sSREHXJzX9px2A2EDTsxmtVq/BpIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qCX6Zs7t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qCX6Zs7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9EC1F000E9;
	Tue, 21 Jul 2026 17:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654349;
	bh=WTFaTy9j7wq3y+AzmLjMtEL3vOdWjvVO+iKUHj+4znM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qCX6Zs7tG/Y5YiWv2LupHXfc/YKz3hE+jzetM+BeFnDaMw9ErWRtTl3bO6OBobQ3R
	 dF8JEO0y2l4lXTczVuaLit5unQUmL0xzVB+N1CPIcQCXkQUPLOxDi4j3QGlwQtMNjq
	 WDHy3klUzTZgS2VADbbXeEShQwqBZwIjFNLlmow0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.1 1672/2077] MIPS: ip22-gio: fix device reference leak in probe
Date: Tue, 21 Jul 2026 17:22:25 +0200
Message-ID: <20260721152632.180224514@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


