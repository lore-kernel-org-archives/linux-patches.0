Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C7D47141F;
	Tue, 21 Jul 2026 20:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664860; cv=none; b=bOpY8TqGjtDrfcp4cfQMiVNa1o+A4NfMrnOYynZ6/JA8DKCvcGTLsZPvjN9ZfhX6yronhDqkyvkTNrO3W9ont6A1hI5U8MUu2XJkVIc5YhvXVcJr6dBYHjuo7LY0FKWTEO1bA4+jN1MV3HwKExMNx5ADbxXNmMx0v+hYWJt1W+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664860; c=relaxed/simple;
	bh=UiXqcbV2+Iksr7Tiz7OGKQk6usganvEw+J0ePAP8oj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOGn+1cHqrmoqsyZniWINPAzUlVxV54noLeRtLzTtjv8f889Q50Ykg8nw3vndIzcHGjE/6hcWbwKoYcbO21whse8kVi1nUpUQzRhXQG+7aiHcN08XmVaVcsYM/0tAGTpTCvo0hmoe/c0sQoqH/2y7WGpI8xYlGEcvOhmo9VSphE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zUitV43D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zUitV43D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC7B1F000E9;
	Tue, 21 Jul 2026 20:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664859;
	bh=BlsjiFTrdBywco5r6UY4vMDkHI8OuRYC7SZcTJRjZx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zUitV43DZ1nyZt0MNA371v5s29a6DIKTIdq6pyU8LAt6nZPJx8aAjndvCOBPHXXRJ
	 z9BVs7ICkT9t0ECjXZa9jGnOW2jifLJsOu3oUzEe+3AWZDWCbKnSYMz7Lv/QfHOMFb
	 AO4Fo6cNkZKwul5YAYEC95/PBfMV/TTAARzrRR/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.6 0084/1266] iio: accel: kxsd9: fix runtime PM imbalance on write_raw() error
Date: Tue, 21 Jul 2026 17:08:41 +0200
Message-ID: <20260721152443.679894828@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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


