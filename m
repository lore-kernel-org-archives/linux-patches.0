Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAB71F91F6;
	Mon, 23 Mar 2026 14:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275759; cv=none; b=skLmp2ibxafcDpF2rO9F69OKwH0SZC8Bq8cMHfBk5qU8yFhObX1k00IZaRWPgyJQjGVZEBC0MqP0YzU3vOelBB14lzDn6N3aB/ga5slrMu7dWBg8ctbnaBO6ZHCo6xC/gr6Jbe6Uhg/MQatnOZe4CrUQLeIVdi9UreigsE1eG00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275759; c=relaxed/simple;
	bh=IyKIAJGwdXwpZh6Ys13RESgVe4lZXpekzMFRInjcIrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SjfcB2TLdLfeDRVUnFDD27eMDJ+gjhpIASbMtsdKsWS+J3WE64BzqkQt1Ajl0djtI0BITdY/vKaWpUCoIF1Io3LJ3ZO8igFeItvy6dPzesmw3jPRWTEQT1IqBlAmmc/eciPU4GT+NBa/0BhodLgmHfiKJ7p6I2raEobcOTUuhCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OibQwSm5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OibQwSm5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15DFC2BCB3;
	Mon, 23 Mar 2026 14:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275759;
	bh=IyKIAJGwdXwpZh6Ys13RESgVe4lZXpekzMFRInjcIrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OibQwSm5ON3yZnq2psXjhWC9O9RoG+/SSK7cBLUsXqgTWuKVoAi07SpifRuodug3Q
	 wkN2zb2YQKrioShZI0OSNgccMRp6Oiqg5IYd1t5JAPAKk4E8Yu+CarznGl+Np8f8r9
	 K74J4kv7bAz4CD5LSxNdr/2DTvhjma2RsP2RmNtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 209/460] iio: buffer: Fix wait_queue not being removed
Date: Mon, 23 Mar 2026 14:43:25 +0100
Message-ID: <20260323134531.656192172@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

commit 064234044056c93a3719d6893e6e5a26a94a61b6 upstream.

In the edge case where the IIO device is unregistered while we're
buffering, we were directly returning an error without removing the wait
queue. Instead, set 'ret' and break out of the loop.

Fixes: 9eeee3b0bf19 ("iio: Add output buffer support")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-buffer.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -228,8 +228,10 @@ static ssize_t iio_buffer_write(struct f
 	written = 0;
 	add_wait_queue(&rb->pollq, &wait);
 	do {
-		if (!indio_dev->info)
-			return -ENODEV;
+		if (!indio_dev->info) {
+			ret = -ENODEV;
+			break;
+		}
 
 		if (!iio_buffer_space_available(rb)) {
 			if (signal_pending(current)) {


