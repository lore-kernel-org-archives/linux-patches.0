Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA325146A81;
	Thu, 13 Jun 2024 11:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279405; cv=none; b=bWA9UU5P2fk9F6Uc4W86xgY/+Qj71hXDKwJDAhbECuDNhTXK6oo0GICnFYgHeKxp6dBqLOcU2B04fH5CUmSUooQlxGSAAxre/EKyssdwhq4D2Wk0nYUNHp4pidU3Dfg+lQhGPu4/ACHFEjdbdcMFU2OmkzFeNzzBHO84jHo6/Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279405; c=relaxed/simple;
	bh=DGGhTHwDyQnBakmgcFkpxuJNGrMbw7s+bT2Oql1lraU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xz5czSvw3Jh5nstE3rbjRxBVR/lDHFGWyT1ntpxKaHe3gAWm510rczuF5Ep/D5MoV+Jr5i7vyG+rVZQYS9p6Jmlb/GpvHtAy8ydoiTiQ4hlgOstYrPrE83QTPx3TIoXgM3ysuag5Ipdq1wVk4Jjfy3/BFEOdCUTVHtD6zDkDkmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZdrw1rw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZdrw1rw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD56C32786;
	Thu, 13 Jun 2024 11:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279404;
	bh=DGGhTHwDyQnBakmgcFkpxuJNGrMbw7s+bT2Oql1lraU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZdrw1rw/2OUbPeUriwexj7N2uwmMbEp8tQ4V27/R2oMY3dmDFFkv/hKgygSXf6LM
	 zfSkTMBgL/5d7Gl6gu9y3avVfS/VPTewveor3eBDAAa5DMGrJc9e1Z6Vb9s7NeG81s
	 GHb462P06qX1x4cQ0YEFuRKv4l/5bFrZUeKr42VI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.9 065/157] clk: bcm: dvp: Assign ->num before accessing ->hws
Date: Thu, 13 Jun 2024 13:33:10 +0200
Message-ID: <20240613113229.937998165@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 9368cdf90f52a68120d039887ccff74ff33b4444 upstream.

Commit f316cdff8d67 ("clk: Annotate struct clk_hw_onecell_data with
__counted_by") annotated the hws member of 'struct clk_hw_onecell_data'
with __counted_by, which informs the bounds sanitizer about the number
of elements in hws, so that it can warn when hws is accessed out of
bounds. As noted in that change, the __counted_by member must be
initialized with the number of elements before the first array access
happens, otherwise there will be a warning from each access prior to the
initialization because the number of elements is zero. This occurs in
clk_dvp_probe() due to ->num being assigned after ->hws has been
accessed:

  UBSAN: array-index-out-of-bounds in drivers/clk/bcm/clk-bcm2711-dvp.c:59:2
  index 0 is out of range for type 'struct clk_hw *[] __counted_by(num)' (aka 'struct clk_hw *[]')

Move the ->num initialization to before the first access of ->hws, which
clears up the warning.

Cc: stable@vger.kernel.org
Fixes: f316cdff8d67 ("clk: Annotate struct clk_hw_onecell_data with __counted_by")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20240425-cbl-bcm-assign-counted-by-val-before-access-v1-1-e2db3b82d5ef@kernel.org
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/bcm/clk-bcm2711-dvp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/clk/bcm/clk-bcm2711-dvp.c
+++ b/drivers/clk/bcm/clk-bcm2711-dvp.c
@@ -56,6 +56,8 @@ static int clk_dvp_probe(struct platform
 	if (ret)
 		return ret;
 
+	data->num = NR_CLOCKS;
+
 	data->hws[0] = clk_hw_register_gate_parent_data(&pdev->dev,
 							"hdmi0-108MHz",
 							&clk_dvp_parent, 0,
@@ -76,7 +78,6 @@ static int clk_dvp_probe(struct platform
 		goto unregister_clk0;
 	}
 
-	data->num = NR_CLOCKS;
 	ret = of_clk_add_hw_provider(pdev->dev.of_node, of_clk_hw_onecell_get,
 				     data);
 	if (ret)


