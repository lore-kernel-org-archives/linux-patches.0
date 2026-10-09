Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8004F3D34A2;
	Fri,  9 Oct 2026 14:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556960; cv=none; b=lTIxKZOryflqDnk688DurcMWzffWvcBnzVJvEY8bSMGdLeXWgjDTwDwM2ivZke2RNbqw0rotfMRkFRquFXaR2Klf/D+NM0UetKuad080l5FXVhgEuH7+vgjpQB734/xVaAiWUyoCjDn05Co/2ABprmcvl/bqC8L7dBmiDxR2vIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556960; c=relaxed/simple;
	bh=v0UK5OfsPpvHDMn65Coa84qu9a29p9uYiBizerZ1JBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AhbHwpbreARUZPPsb/g2SrBos5fr78XBND3xLYVU5NXM8kooPhzw5rHk1LgZRioAv0DaDhkCEcqDIc3ExJPSC3YYnkvK4FteezqvGbnGkKU2zXJPgFu886Q0BEVqEdXmBegpyVjWXMsWKqzJsjH1gmw31G7F2E2tAICN4i3tr+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZC5VsbNd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZC5VsbNd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44391F000FF;
	Fri,  9 Oct 2026 14:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556959;
	bh=NiJ/aDoAnTqIyzIP3vcxDUD+Qy6MVxs2A5TcWwT8AVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZC5VsbNd8stytZxOlM5WKpR+7ZdPUnfU6jpXrLczpF4munpBemAVxObik/yAztKQI
	 x6LtUwV5yXtZRtm3jabNV7BExeJdRhKB4WLtpXLVzKYHbZmxDRchJZqyRJYDM7dAiE
	 62LmPwkSqxMcm51rplrEZXOHVSkC2uiiz1E3kHBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arkamondalofficial@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 324/403] iio: gyro: adis16136: fix unprotected debugfs reads
Date: Fri,  9 Oct 2026 16:11:25 +0200
Message-ID: <20261009140959.807729709@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Arka Mondal <arkamondalofficial@gmail.com>

commit 2b498df75d6c29aa3e760127ae0f0003df598b53 upstream.

The serial_number file operations are open coded and never call
debugfs_file_get(), which debugfs_create_file_unsafe() requires.
debugfs_remove_recursive() therefore does not wait for a read in
progress, and unbind frees the iio_dev underneath it.

Use debugfs_create_file() instead.

Fixes: 9aaea09b4cbd ("gyro:adis16136: fix debugfs_simple_attr.cocci warnings")
Signed-off-by: Arka Mondal <arkamondalofficial@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/adis16136.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/gyro/adis16136.c
+++ b/drivers/iio/gyro/adis16136.c
@@ -145,7 +145,7 @@ static int adis16136_debugfs_init(struct
 	struct adis16136 *adis16136 = iio_priv(indio_dev);
 	struct dentry *d = iio_get_debugfs_dentry(indio_dev);
 
-	debugfs_create_file_unsafe("serial_number", 0400,
+	debugfs_create_file("serial_number", 0400,
 		d, adis16136, &adis16136_serial_fops);
 	debugfs_create_file_unsafe("product_id", 0400,
 		d, adis16136, &adis16136_product_id_fops);


