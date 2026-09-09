Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE8156E079;
	Wed,  9 Sep 2026 14:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963812; cv=none; b=EGPW8FjD6UCESADSYaC/KU8p2ss4bggj4DNVkTKW9Jr0/FiNaQwu+tXqalKfP+qEGeWO5nO8N/LnfLbMiRlu7lktl3cF3QogkkoU7feefw7NOCU6vlvjonjSkd78+xl6GlwsZZgNnDkCqQGdVanr4RG5aT0LG2r/bjDxughs2bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963812; c=relaxed/simple;
	bh=1dqClWwQtFQu8wXdVOPkptoypHzp3AqvtCaasphp0OM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EAOksb841VWzbiaiV3ZcdWMHUUg2oUU87NW6wOmHlpgEbjKK9OIBKl8ahKQMvVlyxwkUWV41WcXmH2DxOtWeAnuZt5deYGSRbbxIrcCKVjM90MMq12SmP9ewxmnqYjCXcw/rfjnHN8iuil3lXGduc/p2EOCcUlC28nkmJGbrOtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yygLQVCw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yygLQVCw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA391F00A3A;
	Wed,  9 Sep 2026 14:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963811;
	bh=TQZdYbOI2GoyVuFn+egMbV8XUKVZU20wFlBWCxFQ+RQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yygLQVCwWtCnxRJL8KHz146D919OX3qma+sASr8B1nLpU23kw+CGIBZ0A2MhZt2sL
	 IhACD1q0y54sbplrh4d3mWFVg0B5veD1QpYocOyyLKTrfqIKCxIyF5xu43js/ckSjo
	 OkSgFqZfUUZbm/Do89rkEYHaaOfWwoB56Z8MysDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lars-Peter Clausen <lars@metafoo.de>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 206/583] iio: buffer: Fix potential use-after-free in anonymous buffer release
Date: Wed,  9 Sep 2026 15:38:11 +0200
Message-ID: <20260909134245.279863140@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Lars-Peter Clausen <lars@metafoo.de>

commit 6288b593e76eb10329326f2cd51e32557203b9e5 upstream.

An anonymous buffer handle holds a reference to the underlying IIO device.
The reference is dropped in the buffer handle's release function. If the
device has been removed, either through unbind or hot-unplug, the buffer
handle might hold the last reference.

The release function takes the mutex for the buffer using a guard, which
means the unlock happens after all the code in the function, including
`iio_device_put()`. If the anonymous buffer holds the last reference this
might free both the IIO device and the buffer, which contains the mutex,
leading to use-after-free when the mutex is unlocked.

Fix this by using a scoped guard just around the buffer dmabuf list access,
making sure the mutex is unlocked before releasing the IIO device.

Version 10 of the patch that introduced this issue used this exact scheme
of first unlocking and then dropping the reference [1]. During review it
was suggested to use a guard instead, and version 11 made that change [2].

Reported-by: codex:gpt-5.6
Fixes: 3e26d9f08fbe ("iio: core: Add new DMABUF interface infrastructure")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Link: https://lore.kernel.org/linux-iio/20240605110845.86740-4-paul@crapouillou.net #[1]
Link: https://lore.kernel.org/linux-iio/20240618100302.72886-4-paul@crapouillou.net #[2]
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-buffer.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -1599,12 +1599,16 @@ static int iio_buffer_chrdev_release(str
 
 	wake_up(&buffer->pollq);
 
-	guard(mutex)(&buffer->dmabufs_mutex);
-
-	/* Close all attached DMABUFs */
-	list_for_each_entry_safe(priv, tmp, &buffer->dmabufs, entry) {
-		list_del_init(&priv->entry);
-		iio_buffer_dmabuf_put(priv->attach);
+	/*
+	 * The mutex must be unlocked before iio_device_put(), which might drop the
+	 * last reference and free the buffer.
+	 */
+	scoped_guard(mutex, &buffer->dmabufs_mutex) {
+		/* Close all attached DMABUFs */
+		list_for_each_entry_safe(priv, tmp, &buffer->dmabufs, entry) {
+			list_del_init(&priv->entry);
+			iio_buffer_dmabuf_put(priv->attach);
+		}
 	}
 
 	kfree(ib);


