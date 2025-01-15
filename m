Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEFF248BA0;
	Wed, 15 Jan 2025 10:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937742; cv=none; b=Ridsg1ZpNag4fAO/aod6XOn6KtkS8MOHyYIq1jXSnBzkYEQF9SeMSnd9IUr3yFcA0JElDEnSsEI/rBlTD+YI0CFoCGt3gR6A8KQiTcsgOSwFQqbC98Di2+xAqK867vSNQPx+UF4c07ZZrhNiW5rwhN+HIuTfg1g8tbJnGbsUK0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937742; c=relaxed/simple;
	bh=EB290JqnO+5yNfzwdyQavCnoHrKkUHcm36jCnRBl1Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6Mkrd/qNDiC5+LtHqB190+/skuInTk1/B4C8Df20exWVi85v112K1yM9gQWMatfrd1qkDRv+durbPacdelP5he770YB7kt51lw5dV3GoJl2+YKgqJTEPqyNyz0MqfxPEnMW02DQNcJ9TkOKY24yGy36KbZj6vEnoLtwMsnu4ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wkXmmpYt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wkXmmpYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D479C4CEE1;
	Wed, 15 Jan 2025 10:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937742;
	bh=EB290JqnO+5yNfzwdyQavCnoHrKkUHcm36jCnRBl1Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wkXmmpYtjYQvM1B8sKVpeZo13l3xleJvs+k0uab6+OHMVkpRRImsCsbE47DVzGHVv
	 mu8fWc6N9W3QULiZLxlFHXX4+4XZq1PdP0DAx6nSch5J3LxziLMB7Q8GLXVnLl87E8
	 XUhZBcpBRysAbbjyV1GZRMndrF5QC6UFmez9zY0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 69/92] iio: pressure: zpa2326: fix information leak in triggered buffer
Date: Wed, 15 Jan 2025 11:37:27 +0100
Message-ID: <20250115103550.314055775@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


