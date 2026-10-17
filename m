Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031D53876CC;
	Sat, 17 Oct 2026 17:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256880; cv=none; b=Hoe32vidO8L5tGe/NaV4Q8QVQ39AXvbFgUP5CmFLpQXLMgMXfcSc6uBXRjwlbIo5TsP4KhFF/qaUD5RfnFIJbySwiAmILIijBP54KleNaMcxackT9U7jfXoHXzdJssrBIR2tVzptN6hQkcO1rYO6Zk3IsO26dvGgQBpOLvqavnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256880; c=relaxed/simple;
	bh=/Gz2ZpyNj0YyAqXOWhwvMp7DDBtriD7iHqjMMpymhrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSTdcWzxltNU663J8xbuoZ1Y0zXp24Bgy3n2oHOFnTgLQRC5jpGIgT+nNnZ6Xp5QjbpmoAP8lnc18gw6+g4jN1lGcEIOxMe2BTKdsB3NEx3vrZIwHtYAqMWZKTfVXGpmuVaOz0kotpDdvSUHF+ZrbKX8e6EXwGc1OH76ojZtdP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BRmnmIjN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BRmnmIjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507A81F000C5;
	Sat, 17 Oct 2026 17:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256878;
	bh=Jc5gz3vrj3af+aZ4oFMZ//ojfM/t4p1EhMXGykOg3Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BRmnmIjNB1k549oyswDTWzzGzupYsV8Pifx1oxBOmtP2MtOw/2bU9kmZLFz1IZMZ/
	 k/6ENTORmTQqqIxv0Hl/dN4sL6luaQyBEeJWnu1XmhOtpE5io3zLk8K5QKOu65LHBU
	 qLJFoYlTBCagNLYwVB08wsfGLuMSRhauAeF/RSQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arkamondalofficial@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.6 0344/1674] iio: gyro: adis16136: fix unprotected debugfs reads
Date: Sat, 17 Oct 2026 17:43:36 +0200
Message-ID: <20261017160439.958051037@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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


