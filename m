Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8063D091A;
	Tue, 16 Jun 2026 18:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633487; cv=none; b=TYZnBcm7n25oLYMQCXaoIflIfSeYjGrR4PFSmcphCoxDeQ+yAKtvwN4CxLSdoYR07SgcFVBxc+FiLeUOyDKGWxnaZVw1ri3DawshZpCImyBGjo0qhr8++4k6Iyqs/o8BJktY0FPbzul5Zh/gj1yWcSo8/u6wVAnrBr8/D3WR3es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633487; c=relaxed/simple;
	bh=1iTjRToHomROJLACMW+U1V7o+VRUEEzx8SsPRE05ztA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Db8Z8KMmkevt87xoN6hMklrWTz6vBn1xSxiV64PWW9d4JW5dbFLdYK2qUqAquNzGxvaHUpkP5bd3wJno8fWae9odNtx7IJ25MIyr4q7hEXWNwnd+DmK4uabZxiAkYyTwN1rUMutNYs2UMtmwknDXCJzNVj7W1Hog3Y3e0q1OLnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pxkVXyR5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pxkVXyR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8EE71F000E9;
	Tue, 16 Jun 2026 18:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633486;
	bh=L6oXIbraBukd4wRcaf36fqmp8uUZlJWLA7p5tiYhjWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pxkVXyR54MmQBZGPfmbrLvuJfNHEMgDPaRAl+v37luQhUnxlVFdhvkxRodKKCflam
	 6EIYBmyvzoiYhlm4zbmXGDuzsSQadIhBLwswr+0d6mvEwdPpN4efcNntuXKaBUVIYT
	 XVLebq5hSElVTqPJF/uGQc6eMcoFKC8VDwiYvKpM=
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
Subject: [PATCH 5.15 055/411] iio: imu: st_lsm6dsx: fix stack leak in tagged FIFO buffer
Date: Tue, 16 Jun 2026 20:24:53 +0530
Message-ID: <20260616145103.209900198@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -585,7 +585,7 @@ int st_lsm6dsx_read_tagged_fifo(struct s
 	 * must be passed a buffer that is aligned to 8 bytes so
 	 * as to allow insertion of a naturally aligned timestamp.
 	 */
-	u8 iio_buff[ST_LSM6DSX_IIO_BUFF_SIZE] __aligned(8);
+	u8 iio_buff[ST_LSM6DSX_IIO_BUFF_SIZE] __aligned(8) = { };
 	u8 tag;
 	bool reset_ts = false;
 	int i, err, read_len;


