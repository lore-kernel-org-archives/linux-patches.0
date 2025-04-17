Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FBF256C7C;
	Thu, 17 Apr 2025 18:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914375; cv=none; b=ai09zCRnS+4xhX0QBvCEqFT9/AsPbbNyt6VtZQqXryq/izAp59msgjeReUq8mISku3CYTTeBqEA83ZjLRlOdrSY1E/j6Z6UwqT8GyYTBZrCWZgzNyTolnV4Igtax2/5cBYwqRVChiwBsB4hPeMTI5W+N6rbiP7iYxYw6pzvm86k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914375; c=relaxed/simple;
	bh=c5Ci5tSbR7G5t7fbK1PcCKo3yaz8Zk0uaMHmzCeZfuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqyH5nTwOs+Nk9dyhPyvdjkqY3DxD/Dck0Iup5T9dCqZIF9cDcda5G4wGUyZvDlFtle1kWro/Oue9wAU5rRhKu1trCsTAJiH7mdDg7Oa306/Rqd5mHvj6OU9+wO+KhftZ3I8qTB2otD9Jc7h6HYpJIF9ZkFRrgO6N8JL+4mgkpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PlLvgNaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PlLvgNaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369C4C4CEE4;
	Thu, 17 Apr 2025 18:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914375;
	bh=c5Ci5tSbR7G5t7fbK1PcCKo3yaz8Zk0uaMHmzCeZfuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PlLvgNaHG7V9Nrg1Lje7WKft2GZ+XtoYoPJDkQYiTbmMnaD16jPmSxwthqI0mNscO
	 t06wUiflR38sMr5UUpK9IbYorTYL4pBHiZOaewYiSIFVNnxzXS5bY68R4Ov7vjVzAo
	 KfLESKJybOp/kwXXOT80DZxxEYdloptZqMpN3ry4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.13 195/414] auxdisplay: hd44780: Fix an API misuse in hd44780.c
Date: Thu, 17 Apr 2025 19:49:13 +0200
Message-ID: <20250417175119.284081024@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 9b98a7d2e5f4e2beeff88f6571da0cdc5883c7fb upstream.

Variable allocated by charlcd_alloc() should be released
by charlcd_free(). The following patch changed kfree() to
charlcd_free() to fix an API misuse.

Fixes: 718e05ed92ec ("auxdisplay: Introduce hd44780_common.[ch]")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/auxdisplay/hd44780.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/auxdisplay/hd44780.c
+++ b/drivers/auxdisplay/hd44780.c
@@ -313,7 +313,7 @@ static int hd44780_probe(struct platform
 fail3:
 	kfree(hd);
 fail2:
-	kfree(lcd);
+	charlcd_free(lcd);
 fail1:
 	kfree(hdc);
 	return ret;
@@ -328,7 +328,7 @@ static void hd44780_remove(struct platfo
 	kfree(hdc->hd44780);
 	kfree(lcd->drvdata);
 
-	kfree(lcd);
+	charlcd_free(lcd);
 }
 
 static const struct of_device_id hd44780_of_match[] = {


