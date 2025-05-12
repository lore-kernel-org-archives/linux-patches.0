Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C2521770B;
	Mon, 12 May 2025 17:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071147; cv=none; b=PySrpsS2UJpYg9EgC7CTbSDadCA5fXpOZsBO2+GvwFoizEUxZ0vjkpyoIlM2qHlCaxCsai8asttLZQ+zsOruLxpBQvFduTP8xnSAxRVbueFFI0eFJFk1YqmA6hAlfa80qlzHv8Rua1+eIJQkXFixk1wwcys9bAiI8GIpogfqsT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071147; c=relaxed/simple;
	bh=9SMR5DlrEgIUadMQm+drJv05wr0BROAU4FhU67lvObg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=trgbE+zDXWzr+heumzcB3QrqAzqhcJLK1LmIA1UPyAQme+Aw7Rty1Wee9u8KPBh5naktdIayuQgpleR6KWwNQ9F5UFPfF1k8neQPpuZpIO7+sJ6dM3iZBvySU+Pb68knGK7cg0yWYucpMwFNgEG8K5UoK2kKzTx4ObZayaVt3EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FHlhIUgH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHlhIUgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E1FC4CEE7;
	Mon, 12 May 2025 17:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071147;
	bh=9SMR5DlrEgIUadMQm+drJv05wr0BROAU4FhU67lvObg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHlhIUgHhTiY+rFjwI7Un/OqKUjRzmjr5JXM8q//2x7SwwTWvCiBHld6ZBTuntSpt
	 4sJSeC8qAAKzHGPx5+pswczZDO9EyDgysarHZJQuaybe3p/uegJMvHLxqK83TPTAxm
	 /Td8yp1E/t3Tu9niip/41wR4cUspr9LJwuSLwjBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Silvano Seva <s.seva@4sigma.it>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 27/54] iio: imu: st_lsm6dsx: fix possible lockup in st_lsm6dsx_read_tagged_fifo
Date: Mon, 12 May 2025 19:29:39 +0200
Message-ID: <20250512172016.737336170@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Silvano Seva <s.seva@4sigma.it>

commit 8114ef86e2058e2554111b793596f17bee23fa15 upstream.

Prevent st_lsm6dsx_read_tagged_fifo from falling in an infinite loop in
case pattern_len is equal to zero and the device FIFO is not empty.

Fixes: 801a6e0af0c6 ("iio: imu: st_lsm6dsx: add support to LSM6DSO")
Signed-off-by: Silvano Seva <s.seva@4sigma.it>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250311085030.3593-4-s.seva@4sigma.it
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
@@ -589,6 +589,9 @@ int st_lsm6dsx_read_tagged_fifo(struct s
 	if (!fifo_len)
 		return 0;
 
+	if (!pattern_len)
+		pattern_len = ST_LSM6DSX_TAGGED_SAMPLE_SIZE;
+
 	for (read_len = 0; read_len < fifo_len; read_len += pattern_len) {
 		err = st_lsm6dsx_read_block(hw,
 					    ST_LSM6DSX_REG_FIFO_OUT_TAG_ADDR,


