Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7768BEEA8;
	Sat, 30 May 2026 17:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161135; cv=none; b=Rpfe8/+Q3KfpSQuWoGMy+jpe6bimDlg/Ej3DqZ9R0/MqWIoy/Ug9t2AAhUIwxYUe2rMFhCNqYDlenElLPKRviWFwDR3Ig6otXdJziSzOb1aQMYQr7HJiyYMgUCGUSJsCruwj5dTm0OGZdhGL0b2/qfzsvTFUixLg2s1IF8CWYaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161135; c=relaxed/simple;
	bh=J7Uc9VCXrsUrKyP5K1PjmMFFTCiwvB+jxVfvxRFPxMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3S9Xekwpyyy9jIt2Rhc8Yh27zGVk2EvS0Jas5F+bmSCL9dlZV3h/OhfTImuZpmC2PMt57N57OF25JjvfMK13Yj3PH1BsXDPL+pxZ7i7XSUYbYK+xKE3sZS2kcU4+X1pBQpys0HSfpH1ywyA52PRbkR3/Iu1v9ILwnme4sERYNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bW43MAAL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bW43MAAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0EEA1F00893;
	Sat, 30 May 2026 17:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161134;
	bh=2uclVLpK0SVNw6y3bdv+Arj76+a/HQTCYzWcE9bH3xA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bW43MAALj0rhqI40S+oKCu7AuFsK3bU7Kl0113bZNqsihQcnf1TSd5w8JC2PiF9Ce
	 FxcJoiAfDXl0lA+a5v6PYBZ8RrSN7cQBnoclkBVpvmdeXcJtcyAbMEBWtVQcFs160t
	 bAp3F31k6bjVa3lZ/MiTEuvcQ1p3PTYknErdxujM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 505/969] drm/sun4i: Fix resource leaks
Date: Sat, 30 May 2026 18:00:29 +0200
Message-ID: <20260530160314.277511269@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Tidmore <ethantidmore06@gmail.com>

[ Upstream commit 127367ad2e0f4870de60c6d719ae82ecf68d674c ]

Three clocks are not being released in devm_regmap_init_mmio() error
path.

Add proper goto and set ret to the error code.

Fixes: 8270249fbeaf0 ("drm/sun4i: backend: Create regmap after access is possible")
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20260226163836.10335-1-ethantidmore06@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_backend.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sun4i/sun4i_backend.c b/drivers/gpu/drm/sun4i/sun4i_backend.c
index d4fd621e33158..7cabf677ab1fc 100644
--- a/drivers/gpu/drm/sun4i/sun4i_backend.c
+++ b/drivers/gpu/drm/sun4i/sun4i_backend.c
@@ -878,7 +878,8 @@ static int sun4i_backend_bind(struct device *dev, struct device *master,
 						     &sun4i_backend_regmap_config);
 	if (IS_ERR(backend->engine.regs)) {
 		dev_err(dev, "Couldn't create the backend regmap\n");
-		return PTR_ERR(backend->engine.regs);
+		ret = PTR_ERR(backend->engine.regs);
+		goto err_disable_ram_clk;
 	}
 
 	list_add_tail(&backend->engine.list, &drv->engine_list);
-- 
2.53.0



