Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B1A2F260C;
	Sat, 12 Sep 2026 18:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237501; cv=none; b=kJtYXn1mSUOyYp1FCCyocp0dWYbyPGsPEhgtM+Xh71Tsh7GCi8OgR0/xuRGfwPWia1ZRbBQ3ItI4BwiFYdQhSUh0CSqYy/ZIG/lutVGPH/rit5PMumcc6DU/MX/cUcE4KKoVf8lT3bDVDJNrMTDPmDwgEwLpuxPsF96o/oXo9h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237501; c=relaxed/simple;
	bh=e3xt6CbqyuFVpxnYNB0bSVPWyI3EF1DtKt/Veq4Rm/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SMDASlgWJ5PuU7s+1oZjN7pkmKhWnB83FukyiOEmbjSlz5T6W18cA0CM/yTib7uW9EIU1oZDYpK3GW2kNQz021QNjzqVs4lMUe8330WeT71RQD6G9/qZ5HrfNJgXiDGaVjWKjMDGohTgla49lhCEkLr3vcNaTgOK8YSgg3zbC/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qBABxj47; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qBABxj47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7028A1F000FF;
	Sat, 12 Sep 2026 18:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237499;
	bh=0rnBHYdI49OPct6GttDw24Y8Cemjj13UL5yqPxrFaTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qBABxj471b9acLfWVnYWEwT22Gn++HJBx6lngQqckrVb6aQbmsMemtAVDaEdkV8/s
	 8/l4/Fw+/+zRYyTK2pBBG6sGjNbda6sqDy7dsGwXhe0+i4cZ1pCOFH98+uMpe6WhJy
	 n/fth21f9KiA2eTokC0pu+wjEhc6CpZvnZkuOqjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 272/935] mtd: mtdoops: free page bitmap when the backing MTD is removed
Date: Sat, 12 Sep 2026 08:55:02 +0200
Message-ID: <20260912065533.062037013@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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
@@ -367,6 +367,9 @@ static void mtdoops_notify_remove(struct
 	cxt->mtd = NULL;
 	flush_work(&cxt->work_erase);
 	flush_work(&cxt->work_write);
+	vfree(cxt->oops_page_used);
+	cxt->oops_page_used = NULL;
+	cxt->oops_pages = 0;
 }
 
 


