Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE06233722;
	Wed,  9 Sep 2026 14:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963608; cv=none; b=SdFAY4uVPWfyyzx8Lyty3y168NLOyOGn5KMpdEnHH2qWl4dPI9iQys4VpFhLjHB3IacevveBI5uiybuud3pW/PcS/Plp3NEnF/ZG9vGxkR0SMqh0fkBoV0JqG+iMqBG5NeKWovTRM6Ep8zULCPzfXQ+Dbr/KDEsHDRRxQttGd2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963608; c=relaxed/simple;
	bh=+fBBwhcjvg/yOzYSvCLEKo9qg/V3u+hD/HWmyxpZJzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gd1evDL9TDFY2TwdHzsVlm6PVzHFc3QvYcKcWorWzp08Jo5Su7pKuPkGWA/uAH2/g2D29Ie+lzr2twYNMtaNx8eZCr4xQ5jHgtWdSQTbm9YaVGReBIrUbFnE49h+lt5fk+eXA69lM74G/dz7gtlayrr/ARdVA8hpA6/vAxcT25M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hbSpFXJF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hbSpFXJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5111F00A3A;
	Wed,  9 Sep 2026 14:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963606;
	bh=hy3o77qqfMWiXbDov6xY7Q3OPp5YKvr1hScbFJMsu/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hbSpFXJFq5SIcgCnM/tXyu7FI8eoEZE25tji9PPZ/cRQklNvdW3HbBxadhPIBgpcP
	 oPBvYVib01qZoIWkaPEEKT5+CWkaCc0KQ2H0rA8Ju7DfB1a8vcWzZCEWxnAN2YkiQP
	 F90Ox3uTwP+viHcahq/JwV/JziRmEU60RXQ7Ql6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.18 137/583] mtd: mtdoops: free page bitmap when the backing MTD is removed
Date: Wed,  9 Sep 2026 15:37:02 +0200
Message-ID: <20260909134242.892666904@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

commit 956e7da12c114f13c63d126ab1d79c3b6a819060 upstream.

mtdoops_notify_add() allocates oops_page_used when the configured MTD
device is registered.  mtdoops_notify_remove() detaches from that device
but leaves the bitmap allocated.  If the same MTD device is later
registered again, the add path allocates a new bitmap and overwrites the
old pointer, leaking one vmalloc allocation per remove/add cycle.

This is only visible when the backing MTD device can disappear and be
registered again while mtdoops remains loaded, so the usual static MTD
case does not expose it.

Free the bitmap after unregistering the dumper and flushing the pending
workers, then clear the pointer and page count before a later attach can
allocate fresh state.  Clearing the pointer also keeps the module exit
path from freeing the same bitmap a second time after a remove event.

Fixes: be95745f0167 ("mtd: mtdoops: keep track of used/unused pages in an array")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/mtdoops.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mtd/mtdoops.c
+++ b/drivers/mtd/mtdoops.c
@@ -392,6 +392,9 @@ static void mtdoops_notify_remove(struct
 	cxt->mtd = NULL;
 	flush_work(&cxt->work_erase);
 	flush_work(&cxt->work_write);
+	vfree(cxt->oops_page_used);
+	cxt->oops_page_used = NULL;
+	cxt->oops_pages = 0;
 }
 
 


