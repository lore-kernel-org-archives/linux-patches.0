Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9643D34A2;
	Fri,  9 Oct 2026 14:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556971; cv=none; b=iaOqc3TBxfoz1X9FwjfszXQ7zWLgwSTFApqPu+8J83vCJQy4TrR/QbuGurDj3jagSP6jqLMYm5oiAEBdTmxkWIKJixvhQwKeKRNAMBhEVUqKnC6E7pHBo1TnX/SlHT2r7vr20A5DtSIAFaL4gv59P8pegwpRrbLvONtMi4W+/Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556971; c=relaxed/simple;
	bh=VlXR1wHJG0aTW+zDzOpH/szsuPu3knNFc61JuZwe9EM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/o8HXcb6kd4GecE6pzPQEU3ur48w6otrJ5TjNZwYj0YKDP5waLn86pjt8umQAOJa5ybOkTXQ8V+arj4ovNa+3gh3Uwc1EZ/7TiNVRB+uGKN1o2Fruf7H2vse1yY1Qy1RhWTRXQfAj/bHeXQBDc2rn6UgbMAciJo93y++bLjxeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMg1iYyq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMg1iYyq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3641F000FF;
	Fri,  9 Oct 2026 14:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556970;
	bh=foRCHARXLZ3nDmcn6Jq1iyPsDoqFmEHQzTffP1SUzFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pMg1iYyqy7JWkvXqZ6FdJk0DzUQG7wmbpfTCWP3CF5ad1xIcLv9VLEExmcF8ePe3r
	 6sI3ARXVfMZ9L0E2a4jPocUcq08OaeN7/oUipVfSaHUUPisGPG3+SsOx3boXUGTnBT
	 6hQPMJkmbWdYtXRzY018e4Od2e1Xihn5hEf3XBq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arkamondalofficial@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 326/403] iio: imu: adis16400: fix unprotected debugfs reads
Date: Fri,  9 Oct 2026 16:11:27 +0200
Message-ID: <20261009140959.857073222@linuxfoundation.org>
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

commit d94787287a113a1326211647d5e0deed1e9de105 upstream.

adis16400_serial_number_fops is open coded and never calls
debugfs_file_get(), so debugfs_remove_recursive() does not wait for a
read in progress and unbind frees the iio_dev underneath it.

Commit ae1d37a9bb4b ("iio: imu: adis16400: use DEFINE_DEBUGFS_ATTRIBUTE
instead of DEFINE_SIMPLE_ATTRIBUTE") converted product_id and
flash_count to DEFINE_DEBUGFS_ATTRIBUTE, which protects itself, but
moved all three files to debugfs_create_file_unsafe().

serial_number prints three registers as "%.4x-%.4x-%.4x" and
DEFINE_DEBUGFS_ATTRIBUTE() formats a single u64, so it cannot be
converted without changing what the file returns. adis16475 and
adis16550 already use debugfs_create_file() for their open coded
files. Use it here too.

Fixes: ae1d37a9bb4b ("iio: imu: adis16400: use DEFINE_DEBUGFS_ATTRIBUTE instead of DEFINE_SIMPLE_ATTRIBUTE")
Signed-off-by: Arka Mondal <arkamondalofficial@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/adis16400.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/imu/adis16400.c
+++ b/drivers/iio/imu/adis16400.c
@@ -280,7 +280,7 @@ static void adis16400_debugfs_init(struc
 		return;
 
 	if (st->variant->flags & ADIS16400_HAS_SERIAL_NUMBER)
-		debugfs_create_file_unsafe("serial_number", 0400,
+		debugfs_create_file("serial_number", 0400,
 				d, st, &adis16400_serial_number_fops);
 	if (st->variant->flags & ADIS16400_HAS_PROD_ID)
 		debugfs_create_file_unsafe("product_id", 0400,


