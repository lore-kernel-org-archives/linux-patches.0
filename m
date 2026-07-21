Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C5646E009;
	Tue, 21 Jul 2026 18:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658766; cv=none; b=lHWx68As/yJtgBlmqM/yfQ0eKt8kYrRMfZGO6ean+j5/bvR8xm6KwDaE9ko2c9PPKuVqxPiFTM/xPWOU540wOFeU+HscQkpMkdRSihm94nKq1pumbf0n30T9Cs276yWeH7xF8JtXRmtYFMWv77EHJAdN3gJZh0uvuzwfbCV9CII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658766; c=relaxed/simple;
	bh=KZWUTQxSMZ0ytYK/gqAssNLtiS6Dahbn2/4FGyqeU9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctMfpeD08OYYfXMk4R0yYorJLZe/3caE9l7eF0reLP0YMAxWCn3HOHWxSq/DrXGgxbmF2YjwZRMTSSIsJEXMLQEUpU7wrewyaLwz9z+vignYmQ/1UvR+mszToaYFew/BdxNPTcaJ6oaHyUptaZaTRXQDMIJ/Dpoh2ICGmGQL1HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SAjZ5RWc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SAjZ5RWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2F41F000E9;
	Tue, 21 Jul 2026 18:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658765;
	bh=SQ+Loyh+jo9qwu3MPpnMPL81tv1REeca5VZ9yJo2WG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SAjZ5RWcdbIS5Y5DpCvRZ6eqCJo+QanPN9KIL382Kwnncikz4KjSk6oCSi7t5uKM4
	 H5lAT7Ascbgq/pjQI6QN5JjLMHRwE0ZmEBLyYjPKjfY+JZETeOcpmD5OWyPfnft5vX
	 C1/lMO3wvbyKKkRl/3YXBg+6eKE2I8S4Z3YUwIRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@rulkc.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.18 1268/1611] mtd: rawnand: fix condition in nand_select_target()
Date: Tue, 21 Jul 2026 17:23:04 +0200
Message-ID: <20260721152543.968693808@linuxfoundation.org>
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

From: Arseniy Krasnov <avkrasnov@rulkc.org>

commit 8507c2cc9e4fa402401819f44d1e8a5ef4d11d8b upstream.

'cs' here must be in range [0:nanddev_ntargets[.

Cc: stable@vger.kernel.org
Fixes: 32813e288414 ("mtd: rawnand: Get rid of chip->numchips")
Signed-off-by: Arseniy Krasnov <avkrasnov@rulkc.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/nand_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -174,7 +174,7 @@ void nand_select_target(struct nand_chip
 	 * cs should always lie between 0 and nanddev_ntargets(), when that's
 	 * not the case it's a bug and the caller should be fixed.
 	 */
-	if (WARN_ON(cs > nanddev_ntargets(&chip->base)))
+	if (WARN_ON(cs >= nanddev_ntargets(&chip->base)))
 		return;
 
 	chip->cur_cs = cs;


