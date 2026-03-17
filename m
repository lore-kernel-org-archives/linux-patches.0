Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163CD331A64;
	Tue, 17 Mar 2026 17:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768396; cv=none; b=dCsc9jiqYJc1YXoMS2X/hgtMZsL37kzk+nFMsvpqbSwr79o6vDnyuk0NByQLDozFcQdqzTf3YwyhDzI1P8P5UFcYaZXd7WtYx6pXrf60ljcI6JiM4QoS3bd5lftNehLai+6HjFtxnknwMLB1UeINrLo4tFJr93zgLvdUA2D6Kxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768396; c=relaxed/simple;
	bh=9NYHF8dDS1hT5Mjeh3/JvDo41qB/ulwIAkOJaRpIZhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QCdrK90EVo7DgmWXHL1bJgY3ekmQQcg5YN9M288QrTlb/sibwSWEAwYlNFk1ehpC80u1qhSHZHDRujxVFsX9A7C0lQcCDJbMoDiGE9aCw36uWXg7VrBjR7+XIzHzJHVgsT9pn6h7Kl4VO0SlUXrakbDZmK4+SDqclKWuf699C3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xOf4sv6t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xOf4sv6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4589C4CEF7;
	Tue, 17 Mar 2026 17:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768395;
	bh=9NYHF8dDS1hT5Mjeh3/JvDo41qB/ulwIAkOJaRpIZhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xOf4sv6t3Kg/IHWrb34yMpo+scFcw1F3XGDcBX6jfdDB5vVkaMkD4SM+LlqxF0TjW
	 M5S9E2WbBTPZ2Oufrrk6C2uh7n/QBtEDxBYXpbQFY7gF7caRkHwRHGDBi+RO1i1uFf
	 JQXgPbORkeApqnkay4TKaIfHvgEoLO1gBdSHc82M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 299/333] iio: buffer: Fix wait_queue not being removed
Date: Tue, 17 Mar 2026 17:35:28 +0100
Message-ID: <20260317163010.481665250@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


