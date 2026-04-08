Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F193DA5A5;
	Wed,  8 Apr 2026 19:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674869; cv=none; b=mRgIComX0WVyDnvoe3l59ZmHEOc74EFqX56onm0rekavE9KwdBDzJeG8JIoRLBUKWdhKjFr255/EAYz9K4WEjkZ7ftm4IN6UyO3ceq48Ps4cBYK+k1k+DYX8d7svZODP7sQta7+E9luEabXfWk5QYbciyjCM1UIjRxIm4Xcf+eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674869; c=relaxed/simple;
	bh=PhkSH4Ja0Kx/25aiGt/YUdmbeatoq8vq516lYmpeyv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dV89GEtwE9cTW9pG1zdOMqDir42m0CpLdFPcNopMSYYH30k6Ix5M/3NTAAnb2Ve2ZAbgKt2RXZU+foZ/KNUXa2GI5fqyTPI2jMElgotDi67DBjW2h4vhGtr6SRU5OYg3DQLFIu4S9WX3fD64dgQKK0uOmNfBHQ7OpIdO6oF2jno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4sOIcoL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4sOIcoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F78C19421;
	Wed,  8 Apr 2026 19:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674868;
	bh=PhkSH4Ja0Kx/25aiGt/YUdmbeatoq8vq516lYmpeyv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4sOIcoLDy8tlMKi9RsGgW3nIwN2sgZ5hDrLug+zfgYRgtjHV4zIW0aVtEWjJ6ZpE
	 mXHJzaUejOnRVgACKb7GaG1K8k7EzaCz0FVhiU1mJHjqJC9y975wgupS/b0qLtgAn4
	 E/AeqVq78Ov1yaM2fUnk+ZzwIG58Q5dva2N6uabQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 6.19 264/311] reset: gpio: fix double free in reset_add_gpio_aux_device() error path
Date: Wed,  8 Apr 2026 20:04:24 +0200
Message-ID: <20260408175949.241001089@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit fbffb8c7c7bb4d38e9f65e0bee446685011de5d8 upstream.

When __auxiliary_device_add() fails, reset_add_gpio_aux_device()
calls auxiliary_device_uninit(adev).

The device release callback reset_gpio_aux_device_release() frees
adev, but the current error path then calls kfree(adev) again,
causing a double free.

Keep kfree(adev) for the auxiliary_device_init() failure path, but
avoid freeing adev after auxiliary_device_uninit().

Fixes: 5fc4e4cf7a22 ("reset: gpio: use software nodes to setup the GPIO lookup")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/reset/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/reset/core.c b/drivers/reset/core.c
index fceec45c8afc..352c2360603b 100644
--- a/drivers/reset/core.c
+++ b/drivers/reset/core.c
@@ -856,7 +856,6 @@ static int reset_add_gpio_aux_device(struct device *parent,
 	ret = __auxiliary_device_add(adev, "reset");
 	if (ret) {
 		auxiliary_device_uninit(adev);
-		kfree(adev);
 		return ret;
 	}
 
-- 
2.53.0



