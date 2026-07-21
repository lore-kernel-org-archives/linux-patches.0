Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8119C43F8AC;
	Tue, 21 Jul 2026 22:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673175; cv=none; b=NO7WwDK7QKzBGlg1EnlX9W3BVB1uBYPsUpj7RKxrm0F3UdOTekBUhAp2rNgIZOcg+28ky3dA48mKIrw1IEUwV/PE9Gl8mgVa22D28MjSiDwmh786ApKMKcZYolw6Z3TyY9braSdZsfCYv2m+Ox77/eTMte6RV3y6yJAd7sr/DX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673175; c=relaxed/simple;
	bh=psoiLdy2V4S2sO4jSu8kn46hARoQvVWC9c1C2buEE9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKKn+YfJJXVXBPHFKtPUeM7m1FJGCyE2HwjEdxLwq2Slb83/1KEwZG29U5eqAwDRTQyGVJY2wUlzUtZ0SATxfTdsiQ3qTddYykwIClyk/0kD0THEVdiFgoKk8L5x6/Gr3wl96LWbHyhOZpMJMPInhYck2DbwzN3Ck4D0ygUhzF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9Yk+f1W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9Yk+f1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F151F000E9;
	Tue, 21 Jul 2026 22:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673174;
	bh=HfeqBpeDDfBafE7KxsLXrNmwfW1vGw/dyqLcdG9S/GQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n9Yk+f1WGF0czuKUEQzYP3uVs91qbLruiSlwcALeSOiQqDTDNZBAnxTHNfNLKCt4f
	 e5AVRV3ZzFsHJSZyDZ2Lfu16f0CqbwYLhM1EeB26IoI8mSLGwPUV3Sa1A/MxC0hbx1
	 Rt2cMj08nHlusWJJ3fZKCjQcClG0bqribKsOtLCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 5.10 036/699] iio: accel: kxsd9: fix runtime PM imbalance on write_raw() error
Date: Tue, 21 Jul 2026 17:16:35 +0200
Message-ID: <20260721152356.523237295@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


