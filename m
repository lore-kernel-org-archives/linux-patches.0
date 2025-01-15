Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473B2248BA1;
	Wed, 15 Jan 2025 10:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938357; cv=none; b=J4scFEap3OQCn7oHQyl7J67CiczT1MuYZ3fOKXar2mKvgqUhzImP0w3N52hLglzy33GaMfvh+GvSQMNyPjpDnFI9honcmE8qGQ739QCbVzOWhxSYVb6Fbur/1NoUSIPuvLUGvC0DCaPnZEp7jBjAlK4cPz+YTJWiACUJCIZR4zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938357; c=relaxed/simple;
	bh=w5SuH9oezq77LWx1fQ+84qw6oB1Ws0m0nSgUNsV6J2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nHawmCTEN0UZoK/1yHiUe7Uk/L3JvIKcdi9BV2Kjkqrl94Q8Ma3LWHPGTvufbMr492aY8I4PrvwXaj12Sm7PwKh5WCInNyLWfgrNafDYY3KHfdfL6q+7sHu2M4F3gczb6WleDY9JgKJ/vckH7/hzySEXPaeXK2+clURNmd2FbqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TFojp3mm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TFojp3mm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA866C4CEDF;
	Wed, 15 Jan 2025 10:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938357;
	bh=w5SuH9oezq77LWx1fQ+84qw6oB1Ws0m0nSgUNsV6J2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TFojp3mmhFlk7EptpzwJLopCg175k+kHavxSN+YsaGa24fjw/40/TpVoDj0SyNee3
	 DLTCc2EhYEmMQyWCzXcZgdWC5w3D7wucqCo9gBhgiCRktfHf3JH8ZY/gnMqKJ1MRLT
	 tOuZLjnz2ZNCPNbWG7SynTl0F0xRIElrxJyp1z1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 157/189] iio: pressure: zpa2326: fix information leak in triggered buffer
Date: Wed, 15 Jan 2025 11:37:33 +0100
Message-ID: <20250115103612.676193029@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


