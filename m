Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4472022DA17;
	Mon,  2 Jun 2025 14:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875263; cv=none; b=T5+4meHM2Z6Z08cn9Vq6AGgsTgNoVOCbspOYNF+qIVqaYcNk3Hx/MEGa1b/xcywiQgGpkheF5J0GUmcTmJbnY9skl2fRZQyzU3gE1UDlBxEaPBmYi6+jmygrzamRqN5RlHEJn5LUuxl637fVO7ZZ+hmq114AorqZjnePW/NnPxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875263; c=relaxed/simple;
	bh=2KEmEc5f+DKDfF++oPpYdXRHRQKU5gW0JLxqjQVmsFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8BOOjpGE2XFSZ0Z60K81kHUOBK8sxSPujCuOR35z08H130pAPY1Z0waedTZ2cEKqC+ZfLQDmKA9u4TwaVdTJ/Lsyxy3cnpnjOofROqEjiH5F/wj7DyJmCJhpsSatzuUDmW6f0bC8XxXdxQrhjlReQQUvnoxd77Nwm4afcUjcyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T1/Pa4Zh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T1/Pa4Zh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7EBC4CEEB;
	Mon,  2 Jun 2025 14:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875263;
	bh=2KEmEc5f+DKDfF++oPpYdXRHRQKU5gW0JLxqjQVmsFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1/Pa4ZhAaESMhbYipMjbucGa9OxsTSk/iDIM7p2ocOq329+6KTKFKVaFz6A/0Mau
	 tCqt1/IibhbPgfwl9aEELdu3d/yeYoTHOxM1m9igVa+f3axEJv9OaC2riXhT3P+AJy
	 l+x8vvsjYWvsbwgimOEqh8yUGPp9gRq6s/f7fpTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Silvano Seva <s.seva@4sigma.it>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 062/270] iio: imu: st_lsm6dsx: fix possible lockup in st_lsm6dsx_read_tagged_fifo
Date: Mon,  2 Jun 2025 15:45:47 +0200
Message-ID: <20250602134309.726933212@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


