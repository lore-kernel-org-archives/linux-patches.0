Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C173426433;
	Thu, 16 Jul 2026 13:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209815; cv=none; b=nZ0uGOag4jpS84xRe3ypOrOM2bzaNda4NkqoO3AB5J1BL+BdeoYcjky01ugF/bFBOGYvEo0XUhHLxgSuDp1DQ7cdUIHsxrd/2X+oDGLNm4Iice1H71nbpJcmyRtLXUkeUJFF3PFgIKHbEHeD1RBGLPyDLBmbUOJO/ibZM7E30LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209815; c=relaxed/simple;
	bh=/k/LjMmccc3l9F1XtlQNdprqcGZeofPiEBILydPDpOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RxJoJGf5DoCZXLAaVNdGX2jVnhBWZmPsfJa7aIdnsIM+Um+rSacRVOGZEwEgCvXCOJhaVqdH2AzFDZ+2vEDTcTjIk/nWiVEKkhxfsgMr0QnScH8TrSUmumon7wWiFh5lt2nm6zv7aMtqwpyVCE09lg9kRVU6DPwzET2JK8zqbKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OQ5zU4P4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OQ5zU4P4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410651F00A3A;
	Thu, 16 Jul 2026 13:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209812;
	bh=KsCq32zdABNi/AOQaMapPwHnws4SoP42Rm24F+eqA0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OQ5zU4P4dj0oTJbrR8K2KnHxAtLQwC2hog5QSpnMuRe7YU6YDG0ekL1oHJgK+GV59
	 doM+9ktR2RT5/mrZ9RSFHs+kvoU718CllVz6N89Dt3/WfnnKH2CfnoFayTB19TjTWK
	 c5Pq+OwLaWchjbJKafY8Jr2+XtJcPJRbqPokh3c4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH 7.1 328/518] usb: typec: class: drop PD lookup reference
Date: Thu, 16 Jul 2026 15:29:56 +0200
Message-ID: <20260716133054.990185512@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

commit 43ae2f90b70cda374c487c1639a01d0f14e5d583 upstream.

usb_power_delivery_find() wraps class_find_device_by_name(). That helper
returns a device reference that must be released by the caller.

select_usb_power_delivery_store() only needs this reference while calling
the pd_set callback. Drop it once the callback returns. Otherwise the sysfs
write can pin the selected USB Power Delivery object and prevent it from
being released on unregister.

Fixes: a7cff92f0635 ("usb: typec: USB Power Delivery helpers for ports and partners")
Cc: stable <stable@kernel.org>
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Link: https://patch.msgid.link/20260702191329.2648043-1-shuangpeng.kernel@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/class.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -1619,6 +1619,7 @@ static ssize_t select_usb_power_delivery
 		return -EINVAL;
 
 	ret = port->ops->pd_set(port, pd);
+	put_device(&pd->dev);
 	if (ret)
 		return ret;
 


