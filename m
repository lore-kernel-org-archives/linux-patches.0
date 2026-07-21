Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FF947141B;
	Tue, 21 Jul 2026 19:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663672; cv=none; b=qnpGVRZmpizQZ4jCBRynUyDPJFzohLrGZyiqo+88flQ+ropVGrHXzK/CI6RUgzXSZFXdD0CWnGENaxPuoqcyXPYwLJM+PWiWK1ZOr1bq3/uiaqzgDRxpfnhgT7CifigGOrTu40I2kKGMatEwKQmonIKl4Wtr304NojX9kdnKUtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663672; c=relaxed/simple;
	bh=VxwFJ3ye8304q5CXaS5mNThbTmM67YtnkwimTT2fyFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7Dof2JatBh/zPuo7DSQhtio75UX1rTXM+kpFsbFCm44l57d2DD3zsNpkw73BCpcoOhsdjzxSKnGdhCxrpt7fESNX0rCwT3fHPycFOCRd+mtMyLTVHois5y92CvikBuUyyB7MH23hVNtfMbz9N2F/t9ag1oOAiEvB8b9aPjJeUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AezV9cT7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AezV9cT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049611F00A3A;
	Tue, 21 Jul 2026 19:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663671;
	bh=G31f9DlPYZOuBRoMYoBeh+UEAo1HY5YH78nMUuo7NYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AezV9cT7a/myE98nJkGq0lx1UuiLZvdYly+fOnaTSK8eOhhyPcvkyxhOTiO5qhs7K
	 P9UZBxw1NkQEp4/tNJtYXrg/+/UOym6OdqXs1c3Cq+yoReBBEqyPt9ExrfRZU7GXPe
	 /5u9JBHA6/HB/4DnkKdVyn9Ek2P9pKQhJ2pe098M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 0910/1276] MIPS: ip22-gio: fix device reference leak in probe
Date: Tue, 21 Jul 2026 17:22:33 +0200
Message-ID: <20260721152506.399194087@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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


