Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1B73191C8;
	Thu, 16 Jul 2026 14:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210556; cv=none; b=WVw4h3jvStuL9kwVb2kDONmZ/JFrrfFoJ1udBmym3cIaupycu2IhQkstOollLk+To2PYBpib1FZi2YkZB1y5ymLATgOWA7wBJteW/MtkKmeDZIYV63n2kem5HqtGLd4Urq9xhfKEuPWTpOFJIAiEYtmPbv8ERgeJ6kvTUcH4uNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210556; c=relaxed/simple;
	bh=rMVWTIoDGq8ZGaaFg3X7CmFp/gIHUh8Fmvlmm8AjCsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YLBofDZh7DQCXHF84cnFrTTk8tAAe/gCaDq7/xPCLjDBpB29yHTXS5IDN++73adbHnaci5J65mAXzqJOMaujPjGcBkUrasN9KF2uXA6xQ9MNTwl5/PpE2zgJnJ7dacyLdCNdcO6qFwacpq4UrW7L8+ZIajxlTg8QdHdG0O6cUdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y57gPpBd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y57gPpBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0141F000E9;
	Thu, 16 Jul 2026 14:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210555;
	bh=sZ/jBwHYYC1LiEhG7JtJ+4HHNctSv8Wuq+PcXp3fKgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y57gPpBdLnQUPceg7d9iZGYO3f7Y4EGnDl+LSjrfLCRLM7/qdDAvl9VXhqN6T46BW
	 ut9CBahxMuZYiQVGaWxjnQPvkW8hb6YmklmwUPuZWS9CrQgJMQ7JjGxVtXIkv4Bq/w
	 fYS+/9FdVv5K0trgWkSrYKRDbN3b/nSfhp7RSauc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 049/480] iio: accel: kxsd9: fix runtime PM imbalance on write_raw() error
Date: Thu, 16 Jul 2026 15:26:36 +0200
Message-ID: <20260716133045.770170224@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
@@ -147,8 +147,9 @@ static int kxsd9_write_raw(struct iio_de
 	if (mask == IIO_CHAN_INFO_SCALE) {
 		/* Check no integer component */
 		if (val)
-			return -EINVAL;
-		ret = kxsd9_write_scale(indio_dev, val2);
+			ret = -EINVAL;
+		else
+			ret = kxsd9_write_scale(indio_dev, val2);
 	}
 
 	pm_runtime_put_autosuspend(st->dev);


