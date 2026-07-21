Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F7225B0AB;
	Tue, 21 Jul 2026 22:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672395; cv=none; b=gX0AF6obs3g+ImpccOdIY8MH86t4riRWb5KXgrIorc2eii3WsFuRUQTm6VLgNARHTKw/qNBIKAN7nNRYByzz+4mqXOHSZZlvhGVeDyZuiwgMqQC5DyiTA86SFOLDIi5PLws3GvClJmn9TA4C0jpVmdK0MTb0Yt6mRa7F5gxHulI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672395; c=relaxed/simple;
	bh=3un6et7LF0q9I+QjE2vxn8gOWw3qasg7TpnXrsxJBdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shiXTio/TTroHco/NJXL3AbrHDs9w2KRUt7hrr+YgQQp92RpaZ9U5mj/OLLnciH20tEYb2qtUj6QfeidObN3eX6gAYsQ57TRfwj7ihVou5VaRHRze3wNStAhVZBeolfwSs4vpmdQSmtyCn8MJIcP4EhpDu7z/+hKREJXA16A7qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e39D0/1n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e39D0/1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6371F000E9;
	Tue, 21 Jul 2026 22:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672394;
	bh=Has6NIZ3as0ovRK3X1QCJ/EPeyJHyUNx8jMMdmlqkCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e39D0/1nMUHXirk3MRg0Ryjfvz3RHkon4uMvts2zhvot4kkmzlrZKnluFmtCgA1eq
	 uiT5dZ+SYYH9pewOQNybKVrDAvZjhg62hqkCRn9c8tK6lmtbIJ5LcyZSChqwJmerfb
	 iYzvD3LCjZu7QydVJ/pJ8e3NcuXLxial3JaYYB48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 608/843] MIPS: ip22-gio: fix device reference leak in probe
Date: Tue, 21 Jul 2026 17:24:03 +0200
Message-ID: <20260721152419.728877233@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


