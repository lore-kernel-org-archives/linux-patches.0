Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C8D7E110;
	Tue, 11 Mar 2025 15:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706240; cv=none; b=ZTPnql/8wFP0X9YjofRJ3tpy/rRD4KrpJHdaAIrSp+ydOZwbQUS4U2OQJ/9C0tHe8qzAsYfwxPUiD1n0leqPyypaL5tFYjvGzCbWNZOz/kOnJXpl8UYVnc/AAOV8KXa/aUXEOW1eJt0QF9ftcduHk+a/smO7QedLlbKHsrR5jN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706240; c=relaxed/simple;
	bh=CYnA7oOcOzj9PlCpXe9rmLc8oFDWIHjvrhi/lr/lz2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APtYMeBhs7O0A1dPmoELOqutF166yooKym4GXWim5yJhWh8xI4HqYp2OwFZ5/GljYuiigyc3P1e8GGsJPAnEHRHzBAqPTrxunQPrPMHyt9CkhBUlbh46Cutz7zfKuIdhzGB2QhRsmXKAwy+oefYAZej7YcyLCJP3GIShLbDNWo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1gug6Wm7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1gug6Wm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC774C4CEE9;
	Tue, 11 Mar 2025 15:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706240;
	bh=CYnA7oOcOzj9PlCpXe9rmLc8oFDWIHjvrhi/lr/lz2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1gug6Wm7gZ0PaNvppAzxaxp6AuHLPZXcaT6O4AT+boXXLTyXOWDLGuXNTJGMRE2Qb
	 AI6Rjh7mnlTqbiedJ0I4lBj35AfJGWJMXT6gNsqCVRkBR5hqEZVeWHn9hI61IUtLrG
	 mQTbzgu5oLnZMFGSS+kxNSmhUD2bsqDNFMDVq5Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 291/328] rapidio: fix an API misues when rio_add_net() fails
Date: Tue, 11 Mar 2025 16:01:01 +0100
Message-ID: <20250311145726.476624844@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit b2ef51c74b0171fde7eb69b6152d3d2f743ef269 upstream.

rio_add_net() calls device_register() and fails when device_register()
fails.  Thus, put_device() should be used rather than kfree().  Add
"mport->net = NULL;" to avoid a use after free issue.

Link: https://lkml.kernel.org/r/20250227073409.3696854-1-haoxiang_li2024@163.com
Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rapidio/devices/rio_mport_cdev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -1743,7 +1743,8 @@ static int rio_mport_add_riodev(struct m
 		err = rio_add_net(net);
 		if (err) {
 			rmcd_debug(RDEV, "failed to register net, err=%d", err);
-			kfree(net);
+			put_device(&net->dev);
+			mport->net = NULL;
 			goto cleanup;
 		}
 	}


