Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F209D34752E;
	Sat, 12 Sep 2026 11:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214131; cv=none; b=OyXW2cfGjV0n0OLLDE+RGWwHr+XcRfxDi9ES1FvxzEBk61D4a3MtaV8pG/veUFkxRYLyi/spO6ttP0/eYyBUBLPjOALNaOfZcNeny1WfNSc1ZWAZmYcBLzjrZYHAwj6ti99Z7PnDm5vXf2C1UU2vRFQKLVmUXzbPJ6cOBKcFViM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214131; c=relaxed/simple;
	bh=i08uMt9XW6vvigzysJlIuKiXgPFUd/OAkqHY8BKJXzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5C82iCwnqXtNDY9WM/Xy/jxteHKEvtYZdcnW4qn/tPWAlG0Z9WREF6EjovEqczSr5AgMN9KA7VHorU3EZ2XYWP/jUzTPuB40RGspzpqPAUfl6a+oxfGgCrMjw97iCKUp06We/594yiMWnn6wB50UdDh1XNbCUa91JZ5Y0Wj6Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vCqMQQah; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vCqMQQah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367FC1F000FF;
	Sat, 12 Sep 2026 11:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214129;
	bh=EjuilKq/jCyhLT0BQRLK+w14RAr8WrHD3gXS8+c9UsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vCqMQQah0cw0eo1/BC7e7iAEyVr2EFa/TOtBLrqulkDgPhk/4dS21DK5+GWtw6s6f
	 k+3rLtve/8UWYVCWOSYvUFmRK3b0AUzQN1u+63bSO/J53wIHpwX+AeOMiogqweT/22
	 hqWI5q9vh18D9XAUVr2QFMcgSyP0wqghPAG/TRq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>
Subject: [PATCH 6.12 0264/1376] drm/sun4i: fix refcount leak in sun4i_backend_init_sat()
Date: Sat, 12 Sep 2026 08:44:50 +0200
Message-ID: <20260912065613.424259503@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -685,7 +685,7 @@ static int sun4i_backend_init_sat(struct
 	ret = clk_prepare_enable(backend->sat_clk);
 	if (ret) {
 		dev_err(dev, "Couldn't enable the SAT clock\n");
-		return ret;
+		goto err_assert_reset;
 	}
 
 	return 0;


