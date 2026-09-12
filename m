Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD48305680;
	Sat, 12 Sep 2026 14:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221621; cv=none; b=VCbkb76D6YMV35y6ugWK6pDyI75hvHZjdch7wHAwkwXSu0Aty7cu71pQ7eVYgBSEk6/rli1jidn6N1wmA2zZi5BJnPLyF+FiXR9r4bauKnmXWcuCpkqSym4ysvAp/nBbZ1ivvTmM1rLV4CSU0S5xBERzEOcOABFmCnqhVd8kD38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221621; c=relaxed/simple;
	bh=+GhwktDKUYGJm0PbRhCz7IRE7M3mKAjdDboY8Ky9/uI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KD5pBty1V4DC5SWDQLNJuLzUqF+x7BYW5iU5IQVRciQtifw7BJFo1IyRQlr8UoSeYftuReFkZL49XMc3p466Q+FMrAGm3uEUrSdQiX6EOFY68Z0OoRl0xu1AzF4xQrC3Q9rH72YRZVOSbX5AwSVgNxByA+ZYsnjdOCJXL1Ykuxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iDD1Oe85; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iDD1Oe85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324F41F000FF;
	Sat, 12 Sep 2026 14:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221620;
	bh=Ghigoa8FEVbiURwTbFmcpXzUG8bzLaVtFZtlvmJ/SzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iDD1Oe85M5yH/6q4fEU+NiTRHwi16UTNr5iaVN6+WNjfKYuSdvfCZc1splhW/jTQA
	 cFUDrNHVoAH51QZ5IT2ubR+FW5FhoUmqmytedtUbSq+jdO6iR/dLbRb0JplsMUkQ7d
	 fNo+SwUic0HgcAufizGmgdszN9Fy6RXtzhMaZwJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 0393/1424] mtd: mtdoops: free page bitmap when the backing MTD is removed
Date: Sat, 12 Sep 2026 08:47:05 +0200
Message-ID: <20260912065616.090422570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
@@ -393,6 +393,9 @@ static void mtdoops_notify_remove(struct
 	cxt->mtd = NULL;
 	flush_work(&cxt->work_erase);
 	flush_work(&cxt->work_write);
+	vfree(cxt->oops_page_used);
+	cxt->oops_page_used = NULL;
+	cxt->oops_pages = 0;
 }
 
 


