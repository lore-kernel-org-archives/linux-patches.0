Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959C233F5BC;
	Tue, 13 Oct 2026 12:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895339; cv=none; b=HpTBfOwp3NOmHpNFavCFnhSYTV8j1CsWzxD28ERA3xd1Yy4cb3DIHJ1rw1ALP9g6qe5nqM+0ni3ZrDJeJm3Cg0I8KVLXyFLPUP2dXTmM73LsiTE0aIn2cjQ5au28VvCkZm5Yn50sZONsL8vA1iFCbqqVPDJ7VfxnkCWHqr61A/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895339; c=relaxed/simple;
	bh=XTKRpPP81Op5iOHRMpDhCIMQ8lUigzyBLeg5aUicSG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K8WS9+UxUQ/Y3wWssyuv7XpisooeAHMCirZqMFtq9MRbdyxZqXCD8Q+BlLo1pWXLUnnDe7/HHpkgJgXP47aXhxyo228XWgudoIDBLzmXrmZ5Muyt96/yVG2kcBDQyjCZWJsaJ8bksYZq79g4h2BcI0kbaUan3fe9fSv3jzgbYW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJ+YF4yQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJ+YF4yQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E772B1F000FF;
	Tue, 13 Oct 2026 12:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895338;
	bh=wjcN8hWXM+RyljDS3juqSihuXWXhL91WW5eog5EKrjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RJ+YF4yQz1p2psmX54O51+8Xo6wRJtF0ZdFqRCts766+EFIiLF57LV27rPqNxbNbI
	 GmJr/YBR3jBFlWSREjkoff4AHZQrGmVwhpF9A0+tqd8hfaH49UC4vw1pyRsz1QwNz7
	 BcR4svUZ7k+wp5SnRU8T5aQpYJU5NUBsVFbGQCxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arkamondalofficial@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 242/497] iio: gyro: adis16136: fix unprotected debugfs reads
Date: Tue, 13 Oct 2026 13:36:49 +0200
Message-ID: <20261013112913.639526363@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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


