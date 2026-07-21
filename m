Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FA144AB9D;
	Tue, 21 Jul 2026 21:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670101; cv=none; b=O+tK3ki99pgMfeK9Vom+k9NvYk2JTpjOcedQ7qVgiggwXTuBUrGVwVwrqTo0oIiTOrS0dsi5WhMv1+0ebhw+R4T6ZIpfYSbBB7L1halw4PC16GwQd4oVK0ryhdPd2f57xuSLo7ctLDjbTiBRNS89jyK16wHVZyWGkwN0o5v70M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670101; c=relaxed/simple;
	bh=i4dnYukC0I0xC9TADT8BwlBp/ZKk0iR0CdrzDlbAwJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEEytZJCVPapFg/oCKv1264Rw3C87n2emLldnVcp5dBpDPuMfeAqBqT4RURAKp3k2yuPNtJH25bFISuYU0pRaKrM4pS33WDf61nbAXG9pXnaS0iOzUnD7rw8x0pePPR7wGimc5Wxr/x3ovSx8AQIGmZsvnNExX5H5nbj6+swISo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gpRrrGdo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gpRrrGdo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85BE1F000E9;
	Tue, 21 Jul 2026 21:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670100;
	bh=HdtUDEx20P1Eok/6qHSCw+2+wMInadcQ2CEv+1U63Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gpRrrGdoRPU6SUeXMoi2Ok3tvUHe2DzQkfGYYMeu3FUFFGFqvXJn9PPBmdDGshOS3
	 aP6NTr3LaJGOsDIDlTtPEFTWL+3T0N2q6YZ0qBfuSR6eLzQpHeoaDmNhWliss0BPW0
	 Gg9iw2mxeHcotnFD+WkQAw+ixtpEbFYNZmPOkRAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@rulkc.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 0806/1067] mtd: rawnand: fix condition in nand_select_target()
Date: Tue, 21 Jul 2026 17:23:27 +0200
Message-ID: <20260721152442.588348937@linuxfoundation.org>
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
@@ -175,7 +175,7 @@ void nand_select_target(struct nand_chip
 	 * cs should always lie between 0 and nanddev_ntargets(), when that's
 	 * not the case it's a bug and the caller should be fixed.
 	 */
-	if (WARN_ON(cs > nanddev_ntargets(&chip->base)))
+	if (WARN_ON(cs >= nanddev_ntargets(&chip->base)))
 		return;
 
 	chip->cur_cs = cs;


