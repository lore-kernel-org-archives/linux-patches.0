Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980D54502F;
	Thu, 17 Apr 2025 18:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915646; cv=none; b=ioQ67E/inToYNky5JwIVZfHhGrj5WEWB0bdNtDApShzx30lSvQbmCE2i/jO/oSjQp5Fh1tTNUpUUprQL2S/3zO7M3HbFXEjv09Qi6clRhGlkn1qYzCPlgRxKizbmOWaMQRHusGJ+5WjeTlwM5kY7twVyS6HUFWNXU9lpbDK/Ykw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915646; c=relaxed/simple;
	bh=9J7uXUVgCq8SGoBbrl6pDp7xdYx6yxaxN0ckMq8chIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5SJbUXkoWXppWXR4RMmGlVyaywRdhxswqw0G3v/sZLrBlzLPtOZY4SPZ0q+wNuaBYLIk90r4HK87CdNNwM2vCht4SQ0IX64ITAjhENNZurEEXg+AJpuyi6R3sHTdnH9g59iEn2dYBJcIiZerprtXWJw+svYlGAyA3VZ+AAmKbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1j6wT9wT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1j6wT9wT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE70C4CEE4;
	Thu, 17 Apr 2025 18:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915646;
	bh=9J7uXUVgCq8SGoBbrl6pDp7xdYx6yxaxN0ckMq8chIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1j6wT9wT5tGaAmlD6TZEA6XDy9jYkFC0i2buqmm6hopuvgwEBYuBtn/bqwCvSvPiq
	 PZRXDTbaQ6a7FTs2/FGsuUydZDPsX5R1bayBYaL1LIfOrz2LYi7UXUtIUOuby+hNXi
	 wsoYIR0szM8FTv5z/2oiiVXcM4sG3HFFzyHMstHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.12 187/393] auxdisplay: hd44780: Fix an API misuse in hd44780.c
Date: Thu, 17 Apr 2025 19:49:56 +0200
Message-ID: <20250417175115.111625011@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


