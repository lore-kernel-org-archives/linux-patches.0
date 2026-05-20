Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A3B270545;
	Wed, 20 May 2026 18:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779303070; cv=none; b=lXekRe0EcYrx0WC4HacDVz4yFVgGQgINOhINMGlOrRLfA8rNj2bb0f2SlkOZHi+qHUQtEpu9t8n2ryCwTG6HWrk7GnxlwwwdJ1BsEmnIxbcr0iraBx0EjEW0RaqWEiCEIT224L3q2wUXsywBVPsFDS5vnlPvzawt3zMqO5GsygA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779303070; c=relaxed/simple;
	bh=r7ELDi5vjd3jmtLHHYg4mWI0isPjTm9obqi5l4DvLAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QtN2LtcMZJgeU9kuVrKd9TMN3l1bY+ToPzqJACN4CdXtBNtX3rxYYsiL9p3QLdsy6nNzXlbiyRP4nI0rE0CGDVStqGpnGlP0cGjBMHKHsZ+mDy587XO13FhO4g4qK86IGzqm9dnfctVOkG/yodqZvkhYZsMxrzQX3bWVQK8/RqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tvbhQWGH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tvbhQWGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954251F00893;
	Wed, 20 May 2026 18:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779303067;
	bh=FUkar5zjTJHI5hC2ml50gIfAnQoyR0pfExI8/okLoPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tvbhQWGHb3L0vdcBrdjqSz0dxTnTdWu5SzL6s1JuoD/ld55fsOu7V4zEN6Z4jrg8f
	 gpYOIFaaFk08Efmmy+NA9E4HkB0uwoQxJJz7gvsLZ/CRkDLh8U3S/al+9L4hqZtDEJ
	 /uxYEt88Eoy5WF8Wke3+0ONzMa+giS27/qKXdJkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gyeyoung Baek <gye976@gmail.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH 6.6 480/508] drm/panfrost: Fix wait_bo ioctl leaking positive return from dma_resv_wait_timeout()
Date: Wed, 20 May 2026 18:25:03 +0200
Message-ID: <20260520162108.993199274@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -324,6 +324,8 @@ panfrost_ioctl_wait_bo(struct drm_device
 				    true, timeout);
 	if (!ret)
 		ret = timeout ? -ETIMEDOUT : -EBUSY;
+	else if (ret > 0)
+		ret = 0;
 
 	drm_gem_object_put(gem_obj);
 


