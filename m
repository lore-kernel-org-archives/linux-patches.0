Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C693D169AD2;
	Tue, 16 Jun 2026 18:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635116; cv=none; b=GS3BQv0HO21s9bLpggpvYy6QMRO124cEKF4Bj6jTKwo1kpfChEsoO5fyRvhYBxW/qEzkrOwByU4OJF1QUisxHtESwWLM3WxmObLWn5aDDCc0xRYoYWXlmQYGUHhs6ubjT0xEW/m4A/th3r+fLqIxW2MXnwpHWN8UskBj4WwNmKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635116; c=relaxed/simple;
	bh=kCjodx5rnAF73DKLTHeI5++55/1TBQBvn+sgqePOcco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTukwRcEb9QRLG6pSlyeGvGuEdGkKByremAjlXn16wx7m+lzOvc8vipCwk4Ic3c0Go8Z//pkXjV9weX5RBvYFznCufmAPAl0w4YEZKDevB3LrVgvtJMOXmkcYxnwjPvwYKPgHwoS0zvaPyyGHiKlHZmVca/dypJN7xSHlWrhF5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYoiYJRf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYoiYJRf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A119A1F000E9;
	Tue, 16 Jun 2026 18:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635115;
	bh=SHVHQgj14GIDws6lRlwReuzrvIEkkI3jIHaqFY8JDyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hYoiYJRfKHSrJtfR0+J5yZu7/glpl4P39YbuE7pKrFGMb76XFrzMkal/vJ4QRQn8O
	 hghxMgDm9FjS9LkgzizQCMhV4hvomfJs0eqRrTjrXwjG0KRiXIqTOvfaK5Hx0m74ov
	 xhSgEs0D7mrdIvIkNapSMAK54jj5ken7PW29bFX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 366/411] iio: chemical: scd30: fix division by zero in write_raw
Date: Tue, 16 Jun 2026 20:30:04 +0530
Message-ID: <20260616145120.788086459@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

[ Upstream commit 5aba4f94b225617a55fed442a70329b2ee19c0a5 ]

Add a zero check for val2 before using it as a divisor when setting the
sampling frequency. A user writing a zero fractional part to the
sampling_frequency sysfs attribute triggers a division by zero in the
kernel.

Fixes: 64b3d8b1b0f5 ("iio: chemical: scd30: add core driver")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/scd30_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/chemical/scd30_core.c
+++ b/drivers/iio/chemical/scd30_core.c
@@ -257,7 +257,7 @@ static int scd30_write_raw(struct iio_de
 	guard(mutex)(&state->lock);
 	switch (mask) {
 	case IIO_CHAN_INFO_SAMP_FREQ:
-		if (val)
+		if (val || !val2)
 			return -EINVAL;
 
 		val = 1000000000 / val2;


