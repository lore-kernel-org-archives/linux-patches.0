Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5950B1F80B5;
	Wed,  6 Nov 2024 13:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898071; cv=none; b=U+F/4/9RTI6/Z+DImwDx5HwZGwsunPgxtG4IWmVGc0lWfIQy6yqli0pg0Kz+0e9m01euDZhzD7QzsJAszLHjnxVSH8xM4mJyiHNzTuzV+tdM5eANob8eXt69lDeOXMXgykDohmUwzuDp2WmrDx75TXKN3fo5HY710bUUbqiOvIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898071; c=relaxed/simple;
	bh=gBqyf0E8JnCAN3/FFT5KiZ7dSJR2jOtVsmu6hHngteI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZrxnPvppcFS4qT+C1ihqRCOoAPqI2wOh9nQVHwYymG8TSr9fhnZcHoqupa0KmbZ4IxkJPNxTOQmXWkbjeNGmPN8Uwkz+hhCaonwkdfXEPoQPYL2KiXCmP8j5parBeDczFsGLPX0g2xJBEkWsYi50MxAKNP9IxyfC6e6fB3jD7ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wvd21i9l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wvd21i9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09AFC4CECD;
	Wed,  6 Nov 2024 13:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898071;
	bh=gBqyf0E8JnCAN3/FFT5KiZ7dSJR2jOtVsmu6hHngteI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wvd21i9lgcg6lwdoMMwJBSbKpIMBSgwtFjidIIKybQyTQvIXx46LVNxo7gA89HFLH
	 zj/88+nwr3P8hmnTxRq3V9lnySgPUskcCHBGJD+aHlrD/hvKszzYAgYCIZTdIJMO6S
	 Vj83Y3wo/7hTNbu0PZVhw/Gtpnh7z4zXlIzFZt+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 067/462] fbdev: hpfb: Fix an error handling path in hpfb_dio_probe()
Date: Wed,  6 Nov 2024 12:59:20 +0100
Message-ID: <20241106120333.167088060@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit aa578e897520f32ae12bec487f2474357d01ca9c ]

If an error occurs after request_mem_region(), a corresponding
release_mem_region() should be called, as already done in the remove
function.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/hpfb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/hpfb.c b/drivers/video/fbdev/hpfb.c
index a79af8f069d16..40e51a2fc34d0 100644
--- a/drivers/video/fbdev/hpfb.c
+++ b/drivers/video/fbdev/hpfb.c
@@ -344,6 +344,7 @@ static int hpfb_dio_probe(struct dio_dev *d, const struct dio_device_id *ent)
 	if (hpfb_init_one(paddr, vaddr)) {
 		if (d->scode >= DIOII_SCBASE)
 			iounmap((void *)vaddr);
+		release_mem_region(d->resource.start, resource_size(&d->resource));
 		return -ENOMEM;
 	}
 	return 0;
-- 
2.43.0



