Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BD22FFDEA;
	Tue, 17 Mar 2026 17:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766928; cv=none; b=CibnSWhOXiNxeP8Xn59Waov8eWhZ6/HVtkQ8EMxOa5YKcJr2dvJOIjVobka10BdjtT62CuuN4+fwx+p0CWlvrHbE96+j2eggTumq1lrgY0FKyIaxaVQAHXof4xoeAo0VZySrMez/QsZcXW0asgi+D5jWsNhYEHvtGzgxPJ2rQOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766928; c=relaxed/simple;
	bh=2Op0Y71CeDSN0fqbNNdgACZjAuyZ6UgyJ4e1DTbbh68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dXxxkW3rC37q3qDVaYXZQzEekBmJERFlR8PIgWCuDCeyeSTQ3c5kUyQ2P57o2LWrQkp2g+YeMNEjeZUXAZsQiDnkcYWLHjOFbmCX2ix4u3tDEYvwURkWd6A5mKX0bgEZlAiOryuKomHHERPR3U/GPCJ4pz3OoMwQ3NpJsuH6xsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SOJP6ccO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SOJP6ccO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C5DC4CEF7;
	Tue, 17 Mar 2026 17:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766927;
	bh=2Op0Y71CeDSN0fqbNNdgACZjAuyZ6UgyJ4e1DTbbh68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SOJP6ccOoN6kbKDUOyLOkLmukOeS882tZ16/OBLTcu90fzxPsxw3dd47m11VJfb9g
	 3NnLH/SYWjY54VBNRER5CWz7acpiVxT4+pXWMYE3ydmKkvKpPVvT3XbtU9YVwO4o0Y
	 GL6GxJv1jy5/QlTSLaZcFbQvXMYH3hD3FI7K4gNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.19 353/378] iio: buffer: Fix wait_queue not being removed
Date: Tue, 17 Mar 2026 17:35:10 +0100
Message-ID: <20260317163019.974294398@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


