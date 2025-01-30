Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9236A1DDE9;
	Thu, 30 Jan 2025 14:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246685; cv=none; b=jds9j7XfAa0LEI6cME6nci+NeT8aAUH6w5YZKyBwwan04D1IQtH9e1R73Z85P1eWtibtt6WNqhirGLWe/C1oI4/Tv6mFCgRenZMtvtI0RPwcerXMvwrxwSeddM2oai8RWUjnyQvGOgh3OueDX1eka61wd8SLRssPV4QCBT3luBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246685; c=relaxed/simple;
	bh=pYll21GBMmtwMIv9HmyTMRWpUKC91QRts+lUovJaAaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uhk4a1amGNVdKwZaX9lk9APiKAh5hClaN8b7gorZ+5au9ZD4X3l/uhaA/0yoXAh+F/GT0K0BeVriS4j1yx2IW11lPYiUEZ+5yf2aV7SHKyaessdPY4nYwBFDfF1pM8OG6GiH9aYOOq7eHwL3X+aOpRNst+hsdhCgxUE/hGWeS8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E9IocjdT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E9IocjdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212D1C4CED2;
	Thu, 30 Jan 2025 14:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246685;
	bh=pYll21GBMmtwMIv9HmyTMRWpUKC91QRts+lUovJaAaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E9IocjdTbszcsDSzPgcvTITKT6++R+ExANP2jgvs07CWGFrahJjaoYhID2kpmzRtQ
	 3TO843M1QqwZPtMBwk4DByx88qJQ9vP1d6XwKmuvXZcrch319LOfQ55Ve56UvsOyTO
	 OofkaK1P5R/TgeoXkeezHUg7Cnlv+GuklOlNw2p4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 32/91] iio: imu: kmx61: fix information leak in triggered buffer
Date: Thu, 30 Jan 2025 15:00:51 +0100
Message-ID: <20250130140134.955098774@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 6ae053113f6a226a2303caa4936a4c37f3bfff7b upstream.

The 'buffer' local array is used to push data to user space from a
triggered buffer, but it does not set values for inactive channels, as
it only uses iio_for_each_active_channel() to assign new values.

Initialize the array to zero before using it to avoid pushing
uninitialized information to userspace.

Cc: stable@vger.kernel.org
Fixes: c3a23ecc0901 ("iio: imu: kmx61: Add support for data ready triggers")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241125-iio_memset_scan_holes-v1-5-0cb6e98d895c@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/kmx61.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/imu/kmx61.c
+++ b/drivers/iio/imu/kmx61.c
@@ -1198,7 +1198,7 @@ static irqreturn_t kmx61_trigger_handler
 	struct kmx61_data *data = kmx61_get_data(indio_dev);
 	int bit, ret, i = 0;
 	u8 base;
-	s16 buffer[8];
+	s16 buffer[8] = { };
 
 	if (indio_dev == data->acc_indio_dev)
 		base = KMX61_ACC_XOUT_L;


