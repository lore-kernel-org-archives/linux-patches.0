Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C28223ED64;
	Thu, 12 Dec 2024 16:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019979; cv=none; b=ez8H3AXFjORPGO5CT/GJNa/DxawTXNQtmA1eObztz3wwKzx7umf1/8rU7ev3d+fONFhIwIf6zR7cczWiG2tAgD9Fb9Gb+HoELgGP7XaanD5v3bOFTnpnnI02bC44++hitim2niwbBkvQiVvd6HZVCtU1+2Y27cMDHfqT+mNp6Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019979; c=relaxed/simple;
	bh=Je+0CY9TZvC5Kqrl9HnRuKYgYRg1lJ1bE3NoYzKSlqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ow/qtl3+Qjn0v5zRB4/SmX2s4R3dmISQkvIJaSfZWWK+byhTToreqOF9d08vVI8+OEzBQYHRxk0WCiq/8UFp1SdRbCCf3vXrXWsjmIUy1/d7W40YwuMtWYQFWfUT4s8eeuS7mDN1H2/sFgmENje83ntkpPsfH2eeTFGIsetyUF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hnekHaFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hnekHaFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849F3C4CECE;
	Thu, 12 Dec 2024 16:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019979;
	bh=Je+0CY9TZvC5Kqrl9HnRuKYgYRg1lJ1bE3NoYzKSlqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hnekHaFeBjhQB40REwvChbLHZbV9gvuY6QQpk99ig4k1nvzp0sr8gpjoUkNeGRKur
	 7M6sD9efZXWd5ciGXkEE3sf9FG5REGZ55SnsaOUIsvXOhIu7drt+gzc1g4ygwJmynH
	 1FUuYrFIKUTMl6bqWyshUN2TUCYv6Cr5loTmZ3yY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.1 347/772] drm/amd/display: Add NULL check for clk_mgr and clk_mgr->funcs in dcn30_init_hw
Date: Thu, 12 Dec 2024 15:54:52 +0100
Message-ID: <20241212144404.252465476@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

commit cba7fec864172dadd953daefdd26e01742b71a6a upstream.

This commit addresses a potential null pointer dereference issue in the
`dcn30_init_hw` function. The issue could occur when `dc->clk_mgr` or
`dc->clk_mgr->funcs` is null.

The fix adds a check to ensure `dc->clk_mgr` and `dc->clk_mgr->funcs` is
not null before accessing its functions. This prevents a potential null
pointer dereference.

Reported by smatch:
drivers/gpu/drm/amd/amdgpu/../display/dc/hwss/dcn30/dcn30_hwseq.c:789 dcn30_init_hw() error: we previously assumed 'dc->clk_mgr' could be null (see line 628)

Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[Xiangyu: BP to fix CVE: CVE-2024-49917, modified the source path]
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
@@ -448,7 +448,7 @@ void dcn30_init_hw(struct dc *dc)
 	int edp_num;
 	uint32_t backlight = MAX_BACKLIGHT_LEVEL;
 
-	if (dc->clk_mgr && dc->clk_mgr->funcs->init_clocks)
+	if (dc->clk_mgr && dc->clk_mgr->funcs && dc->clk_mgr->funcs->init_clocks)
 		dc->clk_mgr->funcs->init_clocks(dc->clk_mgr);
 
 	// Initialize the dccg
@@ -631,11 +631,12 @@ void dcn30_init_hw(struct dc *dc)
 	if (!dcb->funcs->is_accelerated_mode(dcb) && dc->res_pool->hubbub->funcs->init_watermarks)
 		dc->res_pool->hubbub->funcs->init_watermarks(dc->res_pool->hubbub);
 
-	if (dc->clk_mgr->funcs->notify_wm_ranges)
+	if (dc->clk_mgr && dc->clk_mgr->funcs && dc->clk_mgr->funcs->notify_wm_ranges)
 		dc->clk_mgr->funcs->notify_wm_ranges(dc->clk_mgr);
 
 	//if softmax is enabled then hardmax will be set by a different call
-	if (dc->clk_mgr->funcs->set_hard_max_memclk && !dc->clk_mgr->dc_mode_softmax_enabled)
+	if (dc->clk_mgr && dc->clk_mgr->funcs && dc->clk_mgr->funcs->set_hard_max_memclk &&
+	    !dc->clk_mgr->dc_mode_softmax_enabled)
 		dc->clk_mgr->funcs->set_hard_max_memclk(dc->clk_mgr);
 
 	if (dc->res_pool->hubbub->funcs->force_pstate_change_control)


