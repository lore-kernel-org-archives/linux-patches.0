Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E663B3C08;
	Mon, 23 Mar 2026 15:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278600; cv=none; b=kwjdo+uPTKGgKPZ4mTHa0sDvSLKPzDxn5zHSooBbYAO8jAme6SX6bhBeye196mVPhqSgjPG606T3eGg66Go9SrMSCrinBhib1oqu04mD5kKLQ84barHebhD02w2QyS/vdoIg5dIJqGWRYIy0BTlOkr/VSuumlRh11dObXcCFYZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278600; c=relaxed/simple;
	bh=CCqjTelam7cbnD1RIZPtb71Jv7PxD8Bo8Iz8QmeHTCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hUuWR9V/s/eLgrgPonnqz824akcZe52EFGZGAeNPCXQfI9c/XidpuzLnY83ObyflBwwEa9wjvQLDfDfX2u5fO4GD3K6PAYVdU9DXI46SmQHVoF1Tb/bbpf00iugPCjs+cqub9prvFdjs7zNWGk3BAjq2dvV34G/JnkxccpsaeBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lfmyee8X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lfmyee8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6AB4C4CEF7;
	Mon, 23 Mar 2026 15:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278600;
	bh=CCqjTelam7cbnD1RIZPtb71Jv7PxD8Bo8Iz8QmeHTCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lfmyee8XMl/e/jR26H8WMFalMTbzmZvwMwMMLWHG5TthJmA+loXWwIVLDD0eX2/TQ
	 V4vUJ4jzqcIOiAyObTlzdG07uPI0o0YaG1le8q7UhcbYdt7rpDvhJn2HAfEtZXDDs5
	 kXW/6S2Bltu1B1UEswF4MepF/bV/yET27UInb35c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 358/567] iio: buffer: Fix wait_queue not being removed
Date: Mon, 23 Mar 2026 14:44:38 +0100
Message-ID: <20260323134542.689388205@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -194,8 +194,10 @@ static ssize_t iio_buffer_write(struct f
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


