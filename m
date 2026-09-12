Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BE13176EE;
	Sat, 12 Sep 2026 19:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242187; cv=none; b=S0/i+potvuze+vwVSIJpHk/KjkclS6d/TvZ99eyNBUEUps+PwPyV3rXjXTfWfnD8SaqK+N33V9BmHgKyxhdFsCfaYejGN+UIOzfHL0HnDoqTZCY5hSITbR9z2h+nEbGcX5YWhIcPUXHEv6DXcd5aVbnsvWAgGBM+yKZJ1H73aD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242187; c=relaxed/simple;
	bh=xXAYtjTSBVybjbGHkvU1BBcrKa0BTy4V9WCQBGFrSiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rtnh66lOdkVwiYUpG0PmNRQwccLvcSLlBlaTPjHOu1y7Q9nZQFQbs2WjaFruPQyXyQD1XJdkq9XIWG+B7V8evIPjYVcGSO/3hzCv9Me6iLZI2J3IShQn07fO2Qu/37RJ3/+/I4v9q88ikkqIDVi4VcJJDYa27Oxc2xDs2GEvlyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fBSN7/NM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fBSN7/NM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096881F000FF;
	Sat, 12 Sep 2026 19:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242186;
	bh=U4W0a6NhzmqiGROft/hpYUMu4Hrjh8Tg/7bnCwOVLhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fBSN7/NM+kxGsantqCyIa+doMfopMvpRUJEkFn67oSCA0amfRLAO9Wg74CNSuW4wv
	 hdx3iSZhfZsvsPoDIH73rty9U+7lUOnHA38eyEjz8pwGCvPOUsXAJE858gOjzcuLrJ
	 872m1h6yZkQSLf59WIY/3bFgJLOQnnkFrXYqqivw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>
Subject: [PATCH 5.10 315/798] drm/sun4i: fix refcount leak in sun4i_backend_init_sat()
Date: Sat, 12 Sep 2026 08:59:03 +0200
Message-ID: <20260912065524.380137763@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -682,7 +682,7 @@ static int sun4i_backend_init_sat(struct
 	ret = clk_prepare_enable(backend->sat_clk);
 	if (ret) {
 		dev_err(dev, "Couldn't enable the SAT clock\n");
-		return ret;
+		goto err_assert_reset;
 	}
 
 	return 0;


