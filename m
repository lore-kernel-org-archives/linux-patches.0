Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309DC4D9F7D;
	Tue, 13 Oct 2026 12:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895345; cv=none; b=nb6TY0KqVD7TEPflY9J7BA6MGzTnrYIRUZSVvDbnH57Wh1sVi0tuiYwXKTkBm+NyR63gDC5tff0q/+MlY7jf8xN2VSkqYJ1aqj7zPgRcgTynjy1WO3yatvRCiLJ0eTNJli3ojSFeCeL5+a1FtMDYPCR1+8epx8uGaw7REkqNeTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895345; c=relaxed/simple;
	bh=gBAamRQj4VNVm+wbF1E6uXsO9jmv8DRfEugvwEdiYkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKK+7vl0eKXBNMKuqeN4zQ/aVX6u005CskeFZVYBZpuXlratdiMXArqdAxBxtZ77kjDlksiVBwmLTy7ljDk7BWPKnc+8jsIqw95GTSp6+VVBoUunHuxDBWb+tsTOr1bQVW36X9+yKFNif92vqczYymaYQZbVHPzL3d/Ft+a1qkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bmMmZM4O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bmMmZM4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887771F000FF;
	Tue, 13 Oct 2026 12:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895344;
	bh=8DVrGo83i7673ACQzcdOUfxwEvKSpB2Q3lJxxP3iPJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bmMmZM4ODYEeAQvmy1UQvIvS899I/xff1Wz/O8XMgjEIOXQfZd3WNSu+VWHeOPOzU
	 GbHgtqbgkLaLeE8ue1smH8J7NgkdFNX9Ggm8DSa1TEtTQ3LXYIDNrrvoauU154Wz6T
	 Ziv1AswfNbqPHyOL60G/5v1GqvrMcD8ZJjWxZv3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arkamondalofficial@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 244/497] iio: imu: adis16400: fix unprotected debugfs reads
Date: Tue, 13 Oct 2026 13:36:51 +0200
Message-ID: <20261013112913.687328687@linuxfoundation.org>
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


