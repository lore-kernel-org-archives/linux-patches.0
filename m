Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162E523B61B;
	Wed, 20 May 2026 17:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299930; cv=none; b=a5OOzNTw6BqdLV4efQDfnJDWbMCg3pabnNGHzHK03LHjqVDWww/zHHLfGwCpWdl8ub5TG73vXlX8mcxNcIX6xjBY6nAG2umMASqMg3E2VfVGQJvTbk8Jqd9stwNQ4hAhmx8yjaGNXJ6l6NH33yvlTlowX+couOYG/zb/cj7ibT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299930; c=relaxed/simple;
	bh=xlNDHDEx18MPabqMLrbKd3Nag1tJbjJnEgaGbIsq3ZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z6Z8Vt0D8J7c2iPXzmuIkn+jxBiRg8llewCdwsfIb3ETf4rYnxypOJwHGFdrZqW2l7RzD7sDEFYiUdEbECxaPShRXWGp2R9mZxlJOC2Iahim/CWKfpnhp4zWCNP5ITzC9Xp8aL+p5WnaV2jiJxAgwDXfmzmbMSUoN4SnRZJYXWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=thqr2QM9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="thqr2QM9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336781F000E9;
	Wed, 20 May 2026 17:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299928;
	bh=bAlpf5+pA+HLzLdJNr5uaV1QtQkyWDIpEEb335mTIPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=thqr2QM99tBtMAuxSXMnmwLv3sH/KDb+yOAEn1t4+ICTH82Lgt511wQL9sV7XSS+F
	 Z7RJG4vAvnRmlALtSeQSSSdxvxbj3GlTmEas5b8SZT/qzUw3HSKOKM7VAU238YMrIH
	 q2XX3jz353XeinJlIFGCri95aWtGtRZNuLcdggN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gyeyoung Baek <gye976@gmail.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH 6.18 941/957] drm/panfrost: Fix wait_bo ioctl leaking positive return from dma_resv_wait_timeout()
Date: Wed, 20 May 2026 18:23:44 +0200
Message-ID: <20260520162155.004551259@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
@@ -365,6 +365,8 @@ panfrost_ioctl_wait_bo(struct drm_device
 				    true, timeout);
 	if (!ret)
 		ret = timeout ? -ETIMEDOUT : -EBUSY;
+	else if (ret > 0)
+		ret = 0;
 
 	drm_gem_object_put(gem_obj);
 


