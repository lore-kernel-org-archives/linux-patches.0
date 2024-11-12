Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405502144D2;
	Tue, 12 Nov 2024 10:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408524; cv=none; b=ZA9Il3DmCRrD+jtzkDk3B5K8AzT3Ytsx4zGq/LkYDEX2m/1/tUHBHA9nXsLr5dEVQJKfXbYCssoCY3nsLhMbT77OessnyXzh97B+zI0UjXgHJk3aCA9ym6AX+vkaU04RxxQDk+vTCD3v0s9xaYjPGdYHErbFSWtvzNDOujs1CwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408524; c=relaxed/simple;
	bh=jz4gqpdeyVvzBKF8Gd5UGnQeYfh/PXEuqfvO5SLqXuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TqyRQQSzqQ8qyXdWxjtoLyuEwTTxanzYbkAMo3Ype4M01Un3ZX9vDbRj1ZuixYGyvRJ49MTWqxTOhMIHIeo3NfZnzGQ4aaUNjq4SycBUqCvDgWYWgiBDpPRw5J597Y902fGZWr3I+dJ/N39Bwg6YEKinVg3kYRJSyUNQWXBTjCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zU7ywtZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zU7ywtZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A78C4CECD;
	Tue, 12 Nov 2024 10:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408523;
	bh=jz4gqpdeyVvzBKF8Gd5UGnQeYfh/PXEuqfvO5SLqXuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zU7ywtZD5ejjur4BKiBsPWQDTwtL4Q3TpPqmBcc19+cE7QsDc8m3U9IhYLqw/DAoh
	 uZ2tgd7aDehk/qM7J0h8EWM0E+4w8jdQJh46AWqL0g8fASKc5vy6VpOtv6Szjr9gwn
	 TfgMvRLOpyOA402EY/YdSEElpXud+m+wtx2h+n4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umang Jain <umang.jain@ideasonboard.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 6.11 168/184] staging: vchiq_arm: Use devm_kzalloc() for vchiq_arm_state allocation
Date: Tue, 12 Nov 2024 11:22:06 +0100
Message-ID: <20241112101907.315123525@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Umang Jain <umang.jain@ideasonboard.com>

commit 404b739e895522838f1abdc340c554654d671dde upstream.

The struct vchiq_arm_state 'platform_state' is currently allocated
dynamically using kzalloc(). Unfortunately, it is never freed and is
subjected to memory leaks in the error handling paths of the probe()
function.

To address the issue, use device resource management helper
devm_kzalloc(), to ensure cleanup after its allocation.

Fixes: 71bad7f08641 ("staging: add bcm2708 vchiq driver")
Cc: stable@vger.kernel.org
Signed-off-by: Umang Jain <umang.jain@ideasonboard.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20241016130225.61024-2-umang.jain@ideasonboard.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -593,7 +593,7 @@ vchiq_platform_init_state(struct vchiq_s
 {
 	struct vchiq_arm_state *platform_state;
 
-	platform_state = kzalloc(sizeof(*platform_state), GFP_KERNEL);
+	platform_state = devm_kzalloc(state->dev, sizeof(*platform_state), GFP_KERNEL);
 	if (!platform_state)
 		return -ENOMEM;
 


