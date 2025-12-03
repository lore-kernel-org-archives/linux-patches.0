Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8FD324B2C;
	Wed,  3 Dec 2025 16:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778242; cv=none; b=YOsykTDJX1v9tIPyr8yzV1ecLtySO5wxsmJhVzGQBou5AmYIt2OvjT6GH3zjHkqEerD/48x2UtptdXcOtxh7UD/uJ2ZXedkEEQ6UYAAWYfS7O0ftM+pXSrX91tavM5SPiwxOf964k4Qcy9FLpdZyzHWplh4hICveN61u/brcEfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778242; c=relaxed/simple;
	bh=T7Z0f4saomKbf90zrkI3wvqjVSVLD1BWz1nMUNlzulw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DiaEPTwd2xune7ldxLHSEk/xIHwdFwg/s0Q4VxV2HYf1/LLTEv+i6cq1dwU06WLyxe6uV0Xre4wpZq9FJLSJ9MvCwmpi0K4pq5KSIkLBLCQVrotjdTwlU4QbPd6W/guG+EEZpTNcS0Iy18oGPE8KTKT/ITMcuZLaM2Trxo+2/HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VN1UIqhu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VN1UIqhu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9CDC16AAE;
	Wed,  3 Dec 2025 16:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778241;
	bh=T7Z0f4saomKbf90zrkI3wvqjVSVLD1BWz1nMUNlzulw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VN1UIqhuoPaMUaaGbJfPAuGMnQQBD7+QsgvphegxidtT1wUDuzCv/PRu5qF5POlDn
	 /Etkmza+zX1B9TzUyxbNKB3rY0ir3kH2GTDjhx6nWB5Me5y1n2EQm+F22vxB8EqV04
	 IEgjNy34gNVSu+HHiZhAkQrrBIyAipKaO8QuWrgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 287/392] Input: imx_sc_key - fix memory corruption on unload
Date: Wed,  3 Dec 2025 16:27:17 +0100
Message-ID: <20251203152424.719709612@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit d83f1512758f4ef6fc5e83219fe7eeeb6b428ea4 upstream.

This is supposed to be "priv" but we accidentally pass "&priv" which is
an address in the stack and so it will lead to memory corruption when
the imx_sc_key_action() function is called.  Remove the &.

Fixes: 768062fd1284 ("Input: imx_sc_key - use devm_add_action_or_reset() to handle all cleanups")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/aQYKR75r2VMFJutT@stanley.mountain
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/imx_sc_key.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/keyboard/imx_sc_key.c
+++ b/drivers/input/keyboard/imx_sc_key.c
@@ -158,7 +158,7 @@ static int imx_sc_key_probe(struct platf
 		return error;
 	}
 
-	error = devm_add_action_or_reset(&pdev->dev, imx_sc_key_action, &priv);
+	error = devm_add_action_or_reset(&pdev->dev, imx_sc_key_action, priv);
 	if (error)
 		return error;
 


