Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5352F39C2;
	Sat, 12 Sep 2026 18:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237939; cv=none; b=CmmCgXAw+fmJXbqky5MMCAbdOwubQkILgDUcabYSepArEPb4m+T4wJE+u4KjCg4uSlEOZCzY6OX6UzhFUff8NybdH1yiZIFSyuqYoSVza4jTkMwxiZAi7ni3Ed0lgZr8l03JmypN/z1XZ7H/i6w82acOYRWanQEj9iYNpfsDaZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237939; c=relaxed/simple;
	bh=A6jlFyfrf6R6dHLJnYBzzy9P2efZAHzGKJ47IwHX0Ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g9UBVCvoeBCI80Mae4GHciRBwNc6rfUDb0XNff86+J7JjQsMhQZorjJSDjxH583+LKeS/t9w5K5pVQifwIkQKZI3d4HBt4AnWntrs/c1UHbBzP5+/wfL/Y2rlysLYWJodzqgf3LxbkNdvCkqKZiaXhwaUzCs9EP5KeBVLmM2j54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q9TXZWni; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9TXZWni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4291F000FF;
	Sat, 12 Sep 2026 18:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237938;
	bh=Royy/45FSjJdZ5HObPZpV+SH1UVwxDtykOLlfBv1w/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q9TXZWni07iZQmQer46q7cfNGiQghN05YvHiWnhNdSeLY7mAKaLYiSF7sTF5BACKs
	 wnaeYwjll8odmrI3Xf7SyQDJoS4ERH1+da58SFUGUTySLmqSEkGuZy0lNsIWVV9mzE
	 RfRynRftIlEnwem0/eR2pGfD3mkONw/uBQG/KZic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>
Subject: [PATCH 5.15 361/935] drm/sun4i: fix refcount leak in sun4i_backend_init_sat()
Date: Sat, 12 Sep 2026 08:56:31 +0200
Message-ID: <20260912065535.085110806@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit f7a56ff6240e6fd0cb36a3c0a911a1cd54789ce2 upstream.

When sun4i_backend_init_sat() calls reset_control_deassert() it
increments the deassert_count of the reset controller, and must
pair that with a reset_control_assert() call to decrement it.
In the error path where clk_prepare_enable() fails, the function
returns immediately without calling reset_control_assert(), leaking
the reference count.  Other error paths, like the devm_clk_get()
failure, correctly jump to the err_assert_reset label which performs
the missing assert.

Fix the leak by using the existing err_assert_reset label in the
clk_prepare_enable error path instead of returning directly.

Cc: stable@vger.kernel.org
Fixes: 440d2c7b127a ("drm/sun4i: backend: Handle the SAT")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20260607030950.83636-1-vulab@iscas.ac.cn
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/sun4i/sun4i_backend.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/sun4i/sun4i_backend.c
+++ b/drivers/gpu/drm/sun4i/sun4i_backend.c
@@ -680,7 +680,7 @@ static int sun4i_backend_init_sat(struct
 	ret = clk_prepare_enable(backend->sat_clk);
 	if (ret) {
 		dev_err(dev, "Couldn't enable the SAT clock\n");
-		return ret;
+		goto err_assert_reset;
 	}
 
 	return 0;


