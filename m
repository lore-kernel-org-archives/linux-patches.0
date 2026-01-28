Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88EE308F3B;
	Wed, 28 Jan 2026 15:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615540; cv=none; b=lzW1I1e7eAO82+2NEKyT/jVDll8wp3qCK4yUM5sMOVqV4vDlhhUyB2Pwwp0lUcSXql/bR+DusdrL+HpeM+mV1UnOsnEj631NdFq+xHzrT+heFv9JzYPum3eM+nY0reONwNkmjKHAOf2RBJ6xT+x2vLh6LbuzCFZ8tnvWAX9VNuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615540; c=relaxed/simple;
	bh=6jXQdvS4rOltFuTDh5KwlMPwoeWEH363Hra+YgyFG0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nrALTVt6UXmg324TJnrRUeUZoG97bLBroVAG6255RJuWPoe7dhV440PQPll82HdhzDPAuYjrkTgyPYer/J0Ds77e3fEw2jiji6epKg/qpraoNE2tmNDUVQK7Sv7iPuLyaelV43B0gg7miyEdi+xYO6d6dhk/PVeN9z+G9db4vLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=olYOyq6k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="olYOyq6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7CCC4CEF1;
	Wed, 28 Jan 2026 15:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615540;
	bh=6jXQdvS4rOltFuTDh5KwlMPwoeWEH363Hra+YgyFG0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=olYOyq6kb9sG6OORCBfDGvTnhmFJgj6T3PtwtZiDeGBKHijLqhVHPbfd/BS0H62he
	 ABw+5rzBdPROKmDqYOR6y92v3R/BSwITLs5D305PnD48vbkbnW0RBbaok5RNSycPj5
	 pDlmMySG2Y/Q+OxHghCZqvPj/4LPp5xxVs6x2UIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 040/227] pwm: Ensure ioctl() returns a negative errno on error
Date: Wed, 28 Jan 2026 16:21:25 +0100
Message-ID: <20260128145345.785798692@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit c198b7773ca5bc3bdfb15b85e414fb9a99a5e5ba ]

copy_to_user() returns the number of bytes not copied, thus if there is
a problem a positive number. However the ioctl callback is supposed to
return a negative error code on error.

This error is a unfortunate as strictly speaking it became ABI with the
introduction of pwm character devices. However I never saw the issue in
real life -- I found this by code inspection -- and it only affects an
error case where readonly memory is passed to the ioctls or the address
mapping changes while the ioctl is active. Also there are already error
cases returning negative values, so the calling code must be prepared to
see such values already.

Fixes: 9c06f26ba5f5 ("pwm: Add support for pwmchip devices for faster and easier userspace access")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/20260119151325.571857-2-u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 7dd1cf2ba4025..462c91a034c8e 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -2294,8 +2294,9 @@ static long pwm_cdev_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 				.duty_offset_ns = wf.duty_offset_ns,
 			};
 
-			return copy_to_user((struct pwmchip_waveform __user *)arg,
-					    &cwf, sizeof(cwf));
+			ret = copy_to_user((struct pwmchip_waveform __user *)arg,
+					   &cwf, sizeof(cwf));
+			return ret ? -EFAULT : 0;
 		}
 
 	case PWM_IOCTL_GETWF:
@@ -2328,8 +2329,9 @@ static long pwm_cdev_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 				.duty_offset_ns = wf.duty_offset_ns,
 			};
 
-			return copy_to_user((struct pwmchip_waveform __user *)arg,
-					    &cwf, sizeof(cwf));
+			ret = copy_to_user((struct pwmchip_waveform __user *)arg,
+					   &cwf, sizeof(cwf));
+			return ret ? -EFAULT : 0;
 		}
 
 	case PWM_IOCTL_SETROUNDEDWF:
-- 
2.51.0



