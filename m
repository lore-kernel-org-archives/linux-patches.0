Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433681E990D;
	Wed, 15 Jan 2025 11:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938814; cv=none; b=GJcmUwwKjCcvTWrng9iPWrQc/i9PcyoXdtMREUJ4d2BSDRxXbjBYSWv0ociy8WfuHH1Xxf5GGx+0uSLa5VdPAv55OVWxKq39iG+7JDZv70qXcuxpRAk8CJ+0Van0+SnqwyKcO2Kcuz3tmJBRYtEmBxhKzw3CyUYJX7UVv1U3nwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938814; c=relaxed/simple;
	bh=u1Df2IefwEk4F+gNWMY73Xa9dcVC0LGZB5AXJP1/B0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j86PjGSIWQVbZZJx+J33YDWI+GVFPFbfkm7SJdT/7f5GwoEU55hDlB/UTS7IDse9S8oSLbfyZRUFK0SWwpicuTdT8s1YukQhgAvWKxDLPwzw1YxNBHFhpHgVkpOjyn8B/M6tEmw/2ORLh3Ye+rbIW0lNT8UMKWd1g82Nkfa4M2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dKZtXLRs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dKZtXLRs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4912FC4CEDF;
	Wed, 15 Jan 2025 11:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938813;
	bh=u1Df2IefwEk4F+gNWMY73Xa9dcVC0LGZB5AXJP1/B0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKZtXLRsICkUI4Ygc9AWgZItF7FI7Z64g68bcacdGpiB/lNBSpcMH6c2smlA4xg5Q
	 IU3bNUaisp7Pb4RPT2ZX+0mcLWyBNhj89e8fKE3JRJoVUAwjwsLO8QLpthkiC7gZkk
	 +e8Lf/I/DHnn8eQmldO3GOdQJ5jJiF1goDc0ixe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 104/129] iio: light: vcnl4035: fix information leak in triggered buffer
Date: Wed, 15 Jan 2025 11:37:59 +0100
Message-ID: <20250115103558.501688335@linuxfoundation.org>
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


