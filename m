Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A651E9B03;
	Thu, 30 Jan 2025 14:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246989; cv=none; b=qlywylE5+YI+JIEjQcKRUfB1atscvFHMSJzQ5ycU3PI5Bo7AwOmYk7T9lWq98X9rKsma0Dtwj17wB1XpsZDvlH9NjvQCx6bgvWKkfpGTjkkursq3W7lgBJF4iKg8+NuyrOGZRBNI64ZWTMui+d0dCroVgiqeUIKIcEKXQnD6B/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246989; c=relaxed/simple;
	bh=fsrPpCyResezhB94a5ZRqYnxhC3UvmRsHA4u5bWmdgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDINFW5gLdVOx/7HHvTPsSvdbwNps/aIEMtR0HgLjJ6PX953MzSZLLZhtluaomb81eCd1ng0g4pEkntq26EZ7G79p8U7/cs7/0wmwgrrGREfmzTBqYXjtpCVu7BtlHmR+SksEy4/6YHlQtm0pGTV2mLHQvPS9W0qBjNQP1MRCpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2gXBtf3U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2gXBtf3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C34C4CED2;
	Thu, 30 Jan 2025 14:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246989;
	bh=fsrPpCyResezhB94a5ZRqYnxhC3UvmRsHA4u5bWmdgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2gXBtf3UYSOsUk9XeErwmusYtaWcMqtMcNxLw7pyQBhUOQ1EMAMuTjZawtWEinufD
	 b1FFwHxugLUOD5B2tD3gJTc50GJXV+dFcWchBLeVs26vj875UvcXNCVksdsoibtYUI
	 fdLPwHZZMC9Qi/yiTYzh5fv8EvmvBT3OWMAnwkXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 045/133] iio: imu: kmx61: fix information leak in triggered buffer
Date: Thu, 30 Jan 2025 15:00:34 +0100
Message-ID: <20250130140144.328039962@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 6ae053113f6a226a2303caa4936a4c37f3bfff7b upstream.

The 'buffer' local array is used to push data to user space from a
triggered buffer, but it does not set values for inactive channels, as
it only uses iio_for_each_active_channel() to assign new values.

Initialize the array to zero before using it to avoid pushing
uninitialized information to userspace.

Cc: stable@vger.kernel.org
Fixes: c3a23ecc0901 ("iio: imu: kmx61: Add support for data ready triggers")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241125-iio_memset_scan_holes-v1-5-0cb6e98d895c@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/kmx61.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/imu/kmx61.c
+++ b/drivers/iio/imu/kmx61.c
@@ -1198,7 +1198,7 @@ static irqreturn_t kmx61_trigger_handler
 	struct kmx61_data *data = kmx61_get_data(indio_dev);
 	int bit, ret, i = 0;
 	u8 base;
-	s16 buffer[8];
+	s16 buffer[8] = { };
 
 	if (indio_dev == data->acc_indio_dev)
 		base = KMX61_ACC_XOUT_L;


