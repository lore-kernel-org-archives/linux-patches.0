Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397CE248BA1;
	Wed, 15 Jan 2025 10:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938474; cv=none; b=iHNfjQPLzWd6QtfXiavR2bljNP3ZR3TpjcNZC0tFDzN3DVw4GU+0JgvmsysPe0SEhXiMyJfyTiLl9OrJu9PgwJjcDozr8BQcYJB4ik2nxlMhG/oOW7W0t3v4hOZg+lviMhxrWl+6lO6W6F9+AMMJZWuuozfyofd5mRBRu7DzT3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938474; c=relaxed/simple;
	bh=J7i1wauo7Bi1Q5TxoJ3h+l3sTgakbJ3OwAdowTForF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JI/Ti2kppsG2G0ZipboEN2M/Sqw2eHlb/0V4FwSMKVHZW1aShZblS9R/yEwfswlFLJfaPjsHDyV7AE/2Tkb06IZSwB59+Lmcr693V+X80FDGNbg9a01qMr1mYorlQC8fqGl7W3Bvw4+iz+1qhft1AG8QNeC78otrYeQ43gjUru0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wsn7XE68; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wsn7XE68"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2400EC4CEDF;
	Wed, 15 Jan 2025 10:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938473;
	bh=J7i1wauo7Bi1Q5TxoJ3h+l3sTgakbJ3OwAdowTForF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wsn7XE68PQ5GbGhgC4ltnIrCI8MMcEF7hWV7tAt9JcR2O9jmsIf5VsjrUQ9dIttJZ
	 Yn86YrErrz+z3DEMKRjDBBxZYQoS2pQHaW2xX5t6CTVCfnsQpkM3eonedibdgFyO4/
	 8GRCgfS+eqd6IAQUnocwLvJv8Ph0YyXtKqH2Y6jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 164/189] iio: adc: ti-ads1119: fix information leak in triggered buffer
Date: Wed, 15 Jan 2025 11:37:40 +0100
Message-ID: <20250115103612.943171639@linuxfoundation.org>
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

commit 75f339d3ecd38cb1ce05357d647189d4a7f7ed08 upstream.

The 'scan' local struct is used to push data to user space from a
triggered buffer, but it has a hole between the sample (unsigned int)
and the timestamp. This hole is never initialized.

Initialize the struct to zero before using it to avoid pushing
uninitialized information to userspace.

Cc: stable@vger.kernel.org
Fixes: a9306887eba4 ("iio: adc: ti-ads1119: Add driver")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://patch.msgid.link/20241125-iio_memset_scan_holes-v1-2-0cb6e98d895c@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads1119.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/adc/ti-ads1119.c b/drivers/iio/adc/ti-ads1119.c
index e9d9d4d46d38..2615a275acb3 100644
--- a/drivers/iio/adc/ti-ads1119.c
+++ b/drivers/iio/adc/ti-ads1119.c
@@ -506,6 +506,8 @@ static irqreturn_t ads1119_trigger_handler(int irq, void *private)
 	unsigned int index;
 	int ret;
 
+	memset(&scan, 0, sizeof(scan));
+
 	if (!iio_trigger_using_own(indio_dev)) {
 		index = find_first_bit(indio_dev->active_scan_mask,
 				       iio_get_masklength(indio_dev));
-- 
2.48.0



