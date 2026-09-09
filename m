Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5BB572699;
	Wed,  9 Sep 2026 14:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964308; cv=none; b=kJm1bp2f+9nRB2ZDD1Rbm3V+X53RMIDz4MID8dbkVcD9Ar2FgRMRqk2Ca9YgNrwzvfPHS2Rt9tbiZDHTNOxgwJUcpvAmJ7LSnmHLqpwwZv/RRy9yCVTTXOs7PGEMmFJATAFcWDx266lTmqf/U9T0AKaKeukNta55fgJvVhoIBYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964308; c=relaxed/simple;
	bh=4nbTprAkfnRSwR+ZbzzguctSBfNL0zZ0Yh9XQEjCUvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tve0RGA21uANvyET8pV/0ojI9SXo/LsSgh/SMWX66mLlsKya7Ye6/mwgk3PLiWkz34nZVhoCVRPuW6AjgUHFrDaZEef3IEtfww+WBvInD+IYPBwsauQZd7d4HgSmlDWu9lXVneAchjarskyTUkEzS6aOoqcqdot9pHtswn87f7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sooNnxeW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sooNnxeW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA701F00A3A;
	Wed,  9 Sep 2026 14:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964307;
	bh=Q5abuy3gSz31w99Z2rIgkmMW/ZQydnYf2PW76aRdfI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sooNnxeW1CeD25zNCqBROG7S72P8nS5mN9Jpk2uFkwbZD/Dc5hTZ+mtir2p6LEvyK
	 avCdmdkDhkS3uVrFwtLjKWwLBwgiccgEFwVG8qkftDgzojSLOgPHQeTEZ44p8+JCBn
	 EP7QWdb6MJTXmwO7je5t/yg6KWseCHuCAEGSSLVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>
Subject: [PATCH 6.18 378/583] drm/sun4i: fix refcount leak in sun4i_backend_init_sat()
Date: Wed,  9 Sep 2026 15:41:03 +0200
Message-ID: <20260909134251.114950725@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


