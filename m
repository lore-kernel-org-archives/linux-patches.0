Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFB81F55E3;
	Tue, 21 Jan 2025 18:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482915; cv=none; b=ETOo8J7Bbx+OMELDTzKX22OBZytPcOL+3y8Sb3qCiBAwLd/lAxxr1P7nZgXfQTXRdunTaAtXSZuU3oK08/EgNaw3ztBuMr6HVpFexEfPmH/bQYwzI7AWkAaAg0Zfv1zEHf8bL/3d/HUPlSusgeCIPJr2UwpPuC+YweXM2IVNPho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482915; c=relaxed/simple;
	bh=JyUEwIspsvJzZovhblB7eQQLdqRyoQuTTifPPMa4lLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eD8jstrzlXiOLhMdhRgXYCpLfBsQDTZwaOt7COwn3upCIlRFeKCe7p1Ts+elpfJbQO3jXBPMjfbVviZdltZzp0LGed8B25ikYgzuLXYmnpEE7STRm3twFd0i+fLs9UNRmR2UqzAk/L3vARqKCI1PxbsaZpHmcOYaReF57csAtmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOMTzVJT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOMTzVJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27FC5C4CEE1;
	Tue, 21 Jan 2025 18:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482915;
	bh=JyUEwIspsvJzZovhblB7eQQLdqRyoQuTTifPPMa4lLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eOMTzVJTBBlEfILlAmaHAEInmwVTZPVFZg+RONVmRwJgTwQkoM/jnuCucWhZFnFms
	 gYBfAqd1cNuuRaSDpsEUZqmFMfnzT+LZJNgPWGUkDAIK9052hh3wc/RNtuQaAOxKbA
	 iR5L0k/6QnKY+Z9pDvOeLNJEQgYoNW8R4Z8sj9Wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 053/127] iio: pressure: zpa2326: fix information leak in triggered buffer
Date: Tue, 21 Jan 2025 18:52:05 +0100
Message-ID: <20250121174531.712001355@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 6007d10c5262f6f71479627c1216899ea7f09073 upstream.

The 'sample' local struct is used to push data to user space from a
triggered buffer, but it has a hole between the temperature and the
timestamp (u32 pressure, u16 temperature, GAP, u64 timestamp).
This hole is never initialized.

Initialize the struct to zero before using it to avoid pushing
uninitialized information to userspace.

Cc: stable@vger.kernel.org
Fixes: 03b262f2bbf4 ("iio:pressure: initial zpa2326 barometer support")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241125-iio_memset_scan_holes-v1-3-0cb6e98d895c@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/zpa2326.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/pressure/zpa2326.c
+++ b/drivers/iio/pressure/zpa2326.c
@@ -586,6 +586,8 @@ static int zpa2326_fill_sample_buffer(st
 	}   sample;
 	int err;
 
+	memset(&sample, 0, sizeof(sample));
+
 	if (test_bit(0, indio_dev->active_scan_mask)) {
 		/* Get current pressure from hardware FIFO. */
 		err = zpa2326_dequeue_pressure(indio_dev, &sample.pressure);


