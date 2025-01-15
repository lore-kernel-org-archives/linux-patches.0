Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C076C1E9905;
	Wed, 15 Jan 2025 10:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938491; cv=none; b=pJ/4SHq83xISnnMru74zsipr0mcuMQ0Qa62OqOm18FkAYeotDukeGXlzrW2ryPGJGpfLn1jLp8/HOzxMW8RfTMH5D+WwZrNdtlonF8/or92cebmrFce3lernVNrZIE1+Who2uqlgRCBSf4MZG1qN5ywjLPCM/peaqHg+oArfr0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938491; c=relaxed/simple;
	bh=TN79HCMFHAUSLSOYKd68uJm0vDXjW68pe50okowaT88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=by0Q8jv8XQOSaUAGqfJxLB1Qd8HgZbVoemRjBKmZIfdwnGXSjJClSzylc3ZSQBv+MiO0q0dPqTmZO4MPwQfx71ZFIJGSBScOmGlspljEBlWX1XEhDmINDPvrKi9M6Jr5aZCyDHt2HD8aVydrtNCZlmm4tXxiVBPBIwmdyDxXbWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jAmRBCjx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jAmRBCjx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8CFC4CEE5;
	Wed, 15 Jan 2025 10:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938491;
	bh=TN79HCMFHAUSLSOYKd68uJm0vDXjW68pe50okowaT88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jAmRBCjxOfXsf1fHZeNFQSwVKBv3SzSKKiD0ZPa2IKEUjrVx1s8fv8iRzK130dH/h
	 lhUItCmzI+Vw9ANh2zm+lE8l+qX6kaasRETzPgXsC+bCuLvhLP4qn2QU3cmso7CAcr
	 YmW1i2jSth1jMF6AYvFp+KRkKBYgM7NTdqVPYxJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 159/189] iio: light: vcnl4035: fix information leak in triggered buffer
Date: Wed, 15 Jan 2025 11:37:35 +0100
Message-ID: <20250115103612.749762426@linuxfoundation.org>
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

commit 47b43e53c0a0edf5578d5d12f5fc71c019649279 upstream.

The 'buffer' local array is used to push data to userspace from a
triggered buffer, but it does not set an initial value for the single
data element, which is an u16 aligned to 8 bytes. That leaves at least
4 bytes uninitialized even after writing an integer value with
regmap_read().

Initialize the array to zero before using it to avoid pushing
uninitialized information to userspace.

Cc: stable@vger.kernel.org
Fixes: ec90b52c07c0 ("iio: light: vcnl4035: Fix buffer alignment in iio_push_to_buffers_with_timestamp()")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241125-iio_memset_scan_holes-v1-6-0cb6e98d895c@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/vcnl4035.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/vcnl4035.c
+++ b/drivers/iio/light/vcnl4035.c
@@ -105,7 +105,7 @@ static irqreturn_t vcnl4035_trigger_cons
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct vcnl4035_data *data = iio_priv(indio_dev);
 	/* Ensure naturally aligned timestamp */
-	u8 buffer[ALIGN(sizeof(u16), sizeof(s64)) + sizeof(s64)]  __aligned(8);
+	u8 buffer[ALIGN(sizeof(u16), sizeof(s64)) + sizeof(s64)]  __aligned(8) = { };
 	int ret;
 
 	ret = regmap_read(data->regmap, VCNL4035_ALS_DATA, (int *)buffer);


