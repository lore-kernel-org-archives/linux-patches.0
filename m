Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31811DFD1;
	Tue,  8 Oct 2024 13:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392633; cv=none; b=QQNBar+PecDe3uyFxijTN4oW6u74V767VKztawny0qH2efdmsmhA3wVwhsDc0RWkYFMSpzJnKG62NbyOP6GLA72houWmKPyYGkcPQIXIXxjABd5Znpv6qpxT01IzqZwq/fWORDULGCecuRtpMgRsJYATZ2t1Nf66lAe5SZ8LplQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392633; c=relaxed/simple;
	bh=Msk0CKqxOEPOuKqZohYtISrQ+n3lLRKmeVMh0+t45Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNSxc6Sb6qTlOCnqUZt4u820zgF+5PvRhlI0feDwwG/ojgSFMuvhDLiyyUVfb1XMbrCiE5AHKenjg+yga/4Nq+LYm4oK4kppQIclDN6JcWGSOppOCoE8N5V66F2MUQUON3/hUHgkkrYj0ny09uPMd0NjTx9QLlU+J55R8Nqtpa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2GqvBDQS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2GqvBDQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C43C4CEC7;
	Tue,  8 Oct 2024 13:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392633;
	bh=Msk0CKqxOEPOuKqZohYtISrQ+n3lLRKmeVMh0+t45Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2GqvBDQSJkfGEXUeEmDezu5VyzineLHU3cnMxGc1CmFn+UKYib382qwNZJUSlwwQk
	 /rKKGLJjnRZId2eg9SG85EHraHQ3hCLCbyYzB4NOQ2DiVlFDYoITo7HdOE6NxlcX6+
	 SbGuj9z4ORNAKHK4zVFq5Sr7T3DUFioHcwD96gj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 472/558] iio: pressure: bmp280: Fix waiting time for BMP3xx configuration
Date: Tue,  8 Oct 2024 14:08:22 +0200
Message-ID: <20241008115720.818792749@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasileios Amoiridis <vassilisamir@gmail.com>

commit 262a6634bcc4f0c1c53d13aa89882909f281a6aa upstream.

According to the datasheet, both pressure and temperature can go up to
oversampling x32. With this option, the maximum measurement time is not
80ms (this is for press x32 and temp x2), but it is 130ms nominal
(calculated from table 3.9.2) and since most of the maximum values
are around +15%, it is configured to 150ms.

Fixes: 8d329309184d ("iio: pressure: bmp280: Add support for BMP380 sensor family")
Signed-off-by: Vasileios Amoiridis <vassilisamir@gmail.com>
Link: https://patch.msgid.link/20240711211558.106327-3-vassilisamir@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/bmp280-core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/iio/pressure/bmp280-core.c
+++ b/drivers/iio/pressure/bmp280-core.c
@@ -1272,10 +1272,11 @@ static int bmp380_chip_config(struct bmp
 		}
 		/*
 		 * Waits for measurement before checking configuration error
-		 * flag. Selected longest measure time indicated in
-		 * section 3.9.1 in the datasheet.
+		 * flag. Selected longest measurement time, calculated from
+		 * formula in datasheet section 3.9.2 with an offset of ~+15%
+		 * as it seen as well in table 3.9.1.
 		 */
-		msleep(80);
+		msleep(150);
 
 		/* Check config error flag */
 		ret = regmap_read(data->regmap, BMP380_REG_ERROR, &tmp);


