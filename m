Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F251AB6D4;
	Mon, 14 Oct 2024 14:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916410; cv=none; b=Q3e8vREIT67lzerkoXkYbtZmou3NiLyO11XlvdkstfdeZxtkf4berB92iJ2FRwluciPAx3Tsc6uTJAdsY4dTFvX6a8N4HLfiAc7mX1s8HD1uSZt2BCOdYPQ7x4pcBlkO68oUCvMGQ0Xa84TBHtAiMaJEVtFf5QDKzZ+5wpEBNZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916410; c=relaxed/simple;
	bh=BwogQViVP0X61Zwlbes13F2fUBM3JZpek5bsKclV+wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Za0B6GTPmCtUD0Yxr1nqYRAwDdruu3cgJz1jbf/72wpsihdfBUV+IdohK8ncIUfk/f1wjmUWe0y98eaRLky6kyn6YqA9nSL7tOA087bZOns6z0z2GLAjNcXbzXlounGAAl65dIbMBh9D/ab6AFetEABMIV43iGprifZISlxvnoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFIZpw7U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFIZpw7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B93C4CED0;
	Mon, 14 Oct 2024 14:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916410;
	bh=BwogQViVP0X61Zwlbes13F2fUBM3JZpek5bsKclV+wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFIZpw7UVlWTZ30S4sGwsFxKv7UTDg/+e46t7hJuvlBrIYu031YISVHWNqm3I99S+
	 OKR4Xtr3Pgt79/UVbxbS0pMipuJwKlX7DomAyZCdnMxX+pOqBCBwOBs/VWu8dkYtWy
	 vXTZgVb+1B1SjXAppGPmAthJ62Us6riiXYOHeaQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>
Subject: [PATCH 6.11 176/214] drm/amd/display: fix hibernate entry for DCN35+
Date: Mon, 14 Oct 2024 16:20:39 +0200
Message-ID: <20241014141051.846754363@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hamza Mahfooz <hamza.mahfooz@amd.com>

commit 79bc412ef787cf25773d0ece93f8739ce0e6ac1e upstream.

Since, two suspend-resume cycles are required to enter hibernate and,
since we only need to enable idle optimizations in the first cycle
(which is pretty much equivalent to s2idle). We can check in_s0ix, to
prevent the system from entering idle optimizations before it actually
enters hibernate (from display's perspective). Also, call
dc_set_power_state() before dc_allow_idle_optimizations(), since it's
safer to do so because dc_set_power_state() writes to DMUB.

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2fe79508d9c393bb9931b0037c5ecaee09a8dc39)
Cc: stable@vger.kernel.org # 6.10+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2950,10 +2950,11 @@ static int dm_suspend(void *handle)
 
 	hpd_rx_irq_work_suspend(dm);
 
-	if (adev->dm.dc->caps.ips_support)
-		dc_allow_idle_optimizations(adev->dm.dc, true);
-
 	dc_set_power_state(dm->dc, DC_ACPI_CM_POWER_STATE_D3);
+
+	if (dm->dc->caps.ips_support && adev->in_s0ix)
+		dc_allow_idle_optimizations(dm->dc, true);
+
 	dc_dmub_srv_set_power_state(dm->dc->ctx->dmub_srv, DC_ACPI_CM_POWER_STATE_D3);
 
 	return 0;


