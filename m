Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C3A55409E;
	Wed,  9 Sep 2026 14:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963099; cv=none; b=Q0nyWAGYFBei4rkPHvoAE2TPVL3BHGJfVE7O3Ov9VbsyK9JIJHBXXp7TGo+Q1h4teZ+LwQSdpi5hs5qmpIx/FNAI1/LIU+fCle4KA55fpvNFmkCBzXZXHvI/TRG1sY8Wehnj2PJqi9GEKAmxM6f8yPrE3W6IvdpPb7JE5MVe7nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963099; c=relaxed/simple;
	bh=ZGcq20Zh98o5uE7QWL8fwI6qLoqiKfXOMZLkKsVQJlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0lSsoDiYOVNWTxSWjn9349zZRsqaQ15H7issxMzwh2BpU+gry/YCmdWDVpC+RsZkOuuQ3cOjZPzLVgis4MRPmRjy4fsBZiIdeDAzgFFhHQw/W1ooaP1ESxOi5prQ/gwtznxvrWkXRleHkl9ZBtXM8Q0DBG6AN6os3INLJjtvF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cBGKFKyc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cBGKFKyc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97F81F00A3A;
	Wed,  9 Sep 2026 14:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963098;
	bh=pkjUvyhoC+3kxnq0fsiTlvVwPkS0N/6eAJfRl8uGRvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cBGKFKycUO6fWARS1jC6ipUI25/0VlFraiyaL7viYP6lMWtw/FPrs3SMzQI9VeJZ1
	 ZNy/FaO1+su8rFwoyF4GSipr4EZjkzkVSGd10Zivp6GI7teSimUh9RAdH5Tz0vVmlu
	 +v+HDeZE6Q/ksjTPlsv3IqCY984Aq5v2e2LkTstI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>
Subject: [PATCH 7.2 483/556] drm/sun4i: fix refcount leak in sun4i_backend_init_sat()
Date: Wed,  9 Sep 2026 15:42:43 +0200
Message-ID: <20260909134247.511446847@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -686,7 +686,7 @@ static int sun4i_backend_init_sat(struct
 	ret = clk_prepare_enable(backend->sat_clk);
 	if (ret) {
 		dev_err(dev, "Couldn't enable the SAT clock\n");
-		return ret;
+		goto err_assert_reset;
 	}
 
 	return 0;


