Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4989261B70;
	Tue, 17 Feb 2026 20:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361265; cv=none; b=UZSvmQIuv4m4Gtudp0efQvJud3dWzTEe84Vhwr2dxjW4A+WVulietIKIAlNnuDh3hkmKosetgwvVhFb/XkRyQ2rSmc0eStE2zni9wTs7ngOB3zXBOk5jnF9v8cX0uAp2LObEJUsdTYYyCjo0j6LxG7HdZ+fXkjrmBL3xaPQA+yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361265; c=relaxed/simple;
	bh=uJTi23tEe4nvjygCt0m0aAzZtNW0/fncO/xRqMsT1QY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsJiN17an+enCgHksXU4YRCQ8+nzrndBM0OpmzUFnj2SIuhnGLOVUDrDPtBVAyzZubSvYN6kn+ooIiA/sEphxV5mLYUP/2a1WPS854gTHHQfNvhJA9yZxADNCB7ouaFqaMnLGrJJHga8+X7gFIa0GeHdFNHKqHQo8ZKvXQSNR+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+Kxx2e+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+Kxx2e+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5384FC4CEF7;
	Tue, 17 Feb 2026 20:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361264;
	bh=uJTi23tEe4nvjygCt0m0aAzZtNW0/fncO/xRqMsT1QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+Kxx2e+NYbxqqZvh/McYrssrfGzriMfR0nN7I4G6ZUTCnQSJNdG7y6VdMoJH2C7K
	 sM+q4oXqIOoPR7ezXCRkMFsrf/zml/GpAi0SbEyvwFhEX0UPQ5jmcYG/3ar2TOjZuR
	 0Q2Oenrfz6q7YwYhTzum3qpqYeTAHR45I8ZfjOhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bosi Zhang <u201911157@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Stephen Boyd <sboyd@kernel.org>,
	Li hongliang <1468888505@139.com>
Subject: [PATCH 6.1 49/64] clk: mediatek: fix of_iomap memory leak
Date: Tue, 17 Feb 2026 21:31:45 +0100
Message-ID: <20260217200009.343402419@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
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

From: Bosi Zhang <u201911157@hust.edu.cn>

[ Upstream commit 3db7285e044144fd88a356f5b641b9cd4b231a77 ]

Smatch reports:
drivers/clk/mediatek/clk-mtk.c:583 mtk_clk_simple_probe() warn:
    'base' from of_iomap() not released on lines: 496.

This problem was also found in linux-next. In mtk_clk_simple_probe(),
base is not released when handling errors
if clk_data is not existed, which may cause a leak.
So free_base should be added here to release base.

Fixes: c58cd0e40ffa ("clk: mediatek: Add mtk_clk_simple_probe() to simplify clock providers")
Signed-off-by: Bosi Zhang <u201911157@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Link: https://lore.kernel.org/r/20230422084331.47198-1-u201911157@hust.edu.cn
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/mediatek/clk-mtk.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/clk/mediatek/clk-mtk.c
+++ b/drivers/clk/mediatek/clk-mtk.c
@@ -505,8 +505,10 @@ int mtk_clk_simple_probe(struct platform
 	num_clks += mcd->num_mux_clks;
 
 	clk_data = mtk_alloc_clk_data(num_clks);
-	if (!clk_data)
-		return -ENOMEM;
+	if (!clk_data) {
+		r = -ENOMEM;
+		goto free_base;
+	}
 
 	if (mcd->fixed_clks) {
 		r = mtk_clk_register_fixed_clks(mcd->fixed_clks,
@@ -594,6 +596,7 @@ unregister_fixed_clks:
 					      mcd->num_fixed_clks, clk_data);
 free_data:
 	mtk_free_clk_data(clk_data);
+free_base:
 	if (mcd->shared_io && base)
 		iounmap(base);
 


