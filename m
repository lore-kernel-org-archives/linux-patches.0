Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE00175A6B;
	Sat, 30 May 2026 18:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164805; cv=none; b=CDwzY9jgdi/cSulBLq+io70nwcp/uJlZTXAkDoVZVpnh1oiJZAXmeAjKyaHhwNjfXpI8YfaBIoOOwDShq5jZg2jBbuq1stSbjAIQCi4+H+dv626QMXAnd1x5hDN3QaZNry/7OUYlKOj5+oe7JKeP7zycxzuSxWjj6LAv3atxQDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164805; c=relaxed/simple;
	bh=FYfnezWKJyc0cag00UQt6P30uDtZDaBzAqtsS5DyQiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dSJ9aSVriZmG/n+LwKK9pxm01szOqXUSSXUg3x7DB4L5J7HBgDGbugN7fnS9NoUBgooFmTloqh6jkhCTriYZK9MPfqDri9g4WnAuhG2yjYkYSO9Itrgl+CYAPD7gPcOTIHMwp35t93t0vhR1V9J6BBEfSUiaRrIGxeYkhyQnJeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VH/reryi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VH/reryi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827AF1F00893;
	Sat, 30 May 2026 18:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164804;
	bh=RzKM6AoiYMMKG9QWDlBTbAOxEEIqGJ4IDLzaE/689RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VH/reryi9L68birGXLU/vP/183k1g4Erdm1PpQh2w2ei1w3aSQQFU3rvk0Zwmo5sO
	 dluWgxWT/q/RojY8Sn5ZN9kaPSUxkpIs1juXpK3hYmQeVUcerP4XgALUdJDFrCL2QV
	 /4pFXRXoHmRr94AL3zVqAdqfVSpqwvFRDsH4C/po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gyeyoung Baek <gye976@gmail.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH 5.15 665/776] drm/panfrost: Fix wait_bo ioctl leaking positive return from dma_resv_wait_timeout()
Date: Sat, 30 May 2026 18:06:19 +0200
Message-ID: <20260530160257.075979328@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gyeyoung Baek <gye976@gmail.com>

commit 459d75523b71c0ec254d153d8850d0b7008af396 upstream.

dma_resv_wait_timeout() returns a positive 'remaining jiffies' value
on success, 0 on timeout, and -errno on failure.

panfrost_ioctl_wait_bo() returns this 'long' result from an int-typed
ioctl handler, so positive values reach userspace as bogus errors.
Explicitly set ret to 0 on the success path.

Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
Cc: stable@vger.kernel.org
Signed-off-by: Gyeyoung Baek <gye976@gmail.com>
Reviewed-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/fe33f82fded7be1c18e2e0eb2db451d5a738cf39.1776581974.git.gye976@gmail.com
Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panfrost/panfrost_drv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -319,6 +319,8 @@ panfrost_ioctl_wait_bo(struct drm_device
 	ret = dma_resv_wait_timeout(gem_obj->resv, true, true, timeout);
 	if (!ret)
 		ret = timeout ? -ETIMEDOUT : -EBUSY;
+	else if (ret > 0)
+		ret = 0;
 
 	drm_gem_object_put(gem_obj);
 


