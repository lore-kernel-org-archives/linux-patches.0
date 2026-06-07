Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653E12E7179;
	Sun,  7 Jun 2026 10:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827762; cv=none; b=bteNS/D4xNjH+TTtuMQvjgd0pdn7FM5u6Iuts7/cf9l5ATEbdiKbf/4Sna1pioKe63m5MbVR5JXDiheL6Mdsabxw5ZL3JasZ0CseiLQS2KvTUWtDeQB1wQpg1gLpTcYdFZ2Y8PnChturRfoEANNCjaakeDmy7Ycfyz58BZ18sn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827762; c=relaxed/simple;
	bh=ygYd+bNrp9nZSSwsfHGYku7WB+8KGX5fDQbyCOAFJaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aq//YbTJaQk4uqatKdF7ZHJyYDcUCrAwL279puHFY2OcvxhfTH9GEqXWTZp2RA1yxPF+RiY6lTo7cR/OMXuVtuKrWIDKf6IFSvAT4Sfzj58pgrc7KJUbtVaCLVhF5uuSauXj1QCdUhTi1RPIBA5aBEXKaVw0h3n5jNdr5q3nVE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bHjWdSpd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bHjWdSpd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4F31F00893;
	Sun,  7 Jun 2026 10:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827761;
	bh=dpe2jekmI+4xriABGFW27e87on3A7pWLKemtYMofJWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bHjWdSpdFWTmsbgHeypChnZWX3k31L0qXPVvExtmNuNCaO41WDwqCIRP3CPDNEo56
	 NxB35+UWaeDlc8QVtL839km/ucBzDEU02AKdxtjbsHZeLxNlZ7gVNf2YPSVmq3Y2Go
	 np2LZTE3Fp5o2wGYXmxvRBlW1QyEFPdlEnbKf8mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jic23@kernel.org>,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Andy Shevchenko <andy@kernel.org>,
	stable <stable@kernel.org>
Subject: [PATCH 7.0 120/332] iio: pressure: bmp280: fix stack leak in bmp580 trigger handler
Date: Sun,  7 Jun 2026 11:58:09 +0200
Message-ID: <20260607095732.517046828@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 387c86b582e0782ab332e7bfcd4e6e3f93922961 upstream.

bmp580_trigger_handler() declares its scan buffer on the stack without
an initializer and then memcpy()s 3 bytes of 24-bit sensor data into
each 4-byte __le32 field.  The high byte of comp_temp and comp_press is
left uninitialized, and the channel storagebits is 32, so two bytes of
stack are pushed to userspace per scan.

This is a regression from when the buffer lived in the private data, the
move to a stack-local struct dropped the implicit zeroing.
bme280_trigger_handler() was fixed up to handle this bug, but this
driver was not fixed because there was no padding hole, but rather a
short-fill issue.

Fix this all by just zero-initializing the structure on the stack.

Cc: Jonathan Cameron <jic23@kernel.org>
Cc: David Lechner <dlechner@baylibre.com>
Cc: "Nuno Sá" <nuno.sa@analog.com>
Cc: Andy Shevchenko <andy@kernel.org>
Fixes: 872c8014e05e ("iio: pressure: bmp280: drop sensor_data array")
Cc: stable <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/bmp280-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/pressure/bmp280-core.c
+++ b/drivers/iio/pressure/bmp280-core.c
@@ -2616,7 +2616,7 @@ static irqreturn_t bmp580_trigger_handle
 		__le32 comp_temp;
 		__le32 comp_press;
 		aligned_s64 timestamp;
-	} buffer;
+	} buffer = { };
 	int ret;
 
 	guard(mutex)(&data->lock);


