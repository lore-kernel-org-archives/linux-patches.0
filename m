Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB60478E5D;
	Sat, 12 Sep 2026 11:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213383; cv=none; b=agXZQaI32Gh//nlt7ksGtJ3VsCbJhSNiIwz/V9puINEb/XfiXv9eJRDTItOtUEQpczahnNiyKS5KFHtuFTjUhAfBMqZ2IVzAauSLgPqyQiKYe6welYh8z4qgtVroSX5Pl9GLD4sp3SdTPAtVq7GTq13lcdC7AkUNzAzUERwC8Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213383; c=relaxed/simple;
	bh=yPQIuf+G1q7j3tGlKiQceC43eSwy3Ft/RqZbNzwVSmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAD/KplO+fTPPWmvbiE4kHilcPyHisuAx6QBgmEJjOhdOjsIQbgfHL8mU3m2SNY8BimZQpBlQqgUGV3onBoAA01xVe9KK/kfI5M7JY27u11davRvM0u7K9turYvFLLXpbF1qRdC70HtClbT563QfA71N047xCuBSX/8uMmvpIjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZ9gwaFm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZ9gwaFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79A71F000FF;
	Sat, 12 Sep 2026 11:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213380;
	bh=xbEW1qv8RXMrOoyepzoWuVcNH+Oo91ZGk6eQuvLC3LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XZ9gwaFm8Yfr9N1hl5wZtd/vdcIMtJ86LMNO/YGqzg8/CAzCOmjZwp3wPXy3yK6W5
	 vhVob0HVqM/Pv5BgLDMakWWgPgBVwA8WH4h883hXxUbf+7S/8tIlQZo9neHqLqZ59x
	 QHq3b+aEUFh3hUHW0/HjZrLoiIwsvJbnfIo3huA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.12 0110/1376] mtd: mtdoops: free page bitmap when the backing MTD is removed
Date: Sat, 12 Sep 2026 08:42:16 +0200
Message-ID: <20260912065610.007427443@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
 
 


