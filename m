Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9116B248BA0;
	Wed, 15 Jan 2025 10:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937753; cv=none; b=CEkHExJoW5lE3wS6QINu5IGAhIdXH6TAKcfm/LW9UvQDvno+YfTh4nTqUuNSy/x/oqpRBXgat3PIfwLpzgpcaVG+u1cd7rWKVc/iPi+Q6LlpvJVFmbiWW3nS4+2lv/GO71JicQFz8cnkXtfpjGyVBcxUZyC8NR4KWj3a0vQADeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937753; c=relaxed/simple;
	bh=SUcy45RplAgE0a6em4aH7uonpRGg4QA+h1kNGc0imP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WvsWr1WW6B7Zt4oHuItvpW4+o4Ue0aVCmPddQVOzGM2LMvq9uB1LQmTZ+ZOkqflCT36chLGtZmE5qHaaJf2RSX5eqrIskOLjra1e9gYo5+ELc8xUt95wnvOcTmSV3sOYE6L+bZPvGy3YVCvAGjKaUO0xKg45LYtxIOPjoQvmAIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bLHGy5RB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bLHGy5RB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99365C4CEE4;
	Wed, 15 Jan 2025 10:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937753;
	bh=SUcy45RplAgE0a6em4aH7uonpRGg4QA+h1kNGc0imP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bLHGy5RBjwLA0A4bwUiTsXhDILJRInG0+rUxiFUPqAnsXKPs0nZItdd6bdW/q1GiD
	 hu5ZBaZb+OuCzHV4fk7UgOowdHpl6+R7X0gpKjgFEujv53YZ+82u9cUttQB8Rb3QA3
	 fq1Gg82G58/yNC11+ep98QzBxFo5S0CaQxDkQksY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 72/92] iio: imu: kmx61: fix information leak in triggered buffer
Date: Wed, 15 Jan 2025 11:37:30 +0100
Message-ID: <20250115103550.434462406@linuxfoundation.org>
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
@@ -1192,7 +1192,7 @@ static irqreturn_t kmx61_trigger_handler
 	struct kmx61_data *data = kmx61_get_data(indio_dev);
 	int bit, ret, i = 0;
 	u8 base;
-	s16 buffer[8];
+	s16 buffer[8] = { };
 
 	if (indio_dev == data->acc_indio_dev)
 		base = KMX61_ACC_XOUT_L;


