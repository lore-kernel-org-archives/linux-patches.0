Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240E746AA67;
	Tue, 21 Jul 2026 15:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648141; cv=none; b=nlB5fxnDlXD5Ndc8aEm71nV5ehrfmI0p5dBGhBIqZTCY1s6WWLg3y0o71H89Li4M/wIFxKJ4vHmv5sHiR/bKTjEv8gFdCh1BJJ/zm/APAocr58adaBwknmhvNigvalPJVRJ3puTfBTnz3pzjAc9FrBLXL9bZ8W+O5Aby5w3V0tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648141; c=relaxed/simple;
	bh=+HVTvLgV3OQTggdb8yzP5gT5cNONneDsWwHNfKRc4Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCtJtAVNLwReFsu41hzEgEzpJ9C54cYRHPNrIK37fmgLSLSZzgDJXrlgam8c1eyJ2PC8ba83WmU8qLNcffhiA/3c8c4lGwd9Z8Wm+cSA1j7kExBTMT5F8wF+btt8sP5xR8W8EkSRI6N3c+P2BUoLoMha5D1ykLpkW3RHqmmQnVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jG3TGTCv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jG3TGTCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841F81F000E9;
	Tue, 21 Jul 2026 15:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648140;
	bh=z4vWf5SVf5BXXRQJumhYW3JCJAMa4vmLnprG/0EptGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jG3TGTCvpDH2FLfIln0q9sFiftPy5+ia5G+j9P9cKYfIBvhdIXbKRUS2OoSUJGQqG
	 fKaWt6XMUWKHKkYlub5lcgoycL/h033MEFZA+SSO5uV5unSbZ0zhxk/7Kh9Z9flNGn
	 c8GLHpExG5XILIuaZSgiVW7WbBsK6WyGnSSvu5gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0043/2077] clocksource/drivers/sun5i: Handle error returns from devm_reset_control_get_optional_exclusive()
Date: Tue, 21 Jul 2026 16:55:16 +0200
Message-ID: <20260721152553.702802943@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit fed9f727cc3f91dde8278961269419083502b40e ]

The devm_reset_control_get_optional_exclusive() function may return an
ERR_PTR in case of genuine reset control acquisition errors, not just
NULL which indicates the legitimate absence of an optional reset.

Add an IS_ERR() check after the call in sun5i_timer_probe(). On error,
return the error code to ensure proper failure handling rather than
proceeding with invalid pointers.

Fixes: 7e5bac610d2f ("clocksource/drivers/sun5i: Convert to platform device driver")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Acked-by: Chen-Yu Tsai <wens@kernel.org>
Link: https://patch.msgid.link/20260205084037.3661261-1-nichen@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-sun5i.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clocksource/timer-sun5i.c b/drivers/clocksource/timer-sun5i.c
index f827d3f98f60e6..d7e012992170b7 100644
--- a/drivers/clocksource/timer-sun5i.c
+++ b/drivers/clocksource/timer-sun5i.c
@@ -286,6 +286,9 @@ static int sun5i_timer_probe(struct platform_device *pdev)
 	}
 
 	rstc = devm_reset_control_get_optional_exclusive(dev, NULL);
+	if (IS_ERR(rstc))
+		return dev_err_probe(dev, PTR_ERR(rstc),
+				     "failed to get reset\n");
 	if (rstc)
 		reset_control_deassert(rstc);
 
-- 
2.53.0



