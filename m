Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A071BF7F9;
	Wed, 20 Nov 2024 13:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107706; cv=none; b=KBp8kZDfDlmQ5YbCvr+b4H9EDhnfj1vX38TXPbFLYoPQZMAVSuMToUtyUB4CE83IljT+EHZWnXQ8KqqaAVljfM9UUPrWzat8QdCBMkoDYDjsgFdXpkzCZW8UbKxDYF2fbweVeIpUJ2nDAfND3c5zh7oPXLNLQLoku0ru7hVBdDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107706; c=relaxed/simple;
	bh=eU4MkmWWhIyYiBKEr9JEJu0Q+UOovqoxRVvdD+6RY/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0MbG/jtjh6ChKQRGyGQUqjfC0qyrTSHV9z5IuGAqCXqg6t4HeXI2iMEVDWnUQrN4uFSAwfDXrnM7JLh9udkQShH0BHpnh8a5LObfZEwzO8e6OJacfLOLqnf4dW6z3i1/kSgl6AIF4WXW/sC7sl6rooK3ubE7139iOH5FUWN6DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qg4Im6dF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qg4Im6dF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDD6C4CED1;
	Wed, 20 Nov 2024 13:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107706;
	bh=eU4MkmWWhIyYiBKEr9JEJu0Q+UOovqoxRVvdD+6RY/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qg4Im6dF6CE/qFycail+y3gqR3ZYPJXUicYkOJxyxIwfvCoWkh1MKpMq95w6UuT2X
	 xnBijE3C1D5pxl+YVOZOFTwcT/U9IrvtwE1QWPJwpVj/Ca01A5vOgvbuYDEZSGB5fG
	 n6SxDiQPt5rQjglmG+m0N1l+K/nG9zyBOLdyObrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.1 70/73] null_blk: Fix return value of nullb_device_power_store()
Date: Wed, 20 Nov 2024 13:58:56 +0100
Message-ID: <20241120125811.284664756@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Damien Le Moal <dlemoal@kernel.org>

commit d9ff882b54f99f96787fa3df7cd938966843c418 upstream.

When powering on a null_blk device that is not already on, the return
value ret that is initialized to be count is reused to check the return
value of null_add_dev(), leading to nullb_device_power_store() to return
null_add_dev() return value (0 on success) instead of "count".
So make sure to set ret to be equal to count when there are no errors.

Fixes: a2db328b0839 ("null_blk: fix null-ptr-dereference while configuring 'power' and 'submit_queues'")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Link: https://lore.kernel.org/r/20240527043445.235267-1-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/null_blk/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -470,6 +470,7 @@ static ssize_t nullb_device_power_store(
 
 		set_bit(NULLB_DEV_FL_CONFIGURED, &dev->flags);
 		dev->power = newp;
+		ret = count;
 	} else if (dev->power && !newp) {
 		if (test_and_clear_bit(NULLB_DEV_FL_UP, &dev->flags)) {
 			dev->power = newp;


