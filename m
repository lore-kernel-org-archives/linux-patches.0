Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8C347DF80;
	Tue, 16 Jun 2026 16:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628538; cv=none; b=J8wBfjkWsARyg7MLuc1cB/Xb5F1Nub+g1FRopZP0REfHtpuTEZgArw1rRL7Nqk9f0G5I0acnVzDnFBd0uM9gYOzu8tG+mn9t5iVaUvPUX2429FmTVhKxxNkX73Bl954BvYke4HGYux1aEK5JcUq5TaioNWqTqNuX3ziHChaWMz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628538; c=relaxed/simple;
	bh=ujH5TujBRQBmASGcHdVFIc9BmzmGEB6kAqpIfupNOZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VhEfhQ5PYckLttxtK1uR0LEYFCh6MLr0+YSdUhUZDgmku8N9nu0+UKaHzITliyKopH3N3+qPD/UMU8pjnDiynfNKOzJe0Xhp8Hf3AmrhqyoLLq8zPxp04Vt4vbNu70IdO6iBSrnUPACc44pM/vjREJ8b1p/bpXWHa50MLVdn9tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fumDGmGG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fumDGmGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FE61F000E9;
	Tue, 16 Jun 2026 16:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628537;
	bh=55+s0PyAjM8urLjdWksJ1Rd+O29xFqRESpFJdRzMC1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fumDGmGG4DysZHxpfekU5toCPeJiBfLkL36CICw3yKTUjakkM35hmkrrAkuckM9tD
	 G6HMV6uRloY4j2dcWWSHypUAplQXiJAbOQT7ipAUu32DDP+38wUuMcU2M1j3XDi9FM
	 bhgD8tbB6D/YmUpaZHuikO7ElQO71AD4EAGsOVLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Andy Shevchenko <andy@kernel.org>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 082/452] iio: imu: st_lsm6dsx: fix stack leak in tagged FIFO buffer
Date: Tue, 16 Jun 2026 20:25:09 +0530
Message-ID: <20260616145122.181755487@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit c9d8e9adaa63150ef7e833480b799d0bab83a276 upstream.

The tagged FIFO path declares iio_buff on the stack with __aligned(8)
but no initializer, but there is a hole in the structure, which will
then leak to userspace as ST_LSM6DSX_SAMPLE_SIZE bytes (6) will be
copied, but the space between that and the timestamp are not
initialized.

Commit c14edb4d0bdc ("iio:imu:st_lsm6dsx Fix alignment and data leak
issues") moved the untagged FIFO path to a kzalloc'd buffer in hw->scan,
but for the tagged path it only added the alignment qualifier and not
the initializer :(

Fix this by just zero-initializing the structure on the stack.

Cc: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: David Lechner <dlechner@baylibre.com>
Cc: "Nuno Sá" <nuno.sa@analog.com>
Cc: Andy Shevchenko <andy@kernel.org>
Fixes: c14edb4d0bdc ("iio:imu:st_lsm6dsx Fix alignment and data leak issues")
Cc: stable <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
@@ -586,7 +586,7 @@ int st_lsm6dsx_read_tagged_fifo(struct s
 	 * must be passed a buffer that is aligned to 8 bytes so
 	 * as to allow insertion of a naturally aligned timestamp.
 	 */
-	u8 iio_buff[ST_LSM6DSX_IIO_BUFF_SIZE] __aligned(8);
+	u8 iio_buff[ST_LSM6DSX_IIO_BUFF_SIZE] __aligned(8) = { };
 	u8 tag;
 	bool reset_ts = false;
 	int i, err, read_len;


