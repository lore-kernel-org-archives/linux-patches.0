Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F8127732;
	Thu, 16 Jul 2026 14:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211701; cv=none; b=huF8UBckDbDEwM/BLdkGiBvdNC+9errfdkF5wTMeY6a07bpb5GLtwSuigF90VdftO5907C9EHPExSTXJXFZin/eGGRkyPUWh1ErJMTQFz7gUcQFFw3IIvi5OvNqWR5CGWA6YffDGv4DRmxhLGV9mLCC4FoG2Hd+Lln0iX7KsdgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211701; c=relaxed/simple;
	bh=Mt4tAI2Z1iNvC6Xg0PZ2isFQYZDIYwPy3pnPWbsyNxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oALRR4wwvoKXNYBRQolq1ISr0EM+dp9aeUddzgPHMPSKE6hOA41uQs1f6Un/3qzQLPxrQJkeUqqRHxcqOE31dQEYfV+WL//majvC5EZOIvMFhOhs1GJAlFgrQkxLDBDt1CwoRnsA3wGdSlhXvuapZYtyBHCnn/vqVEdWKPoA2ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PewHk4mx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PewHk4mx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5401F000E9;
	Thu, 16 Jul 2026 14:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211700;
	bh=9SVM0zNTG1dxGeCRipUvcbQRxt2xMeeJagewJNO4b+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PewHk4mxvWQN+gn44BYWh+oKOqjRDWHh3fAG7PyJvPhR+Rb+tvB1iqDzEIFM1KQAL
	 Kc+OjRU/koIkqnXlsCTY0WIHLuCmtUNoCo7BnfWrCE5zdSGc5wv8AuQrh/kiEYSB8L
	 zk3t4cL5QG1+rsBf6JLdGr4FN++n4sqiD+3KkZ50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.12 045/349] iio: accel: kxsd9: fix runtime PM imbalance on write_raw() error
Date: Thu, 16 Jul 2026 15:29:39 +0200
Message-ID: <20260716133034.331375283@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Biren Pandya <birenpandya@gmail.com>

commit 44a5fd874bb6873bdaec59f722c1d57832fbc9df upstream.

kxsd9_write_raw() takes a runtime PM reference with pm_runtime_get_sync()
but returns -EINVAL directly when a scale with a non-zero integer part is
requested, skipping the matching pm_runtime_put_autosuspend(). This leaks
a runtime PM usage-counter reference on every such write, after which the
device can no longer autosuspend.

Set the error code and fall through to the existing put instead of
returning early.

Fixes: 9a9a369d6178 ("iio: accel: kxsd9: Deploy system and runtime PM")
Signed-off-by: Biren Pandya <birenpandya@gmail.com>
Assisted-by: Claude:claude-opus-4-8 coccinelle
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/kxsd9.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/iio/accel/kxsd9.c
+++ b/drivers/iio/accel/kxsd9.c
@@ -146,8 +146,9 @@ static int kxsd9_write_raw(struct iio_de
 	if (mask == IIO_CHAN_INFO_SCALE) {
 		/* Check no integer component */
 		if (val)
-			return -EINVAL;
-		ret = kxsd9_write_scale(indio_dev, val2);
+			ret = -EINVAL;
+		else
+			ret = kxsd9_write_scale(indio_dev, val2);
 	}
 
 	pm_runtime_mark_last_busy(st->dev);


