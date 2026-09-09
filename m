Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20093549364;
	Wed,  9 Sep 2026 13:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962157; cv=none; b=TUW2Yi9r8DP1sNXRTJr4aNvsXAZHSQerlkMSFSIhyymqdRH7mSiX+uIq7Feq0uNL0WyuIg2pSi7M7oHuMta5+GtSL4wNLNPofvPxDnuTSPrx8woUEmLTVfRvZCUM1/0Zrk5MwZ3ffpBsWL/EovqkwAdl/8LWI9E7nMZkZewWv2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962157; c=relaxed/simple;
	bh=+DvlVZ9KjUVnSH1XfDTSA5ZGnC8JeYbUFjb9m4HMnDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RLKVgOZhukBvAiw9ZhaMOirvTZNe6gvcVJzl4HoYILCAf9nSw1socpmna1gy9W7aN7sj99aLUGt20RnKP52s5M+HoPEnNf+iqOGh8qNuz4c8zsARUNIoMJTBHujaRoYQI0tutdd5+isNTYkE2FmMG+MyfLCITfBbApKEzGr4Bkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RUHb1fGv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RUHb1fGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780BE1F00A3D;
	Wed,  9 Sep 2026 13:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962156;
	bh=0+Esv8FUVSApq7yRnTPC8HZBShSuaGl/1lx7OIjkz00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RUHb1fGv8lllN27LZNAe8KJo6i6UTBxYDpiFGnkNcQMiXytCE8UzEnj/cTTa8pC4w
	 ulRpLeNhaAuL75nXHkLTcpyoBNlSkMh8y7Y2YMZtSyW8kOt7Lkaclmm5zZjUJkLDBN
	 hYbooXFHMEe6RyeDM+l6Cn3ZQtvo4vYAXzmQ2Sxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 7.2 193/556] mtd: mtdoops: free page bitmap when the backing MTD is removed
Date: Wed,  9 Sep 2026 15:37:53 +0200
Message-ID: <20260909134237.191734931@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 
 


