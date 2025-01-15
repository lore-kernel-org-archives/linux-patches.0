Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC681E98E6;
	Wed, 15 Jan 2025 11:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938803; cv=none; b=bqbJtvzuwlxR6fzGoELwzIJHvlBZ9pWIset8NGK9tS4tcLvpNbmAegHwbSQZw6J4e6EU8IEtiubz4fF2ciBrBccXHYf9M97xj7RKvBEuveYW6LV67Mc82Wbg9PD1226XwCvTL1C+0GhUsXUZNTVVOTCLpc7eqU/eqsOy3OeMCtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938803; c=relaxed/simple;
	bh=ubiQMj+KsMC+7b78EAwXHIPrU/NLlCUCcf1WRgjtvbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=niy1bA9pbDVMv9XSXXT5IJSqz5LaIh+mKcQAys3PaNZV34bBCadmw5KnYgT7OWwgTgYZXQz/lVBXDuiTJ4/KMFPu6YEL9ZjOcUA/Ku3/m6swJzMqqtde4ODJhBr6vuve24o+e99rI6oThATYQnHNit9V+BPh0YVKMxqGSCJyTTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5zWIUej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5zWIUej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B84C4CEDF;
	Wed, 15 Jan 2025 11:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938802;
	bh=ubiQMj+KsMC+7b78EAwXHIPrU/NLlCUCcf1WRgjtvbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P5zWIUejPmB2R2VJ26hEy8V41uA8+sRCQrNzQsQ4X+kR6ZEMuidkB82At52lE75KF
	 Q5MHB4rwrRjRJ2+BT3uUwtRzKKPRDFFRKRX1bhPJRusboZs1CZyOAi6K+39FigNNrI
	 Yp+Rj+rnu13qq6hfuZgQuABoI2VsgxmejREfkYY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 102/129] iio: pressure: zpa2326: fix information leak in triggered buffer
Date: Wed, 15 Jan 2025 11:37:57 +0100
Message-ID: <20250115103558.423066613@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


