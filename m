Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CAD71DDE9;
	Thu, 30 Jan 2025 14:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246674; cv=none; b=rGs3x62Ykl9TsAvnH59iYsDDAkiHtPniZK5zkc44jjg+MwcVRc6vpqMjAPzFRTCMlLU1yaBhY6NNrIbL7MjUwXlIPB9YqbTLZj5NoFEuSH9prmkZhbM2sEj1rSvQw+kWRxwIMGOcY4/y+QcwyRqwnuCF5hnr1Gn0RHxejBboIk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246674; c=relaxed/simple;
	bh=hWqKPSryPnKiAhDoq5s9W1+ryJ6o7digrccYnCw0qVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7qRVGoBLtbbq4FqaBBmFG8bHVLlexr6PBtpmOTeGepdY0vEUJWjYTgTDzZg9DdDdAtZK64zBmGpzomTHQYOKHso/xvGieCiQjdvicuLi+e86D8rAZrKNngTgy1+SrFitSYzxbt47t/TEQlrIi07fGZCqFbbsXTpL7f4A4KOz44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XtVcThha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XtVcThha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88043C4CED2;
	Thu, 30 Jan 2025 14:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246673;
	bh=hWqKPSryPnKiAhDoq5s9W1+ryJ6o7digrccYnCw0qVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XtVcThhadW2Jo89OQh8qwPWCgi1dtO0Wm9icZO1CU3if6OSWwgV7WdvmmpW34dX0u
	 GHNXsVnIxrsqHMlzKTxezOMHWSTub+4IlIqv53fFe7Z+D2O6w9LprAMXDxFg/UWmZA
	 EVCfutdGX2HmTN6cMDHuak0zh06ae2OTCW3Y6ziY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 29/91] iio: pressure: zpa2326: fix information leak in triggered buffer
Date: Thu, 30 Jan 2025 15:00:48 +0100
Message-ID: <20250130140134.837179442@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -585,6 +585,8 @@ static int zpa2326_fill_sample_buffer(st
 	}   sample;
 	int err;
 
+	memset(&sample, 0, sizeof(sample));
+
 	if (test_bit(0, indio_dev->active_scan_mask)) {
 		/* Get current pressure from hardware FIFO. */
 		err = zpa2326_dequeue_pressure(indio_dev, &sample.pressure);


