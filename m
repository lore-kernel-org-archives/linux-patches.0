Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9608367B92;
	Tue, 21 Jul 2026 21:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670914; cv=none; b=hBOAF8Ko3WyOWAUG9Qj5nRqsdiU9pgerKenA2auBEefLUkIB8+bCrzsWw2W3xi5mEHiZB6ZqHpd7uOsyDeYbhXrpeF/dHwHuv54o1CD674zOb248h/6H3fiirlLyejas/C1/kKWnvW+35UsYsdMYgVIMLbBpwOl4KOj0Wj7XA78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670914; c=relaxed/simple;
	bh=rqyva5UwpToc/+xD8LGPxozWyXoZrQ34a5jYyrQxInI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NwlJ5oSNxRw+R0mF5+s0CyyNULsXvnhW71ZFS+YD83rsR7Lfxb16i0wgAs5RUumI59ZVDzOPYKHOuZZ1qJekxfKc/SpSwEYIw74F64Y3CMkq+RoVGPVPYNhfhOWvgn/d4hq1d2Jz2mEp1xpN3oxWYrK8x3OCWvk4Z/ijKXra5Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N8+sDJrA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N8+sDJrA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E2D1F000E9;
	Tue, 21 Jul 2026 21:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670913;
	bh=/Uvc/nt344cqyWnmysXixgZYEgi0s/LFkIpMl6C4Dbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N8+sDJrASpuO7moDz55rcTWZkG7wV+we2yHnhTWsnOXPAIenEev5bjBuV4L1XAZSe
	 o+21mWTx2UHdR9P0u0t7Ir6+BGAjgVOsqZ6ggcuDFG2+unjKLkHYuLVJ2XpLGBMFaq
	 4aBbyT6Va7ucq71Se87qRX1142anPrhtoB3Dtdpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 5.15 049/843] iio: accel: kxsd9: fix runtime PM imbalance on write_raw() error
Date: Tue, 21 Jul 2026 17:14:44 +0200
Message-ID: <20260721152407.086412308@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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


