Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F2C2EF661;
	Thu,  3 Jul 2025 14:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554333; cv=none; b=TpIj1qv5Om6KNxVI2PSSfuRKR7wiumdjbk8qDVgp0R1pL/v8AtBcmNSWE1yPXkRAKkqA8V7q09V5YrUiBZr5QRYtdk5WIbCZ+u5TJ8tyvRqvCd8VdUj/S98fPIxgsCgXCsoT7YcZcqMyw3VzQgeOfeuB3jeH+wzsfX9hP6/vUpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554333; c=relaxed/simple;
	bh=KhwNaxlplhqYkMAluHMMQa5PI3cdOwZ+HpH/zJ3IVT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RroFYMD84FFldW50JR4aSDu3M3HrmAn5KKS1ta1mZ2u2tvpt3J6U+tPVs8OdoSvkkDbDrkMmckw5w37aXtQx1/QUGdkWfpXv4X8UXkvaw5ZZ6PnhC7f/RpH+RttYSnRWLjkEx/gaBvrR0+WShtOoBzgGTCiS6/Gr+8p3BiFNOUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1IiS0zL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1IiS0zL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C004BC4CEE3;
	Thu,  3 Jul 2025 14:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554333;
	bh=KhwNaxlplhqYkMAluHMMQa5PI3cdOwZ+HpH/zJ3IVT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S1IiS0zL4CEE43m5XUTL4P+8/snR+n2QgPU+QxsU1YURXSoKdxuBzWehQNlUEzllG
	 MrgF49FyumE2XItAKFcdO9xln9U1GIrWirtxPQWV9r79Mfq4zTcdiVcZSDh7DIHMmE
	 mpyE9Mlg1h1EtLrX4JgL9UqB5zqG2Jg1R/dpPxBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiu-ji Chen <chenqiuji666@gmail.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.12 152/218] drm/tegra: Fix a possible null pointer dereference
Date: Thu,  3 Jul 2025 16:41:40 +0200
Message-ID: <20250703144002.231877923@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Qiu-ji Chen <chenqiuji666@gmail.com>

commit 780351a5f61416ed2ba1199cc57e4a076fca644d upstream.

In tegra_crtc_reset(), new memory is allocated with kzalloc(), but
no check is performed. Before calling __drm_atomic_helper_crtc_reset,
state should be checked to prevent possible null pointer dereference.

Fixes: b7e0b04ae450 ("drm/tegra: Convert to using __drm_atomic_helper_crtc_reset() for reset.")
Cc: stable@vger.kernel.org
Signed-off-by: Qiu-ji Chen <chenqiuji666@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20241106095906.15247-1-chenqiuji666@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tegra/dc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -1392,7 +1392,10 @@ static void tegra_crtc_reset(struct drm_
 	if (crtc->state)
 		tegra_crtc_atomic_destroy_state(crtc, crtc->state);
 
-	__drm_atomic_helper_crtc_reset(crtc, &state->base);
+	if (state)
+		__drm_atomic_helper_crtc_reset(crtc, &state->base);
+	else
+		__drm_atomic_helper_crtc_reset(crtc, NULL);
 }
 
 static struct drm_crtc_state *


